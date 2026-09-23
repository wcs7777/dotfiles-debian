#!/usr/bin/env bash

sudo \
    env \
    DBUS_SESSION_BUS_ADDRESS="$DBUS_SESSION_BUS_ADDRESS" \
    XDG_RUNTIME_DIR="$XDG_RUNTIME_DIR" \
    RUST_LOG=warn \
    xremap \
    --watch=config,device \
    --mouse \
    --device 'YICHIP Wireless Device Mouse' \
    /etc/xremap/mouse.yml
