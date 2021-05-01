FROM kalilinux/kali-rolling

LABEL version="1.0" \
      author="Braunbearded" \
      description="Custom Kali Linux docker container"

RUN echo "deb-src http://http.kali.org/kali kali-rolling main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://ftp2.nluug.nl/os/Linux/distr/kali kali-rolling main contrib non-free" >> /etc/apt/sources.list && \
    # install packages
    apt -y update && apt -y upgrade && \
    echo "wireshark-common wireshark-common/install-setuid boolean true" | \
        debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive apt install --yes --no-install-recommends \
    # basic
    man-db software-properties-common wget build-essential git unzip curl \
    file build-essential ssh tree vim \
    # zsh
    zsh zsh-autosuggestions zsh-syntax-highlighting \
    # bash
    bash-completion \
    # programming
    python3 python3-pip python2 cargo python3-dev default-jdk npm golang \
    # recon / web
    gobuster dirb dirbuster nikto whatweb wkhtmltopdf burpsuite zaproxy \
    nmap wfuzz enum4linux finalrecon sqlmap wpscan sslscan smtp-user-enum \
    # cracking / bruteforce
    hcxtools hash-identifier hashcat hashcat-utils hashid john hydra \
    # binary exploitation
    strace ltrace binwalk \
    # exploitation
    metasploit-framework exploitdb \
    # gui/vnc
    kali-desktop-xfce dbus-x11 x11vnc xvfb novnc \
    # network
    nfs-common samba smbclient netcat ftp iproute2 iputils-ping telnet \
    net-tools smbmap snmp wireshark traceroute whois passing-the-hash \
    # windows
    crackmapexec python3-impacket \
    # other
    neovim remmina remmina-plugin-rdp mariadb-client firefox-esr seclists wordlists grc ranger \
    xclip fzf ripgrep cewl \
    # TODO check nessus
    psmisc swaks libssl-dev libffi-dev nbtscan oscanner sipvicious tnscmd10g \
    onesixtyone && \
    # settings
    setcap cap_net_raw,cap_net_admin,cap_net_bind_service+eip /usr/bin/nmap && \
    # setup metasploit database
    service postgresql start && msfdb init && \
    # create user
    echo "kali ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    useradd --create-home --shell /bin/zsh --user-group --groups sudo kali && \
    echo "kali:kali" | chpasswd && \
    mkdir -p "/home/kali/.config/vim" "/home/kali/.config/ranger" \
        "/home/kali/.config/zsh" "/home/kali/.config/bash" "/home/kali/.cache/java/.ZAP" && \
    # install 3rd party packages
    tar -xf /usr/share/seclists/Passwords/Leaked-Databases/rockyou.txt.tar.gz \
        -C /usr/share/seclists/Passwords/Leaked-Databases/ && \
    export GOBIN="/usr/local/bin" && \
    mkdir -p /usr/local/bin && \
    go get -u github.com/ffuf/ffuf && \
    GO111MODULE=on go get github.com/projectdiscovery/nuclei/v2/cmd/nuclei && \
    CGO_ENABLED=0 go get -u github.com/liamg/traitor/cmd/traitor && \
    cargo install --root "/usr/local" feroxbuster rustscan && \
    CURR_LSD_VER="$(curl -s https://github.com/Peltoche/lsd/releases/latest | grep -Eo "[0-9]*\.[0-9]*\.[0-9]")" && \
        wget -O "/tmp/lsd" "https://github.com/Peltoche/lsd/releases/download/$CURR_LSD_VER/lsd_${CURR_LSD_VER}_amd64.deb" && \
        sudo dpkg -i "/tmp/lsd" && rm "/tmp/lsd" && \
    python3 -m pip install updog base64io pynvim name-that-hash search-that-hash && \
    python3 -m pip install git+https://github.com/Tib3rius/AutoRecon.git && \
    python3 -m pip install git+https://github.com/calebstewart/paramiko && \
    python3 -m pip install git+https://github.com/calebstewart/pwncat.git && \
    python3 -m pip install ciphey --upgrade && \
    npm install -g neovim && \
    apt -y autoclean && apt -y autoremove && apt -y clean && \
    wget -O /usr/local/bin/findomain https://github.com/Edu4rdSHL/findomain/releases/latest/download/findomain-linux && chmod +x /usr/local/bin/findomain && \
    wget -O /tmp/rhp.zip "https://github.com/$(curl -q https://github.com/quantumcored/remote_hacker_probe/releases | grep -o "/quantumcored/remote_hacker_probe/releases/download/.*zip" | head -n 1)" && unzip -d /tmp /tmp/rhp.zip && mv /tmp/RHP.jar /usr/local/bin && chmod +x /usr/local/bin/RHP.jar && \
    wget -O /tmp/get-pip.py "https://bootstrap.pypa.io/pip/2.7/get-pip.py" && python2 /tmp/get-pip.py && rm /tmp/get-pip.py && \
    curl -o /tmp/ghidra.zip "https://www.ghidra-sre.org/$(curl -q https://www.ghidra-sre.org/ | grep "Download" | grep -Eo "ghidra[^ \"]*\.zip")" && unzip -d /home/kali /tmp/ghidra.zip && \
    git clone https://github.com/pwndbg/pwndbg /home/kali/.pwndbg && \
    cd /home/kali/.pwndbg && ./setup.sh && echo "source /home/kali/.pwndbg/gdbinit.py" >> /home/kali/.gdbinit && \
    chown -R kali:kali /home/kali /usr/share/zaproxy

WORKDIR /home/kali

    # git clone https://github.com/zardus/ctf-tools.git /ctf-tools && \
    # service postgresql start && \
