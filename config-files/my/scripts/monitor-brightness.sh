#!/bin/bash

ACTION=$1
BUS=4
STEP=5
CURRENT=100

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
    update_current
    OUTPUT=$(
        zenity \
            --scale \
            --title="Brightness" \
            --text="Current: $CURRENT" \
            --min-value=0 \
            --max-value=100 \
            --value=$CURRENT
    )
    ddcutil setvcp 10 $OUTPUT --bus $BUS
else
    echo "Usage: $0 [+|-|=|.]"
    exit 1
fi

update_current
echo "Brightness: $CURRENT"

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
