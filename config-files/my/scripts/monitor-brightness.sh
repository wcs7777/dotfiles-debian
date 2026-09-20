#!/bin/bash

ACTION=$1
BUS=4
STEP=5
CURRENT=100
NOTIFY=yes

update_current() {
    CURRENT=$(ddcutil getvcp 10 --bus $BUS --brief | grep -oP ' C \K\d+')
}

if [ "$ACTION" = "+" ]; then
    ddcutil setvcp 10 + $STEP --bus $BUS
elif [ "$ACTION" = "-" ]; then
    ddcutil setvcp 10 - $STEP --bus $BUS
elif [ "$ACTION" = "=" ]; then
    update_current
    OUTPUT=$(
        zenity \
            --entry \
            --title="Brightness" \
            --text="Current: $CURRENT" \
            --entry-text=$CURRENT
    )
    ddcutil setvcp 10 "$OUTPUT" --bus $BUS
elif [ "$ACTION" = "." ]; then
    NOTIFY=no
    if [[ -n $2 ]]; then
        ddcutil setvcp 10 $2 --bus $BUS
    fi
else
    echo "Usage: $0 [+|-|=|.]"
    exit 1
fi

update_current
echo "Brightness: $CURRENT"

if [ "$NOTIFY" = "no" ]; then
    exit 0
fi

NOTIF_ID=
ID_FILE="/tmp/brightness-notification"

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
            "External Display" \
            "Brightness: ${CURRENT}%" > "$ID_FILE"
