#!/usr/bin/env bash
set -e

log() { echo "[$(date '+%H:%M:%S')] $*"; }

log "RTL_433 US add-on started – Blog V4 dongle found"

# Default decoders (no -G needed) + log output to console
exec rtl_433 \
  -s 250000 \
  -F "mqtt://core-mosquitto:1883,retain=0" \
  -F log \
  -M newmodel