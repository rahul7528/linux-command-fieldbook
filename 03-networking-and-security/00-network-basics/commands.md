# Network Basics - Quick Reference<br/>
<br/>
## Interface and IP<br/>
ip a<br/>
ip -4 -br a<br/>
ip link show up<br/>
ip link set eth0 up<br/>
ip link set eth0 down<br/>
ip addr add 10.0.1.10/24 dev eth0<br/>
---<br/>
## Routes<br/>
ip route<br/>
ip route show default<br/>
ip route get 8.8.8.8<br/>
ip route add default via 10.0.1.1<br/>
---<br/>
## Hostname<br/>
hostname<br/>
hostname -I<br/>
hostnamectl<br/>
hostnamectl set-hostname prod-01<br/>
---<br/>
## Connectivity<br/>
ping -c3 google.com<br/>
ping -c3 8.8.8.8<br/>
ping -i0.2 10.0.1.1<br/>
traceroute google.com<br/>
mtr -rwc5 google.com<br/>
---<br/>
## Sockets and Ports<br/>
ss -tulnp<br/>
ss -tulnp | grep :80<br/>
ss -s<br/>
ss -tunap | grep ESTAB<br/>
ss -tulnp | grep LISTEN<br/>
netstat -tulnp<br/>
---<br/>
## HTTP and Fetch<br/>
curl -I https://google.com<br/>
curl -s http://localhost:8080/health<br/>
curl -v http://example.com<br/>
wget -qO- http://ifconfig.me<br/>
wget http://example.com/file.tar.gz<br/>
---<br/>
## DNS<br/>
dig google.com +short<br/>
dig @8.8.8.8 example.com<br/>
dig +trace example.com<br/>
host google.com<br/>
nslookup google.com<br/>
cat /etc/resolv.conf<br/>
cat /etc/hosts<br/>
---<br/>
## Netcat<br/>
nc -zv google.com 443<br/>
nc -zv 10.0.1.5 22-80<br/>
nc -l 1234<br/>
echo "test" | nc localhost 1234<br/>
---<br/>
## Interface Details<br/>
ethtool eth0<br/>
ethtool -i eth0<br/>
cat /sys/class/net/eth0/speed<br/>
---<br/>
## Quick Checks<br/>
ip -br a; ip r; ss -tulnp | head<br/>
ping -c1 1.1.1.1 >/dev/null && echo up || echo down<br/>
curl -s -o /dev/null -w "%{http_code}" http://localhost<br/>
