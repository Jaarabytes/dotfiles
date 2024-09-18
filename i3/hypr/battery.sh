#!/bin/bash

LOW_BATTERY_THRESHOLD=25
FULL_BATTERY_THRESHOLD=100

while true; do
    # Get the current battery percentage
    BATTERY_LEVEL=$(cat /sys/class/power_supply/BAT0/capacity)
    STATUS=$(cat /sys/class/power_supply/BAT0/status)

    if [ "$STATUS" == "Discharging" ] && [ "$BATTERY_LEVEL" -le "$LOW_BATTERY_THRESHOLD" ]; then
        # Send a notification
        notify-send --urgency=critical "Low Battery" "Battery level is at ${BATTERY_LEVEL}%"
    fi

    if [ "$STATUS" == "Charging" ] && [ "$BATTERY_LEVEL" -eq "$FULL_BATTERY_THRESHOLD" ]; then
        # Send a notification
        notify-send "Charging complete" "Battery level is at ${BATTERY_LEVEL}%"
    fi


    # Wait 5 minutes before checking again
    sleep 300
done
