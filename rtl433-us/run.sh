#!/usr/bin/with-contenv bash
#
# Improved run.sh for hass-rtl433-us
# - Per-instance watchdog with automatic restart on crash (including USB transfer errors)
# - Clean signal handling for graceful shutdown
# - Timestamped logging
# - Keeps the main process alive so s6/HA sees the add-on as healthy
# - Minimal changes to original logic and config options
#

set -euo pipefail

CONFIG=/data/options.json

# --- Read configuration (same as original) ---
MQTT_HOST=$(jq -r '.mqtt_host // "core-mosquitto"' "$CONFIG")
MQTT_PORT=$(jq -r '.mqtt_port // 1883' "$CONFIG")
MQTT_USER=$(jq -r '.mqtt_user // empty' "$CONFIG")
MQTT_PASS=$(jq -r '.mqtt_pass // empty' "$CONFIG")

MQTT_URL="mqtt://$MQTT_HOST:$MQTT_PORT"
[ -n "$MQTT_USER" ] && MQTT_URL="$MQTT_URL,user=$MQTT_USER"
[ -n "$MQTT_PASS" ] && MQTT_URL="$MQTT_URL,pass=$MQTT_PASS"

FREQ=$(jq -r '.frequency // 433' "$CONFIG")
DEV=$(jq -r '.device // "0"' "$CONFIG")

SECOND_FREQ=$(jq -r '.second_frequency // empty' "$CONFIG")
SECOND_DEV=$(jq -r '.second_device // empty' "$CONFIG")

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S %Z')] $*"
}

# --- Watchdog function for one rtl_433 instance ---
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
            log "ERROR: Invalid frequency '$frequency' for $prefix (must be 433 or 915)"
            return 1
            ;;
    esac

    local mqtt_topic="retain=1,devices=rtl_433/${prefix}/devices[/model][/channel][/id],events=rtl_433/${prefix}/events[/model][/id]"
    local rtl_cmd="rtl_433 -d \"$device\" -f $tune -s $rate -C si -M utc -F \"$MQTT_URL,$mqtt_topic\""

    log "=== Starting watchdog for $prefix (device=$device, ${frequency} MHz) ==="

    local restart_delay=10
    local max_backoff=120
    local consecutive_failures=0

    while true; do
        log "Launching: $rtl_cmd"

        # Run rtl_433 in foreground so this loop can detect exit
        if $rtl_cmd; then
            log "rtl_433 for $prefix exited cleanly (code 0) — this is unexpected during normal operation"
            exit_code=0
        else
            exit_code=$?
            log "rtl_433 for $prefix exited with code $exit_code"
        fi

        # Handle specific known USB/transfer errors with slightly longer backoff
        if [[ $exit_code -ne 0 ]]; then
            consecutive_failures=$((consecutive_failures + 1))
            if [[ $consecutive_failures -ge 3 ]]; then
                restart_delay=$((restart_delay * 2))
                if [[ $restart_delay -gt $max_backoff ]]; then
                    restart_delay=$max_backoff
                fi
                log "Multiple consecutive failures ($consecutive_failures) for $prefix — backing off to ${restart_delay}s"
            fi
        else
            consecutive_failures=0
            restart_delay=10
        fi

        log "Restarting $prefix instance in ${restart_delay}s..."
        sleep "$restart_delay"
    done
}

# --- Signal handling: kill all child processes cleanly ---
cleanup() {
    log "Received shutdown signal — terminating all rtl_433 instances..."
    # Kill all background jobs started by this script
    jobs -p | xargs -r kill 2>/dev/null || true
    # Give them a moment to exit
    sleep 2
    log "Shutdown complete."
    exit 0
}

trap cleanup SIGTERM SIGINT SIGQUIT EXIT

# --- Launch primary instance ---
start_rtl433_instance "$DEV" "$FREQ" "${FREQ}mhz" &

# --- Launch secondary instance if configured ---
if [ -n "$SECOND_FREQ" ] && [ -n "$SECOND_DEV" ]; then
    start_rtl433_instance "$SECOND_DEV" "$SECOND_FREQ" "${SECOND_FREQ}mhz" &
else
    log "No secondary dongle configured (or missing second_frequency/second_device)"
fi

log "=== All watchdogs started. Main process will stay alive for healthchecks. ==="

# Wait for all background jobs (keeps container alive)
wait

# If we reach here, something went very wrong
log "ERROR: All watchdogs exited unexpectedly — container will now stop"
exit 1