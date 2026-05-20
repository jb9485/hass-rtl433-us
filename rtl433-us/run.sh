#!/usr/bin/with-contenv bash
#
# Improved run.sh - MQTT FIXED for rtl_433 25.12+
#

set -euo pipefail

CONFIG=/data/options.json

# --- Read configuration ---
MQTT_HOST=$(jq -r '.mqtt_host // "core-mosquitto"' "$CONFIG")
MQTT_PORT=$(jq -r '.mqtt_port // 1883' "$CONFIG")
MQTT_USER=$(jq -r '.mqtt_user // empty' "$CONFIG")
MQTT_PASS=$(jq -r '.mqtt_pass // empty' "$CONFIG")

FREQ=$(jq -r '.frequency // 433' "$CONFIG")
DEV=$(jq -r '.device // "0"' "$CONFIG")

SECOND_FREQ=$(jq -r '.second_frequency // empty' "$CONFIG")
SECOND_DEV=$(jq -r '.second_device // empty' "$CONFIG")

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S %Z')] $*"
}

# --- Watchdog function ---
start_rtl433_instance() {
    local device="$1"
    local frequency="$2"
    local prefix="$3"
    local tune rate

    case "$frequency" in
        433)
            tune=433920000
            rate=250k
            ;;
        915)
            tune=915000000
            rate=1M
            ;;
        *)
            log "ERROR: Invalid frequency '$frequency'"
            return 1
            ;;
    esac

    # Working MQTT syntax for the rtl_433 version currently being built
    local mqtt_url="mqtt://${MQTT_HOST}:${MQTT_PORT}"
    [ -n "$MQTT_USER" ] && mqtt_url="${mqtt_url},user=${MQTT_USER}"
    [ -n "$MQTT_PASS" ] && mqtt_url="${mqtt_url},pass=${MQTT_PASS}"
    mqtt_url="${mqtt_url},retain=1,devices=rtl_433/${prefix}/devices[/model][/channel][/id],events=rtl_433/${prefix}/events[/model][/id]"

    log "=== Starting watchdog for $prefix (device=$device, ${frequency} MHz) ==="

    local restart_delay=10
    local max_backoff=120
    local consecutive_failures=0

    while true; do
        log "Launching rtl_433 for $prefix..."

        if rtl_433 -d "$device" -f "$tune" -s "$rate" -C si -M utc \
            -F "$mqtt_url"; then
            log "rtl_433 for $prefix exited cleanly"
            exit_code=0
        else
            exit_code=$?
            log "rtl_433 for $prefix exited with code $exit_code"
        fi

        if [[ $exit_code -ne 0 ]]; then
            consecutive_failures=$((consecutive_failures + 1))
            if [[ $consecutive_failures -ge 3 ]]; then
                restart_delay=$((restart_delay * 2))
                [[ $restart_delay -gt $max_backoff ]] && restart_delay=$max_backoff
                log "Multiple failures ($consecutive_failures) — backing off to ${restart_delay}s"
            fi
        else
            consecutive_failures=0
            restart_delay=10
        fi

        log "Restarting $prefix instance in ${restart_delay}s..."
        sleep "$restart_delay"
    done
}

# --- Cleanup ---
cleanup() {
    log "Received shutdown signal — terminating children..."
    jobs -p | xargs -r kill 2>/dev/null || true
    sleep 2
    log "Shutdown complete."
    exit 0
}

# --- Launch instances with staggered start to avoid USB race ---
log "=== Starting primary (915mhz) first ==="
start_rtl433_instance "$DEV" "$FREQ" "${FREQ}mhz" &

if [ -n "$SECOND_FREQ" ] && [ -n "$SECOND_DEV" ]; then
    log "Waiting 4 seconds before starting secondary (433mhz) to prevent USB claim collision..."
    sleep 4
    start_rtl433_instance "$SECOND_DEV" "$SECOND_FREQ" "${SECOND_FREQ}mhz" &
fi

log "=== All watchdogs started. ==="

wait
log "ERROR: All watchdogs exited"
exit 1