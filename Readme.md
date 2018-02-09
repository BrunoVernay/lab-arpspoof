# ARP Spoofing Lab in Docker

Inspired from https://dockersec.blogspot.com/2017/01/arp-spoofing-docker-containers_26.html 

We create:
- Two "victim" boxes.
- One "attacker" ArpSpoofer.
- An optional "observer" TcpDumper that can be attached to different network interface.


## Buid
  
```
sudo docker build --tag=arpspoofer --build-arg http_proxy=$http_proxy --build-arg https_proxy=https_proxy  arpspoofer
sudo docker build --tag=tcpdumper  --build-arg http_proxy=$http_proxy --build-arg https_proxy=$https_proxy tcpdumper
```

I tried `docker-compose`, but to open terms, a simple script is easier.

## Run
 
Launch 4 terminals:
```
gnome-terminal --title='Box1' -- sudo docker run -it --rm --name box1 busybox
gnome-terminal --title='Box2' -- sudo docker run -it --rm --name box2 busybox
gnome-terminal --title='ArpSpoofer' -- sudo docker run -it --rm --name arpspoofer arpspoofer
gnome-terminal --title='TcpDumper'  -- sudo docker run -it --rm  --net=container:arpspoofer --name tcpdumper tcpdumper
```

1. Check the IPs in Box1 and 2 `ip addr` 
1. Watch the ARP table on Box1 `watch arp -na`
1. Start pinging Box1 from Box2 `ping 172.17.0.x` (replace with Box1 IP)

Usually we would spoof the gateway, but here we spoof both hosts. Since they are on the same LAN, they do not need the Gateway to communicate. (Replace IP with Box1 and 2!)
`/usr/sbin/arpspoof -r -i eth0 -t 172.17.0.3 172.17.0.2`

You should see the traffic in TcpDumper (note that the container can be attached to other boxe's network). You can also capture traffic from within the host on interface `Docker0` with Wireshark. 

### SELinux and tcpdump

TcpDump might not work with SELinux enabled. But: TcpDump is optional (you can use WireShark) and you can either temporarily disble SELinux or add an exception `sudo semodule -X 300 -i selinux/my-tcpdump.pp` (you can remove it after with `-r` instead of `-i`)


## Observations
  
Keep in mind that it is a very simple attack. We didn't do anything to be stealthy. 

The capture file is `result.pcapng`. Capture was done on the host interface `Docker0`.

- Box1 has 172.17.0.2 02:42:ac:11:00:02
- Box2 has 172.17.0.3 02:42:ac:11:00:03
- ArpSpoofer has 172.17.0.4 02:42:ac:11:00:04
- TcpDump has the same as ArpSpoofer 

### ping side
 
No errors. The only hint is the `ttl` decreasing from 64 to 63. 
```
64 bytes from 172.17.0.2: seq=12 ttl=64 time=0.147 ms
64 bytes from 172.17.0.2: seq=13 ttl=64 time=0.149 ms
64 bytes from 172.17.0.2: seq=14 ttl=63 time=0.516 ms
64 bytes from 172.17.0.2: seq=15 ttl=63 time=0.439 ms
...
64 bytes from 172.17.0.2: seq=129 ttl=64 time=0.153 ms
^C
--- 172.17.0.2 ping statistics ---
130 packets transmitted, 130 packets received, 0% packet loss
round-trip min/avg/max = 0.058/0.207/0.859 ms

```

### Tcpdump side

We can see the "nefarious" ARP messages:
```
10:41:37.882841 ARP, Reply 172.17.0.2 is-at 02:42:ac:11:00:04, length 28
10:41:37.883033 ARP, Reply 172.17.0.3 is-at 02:42:ac:11:00:04, length 28 
```

Here we see the ICMP messages:
```
10:41:38.095909 IP 172.17.0.3 > 172.17.0.2: ICMP echo request, id 2304, seq 14, length 64
10:41:38.095962 IP 172.17.0.4 > 172.17.0.3: ICMP redirect 172.17.0.2 to host 172.17.0.2, length 92
10:41:38.095970 IP 172.17.0.3 > 172.17.0.2: ICMP echo request, id 2304, seq 14, length 64
10:41:38.096039 IP 172.17.0.2 > 172.17.0.3: ICMP echo reply, id 2304, seq 14, length 64
10:41:38.096051 IP 172.17.0.4 > 172.17.0.2: ICMP redirect 172.17.0.3 to host 172.17.0.3, length 92
10:41:38.096055 IP 172.17.0.2 > 172.17.0.3: ICMP echo reply, id 2304, seq 14, length 64
```
We can see:
- Box2 request goes to ArpSpoofer
 - ArpSpoofer sends an ICMP redirect, telling Box2 to request Box1. 
 - ArpSpoofer forwards the packet to Box1 (decreases `ttl`)
- Box1 reply goes to ArpSpoofer
 - ArpSpoofer sends an ICMP redirect, telling Box1 to reply to Box2
 - ArpSpoofer forwards the packet to Box2 (decreases `ttl`)

You can select the same sequence in Wireshark with `icmp.seq == 14`. Wireshark interpretation is a bit off.

Box1 receives the ICMP redirect after it already has sent the reply. Looks like it is then ignored. 

## Cleanup

By default Docker will keep images and containers.
Here are some docker commands if you are not familiar with them:
- `sudo docker <image|container> ls -a` will show images or containers
- `sudo docker <image|container> prune` will remove unused images or containers.

Note that the `--rm` option in the run, tells docker to remove the container after use. It is normal if there are no container after running the lab.

Do not forget to eventually `sudo setenforce Enforcing` or remove the SELinux module if you installed it.
