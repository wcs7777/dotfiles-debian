#!/bin/bash

ACTION=$1
STEP=5
CURRENT=100
NOTIFY=no
MAX_BRIGHTNESS=96000

update_current() {
    CURRENT=$(("$(brightnessctl get) * 100 / $MAX_BRIGHTNESS"))
}

update_current

if [ "$ACTION" = "+" ]; then
    ((CURRENT += STEP))
elif [ "$ACTION" = "-" ]; then
    ((CURRENT -= STEP))
elif [ "$ACTION" = "=" ]; then
    CURRENT=$(
        zenity \
            --entry \
            --title="Brightness" \
            --text="Current: $CURRENT" \
            --entry-text=$CURRENT
    )
elif [ "$ACTION" = "." ]; then
    if [[ -n $2 ]]; then
        CURRENT=$2
    fi
else
    echo "Usage: $0 [+|-|=|.]"
    exit 1
fi

brightnessctl set "${CURRENT}%"

update_current
echo "Brightness: $CURRENT"

if [ "$NOTIFY" = "no" ]; then
    exit 0
fi

NOTIF_ID=
ID_FILE="/tmp/laptop-notification"

if [ -f "$ID_FILE" ]; then
    NOTIF_ID=$(cat "$ID_FILE")
fi

if [ -z "$NOTIF_ID" ]; then
    NOTIF_ID=0
fi

notify-send --urgency=normal \
            --icon=display-brightness-symbolic \
            --print-id \
            --replace-id=$NOTIF_ID \
            --expire-time=2000 \
            "Laptop Display" \
            "Brightness: ${CURRENT}%" > "$ID_FILE"
