FROM kalilinux/kali-rolling

LABEL maintainer="naphal@naphal.net"

# install offical packages
RUN echo "deb-src http://http.kali.org/kali kali-rolling main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.ocf.berkeley.edu/kali kali-rolling main contrib non-free" >> /etc/apt/sources.list && \
    # echo "deb http://http.kali.org/kali kali-bleeding-edge main contrib non-free" >> /etc/apt/sources.list && \
    apt-get -y update && apt-get -y upgrade && \
    echo "wireshark-common wireshark-common/install-setuid boolean true" | \
        debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
    # basic
    man-db software-properties-common wget build-essential git unzip curl atool \
    file build-essential ssh tree vim less fuse \
    # shells
    zsh zsh-autosuggestions zsh-syntax-highlighting bash-completion \
    # programming
    python3 python3-pip python2 cargo python3-dev python3-venv default-jdk npm golang shfmt shellcheck python3-virtualenv \
    # recon / web
    gobuster dirb dirbuster nikto whatweb wkhtmltopdf burpsuite zaproxy ffuf \
    nmap wfuzz finalrecon sqlmap wpscan sslscan smtp-user-enum feroxbuster \
    # cracking / bruteforce
    hcxtools hashcat hashcat-utils john hydra \
    # binary exploitation
    strace ltrace binwalk ghidra \
    # exploitation
    metasploit-framework exploitdb pwncat nuclei \
    # gui/vnc
    kali-desktop-xfce tightvncserver dbus dbus-x11 xfonts-base\
    # network
    nfs-common netcat-traditional tnftp lftp iproute2 iputils-ping telnet net-tools snmp \
    wireshark traceroute tcpdump chisel tor proxychains libcap2-bin \
    # dns
    dnsrecon whois dnsutils \
    # windows
    crackmapexec python3-impacket enum4linux passing-the-hash samba smbclient \
    smbmap responder impacket-scripts bloodhound rlwrap \
    # other
    remmina remmina-plugin-rdp  firefox-esr seclists wordlists grc ranger \
    xclip fzf ripgrep cewl jq redis-tools default-mysql-server \
    psmisc swaks libssl-dev libffi-dev nbtscan oscanner sipvicious tnscmd10g \
    onesixtyone && \
    # clear apt cache/packages
    apt-get -y autoclean && apt-get -y autoremove && apt-get -y clean

    # General
RUN setcap cap_net_raw,cap_net_admin,cap_net_bind_service+eip /usr/bin/nmap && \
    sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen && \
    # create user
    echo "kali ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    useradd --create-home --shell /bin/zsh --user-group --groups sudo kali && \
    echo "kali:kali" | chpasswd && \
    mkdir -p /etc/zsh/zshrc.d && \
    printf 'if [ -d /etc/zsh/zshrc.d ]; then\n  for i in /etc/zsh/zshrc.d/*; do\n    if [ -r $i ]; then\n      . $i\n    fi\n  done\n  unset i\nfi' >> /etc/zsh/zshrc && \
    tar -xf /usr/share/seclists/Passwords/Leaked-Databases/rockyou.txt.tar.gz \
        -C /usr/share/seclists/Passwords/Leaked-Databases/

# install python packages
RUN python3 -m pip install updog name-that-hash search-that-hash && \
    python3 -m pip install git+https://github.com/Tib3rius/AutoRecon.git && \
    python3 -m pip install git+https://github.com/calebstewart/paramiko && \
    wget -O /tmp/get-pip.py "https://bootstrap.pypa.io/pip/2.7/get-pip.py" && python2 /tmp/get-pip.py && rm /tmp/get-pip.py

# clone usefull repos
RUN mkdir -p /opt/repos && \
    git clone https://github.com/swisskyrepo/PayloadsAllTheThings.git /opt/repos/PayloadsAllTheThings && \
    git clone https://github.com/samratashok/nishang.git /opt/repos/nishang && \
    git clone https://github.com/FireFart/dirtycow.git /opt/repos/dirtycow && \
    git clone https://github.com/dirkjanm/krbrelayx.git /opt/repos/krbrelayx && \
    git clone https://github.com/rebootuser/LinEnum.git /opt/repos/LinEnum && \
    git clone https://github.com/mzet-/linux-exploit-suggester.git /opt/repos/linux-exploit-suggester && \
    git clone https://github.com/diego-treitos/linux-smart-enumeration.git /opt/repos/linux-smart-enumeration && \
    git clone https://github.com/CISOfy/lynis.git /opt/repos/lynis && \
    git clone https://github.com/ivan-sincek/php-reverse-shell.git /opt/repos/php-reverse-shell && \
    git clone https://github.com/mostaphabahadou/postenum.git /opt/repos/postenum && \
    git clone https://github.com/PowerShellMafia/PowerSploit.git /opt/repos/PowerSploit && \
    git clone https://github.com/diegocr/netcat.git /opt/repos/netcat && \
    git clone https://github.com/Greenwolf/ntlm_theft /opt/repos/ntlm_theft && \
    git clone https://github.com/bitsadmin/wesng /opt/repos/wesng && \
    git clone https://github.com/braunbearded/hacking-handbook /opt/repos/hacking-handbook

