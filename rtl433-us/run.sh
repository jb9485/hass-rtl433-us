#!/usr/bin/env bash
set -e

log() { echo "[$(date '+%H:%M:%S')] $*"; }

log "RTL_433 US add-on started – Blog V4 dongle found"

# 2.0 MS/s sample rate + auto gain + verbose
exec rtl_433 \
  -s 2000000 \
  -G \
  -F "mqtt://core-mosquitto:1883,retain=0" \
  -M newmodel