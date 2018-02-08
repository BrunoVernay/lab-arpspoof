

sudo docker build --tag=arpspoof --build-arg http_proxy=$http_proxy --build-arg https_proxy=$https_proxy arpspoof
sudo docker build --tag=tcpdump  --build-arg http_proxy=$http_proxy --build-arg https_proxy=$https_proxy tcpdump
