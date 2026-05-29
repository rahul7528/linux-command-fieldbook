# Connectivity - Quick Reference

## Ping
ping -c4 8.8.8.8
ping -c100 -i0.1 10.0.1.1
ping -s1400 -M do 8.8.8.8
ping -f 10.0.1.1
---
## Traceroute and MTR
traceroute -n google.com
tracepath google.com
mtr -rwc10 google.com
mtr --tcp -P 443 google.com
mtr -rwc100 8.8.8.8
---
## tcpdump
sudo tcpdump -i eth0 -n
sudo tcpdump -i any port 80
sudo tcpdump -i eth0 host 10.0.1.5
sudo tcpdump -i any port 3306 -w /tmp/cap.pcap
sudo tcpdump -r /tmp/cap.pcap -A
sudo tcpdump -i any tcp port 80 -A | grep -E "GET|Host"
---
## ss
ss -tunap
ss -tunap | grep ESTAB
ss -s
ss -t state established
ss -t state time-wait | wc -l
ss -i dst 10.0.1.5
---
## Netcat
nc -zv google.com 443
nc -zv 10.0.1.5 22-80
nc -l 9000
nc -u -l 9001
echo "test" | nc 10.0.1.5 9000
---
## curl
curl -I https://example.com
curl -s -o /dev/null -w "%{http_code}" https://example.com
curl --connect-timeout 2 --max-time 5 http://api.local
curl -H "Host: myapp.com" http://10.0.1.5/
curl -w "time_total:%{time_total}" -o /dev/null -s https://example.com
---
## Telnet
telnet google.com 80
telnet 10.0.1.5 3306
---
## iperf3
iperf3 -s
iperf3 -c 10.0.1.5
iperf3 -c 10.0.1.5 -u -b 100M
iperf3 -c 10.0.1.5 -P 4
iperf3 -c 10.0.1.5 -R
---
## ARP and Neighbors
ip neigh
arp -a
ip neigh flush all
---
## DNS and Whois
dig google.com +short
dig @1.1.1.1 example.com
dig +trace example.com
dig -x 8.8.8.8 +short
whois example.com
host google.com
---
## Quick Tests
ping -c1 1.1.1.1 && echo up
nc -zv db.local 5432
curl -s http://localhost:8080/health
ss -tulnp | grep :8080
mtr -rwc5 api.local
