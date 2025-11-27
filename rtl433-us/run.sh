#!/usr/bin/env bash
set -e

echo "[$(date '+%H:%M:%S')] RTL_433 US started – Blog V4 dongle (JSON mode – no MQTT client)"

# Pure JSON to stdout – zero MQTT code, zero auth problems, zero flooding
exec rtl_433 \
  -d 0 \
  -F json \
  -F log \
  -M newmodel