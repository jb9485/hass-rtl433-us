#!/usr/bin/env bash
set -e
CONFIG_PATH=/data/options.json

MQTT_HOST=$(bashio::config 'mqtt_host')
MQTT_PORT=$(bashio::config 'mqtt_port')
MQTT_USER=$(bashio::config 'mqtt_user')
MQTT_PASS=$(bashio::config 'mqtt_pass')

echo "[$(date '+%H:%M:%S')] Starting RTL_433 with MQTT + log output"
echo "Connecting to MQTT at $MQTT_HOST:$MQTT_PORT with user $MQTT_USER"

exec rtl_433 \
  -d 0 \
  -F json \
  -F "mqtt://$MQTT_HOST:$MQTT_PORT,user=$MQTT_USER,pass=$MQTT_PASS,retain=0,devices=rtl_433[/model][/id]" \
  -M newmodel
