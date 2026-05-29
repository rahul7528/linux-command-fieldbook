# Connectivity - Quick Reference
<br/><br/>
## Ping<br/>
ping -c4 8.8.8.8<br/>
ping -c100 -i0.1 10.0.1.1<br/>
ping -s1400 -M do 8.8.8.8<br/>
ping -f 10.0.1.1<br/>
---<br/>
## Traceroute and MTR<br/>
traceroute -n google.com<br/>
tracepath google.com<br/>
mtr -rwc10 google.com<br/>
mtr --tcp -P 443 google.com<br/>
mtr -rwc100 8.8.8.8<br/>
---<br/>
## tcpdump<br/>
sudo tcpdump -i eth0 -n<br/>
sudo tcpdump -i any port 80<br/>
sudo tcpdump -i eth0 host 10.0.1.5<br/>
sudo tcpdump -i any port 3306 -w /tmp/cap.pcap<br/>
sudo tcpdump -r /tmp/cap.pcap -A<br/>
sudo tcpdump -i any tcp port 80 -A | grep -E "GET|Host"<br/>
---<br/>
## ss<br/>
ss -tunap<br/>
ss -tunap | grep ESTAB<br/>
ss -s<br/>
ss -t state established<br/>
ss -t state time-wait | wc -l<br/>
ss -i dst 10.0.1.5<br/>
---<br/>
## Netcat<br/>
nc -zv google.com 443<br/>
nc -zv 10.0.1.5 22-80<br/>
nc -l 9000<br/>
nc -u -l 9001<br/>
echo "test" | nc 10.0.1.5 9000<br/>
---<br/>
## curl<br/>
curl -I https://example.com<br/>
curl -s -o /dev/null -w "%{http_code}" https://example.com<br/>
curl --connect-timeout 2 --max-time 5 http://api.local<br/>
curl -H "Host: myapp.com" http://10.0.1.5/<br/>
curl -w "time_total:%{time_total}" -o /dev/null -s https://example.com<br/>
---<br/>
## Telnet<br/>
telnet google.com 80<br/>
telnet 10.0.1.5 3306<br/>
---<br/>
## iperf3<br/>
iperf3 -s<br/>
iperf3 -c 10.0.1.5<br/>
iperf3 -c 10.0.1.5 -u -b 100M<br/>
iperf3 -c 10.0.1.5 -P 4<br/>
iperf3 -c 10.0.1.5 -R<br/>
---<br/>
## ARP and Neighbors<br/>
ip neigh<br/>
arp -a<br/>
ip neigh flush all<br/>
---<br/>
## DNS and Whois<br/>
dig google.com +short<br/>
dig @1.1.1.1 example.com<br/>
dig +trace example.com<br/>
dig -x 8.8.8.8 +short<br/>
whois example.com<br/>
host google.com<br/>
---<br/>
## Quick Tests<br/>
ping -c1 1.1.1.1 && echo up<br/>
nc -zv db.local 5432<br/>
curl -s http://localhost:8080/health<br/>
ss -tulnp | grep :8080<br/>
mtr -rwc5 api.local<br/>
<br/>
