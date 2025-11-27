#!/usr/bin/env bash
set -e

echo "RTL_433 US add-on started"
echo "Trying device 0..."
exec rtl_433 -d 0 -F "mqtt://core-mosquitto:1883" -M newmodel || \
     (echo "Device 0 failed, trying device 1..." && \
      exec rtl_433 -d 1 -F "mqtt://core-mosquitto:1883" -M newmodel)