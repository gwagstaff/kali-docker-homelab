#!/bin/sh

# Setup TigerVNCServer with password for guacamole usage

# set vnc password + startup if no .vnc folder
mkdir -p ~/.vnc/
wget https://gitlab.com/kalilinux/nethunter/build-scripts/kali-nethunter-project/-/raw/master/nethunter-fs/profiles/xstartup -O ~/.vnc/xstartup
< "$KALI_VNC_PASSWD_FILE" tigervncpasswd -f > "$HOME/.vnc/passwd"

#run vncserver
vncserver :0 > /var/log/vncserver.log 2>&1

/bin/bash


