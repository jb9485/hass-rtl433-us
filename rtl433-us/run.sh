#!/usr/bin/env bash
set -e

# Build rtl_433 command line from config
RTL_ARGS=""

for i in $(seq 0 $((${#devices[@]}-1))); do
  freq="${devices[$i][frequency]}"
  rate="${devices[$i][sample_rate]:-1000000}"
  gain="${devices[$i][gain]:-40}"
  ppm="${devices[$i][ppm]:-0}"

  RTL_ARGS="$RTL_ARGS -f $freq -s $rate -g $gain -p $ppm"
done

[ -n "$hop_interval" ] && RTL_ARGS="$RTL_ARGS -t ${hop_interval}"

MQTT_URL="mqtt://${mqtt_host}:${mqtt_port}"
[ -n "${mqtt_user}" ] && MQTT_URL="mqtt://${mqtt_user}:${mqtt_pass}@${mqtt_host}:${mqtt_port}"

exec rtl_433 \
  $RTL_ARGS \
  -F "mqtt:$MQTT_URL,devices=rtl_433/[{model}]/[{id}],events=rtl_433/[{model}]/[{id}]/event,retain=${mqtt_retain:-0}" \
  -M newmodel -M time:iso -M protocol \
  -G