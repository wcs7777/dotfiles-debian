#!/bin/bash

if grep -q "^connected$" /sys/class/drm/card*-HDMI-A-1/status; then
    monitor-brightness "$@"
else
    laptop-brightness "$@"
fi
