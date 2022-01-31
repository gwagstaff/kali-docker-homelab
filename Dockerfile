FROM kalilinux/kali-rolling

LABEL version="2.0" \
      author="Braunbearded" \
      description="Custom Kali Linux docker container"

# install offical packages
RUN echo "deb-src http://http.kali.org/kali kali-rolling main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://ftp2.nluug.nl/os/Linux/distr/kali kali-rolling main contrib non-free" >> /etc/apt/sources.list && \
    apt -y update && apt -y upgrade && \
    echo "wireshark-common wireshark-common/install-setuid boolean true" | \
        debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive apt install --yes --no-install-recommends \
    # basic
    man-db software-properties-common wget build-essential git unzip curl atool \
    file build-essential ssh tree vim unrar rar less fuse \
    # zsh
    zsh zsh-autosuggestions zsh-syntax-highlighting \
    # bash
    bash-completion \
    # programming
    python3 python3-pip python2 cargo python3-dev default-jdk npm golang \
    # recon / web
    gobuster dirb dirbuster nikto whatweb wkhtmltopdf burpsuite zaproxy ffuf \
    nmap wfuzz finalrecon sqlmap wpscan sslscan smtp-user-enum \
    # cracking / bruteforce
    hcxtools hashcat hashcat-utils john hydra \
    # binary exploitation
    strace ltrace binwalk ghidra \
    # exploitation
    metasploit-framework exploitdb pwncat \
    # gui/vnc
    kali-desktop-xfce dbus-x11 x11vnc xvfb novnc \
    # network
    nfs-common netcat-traditional tnftp lftp iproute2 iputils-ping telnet net-tools snmp \
    wireshark traceroute tcpdump chisel \
    # dns
    dnsrecon whois dnsutils \
    # windows
    crackmapexec python3-impacket enum4linux passing-the-hash samba smbclient \
    smbmap responder impacket-scripts bloodhound \
    # other
    neovim remmina remmina-plugin-rdp mariadb-client firefox-esr seclists wordlists grc ranger \
    xclip fzf ripgrep cewl jq redis-tools default-mysql-server \
    # TODO check
    psmisc swaks libssl-dev libffi-dev nbtscan oscanner sipvicious tnscmd10g \
    onesixtyone && \
    # clear apt cache/packages
    apt -y autoclean && apt -y autoremove && apt -y clean


    # General
RUN setcap cap_net_raw,cap_net_admin,cap_net_bind_service+eip /usr/bin/nmap && \
    # setup metasploit database
    service postgresql start && msfdb init && \
    # create user
    echo "kali ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    useradd --create-home --shell /bin/zsh --user-group --groups sudo kali && \
    echo "kali:kali" | chpasswd && \
    mkdir -p "/home/kali/.config/vim" "/home/kali/.config/ranger" \
        "/home/kali/.config/zsh" "/home/kali/.config/bash" "/home/kali/.cache/java/.ZAP" && \
    tar -xf /usr/share/seclists/Passwords/Leaked-Databases/rockyou.txt.tar.gz \
        -C /usr/share/seclists/Passwords/Leaked-Databases/ && \
    git clone https://github.com/wolfcw/libfaketime /tmp/libfaketime && cd /tmp/libfaketime/src && make install && rm -rf /tmp/libfaketime && \
    npm install -g neovim

# install go (packages)
RUN export GOBIN="/usr/local/bin" && \
    mkdir -p /usr/local/bin && \
    GO111MODULE=on go get github.com/projectdiscovery/nuclei/v2/cmd/nuclei

# install python packages
RUN python3 -m pip install updog pynvim name-that-hash search-that-hash bloodhound && \
    python3 -m pip install git+https://github.com/Tib3rius/AutoRecon.git && \
    python3 -m pip install git+https://github.com/calebstewart/paramiko && \
    python3 -m pip install ciphey --upgrade && \
    wget -O /tmp/get-pip.py "https://bootstrap.pypa.io/pip/2.7/get-pip.py" && python2 /tmp/get-pip.py && rm /tmp/get-pip.py

# other
RUN wget -O /tmp/lsd.deb "$(curl -s https://api.github.com/repos/Peltoche/lsd/releases/latest | jq -r '.assets[].browser_download_url' | grep 'lsd_.*amd64')" && apt install /tmp/lsd.deb && rm /tmp/lsd.deb && \
    wget -O /usr/local/bin/findomain https://github.com/Edu4rdSHL/findomain/releases/latest/download/findomain-linux && chmod +x /usr/local/bin/findomain && \
    wget -O /usr/local/bin/gitdumper.sh https://raw.githubusercontent.com/internetwache/GitTools/master/Dumper/gitdumper.sh && chmod +x /usr/local/bin/gitdumper.sh && \
    wget -O /usr/local/bin/extractor.sh https://raw.githubusercontent.com/internetwache/GitTools/master/Extractor/extractor.sh && chmod +x /usr/local/bin/extractor.sh && \
    wget -O /usr/local/bin/gitfinder.py https://raw.githubusercontent.com/internetwache/GitTools/master/Finder/gitfinder.py && chmod +x /usr/local/bin/gitfinder.py && \
    wget -O /usr/local/bin/enum4linux-ng.py https://raw.githubusercontent.com/cddmp/enum4linux-ng/master/enum4linux-ng.py && chmod +x /usr/local/bin/enum4linux-ng.py && \
    cargo install --root "/usr/local" feroxbuster rustscan && \
    gem install evil-winrm && \
    git clone https://github.com/pwndbg/pwndbg /home/kali/.pwndbg && cd /home/kali/.pwndbg && /home/kali/.pwndbg/setup.sh && echo "source /home/kali/.pwndbg/gdbinit.py" >> /home/kali/.gdbinit && \
    chown -R kali:kali /home/kali /usr/share/zaproxy && \
    apt -y autoclean && apt -y autoremove && apt -y clean

WORKDIR /home/kali

# Tools not installed by default
# https://github.com/zardus/ctf-tools.git   # ctf tools
# https://github.com/noraj/haiti            # hashidentifier
# wget -O /tmp/rhp-ext "$(curl -s -L https://api.github.com/repos/quantumcore/remote_hacker_probe/releases/latest | jq -r '.assets[].browser_download_url')" && atool -X /tmp/rhp /tmp/rhp-ext && mv /tmp/rhp/RHP.jar /usr/local/bin && chmod +x /usr/local/bin/RHP.jar && rm -rf /tmp/rhp-ext /tmp/rhp && \
# Nessus
