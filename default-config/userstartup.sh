#!/bin/sh

# Do your user specific stuff like overriding env variables here

# lunarvim
export PATH=~/.npm-global/bin:$PATH
[ ! -d "$HOME/.config/lvim" ] && mkdir -p $HOME/.npm-global && npm config set prefix "$HOME/.npm-global" && wget -O /tmp/lunar-install.sh https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh && bash /tmp/lunar-install.sh && rm /tmp/lunar-install.sh && echo "vim.opt.relativenumber = true" >> "$HOME/.config/lvim/config.lua"
npm list --depth 1 -g neovim > /dev/null || npm install -g neovim
pip3 show pynvim > /dev/null || sudo python3 -m pip install pynvim

# install prettier lsd
if ! command -v lsd > /dev/null; then
  wget -O /tmp/lsd.deb "$(curl -s https://api.github.com/repos/Peltoche/lsd/releases/latest | jq -r '.assets[].browser_download_url' | grep 'lsd_.*amd64')" 
  sudo apt install /tmp/lsd.deb 
  rm /tmp/lsd.deb
fi

# get ranger conf
[ ! -f "$HOME/.config/ranger/rc.conf" ] && mkdir -p "$HOME/.config/ranger/" && curl https://gist.githubusercontent.com/braunbearded/de021eda8704ccc98c19e12a15d57ca8/raw/c0b374b0c23582acda72d0a0b4cc5cbfd7a8729e/rc.conf > "$HOME/.config/ranger/rc.conf"

echo "# empty" > "$HOME/.zshrc"

echo ""
echo "#########################################################################"
echo "CHECK: finalrecon enum4linux psmisc swaks libssl-dev libffi-dev nbtscan"
echo "       oscanner sipvicious tnscmd10g finddomain rhp feroxbuster traitor"
echo "TODO: compare dirb/dirbuster wordlists with /usr/share/wordlists"
echo "#########################################################################"
echo "# port scanning"
echo "      nmap rustscan"
echo "# forced browsing"
echo "      fuff feroxbuster wfuzz gobuster dirb dirbuster"
echo "# scanner"
echo "      nikto whatweb autorecon finalrecon reconftw findomain"
echo "# proxy"
echo "      zaproxy burpsuite"
echo "# sql"
echo "      sqlmap mysql"
echo "# web other"
echo "      wkhtmltopdf wpscan sslscan"
echo "# exploitation"
echo "      msfconsole searchsploit exploitdb pwncat nuclei traitor"
echo "# cracking"
echo "      name-that-hash hashcat john hydra hcxtools hash-identifier "
echo "      hashcat-utils hashid search-that-hash ciphey"
echo "# binary exploitation"
echo "      strace ltrace binwalk strings file pwndbg"
echo "# mail"
echo "      smtp-user-enum"
echo "# samba / ftp / snmp / rdp, vnc / network"
echo "      enum4linux smbclint smbmap ftp snmp wireshark remmina traceroute"
echo "      whois"
echo "# other"
echo "      updog cewl psmisc swaks libssl-dev libffi-dev nbtscan "
echo "      oscanner sipvicious tnscmd10g onesixtyone"
echo "#########################################################################"

# Installing reconftw results in wired version issues
#if [ ! -d "$HOME/.reconftw" ]; then
#    git clone https://github.com/six2dez/reconftw.git "$HOME/.reconftw"
#    cd .reconftw
#    chmod +x *.sh
#    ./install.sh
#    cd "$HOME"
#fi

