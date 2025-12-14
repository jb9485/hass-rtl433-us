PIDS=()

jq -c '.dongles[]' $CONFIG | while read -r d; do
    DEVICE=$(echo "$d" | jq -r '.device // "0"')
    FREQ=$(echo "$d" | jq -r '.frequency // 433')

    case "$FREQ" in
        433) TUNE=433920000; RATE=250k ;;
        915) TUNE=915000000; RATE=1M ;;
        *) echo "Skip invalid freq $FREQ for device $DEVICE"; continue ;;
    esac

    PREFIX="${FREQ}mhz"

    rtl_433 -d "$DEVICE" -f $TUNE -s $RATE -q -C si -M utc \
        -F "$MQTT_URL,retain=1,devices=rtl_433/${PREFIX}/[model]/[id]" &
    PIDS+=($!)
done

for pid in "${PIDS[@]}"; do
    wait $pid
done