FROM fedora:latest
RUN echo -e "sslverify=0" >> /etc/dnf/dnf.conf
RUN dnf -yv upgrade
RUN dnf -y install dsniff iproute
RUN dnf -y install python3-pip make gcc openssl-devel libffi-devel python3-devel
RUN pip3 install -U pip
RUN pip3 install mitmproxy
RUN dnf -y install tcpdump

