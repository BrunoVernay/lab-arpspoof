
# Labs to demonstrate Network Security.

1. [ArpSpoofing / Poisoning](https://github.com/BrunoVernay/lab-arpspoof/tree/master/Lab1-ArpSpoofing)
2. MITM _TBD_
3. ...


It was inspired by the great labs from : https://github.com/docker/labs 

Uses tools like
- Docker
- Mininet ???
  - Still to be investiguated https://github.com/mininet/mininet/wiki/Mininet-VM-Images
- VirtualBox
- NetCat
- dsniff, MITMProxy, 

## Todo

- Replace `arp` by `ip neigh`

## Other tools

### Labs

- Very interesting about Docker http://docker-k8s-lab.readthedocs.io/en/latest/docker/bridged-network.html 

### NetKit

Looks like NetKit used to have many labs and teaching material. But they seems to be abandonned? Also the http://www.Kathara.org/ looked promising, but did not work (for me).

### NetCat
Playing with Netcat is fun.
- run `nc -l -p 2000` in a busybox box1 and `nc $IP_BOX1 2000` in a box2. 
- You could also expose the port 2000 to the host if running Docker with `-p 2000:2000/tcp`. From the host you can then `nc -6 localhost 2000`. You can see it is listening with `ss -lnt` on the host.
-
-


