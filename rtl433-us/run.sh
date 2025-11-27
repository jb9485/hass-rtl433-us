#!/usr/bin/env bash
set -e

echo "[$(date '+%H:%M:%S')] Starting RTL_433 with MQTT + log output"

exec rtl_433 \
  -d 0 \
  -F json \
  -F "mqtt://$MQTT_HOST:$MQTT_PORT,user=$MQTT_USER,pass=$MQTT_PASS,retain=0,devices=rtl_433[/model][/id]" \
  -M newmodel
