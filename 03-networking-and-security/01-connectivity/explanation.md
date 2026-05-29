# Connectivity - Command Explanations with Chai Analogy

## ping -c4
**What:** Sends 4 ICMP echo requests.
**Chai:** Shout "hello" 4 times to neighbor tapri. If all 4 reply, road is good. Packet loss = some shouts lost in noise.
**Use:** Basic reachability test.

## ping -s1400 -M do
**What:** Sends 1400-byte packet, don't fragment.
**Chai:** Send big truck, don't allow splitting. If fails, road MTU too small. Helps find MTU issues in VPN.
**Use:** Debug VPN or tunnels where large packets drop.

## traceroute
**What:** Shows each hop with TTL increment.
**Chai:** Send boy with limited steps. First with 1 step, see first junction. Then 2 steps, see second. Maps full route.
**Use:** Find where packets die.

## mtr
**What:** Combines ping and traceroute, continuous.
**Chai:** Live GPS tracking. Shows packet loss % at each junction over time. Better than traceroute for intermittent issues.
**Use:** `mtr -rwc100` gives report of 100 pings per hop.

## tcpdump -i any port 80
**What:** Captures all packets on port 80 across interfaces.
**Chai:** Sit at main gate, write down every vehicle going to chai counter. `-w file.pcap` saves notebook.
**Use:** Debug HTTP traffic, see actual requests.

## tcpdump host and port
**What:** Filter by IP and port.
**Chai:** Only note vehicles between your tapri and specific neighbor, going to specific counter.
**Use:** Isolate database traffic: `tcpdump host db and port 3306`

## ss -tunap
**What:** Shows all TCP/UDP sockets with processes.
**Flags:** t=tcp u=udp n=numeric a=all p=process
**Chai:** List all customers in shop, which counter, which waiter serving, their home address.
**Use:** Find which process holds port, count connections.

## ss -s
**What:** Socket statistics summary.
**Chai:** Quick headcount: 150 customers total, 120 established, 30 waiting.
**Use:** Fast check for connection flood.

## nc -zv
**What:** Zero-I/O scan, verbose.
**Chai:** Walk to door, knock, check if open, leave. Doesn't enter. Fast port check.
**Use:** Test if firewall allows port without full client.

## nc -l 9000
**What:** Listen on port 9000.
**Chai:** Open temporary counter for testing. Other tapri can send test messages.
**Use:** Test connectivity both ways.

## curl -w
**What:** Custom output format with timing.
**Chai:** Send boy with stopwatch, measure: time to find address (DNS), time to reach gate (connect), time to get chai (total).
**Use:** Diagnose slow API — is it DNS, network, or server?

## telnet host port
**What:** Opens raw TCP connection.
**Chai:** Old walkie-talkie. You type, see raw reply. Good for SMTP, HTTP manual testing.
**Use:** When nc not available.

## iperf3
**What:** Measures maximum TCP/UDP bandwidth.
**Chai:** Test how many chai cups per minute you can deliver between tapris. `-s` starts receiver, `-c` starts sender.
**Use:** Verify network speed, test VPC limits.

## iperf3 -u -b 100M
**What:** UDP test at 100Mbps.
**Chai:** Send cups without confirmation (UDP), at fixed rate. Tests packet loss under load.
**Use:** Test VoIP or video streaming capacity.

## ip neigh
**What:** Shows ARP table.
**Chai:** List of immediate neighbors and their gate nameplates (MAC addresses). If incomplete, can't deliver locally.
**Use:** Debug local network, duplicate IP detection.

## dig +trace
**What:** Shows full DNS resolution path.
**Chai:** Follow phone directory lookup step by step: root → .com → example.com servers.
**Use:** Debug DNS delegation issues.

## Common Workflows

**Database connection fails:**
1. ping db → network?
2. nc -zv db 3306 → port open?
3. tcpdump host db → packets leaving?
4. ss -tunap | grep 3306 → local socket state?

**Website slow:**
1. curl -w → measure total time
2. mtr → network loss?
3. tcpdump → retransmissions?
4. iperf3 → bandwidth?

**High connections:**
ss -s → total count
ss -tun | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -rn → top IPs
