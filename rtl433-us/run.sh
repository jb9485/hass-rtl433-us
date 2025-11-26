#!/usr/bin/with-contenv bash

set -e

MQTT_HOST="${MQTT_HOST:-core-mosquitto}"
MQTT_PORT="${MQTT_PORT:-1883}"
MQTT_USER="${MQTT_USER:-}"
MQTT_PASS="${MQTT_PASS:-}"
MQTT_TOPIC="${MQTT_TOPIC:-rtl_433}"
RETAIN="${RETAIN:-true}"
HOP_INTERVAL="${HOP_INTERVAL:-0.8}"

# Build MQTT auth string
MQTT_AUTH=""
[[ -n "$MQTT_USER" ]] && MQTT_AUTH="user=$MQTT_USER,pass=$MQTT_PASS,"

# Build MQTT output
MQTT_OUTPUT="mqtt://$MQTT_HOST:$MQTT_PORT,${MQTT_AUTH}retain=$([[ "$RETAIN" == "true" ]] && echo 1 || echo 0),topic=$MQTT_TOPIC"

echo "Starting RTL433 US Edition"
echo "Devices: ${#DEVICES[@]}"
echo "MQTT: $MQTT_HOST:$MQTT_PORT → $MQTT_TOPIC"

# Build command
CMD="rtl_433 -F kv -M newmodel -M utc $MQTT_OUTPUT"

# Add each device
for i in "${!DEVICES[@]}"; do
  freq="${DEVICES[$i]}"
  rate="${SAMPLE_RATES[$i]:-1000000}"
  gain="${GAINS[$i]:-45}"
  ppm="${PPMS[$i]:-70}"
  label="${LABELS[$i]}"

  echo "Device $((i+1)): $freq Hz | $rate S/s | Gain $gain | PPM $ppm | $label"

  CMD="$CMD -d $i -f $freq -s $rate -g $gain -p $ppm"
done

# Add hopping if >1 device
if [ ${#DEVICES[@]} -gt 1 ]; then
  CMD="$CMD -H ${HOP_INTERVAL}s"
fi

echo "Final command: $CMD"
exec $CMD
