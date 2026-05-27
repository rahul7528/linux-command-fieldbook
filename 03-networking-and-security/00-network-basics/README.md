# Network Basics

Understanding IP addresses, interfaces, routes, DNS, and ports. Think of your server as a chai tapri in a big market.

## Chai Tapri Analogy

- **Network** = roads connecting all tapris in city
- **IP Address** = your shop's full address (12, MG Road)
- **Interface (eth0)** = your main entrance gate
- **MAC Address** = permanent nameplate on gate
- **Default Gateway** = main market exit to highway
- **Route** = directions to reach other tapri
- **DNS** = phone directory — name to address
- **Port** = specific counter inside shop (port 80 = chai counter, 22 = staff entrance)
- **ss/netstat** = looking at which counters are open and who is standing there

## ip — Modern Network Tool

Replaces old ifconfig.

### ip address
```bash
ip a
ip -4 a
ip -br a
```

**Chai view:** `ip a` shows all your shop entrances and their addresses. `eth0` might have 10.0.1.5/24.

Flags: `-4` IPv4 only, `-br` brief, `-c` color.

Real use:
```bash
# Find your IP quickly
ip -4 -br a | awk '{print $3}'

# Show only up interfaces
ip link show up
```

### ip link
```bash
ip link
ip link set eth0 up
ip link set eth0 down
```

**Chai view:** Open or close the gate. `state UP` = gate open for customers.

### ip route
```bash
ip route
ip route show default
ip route get 8.8.8.8
```

**Chai view:** `ip route` = your directions board. Default via 10.0.1.1 = to go outside market, first go to main exit.

Real use:
```bash
# Where will packet go?
ip route get 1.1.1.1
```

## hostname — Your Shop Name

```bash
hostname
hostname -I
hostnamectl
hostnamectl set-hostname prod-tapri-01
```

**Chai view:** `hostname` = shop name board. `hostname -I` = quick address without details.

## ping — Are You There?

```bash
ping -c3 google.com
ping -c3 8.8.8.8
ping -i0.2 -c10 10.0.1.1
```

**Chai view:** Shout "hello" to neighbor tapri. If they shout back, road is open. `-c3` = shout 3 times.

Real use: `ping 8.8.8.8` works but `ping google.com` fails = DNS problem, not network.

## traceroute and mtr — Path Tracking

```bash
traceroute google.com
mtr -rwc5 google.com
```

**Chai view:** traceroute = ask each junction on road "who are you?" to map full route. mtr = continuous tracking, shows where traffic jam is.

Real use: Slow to API. `mtr` shows 80% loss at hop 5 = ISP problem.

## ss — Sockets and Ports

Replaces netstat.

```bash
ss -tulnp
ss -tulnp | grep :80
ss -s
ss -tunap | grep ESTAB
```

**Chai view:**
- `-t` TCP = regular customers
- `-u` UDP = quick parcel drop
- `-l` listening = counters open waiting for customers
- `-n` numeric = show address not name
- `-p` process = which waiter is at counter

Real use:
```bash
# What is using port 3000?
ss -tulnp | grep :3000

# Count connections
ss -s
```

## curl and wget — Fetch Data

```bash
curl -I https://google.com
curl -s http://localhost:8080/health
wget -qO- http://ifconfig.me
```

**Chai view:** curl = send boy to other tapri to check if chai is ready. `-I` = just check if shop is open, don't bring chai.

## dig, host, nslookup — DNS

```bash
dig google.com +short
dig @8.8.8.8 example.com
host google.com
nslookup google.com
```

**Chai view:** DNS = phone directory. `dig` = look up address for "Sharma Chai". `@8.8.8.8` = use Google's directory instead of local.

Real use:
```bash
# Check DNS propagation
dig +short myapp.com @1.1.1.1
dig +short myapp.com @8.8.8.8
```

## /etc/hosts and /etc/resolv.conf

```bash
cat /etc/hosts
cat /etc/resolv.conf
```

**Chai view:** `/etc/hosts` = your personal diary of addresses (overrides phone book). `/etc/resolv.conf` = which phone directories you use.

Example:
```
10.0.1.50   db.tapri.local
```

## nc — Netcat, Swiss Army Knife

```bash
nc -zv google.com 443
nc -l 1234
echo "hello" | nc localhost 1234
```

**Chai view:** `nc -zv` = knock on door to see if open, don't enter. `nc -l` = open temporary counter for testing.

## ethtool — Link Details

```bash
ethtool eth0
ethtool -i eth0
```

**Chai view:** Check if gate is 1Gbps or 100Mbps, if cable connected.

## Real-world Scenarios

**Scenario 1: Can't reach internet**
```bash
ip a                  # do you have IP?
ip route              # do you have default gateway?
ping 10.0.1.1         # can you reach gateway?
ping 8.8.8.8          # can you reach internet?
dig google.com        # is DNS working?
```

**Chai view:** Check your address, check exit route, shout to market guard, shout to outside city, check phone book.

**Scenario 2: App not accessible**
```bash
ss -tulnp | grep :8080   # is app listening?
curl http://localhost:8080  # works locally?
curl http://<your-ip>:8080  # works from network?
```

**Chai view:** Is counter open? Can you order from inside shop? Can customer from street order?

**Scenario 3: Slow DNS**
```bash
time dig google.com
time dig @1.1.1.1 google.com
cat /etc/resolv.conf
```

## What to Remember

- `ip a` shows addresses, `ip r` shows routes
- `ss -tulnp` = see all listening ports instantly
- ping IP first, then hostname — separates network vs DNS
- `mtr` better than traceroute for live issues
- `/etc/hosts` overrides DNS
- `curl -I` checks headers without downloading
- `nc -zv` tests port connectivity
- Listening on 0.0.0.0 = open to all roads, 127.0.0.1 = only inside shop
