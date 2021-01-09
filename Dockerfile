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
    python3 python3-pip python2 cargo python3-dev \
    # recon / web
    gobuster dirb dirbuster nikto whatweb wkhtmltopdf burpsuite zaproxy cargo \
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
    net-tools smbmap snmp wireshark \
    # other
    neovim remmina mariadb-client firefox-esr seclists wordlists grc ranger \
    npm golang xclip fzf ripgrep \
    # TODO
    psmisc swaks libssl-dev libffi-dev nbtscan  oscanner sipvicious tnscmd10g \
    onesixtyone && \
    # todo install rustscan
    \
    # install 3rd party packages
    tar -xf /usr/share/seclists/Passwords/Leaked-Databases/rockyou.txt.tar.gz \
        -C /usr/share/seclists/Passwords/Leaked-Databases/ && \
    cargo install feroxbuster && \
    CURR_LSD_VER="$(curl -s https://github.com/Peltoche/lsd/releases/latest | grep -Eo "[0-9]*\.[0-9]*\.[0-9]")" && \
        wget -O "/tmp/lsd" "https://github.com/Peltoche/lsd/releases/download/$CURR_LSD_VER/lsd_${CURR_LSD_VER}_amd64.deb" && \
        sudo dpkg -i "/tmp/lsd" && rm "/tmp/lsd" && \
    python3 -m pip install updog base64io pynvim && \
    python3 -m pip install git+https://github.com/Tib3rius/AutoRecon.git && \
    python3 -m pip install git+https://github.com/calebstewart/paramiko && \
    python3 -m pip install git+https://github.com/calebstewart/pwncat.git && \
    npm install -g neovim && \
    apt -y autoclean && apt -y autoremove && apt -y clean && \
    # user
    # chown kali:kali /start.sh && \
    echo "kali ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    useradd --create-home --shell /bin/zsh --user-group --groups sudo kali && \
    echo "kali:kali" | chpasswd && \
    mkdir -p "/home/kali/.config/vim" "/home/kali/.config/ranger" \
        "/home/kali/.config/zsh" "/home/kali/.config/bash" && \
    chown -R kali:kali /home/kali


WORKDIR /home/kali

    # git clone https://github.com/zardus/ctf-tools.git /ctf-tools && \
    # curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python2 get-pip.py && rm get-pip.py && \
    # service postgresql start && \
