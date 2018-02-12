
Labs to demonstrate Network Security.

- ArpSpoofing / Poisoning
- MITM 
-
-

It was inspired by the great labs from : https://github.com/docker/labs 

Uses tools like
- Docker
- Mininet ???
  - Still to be investiguated https://github.com/mininet/mininet/wiki/Mininet-VM-Images
- VirtualBox
- dsniff, MITMProxy, 


Other tools:
- Looks like NetKit used to have many labs and teaching material. But they seems to be abandonned? Also the http://www.Kathara.org/ looked promising, but did not work (for me).

### NetCat
Playing with Netcat is fun.
- run `nc -l -p 2000` in a busybox box1 and `nc $IP_BOX1 2000` in a box2. 
- You could also expose the port 2000 to the host if running Docker with `-p 2000:2000/tcp`. From the host you can then `nc -6 localhost 2000`. You can see it is listeneing with `netstat -lnt` on the host.
-
-


