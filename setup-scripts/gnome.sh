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
