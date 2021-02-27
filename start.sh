#!/bin/sh

. "$HOME/.profile"
echo ""
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
echo "      msfconsole searchsploit exploitdb pwncat nuclei"
echo "# cracking"
echo "      name-that-hash hashcat john hydra hcxtools hash-identifier "
echo "      hashcat-utils hashid search-that-hash ciphey"
echo "# binary exploitation"
echo "      strace ltrace binwalk strings file pwndbg"
echo "# mail"
echo "      smtp-user-enum"
echo "# samba / ftp / snmp / rdp, vnc / network"
echo "      enum4linux smbclint smbmap ftp snmp wireshark remmina"
echo "# other"
echo "      updog cewl psmisc swaks libssl-dev libffi-dev nbtscan "
echo "      oscanner sipvicious tnscmd10g onesixtyone"
echo "#########################################################################"

if [ ! -d "$HOME/.reconftw" ]; then
    export GOROOT=/usr/local/go
    export GOPATH=$HOME/go
    git clone https://github.com/six2dez/reconftw.git "$HOME/.reconftw"
    cd reconftw
    chmod +x *.sh
    ./install.sh
    cd "$HOME"
fi

/bin/zsh
