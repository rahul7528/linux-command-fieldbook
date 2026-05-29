# Connectivity

Testing and debugging network connections between servers. Think of this as checking roads between chai tapris across the city.

## Chai Tapri Analogy

- **ping** = shouting to see if other tapri hears you
- **traceroute** = following the delivery route, noting each junction
- **mtr** = live GPS tracking of delivery boy
- **tcpdump** = sitting at gate, writing down every vehicle that passes
- **curl** = sending boy to buy chai and bring it back
- **netcat** = temporary walkie-talkie between two tapris
- **iperf3** = testing how many chai cups you can send per minute

## ping — Basic Reachability

```bash
ping -c4 8.8.8.8
ping -i0.2 -c100 10.0.1.1
ping -s1400 -M do 8.8.8.8
```

**Chai view:** Shout 4 times. `-i0.2` = shout fast. `-s1400` = shout with big message, `-M do` = don't fragment — test if road allows big trucks.

Real use:
```bash
# Packet loss test
ping -c100 -i0.1 10.0.1.1 | grep loss

# MTU discovery
ping -M do -s 1472 8.8.8.8
```

## traceroute, tracepath, mtr

```bash
traceroute -n google.com
tracepath google.com
mtr -rwc10 google.com
mtr --tcp -P 443 google.com
```

**Chai view:**
- traceroute = ask each junction "who are you?"
- mtr = continuous monitoring, shows % loss at each junction
- `--tcp` = test specific road (port 443)

Real use: Site slow. `mtr` shows 40% loss at hop 6 = problem at ISP, not your server.

## tcpdump — Packet Capture

```bash
sudo tcpdump -i eth0 -n
sudo tcpdump -i any port 80
sudo tcpdump -i eth0 host 10.0.1.5 and port 3306 -w /tmp/mysql.pcap
sudo tcpdump -r /tmp/mysql.pcap -A | grep -i select
```

**Chai view:** Sit at gate with notebook, write every vehicle's number plate, where from, where to. `-w` = save to register for later.

Key filters:
- `port 80` = only vehicles going to chai counter
- `host 10.0.1.5` = only vehicles to/from that tapri
- `tcp[tcpflags] & tcp-syn != 0` = only new connections

Real use:
```bash
# See who is connecting to SSH
sudo tcpdump -i any port 22 -n

# Capture HTTP requests
sudo tcpdump -i eth0 -A -s0 port 8080 | grep -E "GET|POST"
```

## ss — Deep Socket Inspection

```bash
ss -tunap
ss -tunap | grep ESTAB
ss -t state established '( dport = :443 )'
ss -s
ss -i
```

**Chai view:** `ss -tunap` = list all customers currently in shop, which counter, how long waiting. `ss -s` = summary count.

Real use:
```bash
# Count connections per IP
ss -tun | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -rn | head

# Find TIME_WAIT flood
ss -tan state time-wait | wc -l
```

## netcat — Testing Ports

```bash
nc -zv db.tapri.local 3306
nc -zv 10.0.1.5 22-100
nc -l 9000
echo "test" | nc 10.0.1.5 9000
```

**Chai view:** `nc -zv` = walk to other tapri, knock on door 3306, see if opens. `-l 9000` = open temporary counter to receive test orders.

Real use: Test if firewall allows connection without installing mysql client.

## curl — Advanced

```bash
curl -w "@curl-format.txt" -o /dev/null -s https://example.com
curl -I -L https://example.com
curl --connect-timeout 2 --max-time 5 http://api.tapri.local
curl -H "Host: myapp.com" http://10.0.1.5/
```

**Chai view:** Send boy with stopwatch. Measure DNS time, connect time, total time.

Create curl-format.txt:
```
time_namelookup: %{time_namelookup}
time_connect: %{time_connect}
time_total: %{time_total}
```

Real use: API slow. curl shows time_connect 0.001s but time_total 5s = server processing slow, not network.

## telnet — Simple TCP Test

```bash
telnet google.com 80
telnet 10.0.1.5 3306
```

**Chai view:** Old-style walkie-talkie. Type manually, see response. Useful when nc not installed.

## iperf3 — Bandwidth Test

```bash
# On server
iperf3 -s

# On client
iperf3 -c 10.0.1.5
iperf3 -c 10.0.1.5 -u -b 100M
iperf3 -c 10.0.1.5 -P 4
```

**Chai view:** Test how many chai cups per minute you can send between tapris. `-u` = UDP (unreliable delivery), `-P 4` = 4 delivery boys in parallel.

Real use: New VPC slow. iperf3 shows 50Mbps instead of 1Gbps = network limit.

## arp — Local Network

```bash
ip neigh
arp -a
```

**Chai view:** List of neighboring tapris and their gate nameplates (MAC). If missing, can't deliver locally.

## whois and dig

```bash
whois example.com
dig +short example.com
dig +short -x 8.8.8.8
```

**Chai view:** whois = check shop registration details. dig -x = reverse lookup address to name.

## Real-world Playbooks

**Playbook 1: Can't connect to database**
```bash
ping db.tapri.local          # network?
nc -zv db.tapri.local 3306   # port open?
telnet db.tapri.local 3306   # TCP works?
sudo tcpdump -i any host db.tapri.local and port 3306  # packets leaving?
```
**Chai view:** Can you shout to them? Is their gate open? Is your boy leaving shop?

**Playbook 2: Intermittent timeouts**
```bash
mtr -rwc100 api.tapri.local
ping -c500 -i0.2 api.tapri.local | grep loss
ss -i dst api.tapri.local
```
**Chai view:** Continuous GPS tracking shows which junction drops packets.

**Playbook 3: High latency**
```bash
curl -w "total:%{time_total}" -o /dev/null -s https://api.tapri.local
traceroute -n api.tapri.local
mtr --tcp -P 443 api.tapri.local
```
**Chai view:** Time the boy. Check each junction delay.

## What to Remember

- ping tests IP, not application
- nc -zv tests port without app
- tcpdump -w saves, read later with -r
- mtr > traceroute for live issues
- ss -s shows socket summary fast
- curl -w measures real latency breakdown
- iperf3 tests bandwidth, not just connectivity
- Always test from both directions
