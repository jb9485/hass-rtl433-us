#!/usr/bin/env bash
set -e

CONFIG_PATH=/data/options.json

MQTT_HOST=$(jq -r '.mqtt_host' $CONFIG_PATH)
MQTT_PORT=$(jq -r '.mqtt_port' $CONFIG_PATH)
MQTT_USER=$(jq -r '.mqtt_user' $CONFIG_PATH)
MQTT_PASS=$(jq -r '.mqtt_pass' $CONFIG_PATH)

echo "[$(date '+%H:%M:%S')] Starting RTL_433 with MQTT + log output"
echo "Connecting to MQTT at $MQTT_HOST:$MQTT_PORT with user $MQTT_USER"

exec rtl_433 \
  -d 0 \
  -F json \
  -F "mqtt://$MQTT_HOST:$MQTT_PORT,user=$MQTT_USER,pass=$MQTT_PASS,retain=0,devices=rtl_433[/model][/id]" \
  -M newmodel
