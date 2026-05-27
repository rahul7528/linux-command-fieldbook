# Network Basics - Quick Reference

## Interface and IP
ip a
ip -4 -br a
ip link show up
ip link set eth0 up
ip link set eth0 down
ip addr add 10.0.1.10/24 dev eth0
---
## Routes
ip route
ip route show default
ip route get 8.8.8.8
ip route add default via 10.0.1.1
---
## Hostname
hostname
hostname -I
hostnamectl
hostnamectl set-hostname prod-01
---
## Connectivity
ping -c3 google.com
ping -c3 8.8.8.8
ping -i0.2 10.0.1.1
traceroute google.com
mtr -rwc5 google.com
---
## Sockets and Ports
ss -tulnp
ss -tulnp | grep :80
ss -s
ss -tunap | grep ESTAB
ss -tulnp | grep LISTEN
netstat -tulnp
---
## HTTP and Fetch
curl -I https://google.com
curl -s http://localhost:8080/health
curl -v http://example.com
wget -qO- http://ifconfig.me
wget http://example.com/file.tar.gz
---
## DNS
dig google.com +short
dig @8.8.8.8 example.com
dig +trace example.com
host google.com
nslookup google.com
cat /etc/resolv.conf
cat /etc/hosts
---
## Netcat
nc -zv google.com 443
nc -zv 10.0.1.5 22-80
nc -l 1234
echo "test" | nc localhost 1234
---
## Interface Details
ethtool eth0
ethtool -i eth0
cat /sys/class/net/eth0/speed
---
## Quick Checks
ip -br a; ip r; ss -tulnp | head
ping -c1 1.1.1.1 >/dev/null && echo up || echo down
curl -s -o /dev/null -w "%{http_code}" http://localhost
