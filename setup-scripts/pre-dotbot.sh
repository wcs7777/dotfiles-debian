#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo apt-get update && sudo apt-get upgrade --yes

sudo apt-get install dbus  --yes
sudo systemctl start dbus
sudo systemctl reset-failed

sudo apt-get install python3 git  --yes

source "${BASEDIR}/config-locales.sh"
