#!/usr/bin/env bash
set -e

CONFIG_PATH=/data/options.json

MQTT_HOST=$(jq -r '.mqtt_host' $CONFIG_PATH)
MQTT_PORT=$(jq -r '.mqtt_port' $CONFIG_PATH)
MQTT_USER=$(jq -r '.mqtt_user' $CONFIG_PATH)
MQTT_PASS=$(jq -r '.mqtt_pass' $CONFIG_PATH)

echo "[$(date '+%H:%M:%S')] Starting RTL_433 with frequency hopping (433 ↔ 915 MHz)"

while true; do
  echo "[$(date '+%H:%M:%S')] Listening on 433 MHz"
  timeout 0.5 rtl_433 \
    -d 0 \
    -f 433920000 \
    -F json \
    -F "mqtt://$MQTT_HOST:$MQTT_PORT,user=$MQTT_USER,pass=$MQTT_PASS,retain=0,devices=rtl_433/433mhz[/model][/id]" \
    -M newmodel

  echo "[$(date '+%H:%M:%S')] Listening on 915 MHz"
  timeout 0.5 rtl_433 \
    -d 0 \
    -f 915000000 \
    -F json \
    -F "mqtt://$MQTT_HOST:$MQTT_PORT,user=$MQTT_USER,pass=$MQTT_PASS,retain=0,devices=rtl_433/915mhz[/model][/id]" \
    -M newmodel
done
