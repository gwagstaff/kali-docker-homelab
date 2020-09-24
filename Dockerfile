FROM kalilinux/kali-rolling

LABEL version="1.0" \
      author="Braunbearded" \
      description="Custom Kali Linux docker"

RUN apt -y update && \
    apt -y autoremove && \
    apt install -y vim telnet nmap metasploit-framework sqlmap wpscan netcat enum4linux samba gobuster dirb dirbuster exploitdb hash-identifier hashcat-utils hashid hcxtools seclists wordlists man-db burpsuite && \
    tar -xf /usr/share/seclists/Passwords/Leaked-Databases/rockyou.txt.tar.gz -C /usr/share/seclists/Passwords/Leaked-Databases/ && \
    service postgresql start && \
    echo 'alias burpsuite="exec /bin/java -jar /usr/bin/burpsuite "$@""' >> /root/.bashrc

WORKDIR /root

ENTRYPOINT /bin/bash
