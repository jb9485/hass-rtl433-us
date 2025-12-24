#!/usr/bin/with-contenv bash

CONFIG=/data/options.json

MQTT_HOST=$(jq -r '.mqtt_host // "core-mosquitto"' $CONFIG)
MQTT_PORT=$(jq -r '.mqtt_port // 1883' $CONFIG)
MQTT_USER=$(jq -r '.mqtt_user // empty' $CONFIG)
MQTT_PASS=$(jq -r '.mqtt_pass // empty' $CONFIG)

MQTT_URL="mqtt://$MQTT_HOST:$MQTT_PORT"
[ -n "$MQTT_USER" ] && MQTT_URL="$MQTT_URL,user=$MQTT_USER"
[ -n "$MQTT_PASS" ] && MQTT_URL="$MQTT_URL,pass=$MQTT_PASS"

FREQ=$(jq -r '.frequency // 433' $CONFIG)

case "$FREQ" in
  433) TUNE=433920000; RATE=250k ;;
  915) TUNE=915000000; RATE=1M ;;
  *) echo "Invalid frequency option: $FREQ (must be 433 or 915)"; exit 1 ;;
esac

PREFIX="${FREQ}mhz"

LIBUSB_DEBUG=4 RTLSDR_DEBUG=3 rtl_433 -d 0 -f $TUNE -s $RATE -vvv -C si -M utc -F "$MQTT_URL,retain=1,devices=rtl_433/${PREFIX}/[model]/[id]"