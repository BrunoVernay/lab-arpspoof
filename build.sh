

sudo docker build --tag=arpspoofer --build-arg http_proxy=$http_proxy --build-arg https_proxy=$https_proxy arpspoofer
sudo docker build --tag=tcpdumper  --build-arg http_proxy=$http_proxy --build-arg https_proxy=$https_proxy tcpdumper
