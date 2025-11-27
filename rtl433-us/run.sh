#!/usr/bin/env bash
set -e

log() { echo "[$(date '+%H:%M:%S')] $*"; }

log "RTL_433 US add-on started – Blog V4 dongle found"

# Correct MQTT URL syntax for rtl_433 when user/pass are set
MQTT_HOST="${MQTT_HOST:-core-mosquitto}"
MQTT_PORT="${MQTT_PORT:-1883}"
MQTT_USER="${MQTT_USER:-}"
MQTT_PASS="${MQTT_PASS:-}"

if [ -n "$MQTT_USER" ] && [ -n "$MQTT_PASS" ]; then
  MQTT_URL="mqtt://${MQTT_USER}:${MQTT_PASS}@${MQTT_HOST}:${MQTT_PORT}"
else
  MQTT_URL="mqtt://${MQTT_HOST}:${MQTT_PORT}"
fi

log "Connecting to MQTT → $MQTT_URL"

exec rtl_433 \
  -d 0 \
  -F "$MQTT_URL,retain=0" \
  -F log \
  -M newmodel