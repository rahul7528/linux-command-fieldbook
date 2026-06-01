# Firewall - Command Explanations with Chai Analogy

## ufw status
**What:** Shows current firewall rules.<br/>
**Chai:** Ask guard for list of who is allowed. verbose shows more detail.<br/>
**Use:** Check before making changes.<br/>

## ufw allow 22/tcp
**What:** Allows TCP port 22 incoming.<br/>
**Chai:** Tell guard to let people through staff entrance (SSH).<br/>
**Use:** Essential first rule or you'll lock yourself out.<br/>

## ufw default deny incoming
**What:** Sets default policy to block all incoming.<br/>
**Chai:** Guard's default instruction: block everyone unless specifically allowed.<br/>
**Use:** Secure by default approach.<br/>

## ufw allow from 10.0.1.0/24
**What:** Allows all traffic from subnet.<br/>
**Chai:** Allow anyone from office building, regardless of which counter they want.<br/>
**Use:** Trust internal network.<br/>

## ufw limit 22/tcp
**What:** Rate limits SSH connections.<br/>
**Chai:** Guard allows max 6 attempts per 30 seconds from same person, then blocks. Prevents brute force.<br/>
**Use:** Protect SSH from password guessing.<br/>

## iptables -A INPUT -p tcp --dport 80 -j ACCEPT
**What:** Appends rule to INPUT chain.<br/>
**Flags:** -A append, -p protocol, --dport destination port, -j jump to target ACCEPT<br/>
**Chai:** Add to rulebook: for incoming people going to chai counter (80), let them in.<br/>
**Use:** Low-level firewall control.<br/>

## iptables -m state --state ESTABLISHED,RELATED
**What:** Allows return traffic for existing connections.<br/>
**Chai:** If customer already inside and went out to get something, let them back in.<br/>
**Use:** Essential rule or outgoing connections break.<br/>

## iptables -L -n -v
**What:** Lists rules with numbers and packet counts.<br/>
**Flags:** -n numeric, -v verbose<br/>
**Chai:** Read rulebook with counters showing how many people used each rule.<br/>
**Use:** Debug which rule is matching.<br/>

## iptables-save
**What:** Dumps current rules to stdout.<br/>
**Chai:** Photocopy rulebook to save.<br/>
**Use:** Rules disappear on reboot unless saved.<br/>

## ss -tulnp
**What:** Shows listening ports.<br/>
**Chai:** List all counters currently open before deciding firewall rules.<br/>
**Use:** Find what needs protecting.<br/>

## nmap -p 22,80,443
**What:** Scans ports from outside.<br/>
**Chai:** Send test customers to check which counters are reachable.<br/>
**Use:** Verify firewall works.<br/>

## Common Patterns

**Secure web server:**
ufw default deny incoming<br/>
ufw allow 22/tcp<br/>
ufw allow 80/tcp<br/>
ufw allow 443/tcp<br/>
ufw enable<br/>

**Database only from app servers:**
ufw allow from 10.0.1.10 to any port 3306<br/>
ufw allow from 10.0.1.11 to any port 3306<br/>

**Block attacker:**
ufw deny from 198.51.100.77<br/>
or<br/>
iptables -A INPUT -s 198.51.100.77 -j DROP<br/>

**Allow SSH only from your IP:**
ufw delete allow 22/tcp<br/>
ufw allow from YOUR_IP to any port 22<br/>
