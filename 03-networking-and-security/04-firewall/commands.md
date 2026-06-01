# Firewall - Quick Reference

## ufw Basic
sudo ufw status
sudo ufw status verbose
sudo ufw status numbered
sudo ufw enable
sudo ufw disable
sudo ufw reset
---
## ufw Allow/Deny
sudo ufw allow 22/tcp
sudo ufw allow 80
sudo ufw allow 443/tcp
sudo ufw deny 23
sudo ufw allow from 10.0.1.0/24
sudo ufw allow from 10.0.1.5 to any port 3306
sudo ufw allow out 53
---
## ufw Delete
sudo ufw delete allow 80/tcp
sudo ufw delete 3
---
## ufw Defaults
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw default deny outgoing
---
## ufw Advanced
sudo ufw limit 22/tcp
sudo ufw allow 8080/tcp comment 'app'
sudo ufw logging on
sudo ufw logging off
---
## iptables View
sudo iptables -L -n -v
sudo iptables -L -n --line-numbers
sudo iptables -S
sudo iptables -L INPUT -n -v
---
## iptables Basic
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A INPUT -j DROP
sudo iptables -I INPUT 1 -p tcp --dport 22 -j ACCEPT
---
## iptables Delete
sudo iptables -D INPUT 3
sudo iptables -F
sudo iptables -F INPUT
---
## iptables Save
sudo iptables-save > /etc/iptables/rules.v4
sudo iptables-restore < /etc/iptables/rules.v4
sudo apt install iptables-persistent
---
## nftables
sudo nft list ruleset
sudo nft add table inet filter
sudo nft add chain inet filter input { type filter hook input priority 0 \; }
---
## Check Ports
ss -tulnp
sudo lsof -i -P -n | grep LISTEN
nmap -p 22,80,443 localhost
nc -zv localhost 22
---
## Quick Lockdown
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable
