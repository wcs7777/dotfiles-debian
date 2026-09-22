#!/bin/bash

gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:swapcaps']"
gsettings set org.gnome.settings-daemon.plugins.media-keys control-center "['<Super>i']"
gsettings set org.gnome.settings-daemon.plugins.media-keys home "['<Super>e']"
gsettings set org.gnome.settings-daemon.plugins.media-keys search "['<Super>q']"

gsettings set org.gnome.settings-daemon.plugins.media-keys volume-down "['<Shift>KP_Right']"
gsettings set org.gnome.settings-daemon.plugins.media-keys volume-up "['<Shift>KP_Page_Up']"
gsettings set org.gnome.settings-daemon.plugins.media-keys volume-mute "['<Shift>KP_Next']"
gsettings set org.gnome.settings-daemon.plugins.media-keys play "['<Shift>KP_Delete']"

paths=()

path="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/brightness_up/"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$path name 'Brightness up'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$path command 'monitor-brightness +'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$path binding '<Shift>KP_Up'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$path enable-in-lockscreen false
paths+=("'$path'")

path="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/brightness_down/"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$path name 'Brightness down'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$path command 'monitor-brightness -'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$path binding '<Shift>KP_Begin'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$path enable-in-lockscreen false
paths+=("'$path'")

path="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/brightness_set/"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$path name 'Brightness set'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$path command 'monitor-brightness ='
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$path binding '<Shift>KP_Down'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$path enable-in-lockscreen false
paths+=("'$path'")

joined_paths=$(printf "%s, " "${paths[@]}")
joined_paths=${joined_paths%, }

gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "[$joined_paths]"

gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 3600

if ! rg -q '^HandleLidSwitch=ignore' /etc/systemd/logind.conf; then
	echo "Ignoring laptop lid close"
	sudo sed -i '/HandleLidSwitch=/c\HandleLidSwitch=ignore' /etc/systemd/logind.conf
	sudo sed -i '/HandleLidSwitchExternalPower=/c\HandleLidSwitchExternalPower=ignore' /etc/systemd/logind.conf
	sudo sed -i '/HandleLidSwitchDocked=/c\HandleLidSwitchDocked=ignore' /etc/systemd/logind.conf
fi

if ! rg -q '^GRUB_TIMEOUT_STYLE' /etc/systemd/logind.conf; then
	echo "Skipping grub in login"
	sudo sed -i '/GRUB_TIMEOUT=/c\GRUB_TIMEOUT=0' /etc/default/grub
	sudo sed -i '/GRUB_TIMEOUT=/a\GRUB_TIMEOUT_STYLE=hidden' /etc/default/grub
	sudo update-grub
fi
