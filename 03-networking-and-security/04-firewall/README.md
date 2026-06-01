# Firewall

Controlling network traffic with ufw, iptables, and nftables. Think of firewall as the security guard at your tapri gate deciding who enters.

## Chai Tapri Analogy

- **Firewall** = security guard at gate with rulebook
- **Port** = specific counter (22=staff entrance, 80=chai counter, 443=premium counter)
- **ALLOW** = guard lets customer in
- **DENY** = guard blocks entry
- **ufw** = simple guard with easy commands
- **iptables** = detailed rulebook with chains
- **INPUT chain** = people coming into shop
- **OUTPUT chain** = people leaving shop
- **FORWARD** = people passing through to back alley

## ufw — Uncomplicated Firewall

Best for beginners.

### Basic commands
```bash
sudo ufw status
sudo ufw status verbose
sudo ufw enable
sudo ufw disable
```

**Chai view:** Check guard status, turn guard on/off.

### Allow and deny
```bash
sudo ufw allow 22/tcp
sudo ufw allow 80
sudo ufw allow 443/tcp
sudo ufw deny 23
sudo ufw allow from 10.0.1.0/24
sudo ufw allow from 10.0.1.5 to any port 3306
```

**Chai view:** Allow customers to chai counter (80), block telnet (23), allow only office network to staff entrance.

### Delete rules
```bash
sudo ufw status numbered
sudo ufw delete 3
sudo ufw delete allow 80/tcp
```

### Defaults
```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
```

**Chai view:** Default: block everyone coming in, allow everyone leaving. Then open specific counters.

Real use:
```bash
# Secure web server
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable
```

## iptables — Classic Firewall

More powerful, complex.

### View rules
```bash
sudo iptables -L -n -v
sudo iptables -L -n --line-numbers
sudo iptables -S
```

**Chai view:** Read full rulebook with line numbers.

### Basic rules
```bash
# Allow SSH
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Allow HTTP/HTTPS
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Allow established connections
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Drop everything else
sudo iptables -A INPUT -j DROP
```

**Chai view:** -A INPUT = add rule for incoming people. -p tcp --dport 22 = people coming to staff entrance. -j ACCEPT = let them in.

### Save rules
```bash
sudo iptables-save > /etc/iptables/rules.v4
sudo iptables-restore < /etc/iptables/rules.v4
```

**Ubuntu/Debian:**
```bash
sudo apt install iptables-persistent
sudo netfilter-persistent save
```

## nftables — Modern Replacement

```bash
sudo nft list ruleset
sudo nft add rule inet filter input tcp dport 22 accept
```

**Chai view:** Newer guard system, simpler syntax than iptables.

## Checking Open Ports

Before firewall, see what's listening:

```bash
ss -tulnp
sudo lsof -i -P -n | grep LISTEN
```

**Chai view:** List all counters currently open. Close unused ones before setting firewall.

## Real-world Scenarios

**Scenario 1: Lock down server**
```bash
sudo ufw reset
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp
sudo ufw allow from 10.0.1.0/24 to any port 3306
sudo ufw enable
```
**Chai view:** Block all, then allow only staff entrance and DB access from office network.

**Scenario 2: Allow only your IP to SSH**
```bash
sudo ufw delete allow 22/tcp
sudo ufw allow from 203.0.113.5 to any port 22
```

**Scenario 3: Block abusive IP**
```bash
sudo ufw deny from 198.51.100.77
sudo iptables -A INPUT -s 198.51.100.77 -j DROP
```

**Scenario 4: Rate limit SSH**
```bash
sudo ufw limit 22/tcp
```
**Chai view:** Guard allows max 6 connections per 30 seconds from same person, blocks brute force.

**Scenario 5: Docker and ufw**
Docker bypasses ufw by default. Fix:
```bash
# /etc/docker/daemon.json
{
  "iptables": false
}
```

## Testing Firewall

```bash
# From outside
nmap -p 22,80,443 your-server.com
nc -zv your-server.com 22

# From server
sudo ufw status
sudo iptables -L -n -v | head
```

**Chai view:** Send test customers to see which counters guard allows.

## Common Ports

- 22/tcp SSH — staff entrance
- 80/tcp HTTP — regular chai counter
- 443/tcp HTTPS — premium secure counter
- 3306/tcp MySQL — kitchen database
- 5432/tcp PostgreSQL
- 6379/tcp Redis
- 27017/tcp MongoDB

## Troubleshooting

```bash
# UFW blocking something?
sudo ufw status verbose
sudo tail -f /var/log/ufw.log

# Temporarily disable
sudo ufw disable

# Flush iptables
sudo iptables -F
```

**Chai view:** Check guard log to see who was blocked.

## What to Remember

- Default deny incoming, allow outgoing
- Always allow SSH before enabling, or lock yourself out
- ufw for simplicity, iptables for complex rules
- ss -tulnp shows what to protect
- Allow from specific IP for admin ports
- Use ufw limit for SSH brute force protection
- Save rules or they disappear on reboot
- Test from outside with nmap
- Docker bypasses ufw — configure carefully
