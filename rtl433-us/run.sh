#!/usr/bin/env bash
set -e

echo "RTL_433 US add-on started – searching for dongle..."

for dev in 0 1 2 3; do
  echo "Trying RTL-SDR device index $dev ..."
  rtl_433 -d $dev -F "mqtt://core-mosquitto:1883" -M newmodel && break
  echo "Device $dev failed or not found"
done

echo "No RTL-SDR dongle found on indices 0–3 – exiting"
exit 1