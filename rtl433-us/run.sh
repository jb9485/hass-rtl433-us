#!/usr/bin/env bash
set -e

log() { echo "[$(date '+%H:%M:%S')] $*"; }

log "RTL_433 US add-on started – Blog V4 dongle found"

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

# Try only 5 times, then exit cleanly (stops the flood)
for attempt in {1..5}; do
  log "MQTT connection attempt $attempt/5 ..."
  if rtl_433 -d 0 -F "$MQTT_URL,retain=0" -F log -M newmodel; then
    log "MQTT connected successfully"
    exit 0
  fi
  log "MQTT failed (attempt $attempt)"
  sleep 2
done

log "MQTT connection failed after 5 attempts – stopping add-on"
exit 1