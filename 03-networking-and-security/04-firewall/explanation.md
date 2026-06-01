# Firewall - Command Explanations with Chai Analogy

## ufw status
**What:** Shows current firewall rules.
**Chai:** Ask guard for list of who is allowed. verbose shows more detail.
**Use:** Check before making changes.

## ufw allow 22/tcp
**What:** Allows TCP port 22 incoming.
**Chai:** Tell guard to let people through staff entrance (SSH).
**Use:** Essential first rule or you'll lock yourself out.

## ufw default deny incoming
**What:** Sets default policy to block all incoming.
**Chai:** Guard's default instruction: block everyone unless specifically allowed.
**Use:** Secure by default approach.

## ufw allow from 10.0.1.0/24
**What:** Allows all traffic from subnet.
**Chai:** Allow anyone from office building, regardless of which counter they want.
**Use:** Trust internal network.

## ufw limit 22/tcp
**What:** Rate limits SSH connections.
**Chai:** Guard allows max 6 attempts per 30 seconds from same person, then blocks. Prevents brute force.
**Use:** Protect SSH from password guessing.

## iptables -A INPUT -p tcp --dport 80 -j ACCEPT
**What:** Appends rule to INPUT chain.
**Flags:** -A append, -p protocol, --dport destination port, -j jump to target ACCEPT
**Chai:** Add to rulebook: for incoming people going to chai counter (80), let them in.
**Use:** Low-level firewall control.

## iptables -m state --state ESTABLISHED,RELATED
**What:** Allows return traffic for existing connections.
**Chai:** If customer already inside and went out to get something, let them back in.
**Use:** Essential rule or outgoing connections break.

## iptables -L -n -v
**What:** Lists rules with numbers and packet counts.
**Flags:** -n numeric, -v verbose
**Chai:** Read rulebook with counters showing how many people used each rule.
**Use:** Debug which rule is matching.

## iptables-save
**What:** Dumps current rules to stdout.
**Chai:** Photocopy rulebook to save.
**Use:** Rules disappear on reboot unless saved.

## ss -tulnp
**What:** Shows listening ports.
**Chai:** List all counters currently open before deciding firewall rules.
**Use:** Find what needs protecting.

## nmap -p 22,80,443
**What:** Scans ports from outside.
**Chai:** Send test customers to check which counters are reachable.
**Use:** Verify firewall works.

## Common Patterns

**Secure web server:**
ufw default deny incoming
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw enable

**Database only from app servers:**
ufw allow from 10.0.1.10 to any port 3306
ufw allow from 10.0.1.11 to any port 3306

**Block attacker:**
ufw deny from 198.51.100.77
or
iptables -A INPUT -s 198.51.100.77 -j DROP

**Allow SSH only from your IP:**
ufw delete allow 22/tcp
ufw allow from YOUR_IP to any port 22
