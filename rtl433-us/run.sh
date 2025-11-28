#!/usr/bin/env bash
set -e

CONFIG_PATH=/data/options.json

MQTT_HOST=$(jq -r '.mqtt_host' $CONFIG_PATH)
MQTT_PORT=$(jq -r '.mqtt_port' $CONFIG_PATH)
MQTT_USER=$(jq -r '.mqtt_user' $CONFIG_PATH)
MQTT_PASS=$(jq -r '.mqtt_pass' $CONFIG_PATH)
FREQ=$(jq -r '.frequency' $CONFIG_PATH)

if [ "$FREQ" = "433" ]; then
  TUNE=433920000
  RATE=250k
elif [ "$FREQ" = "915" ]; then
  TUNE=915000000
  RATE=1M
else
  echo "Invalid frequency option: $FREQ"
  exit 1
fi

echo "[$(date '+%H:%M:%S')] Starting RTL_433 tuned to $TUNE Hz with sample rate $RATE"

exec rtl_433 \
  -d 0 \
  -f $TUNE \
  -s $RATE \
  -F json \
  -F log \
  -F "mqtt://$MQTT_HOST:$MQTT_PORT,user=$MQTT_USER,pass=$MQTT_PASS,retain=0,devices=rtl_433/${FREQ}mhz[/model][/id]"