# files for external usage
RUN mkdir -p /opt/external && \ 
    wget -O /tmp/chisel_linux64.gz "$(curl -s https://api.github.com/repos/jpillora/chisel/releases/latest | jq -r '.assets[].browser_download_url' | grep 'chisel_.*_linux_amd64')" && gunzip /tmp/chisel_linux64.gz && mv /tmp/chisel_linux64 /opt/external && \
    wget -O /tmp/chisel_linux86.gz "$(curl -s https://api.github.com/repos/jpillora/chisel/releases/latest | jq -r '.assets[].browser_download_url' | grep 'chisel_.*_linux_386')" && gunzip /tmp/chisel_linux86.gz && mv /tmp/chisel_linux86 /opt/external && \
    wget -O /tmp/chisel_win64.gz "$(curl -s https://api.github.com/repos/jpillora/chisel/releases/latest | jq -r '.assets[].browser_download_url' | grep 'chisel_.*_windows_amd64')" && gunzip /tmp/chisel_win64.gz && mv /tmp/chisel_win64 /opt/external/chisel_win64.exe && \
    wget -O /tmp/chisel_win86.gz "$(curl -s https://api.github.com/repos/jpillora/chisel/releases/latest | jq -r '.assets[].browser_download_url' | grep 'chisel_.*_windows_386')" && gunzip /tmp/chisel_win86.gz && mv /tmp/chisel_win86 /opt/external/chisel_win86.exe && \
    wget -O /opt/external/pspy32 "$(curl -s https://api.github.com/repos/DominicBreuker/pspy/releases/latest | jq -r '.assets[].browser_download_url' | grep 'pspy32$')" && \
    wget -O /opt/external/pspy32s "$(curl -s https://api.github.com/repos/DominicBreuker/pspy/releases/latest | jq -r '.assets[].browser_download_url' | grep 'pspy32s')" && \
    wget -O /opt/external/pspy64 "$(curl -s https://api.github.com/repos/DominicBreuker/pspy/releases/latest | jq -r '.assets[].browser_download_url' | grep 'pspy64$')" && \
    wget -O /opt/external/pspy64s "$(curl -s https://api.github.com/repos/DominicBreuker/pspy/releases/latest | jq -r '.assets[].browser_download_url' | grep 'pspy64s')" && \
    wget -O /opt/external/linpeas.sh "$(curl -s https://api.github.com/repos/carlospolop/PEASS-ng/releases/latest | jq -r '.assets[].browser_download_url' | grep 'linpeas.sh')" && \
    wget -O /opt/external/linpeas_linux_386 "$(curl -s https://api.github.com/repos/carlospolop/PEASS-ng/releases/latest | jq -r '.assets[].browser_download_url' | grep 'linpeas_linux_386')" && \
    wget -O /opt/external/linpeas_linux_amd64 "$(curl -s https://api.github.com/repos/carlospolop/PEASS-ng/releases/latest | jq -r '.assets[].browser_download_url' | grep 'linpeas_linux_amd64')" && \
    wget -O /opt/external/winPEAS.bat "$(curl -s https://api.github.com/repos/carlospolop/PEASS-ng/releases/latest | jq -r '.assets[].browser_download_url' | grep 'winPEAS.bat')" && \
    wget -O /opt/external/winPEASany.exe "$(curl -s https://api.github.com/repos/carlospolop/PEASS-ng/releases/latest | jq -r '.assets[].browser_download_url' | grep 'winPEASany.exe')" && \
    wget -O /opt/external/winPEASany_ofs.exe "$(curl -s https://api.github.com/repos/carlospolop/PEASS-ng/releases/latest | jq -r '.assets[].browser_download_url' | grep 'winPEASany_ofs.exe')" && \
    wget -O /opt/external/winPEASx64.exe "$(curl -s https://api.github.com/repos/carlospolop/PEASS-ng/releases/latest | jq -r '.assets[].browser_download_url' | grep 'winPEASx64.exe')" && \
    wget -O /opt/external/winPEASx64_ofs.exe "$(curl -s https://api.github.com/repos/carlospolop/PEASS-ng/releases/latest | jq -r '.assets[].browser_download_url' | grep 'winPEASx64_ofs.exe')" && \
    wget -O /opt/external/winPEASx86.exe "$(curl -s https://api.github.com/repos/carlospolop/PEASS-ng/releases/latest | jq -r '.assets[].browser_download_url' | grep 'winPEASx86.exe')" && \
    wget -O /opt/external/winPEASx86_ofs.exe "$(curl -s https://api.github.com/repos/carlospolop/PEASS-ng/releases/latest | jq -r '.assets[].browser_download_url' | grep 'winPEASx86_ofs.exe')" && \
    wget -O /tmp/sysint.zip 'https://download.sysinternals.com/files/SysinternalsSuite.zip' && unzip /tmp/sysint.zip -d /opt/external && rm /opt/external/*.chm /opt/external/*.txt /tmp/sysint.zip && \
    mkdir /tmp/mimi && wget -O /tmp/mimi/mimikatz.zip "$(curl -s https://api.github.com/repos/gentilkiwi/mimikatz/releases/latest | jq -r '.assets[].browser_download_url' | grep 'mimikatz_.*.zip')" && \
    unzip /tmp/mimi/mimikatz.zip -d /tmp/mimi && cp /tmp/mimi/Win32/mimikatz.exe /opt/external/mimikatz32.exe && cp /tmp/mimi/Win32/mimilove.exe /opt/external/mimilove.exe && cp /tmp/mimi/x64/mimikatz.exe /opt/external/mimikatz64.exe && rm -rf /tmp/mimi && \
    wget -O /opt/external/traitor-386 "$(curl -s https://api.github.com/repos/liamg/traitor/releases/latest | jq -r '.assets[].browser_download_url' | grep 'traitor-386')" && \
    wget -O /opt/external/traitor-amd64 "$(curl -s https://api.github.com/repos/liamg/traitor/releases/latest | jq -r '.assets[].browser_download_url' | grep 'traitor-amd64')" && \
    wget -O /opt/external/SharpWeb.exe "$(curl -s https://api.github.com/repos/djhohnstein/SharpWeb/releases/latest | jq -r '.assets[].browser_download_url' | grep '.*.exe')" && \
    mkdir -p /opt/external/SharpCollection && git clone https://github.com/Flangvik/SharpCollection /opt/external/SharpCollection && \
    wget -O /opt/external/PrivescCheck.ps1 https://raw.githubusercontent.com/itm4n/PrivescCheck/master/PrivescCheck.ps1 && \
    wget -O /opt/external/SharpHound.exe https://github.com/BloodHoundAD/BloodHound/raw/master/Collectors/SharpHound.exe

COPY configs/ctf-kali/bashrc /home/kali/.bashrc
COPY configs/ctf-kali/zshrc /home/kali/.zshrc

# other tools
RUN mkdir -p /usr/local/bin && \
    wget -O /tmp/rustscan.deb "$(curl -s https://api.github.com/repos/RustScan/RustScan/releases/tags/2.0.1 | jq -r '.assets[].browser_download_url' | grep 'rustscan_.*_amd64')" && apt install /tmp/rustscan.deb && rm /tmp/rustscan.deb && \
    wget -O /tmp/nvim.deb "$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | jq -r '.assets[].browser_download_url' | grep -E 'nvim\-linux64\.deb$')" && apt install /tmp/nvim.deb && rm /tmp/nvim.deb && \
    # wget -O /tmp/nuclei.zip "$(curl -s https://api.github.com/repos/projectdiscovery/nuclei/releases/latest | jq -r '.assets[].browser_download_url' | grep 'nuclei_.*_linux_amd64')" && unzip /tmp/nuclei.zip -d /usr/local/bin && rm /tmp/nuclei.zip && \
    wget -O /usr/local/bin/findomain https://github.com/Edu4rdSHL/findomain/releases/latest/download/findomain-linux && chmod +x /usr/local/bin/findomain && \
    wget -O /usr/local/bin/gitdumper.sh https://raw.githubusercontent.com/internetwache/GitTools/master/Dumper/gitdumper.sh && chmod +x /usr/local/bin/gitdumper.sh && \
    wget -O /usr/local/bin/extractor.sh https://raw.githubusercontent.com/internetwache/GitTools/master/Extractor/extractor.sh && chmod +x /usr/local/bin/extractor.sh && \
    wget -O /usr/local/bin/gitfinder.py https://raw.githubusercontent.com/internetwache/GitTools/master/Finder/gitfinder.py && chmod +x /usr/local/bin/gitfinder.py && \
    wget -O /usr/local/bin/enum4linux-ng.py https://raw.githubusercontent.com/cddmp/enum4linux-ng/master/enum4linux-ng.py && chmod +x /usr/local/bin/enum4linux-ng.py && \
    gem install evil-winrm && \
    npm install -g yarn && \
    git clone https://github.com/pwndbg/pwndbg /home/kali/.pwndbg && cd /home/kali/.pwndbg && /home/kali/.pwndbg/setup.sh && echo "source /home/kali/.pwndbg/gdbinit.py" >> /home/kali/.gdbinit && \
    chown -R kali:kali /home/kali /usr/share/zaproxy && \
    apt -y autoclean && apt -y autoremove && apt -y clean

WORKDIR /home/kali

# setup entrypoint.sh that spins up vnc server on start
COPY ./configs/ctf-kali/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]