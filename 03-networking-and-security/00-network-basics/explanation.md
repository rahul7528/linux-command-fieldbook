# Network Basics - Command Explanations with Chai Analogy
<br/>
## ip a<br/>
**What it does:** Shows all network interfaces and IP addresses.<br/>
**Chai analogy:** Lists all entrance gates to your tapri and their shop numbers. `eth0: 10.0.1.5/24` means main gate has address 10.0.1.5, and /24 means you share street with 254 shops.<br/>
**When to use:** First command when network not working. Check if you even have an address.<br/>
<br/>
## ip route<br/>
**What it does:** Shows routing table — where packets go.<br/>
**Chai analogy:** Directions board at gate. `default via 10.0.1.1` means "to go anywhere outside market, first go to main exit". Without this, you can't leave market.<br/>
**When to use:** Can ping local IP but not internet? Check default route.<br/>
<br/>
## ss -tulnp<br/>
**What it does:** Lists listening TCP/UDP ports with process names.<br/>
**Flags:** t=tcp, u=udp, l=listening, n=numeric, p=process<br/>
**Chai analogy:** Walk through shop, see which counters are open. `:80` open = chai counter ready. `0.0.0.0:80` = open to street. `127.0.0.1:80` = only staff can order.<br/>
**When to use:** App won't connect? Check if it's actually listening.<br/>
<br/>
## ping<br/>
**What it does:** Sends ICMP echo requests, measures round-trip.<br/>
**Chai analogy:** Shout "oye" to neighbor tapri, wait for reply. If no reply, road blocked or shop closed.<br/>
**When to use:** Test basic connectivity. Always ping IP first (8.8.8.8), then hostname — separates network vs DNS issues.<br/>
<br/>
## traceroute / mtr<br/>
**What it does:** Shows each hop to destination.<br/>
**Chai analogy:** Follow delivery boy, note each junction he passes. If delay at junction 5, that's where traffic jam is.<br/>
**When to use:** Slow connection to specific site. mtr shows live packet loss per hop.<br/>
<br/>
## curl -I<br/>
**What it does:** Fetches HTTP headers only.<br/>
**Chai analogy:** Send boy to check if tapri is open, don't bring chai back. Just check signboard.<br/>
**When to use:** Quick health check without downloading full page.<br/>
<br/>
## dig<br/>
**What it does:** DNS lookup.<br/>
**Chai analogy:** Look up "Sharma Chai" in phone directory to get address. `dig @8.8.8.8` means use Google's directory instead of local.<br/>
**When to use:** Website not resolving? Check if DNS returns correct IP.<br/>

## /etc/hosts<br/>
**What it does:** Local hostname overrides.<br/>
**Chai analogy:** Your personal diary where you write "Sharma = 12 MG Road". Overrides phone book. Useful for testing before DNS update.<br/>
**When to use:** Test new server before changing public DNS.<br/>
<br/>
## /etc/resolv.conf<br/>
**What it does:** Lists DNS servers.<br/>
**Chai analogy:** List of phone directories you trust. First one is tried first.<br/>
**When to use:** Slow DNS? Change nameserver to 1.1.1.1<br/>
<br/>
## nc -zv<br/>
**What it does:** Tests TCP port connectivity.<br/>
**Flags:** z=zero I/O, v=verbose<br/>
**Chai analogy:** Walk to shop, knock on door, see if someone opens, then leave. Don't order anything.<br/>
**When to use:** Check if port 3306 is open on database server without installing mysql client.<br/>
<br/>
## ethtool<br/>
**What it does:** Shows link speed, duplex, driver.<br/>
**Chai analogy:** Check if your gate is wide enough for trucks (1Gbps) or only cycles (100Mbps). Check if cable is plugged.<br/>
**When to use:** Slow network? Verify link is not negotiated down to 100Mbps.<br/>
<br/>
## hostname -I<br/>
**What it does:** Shows all IP addresses, no extra info.<br/>
**Chai analogy:** Quick way to tell someone your shop address without describing gates.<br/>
**When to use:** Scripts that need IP.<br/>
<br/><br/>
## Common Patterns<br/>
<br/>
**Can't reach internet:**<br/>
1. ip a (do you have IP?)<br/>
2. ip r (do you have gateway?)<br/>
3. ping gateway<br/>
4. ping 8.8.8.8<br/>
5. dig google.com<br/>
<br/>
**Port already in use:**<br/>
ss -tulnp | grep :PORT → shows PID → kill or change config<br/>
<br/>
**App works locally but not remotely:**<br/>
ss shows 127.0.0.1:8080 → change to 0.0.0.0:8080<br/>
