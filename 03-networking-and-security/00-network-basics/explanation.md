# Network Basics - Command Explanations with Chai Analogy

## ip a
**What it does:** Shows all network interfaces and IP addresses.
**Chai analogy:** Lists all entrance gates to your tapri and their shop numbers. `eth0: 10.0.1.5/24` means main gate has address 10.0.1.5, and /24 means you share street with 254 shops.
**When to use:** First command when network not working. Check if you even have an address.

## ip route
**What it does:** Shows routing table — where packets go.
**Chai analogy:** Directions board at gate. `default via 10.0.1.1` means "to go anywhere outside market, first go to main exit". Without this, you can't leave market.
**When to use:** Can ping local IP but not internet? Check default route.

## ss -tulnp
**What it does:** Lists listening TCP/UDP ports with process names.
**Flags:** t=tcp, u=udp, l=listening, n=numeric, p=process
**Chai analogy:** Walk through shop, see which counters are open. `:80` open = chai counter ready. `0.0.0.0:80` = open to street. `127.0.0.1:80` = only staff can order.
**When to use:** App won't connect? Check if it's actually listening.

## ping
**What it does:** Sends ICMP echo requests, measures round-trip.
**Chai analogy:** Shout "oye" to neighbor tapri, wait for reply. If no reply, road blocked or shop closed.
**When to use:** Test basic connectivity. Always ping IP first (8.8.8.8), then hostname — separates network vs DNS issues.

## traceroute / mtr
**What it does:** Shows each hop to destination.
**Chai analogy:** Follow delivery boy, note each junction he passes. If delay at junction 5, that's where traffic jam is.
**When to use:** Slow connection to specific site. mtr shows live packet loss per hop.

## curl -I
**What it does:** Fetches HTTP headers only.
**Chai analogy:** Send boy to check if tapri is open, don't bring chai back. Just check signboard.
**When to use:** Quick health check without downloading full page.

## dig
**What it does:** DNS lookup.
**Chai analogy:** Look up "Sharma Chai" in phone directory to get address. `dig @8.8.8.8` means use Google's directory instead of local.
**When to use:** Website not resolving? Check if DNS returns correct IP.

## /etc/hosts
**What it does:** Local hostname overrides.
**Chai analogy:** Your personal diary where you write "Sharma = 12 MG Road". Overrides phone book. Useful for testing before DNS update.
**When to use:** Test new server before changing public DNS.

## /etc/resolv.conf
**What it does:** Lists DNS servers.
**Chai analogy:** List of phone directories you trust. First one is tried first.
**When to use:** Slow DNS? Change nameserver to 1.1.1.1

## nc -zv
**What it does:** Tests TCP port connectivity.
**Flags:** z=zero I/O, v=verbose
**Chai analogy:** Walk to shop, knock on door, see if someone opens, then leave. Don't order anything.
**When to use:** Check if port 3306 is open on database server without installing mysql client.

## ethtool
**What it does:** Shows link speed, duplex, driver.
**Chai analogy:** Check if your gate is wide enough for trucks (1Gbps) or only cycles (100Mbps). Check if cable is plugged.
**When to use:** Slow network? Verify link is not negotiated down to 100Mbps.

## hostname -I
**What it does:** Shows all IP addresses, no extra info.
**Chai analogy:** Quick way to tell someone your shop address without describing gates.
**When to use:** Scripts that need IP.

## Common Patterns

**Can't reach internet:**
1. ip a (do you have IP?)
2. ip r (do you have gateway?)
3. ping gateway
4. ping 8.8.8.8
5. dig google.com

**Port already in use:**
ss -tulnp | grep :PORT → shows PID → kill or change config

**App works locally but not remotely:**
ss shows 127.0.0.1:8080 → change to 0.0.0.0:8080
