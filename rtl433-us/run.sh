#!/usr/bin/env bash
set -e

log() { echo "[$(date '+%H:%M:%S')] $*"; }

log "RTL_433 US add-on starting – Blog V4 dongle"

MQTT_HOST="${MQTT_HOST:-core-mosquitto}"
MQTT_PORT="${MQTT_PORT:-1883}"
MQTT_USER="${MQTT_USER:-}"
MQTT_PASS="${MQTT_PASS:-}"

# URL-encode password (handles @ : / etc.)
ENCODED_PASS=$(printf '%s' "$MQTT_PASS" | jq -sRr @uri)

if [ -n "$MQTT_USER" ] && [ -n "$MQTT_PASS" ]; then
  MQTT_URL="mqtt://${MQTT_USER}:${ENCODED_PASS}@${MQTT_HOST}:${MQTT_PORT}"
else
  MQTT_URL="mqtt://${MQTT_HOST}:${MQTT_PORT}"
fi

log "Attempting MQTT connection once → $MQTT_URL"

# ONE attempt only. If it fails → exit immediately (no retries, no flood)
rtl_433 -d 0 -F "$MQTT_URL,retain=0" -F log -M newmodel || {
  log "MQTT CONNECTION FAILED – stopping add-on. Check username/password."
  exit 1
}

# Never reached if MQTT fails
log "MQTT connected – running forever"