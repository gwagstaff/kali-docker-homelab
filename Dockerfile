FROM kalilinux/kali-rolling

LABEL version="1.0" \
      author="Braunbearded" \
      description="Custom Kali Linux docker container"

RUN echo "deb-src http://http.kali.org/kali kali-rolling main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://ftp2.nluug.nl/os/Linux/distr/kali kali-rolling main contrib non-free" >> /etc/apt/sources.list

    # todo install rustscan
RUN apt -y update && \
    apt install --yes --no-install-recommends vim telnet nmap zsh wfuzz \
    metasploit-framework sqlmap wpscan netcat enum4linux samba gobuster dirb \
    dirbuster exploitdb hash-identifier hashcat hashcat-utils hashid hydra \
    hcxtools seclists wordlists man-db burpsuite binwalk steghide chafa john \
    python3 python3-pip python2 software-properties-common strace ltrace wget \
    git unzip build-essential curl smbclient iproute2 iputils-ping \
    kali-desktop-xfce net-tools dbus-x11 x11vnc xvfb psmisc ssh ftp \
    nfs-common cargo zaproxy swaks libssl-dev libffi-dev build-essential \
    python3-dev finalrecon nbtscan nikto onesixtyone oscanner smbmap \
    smtp-user-enum snmp sslscan sipvicious tnscmd10g whatweb wkhtmltopdf \
    zsh-autosuggestions zsh-syntax-highlighting bash-completion tree && \
    wireshark neovim remmina && \
    tar -xf /usr/share/seclists/Passwords/Leaked-Databases/rockyou.txt.tar.gz -C /usr/share/seclists/Passwords/Leaked-Databases/ && \
    echo "kali ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    service postgresql start && \
    git clone https://github.com/zardus/ctf-tools.git /ctf-tools && \
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python2 get-pip.py && rm get-pip.py && \
    useradd --create-home --shell /bin/bash --user-group --groups sudo kali && echo "kali:kali" | chpasswd && \
    cargo install feroxbuster && \
    python3 -m pip install git+https://github.com/Tib3rius/AutoRecon.git && \
    python3 -m pip install updog && \
    apt -y autoclean && apt -y autoremove && apt -y clean

WORKDIR /home/kali

ENTRYPOINT /bin/bash
