#!/usr/bin/env bash
set -e

log() {
  echo "[$(date '+%H:%M:%S')] $*"
}

log "RTL_433 US add-on started – searching for dongle..."

for dev in 0 1 2 3; do
  log "Trying RTL-SDR device index $dev ..."
  if rtl_433 -d $dev -F "mqtt://core-mosquitto:1883" -M newmodel; then
    log "SUCCESS: Found dongle on device index $dev"
    exit 0
  fi
  log "Device $dev failed or not found"
done

log "No RTL-SDR dongle found on indices 0–3 – exiting"
exit 1