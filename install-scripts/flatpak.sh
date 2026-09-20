#!/bin/bash

if command -v flatpak &> /dev/null; then
	echo "flatpak is already installed"
	exit 0
fi

sudo apt-get update
sudo apt-get install flatpak --yes
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak install flathub io.missioncenter.MissionCenter --noninteractive
