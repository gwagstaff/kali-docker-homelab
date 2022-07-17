#!/bin/sh

# Setup TigerVNCServer with password for guacamole usage

# set vnc password + startup if no .vnc folder
if [ ! -d "$HOME/.vnc/" ]; then
  mkdir -p ~/.vnc/
  wget "https://gitlab.com/kalilinux/nethunter/build-scripts/kali-nethunter-project/-/raw/master/nethunter-fs/profiles/xstartup" -O ~/.vnc/xstartup
  chmod 755 ~/.vnc/xstartup
  < "$KALI_VNC_PASSWD_FILE" vncpasswd -f > "$HOME/.vnc/passwd"
  chmod 600 ~/.vnc/passwd
fi
#run vncserver
USER=$(whoami) vncserver :0 -geometry 1920x1080

echo 'vnc server started at port 5900 with password from $KALI_VNC_PASSWD_FILE'

cmd="/bin/zsh"
[ "$1" != "" ] && cmd="$1"
$cmd