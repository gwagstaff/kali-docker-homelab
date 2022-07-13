#!/bin/sh

# Do your user specific stuff like overriding env variables here

# Nvchad
if [ ! -d "$HOME/.config/nvim" ]; then
  git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
  mkdir -p ~/.config/nvim/lua/custom
  echo "vim.opt.relativenumber = true" > ~/.config/nvim/lua/custom/init.lua
fi

pip3 show pynvim > /dev/null || sudo python3 -m pip install pynvim

# install prettier lsd
if ! command -v lsd > /dev/null; then
  wget -O /tmp/lsd.deb "$(curl -s https://api.github.com/repos/Peltoche/lsd/releases/latest | jq -r '.assets[].browser_download_url' | grep 'lsd_.*amd64')" 
  sudo apt install /tmp/lsd.deb 
  rm /tmp/lsd.deb
fi

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
echo "      enum4linux smbclient smbmap ftp snmp wireshark remmina traceroute"
echo "      whois"
echo "# other"
echo "      updog cewl psmisc swaks libssl-dev libffi-dev nbtscan "
echo "      oscanner sipvicious tnscmd10g onesixtyone"
echo "#########################################################################"

