FROM kalilinux/kali-rolling

LABEL version="1.0" \
      author="Braunbearded" \
      description="Custom Kali Linux docker container"

RUN echo "deb-src http://http.kali.org/kali kali-rolling main contrib non-free" >> /etc/apt/sources.list

RUN apt -y update && \
    apt install -y vim telnet nmap metasploit-framework sqlmap wpscan netcat enum4linux samba gobuster dirb dirbuster exploitdb hash-identifier hashcat hashcat-utils hashid hydra hcxtools seclists wordlists man-db burpsuite binwalk steghide chafa john python3 python3-pip software-properties-common strace ltrace wget git unzip build-essential curl smbclient && \
    tar -xf /usr/share/seclists/Passwords/Leaked-Databases/rockyou.txt.tar.gz -C /usr/share/seclists/Passwords/Leaked-Databases/ && \
    service postgresql start && \
    echo 'alias burpsuite="exec /bin/java -jar /usr/bin/burpsuite "$@""' >> /root/.bashrc && \
    git clone https://github.com/zardus/ctf-tools.git /ctf-tools && \
    apt -y autoclean && apt -y autoremove && apt -y clean

WORKDIR /root

ENTRYPOINT /bin/bash
