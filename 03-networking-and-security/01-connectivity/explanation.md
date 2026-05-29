# Connectivity - Command Explanations with Chai Analogy
<br/><br/><br/>
## ping -c4<br/>
**What:** Sends 4 ICMP echo requests. <br/>
**Chai:** Shout "hello" 4 times to neighbor tapri. If all 4 reply, road is good. Packet loss = some shouts lost in noise.<br/>
**Use:** Basic reachability test.<br/>
<br/><br/>
## ping -s1400 -M do<br/>
**What:** Sends 1400-byte packet, don't fragment.<br/>
**Chai:** Send big truck, don't allow splitting. If fails, road MTU too small. Helps find MTU issues in VPN.<br/>
**Use:** Debug VPN or tunnels where large packets drop.<br/>
<br/><br/>
## traceroute<br/>
**What:** Shows each hop with TTL increment.<br/>
**Chai:** Send boy with limited steps. First with 1 step, see first junction. Then 2 steps, see second. Maps full route.<br/>
**Use:** Find where packets die.<br/>
<br/><br/>
## mtr<br/>
**What:** Combines ping and traceroute, continuous.<br/>
**Chai:** Live GPS tracking. Shows packet loss % at each junction over time. Better than traceroute for intermittent issues.<br/>
**Use:** `mtr -rwc100` gives report of 100 pings per hop.<br/>
<br/><br/>
## tcpdump -i any port 80<br/>
**What:** Captures all packets on port 80 across interfaces.<br/>
**Chai:** Sit at main gate, write down every vehicle going to chai counter. `-w file.pcap` saves notebook.<br/>
**Use:** Debug HTTP traffic, see actual requests.<br/>
<br/><br/>
## tcpdump host and port<br/>
**What:** Filter by IP and port.<br/>
**Chai:** Only note vehicles between your tapri and specific neighbor, going to specific counter.<br/>
**Use:** Isolate database traffic: `tcpdump host db and port 3306`<br/>
<br/><br/>
## ss -tunap<br/>
**What:** Shows all TCP/UDP sockets with processes.<br/>
**Flags:** t=tcp u=udp n=numeric a=all p=process<br/>
**Chai:** List all customers in shop, which counter, which waiter serving, their home address.<br/>
**Use:** Find which process holds port, count connections.<br/>
<br/><br/>
## ss -s<br/>
**What:** Socket statistics summary.<br/>
**Chai:** Quick headcount: 150 customers total, 120 established, 30 waiting.<br/>
**Use:** Fast check for connection flood.<br/>
<br/><br/>
## nc -zv<br/>
**What:** Zero-I/O scan, verbose.<br/>
**Chai:** Walk to door, knock, check if open, leave. Doesn't enter. Fast port check.<br/>
**Use:** Test if firewall allows port without full client.<br/>
<br/><br/>
## nc -l 9000<br/>
**What:** Listen on port 9000.<br/>
**Chai:** Open temporary counter for testing. Other tapri can send test messages.<br/>
**Use:** Test connectivity both ways.<br/>
<br/><br/>
## curl -w<br/>
**What:** Custom output format with timing.<br/>
**Chai:** Send boy with stopwatch, measure: time to find address (DNS), time to reach gate (connect), time to get chai (total).<br/>
**Use:** Diagnose slow API — is it DNS, network, or server?<br/>
<br/><br/>
## telnet host port<br/>
**What:** Opens raw TCP connection.<br/>
**Chai:** Old walkie-talkie. You type, see raw reply. Good for SMTP, HTTP manual testing.<br/>
**Use:** When nc not available.<br/>
<br/><br/>
## iperf3<br/>
**What:** Measures maximum TCP/UDP bandwidth.<br/>
**Chai:** Test how many chai cups per minute you can deliver between tapris. `-s` starts receiver, `-c` starts sender.<br/>
**Use:** Verify network speed, test VPC limits.<br/>
<br/><br/>
## iperf3 -u -b 100M<br/>
**What:** UDP test at 100Mbps.<br/>
**Chai:** Send cups without confirmation (UDP), at fixed rate. Tests packet loss under load.<br/>
**Use:** Test VoIP or video streaming capacity.<br/>
<br/><br/>
## ip neigh<br/>
**What:** Shows ARP table.<br/>
**Chai:** List of immediate neighbors and their gate nameplates (MAC addresses). If incomplete, can't deliver locally.<br/>
**Use:** Debug local network, duplicate IP detection.<br/>
<br/><br/>
## dig +trace<br/>
**What:** Shows full DNS resolution path.<br/>
**Chai:** Follow phone directory lookup step by step: root → .com → example.com servers.<br/>
**Use:** Debug DNS delegation issues.<br/>
<br/><br/><br/>
## Common Workflows
<br/>
**Database connection fails:**<br/>
1. ping db → network?<br/>
2. nc -zv db 3306 → port open?<br/>
3. tcpdump host db → packets leaving?<br/>
4. ss -tunap | grep 3306 → local socket state?<br/>
<br/><br/>
**Website slow:**<br/>
1. curl -w → measure total time<br/>
2. mtr → network loss?<br/>
3. tcpdump → retransmissions?<br/>
4. iperf3 → bandwidth?<br/>
<br/><br/>
**High connections:**<br/>
ss -s → total count<br/>
ss -tun | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -rn → top IPs<br/>
