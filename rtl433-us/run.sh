#!/usr/bin/with-contenv sh

MQTT_HOST=${MQTT_HOST:-homeassistant}
MQTT_PORT=${MQTT_PORT:-1883}
MQTT_USER=${MQTT_USER:-}
MQTT_PASS=${MQTT_PASS:-}

MQTT_URL="mqtt://${MQTT_HOST}:${MQTT_PORT}"
if [ -n "$MQTT_USER" ] && [ -n "$MQTT_PASS" ]; then
  MQTT_URL="mqtt://${MQTT_USER}:${MQTT_PASS}@${MQTT_HOST}:${MQTT_PORT}"
fi

# Run rtl_433 and send output to stdout (captured by s6 logging)
exec rtl_433 -F "$MQTT_URL" -M newmodel
