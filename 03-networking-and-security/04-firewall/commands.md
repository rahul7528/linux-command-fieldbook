# Firewall - Quick Reference

## ufw Basic
sudo ufw status<br/>
sudo ufw status verbose<br/>
sudo ufw status numbered<br/>
sudo ufw enable<br/>
sudo ufw disable<br/>
sudo ufw reset<br/>
---
## ufw Allow/Deny
sudo ufw allow 22/tcp<br/>
sudo ufw allow 80<br/>
sudo ufw allow 443/tcp<br/>
sudo ufw deny 23<br/>
sudo ufw allow from 10.0.1.0/24<br/>
sudo ufw allow from 10.0.1.5 to any port 3306<br/>
sudo ufw allow out 53<br/>
---
## ufw Delete
sudo ufw delete allow 80/tcp<br/>
sudo ufw delete 3<br/>
---
## ufw Defaults
sudo ufw default deny incoming<br/>
sudo ufw default allow outgoing<br/>
sudo ufw default deny outgoing<br/>
---
## ufw Advanced
sudo ufw limit 22/tcp<br/>
sudo ufw allow 8080/tcp comment 'app'<br/>
sudo ufw logging on<br/>
sudo ufw logging off<br/>
---
## iptables View
sudo iptables -L -n -v<br/>
sudo iptables -L -n --line-numbers<br/>
sudo iptables -S<br/>
sudo iptables -L INPUT -n -v<br/>
---
## iptables Basic
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT<br/>
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT<br/>
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT<br/>
sudo iptables -A INPUT -j DROP<br/>
sudo iptables -I INPUT 1 -p tcp --dport 22 -j ACCEPT<br/>
---
## iptables Delete
sudo iptables -D INPUT 3<br/>
sudo iptables -F<br/>
sudo iptables -F INPUT<br/>
---
## iptables Save
sudo iptables-save > /etc/iptables/rules.v4<br/>
sudo iptables-restore < /etc/iptables/rules.v4<br/>
sudo apt install iptables-persistent<br/>
---
## nftables
sudo nft list ruleset<br/>
sudo nft add table inet filter<br/>
sudo nft add chain inet filter input { type filter hook input priority 0 \; }<br/>
---
## Check Ports
ss -tulnp<br/>
sudo lsof -i -P -n | grep LISTEN<br/>
nmap -p 22,80,443 localhost<br/>
nc -zv localhost 22<br/>
---
## Quick Lockdown
sudo ufw default deny incoming<br/>
sudo ufw default allow outgoing<br/>
sudo ufw allow 22/tcp<br/>
sudo ufw allow 80/tcp<br/>
sudo ufw allow 443/tcp<br/>
sudo ufw enable<br/>
