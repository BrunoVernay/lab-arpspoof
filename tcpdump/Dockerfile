FROM fedora:latest
RUN echo -e "sslverify=0" >> /etc/dnf/dnf.conf
RUN dnf -yv upgrade
RUN dnf -y install tcpdump iproute
CMD tcpdump -n -i eth0

