#!/usr/bin/env bash

set -e

CONFIG=/data/options.json

MQTT_HOST=$(jq -r '.mqtt_host // "core-mosquitto"' $CONFIG)
MQTT_PORT=$(jq -r '.mqtt_port // 1883' $CONFIG)
MQTT_USER=$(jq -r '.mqtt_user // empty' $CONFIG)
MQTT_PASS=$(jq -r '.mqtt_password // empty' $CONFIG)

MQTT_URL="mqtt://$MQTT_HOST:$MQTT_PORT"
[ -n "$MQTT_USER" ] && MQTT_URL="$MQTT_URL,user=$MQTT_USER"
[ -n "$MQTT_PASS" ] && MQTT_URL="$MQTT_URL,pass=$MQTT_PASS"

# Hard-code the device to index 0 (container sees one device at index 0)
DEVICE="0"

# Get the first frequency from config (or default to 433)
FREQ=$(jq -r '.dongles[0].frequency // 433' $CONFIG)

case "$FREQ" in
    433) TUNE=433920000; RATE=250k ;;
    915) TUNE=915000000; RATE=1M ;;
    *) TUNE=433920000; RATE=250k ;;
esac

PREFIX="${FREQ}mhz"

# Run rtl_433 in foreground with index 0
rtl_433 -d "$DEVICE" -f $TUNE -s $RATE -C si -M utc -F log \
    -F "$MQTT_URL,retain=1,devices=rtl_433/${PREFIX}/[model]/[id]"