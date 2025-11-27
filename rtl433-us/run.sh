#!/usr/bin/env bash
set -e

MQTT_HOST=${MQTT_HOST:-core-mosquitto}
MQTT_PORT=${MQTT_PORT:-1883}
MQTT_USER=${MQTT_USER:-}
MQTT_PASS=${MQTT_PASS:-}

MQTT_URL="mqtt://$$ {MQTT_HOST}: $${MQTT_PORT}"
[ -n "$$ MQTT_USER" ] && MQTT_URL="mqtt:// $${MQTT_USER}:$$ {MQTT_PASS}@ $${MQTT_HOST}:${MQTT_PORT}"

echo "RTL_433 US add-on started"
echo "MQTT → $MQTT_URL"
echo "Waiting for RTL-SDR dongle..."

exec rtl_433 -F "$MQTT_URL" -M newmodel