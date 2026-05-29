# Logs - Quick Reference<br/><br/>
<br/>
## Basic Reading<br/>
tail -n 100 /var/log/syslog<br/>
tail -f /var/log/syslog<br/>
tail -F /var/log/app.log<br/>
head -n 20 /var/log/auth.log<br/>
less /var/log/syslog<br/>
less +F /var/log/syslog<br/><br/>
---<br/>
## Searching<br/>
grep -i "error" /var/log/syslog<br/>
grep -r "OutOfMemory" /var/log/<br/>
grep -A5 -B5 "panic" /var/log/kern.log<br/>
grep -C3 "timeout" /var/log/nginx/error.log<br/>
rg "500" /var/log/nginx/<br/>
rg -t log "error" /var/log<br/>
zgrep "error" /var/log/syslog.1.gz<br/>
zcat /var/log/*.gz | grep " 500 "<br/><br/>
---<br/>
## journalctl<br/>
journalctl -u nginx -f<br/>
journalctl --since "30 minutes ago"<br/>
journalctl --since today -p err<br/>
journalctl -b -1<br/>
journalctl -k -f<br/>
journalctl _PID=1234<br/>
journalctl -o json-pretty<br/>
journalctl --disk-usage<br/><br/>
---<br/>
## Parsing<br/>
awk '{print $1}' /var/log/nginx/access.log | sort | uniq -c | sort -rn | head<br/>
awk '$9 >= 500' /var/log/nginx/access.log<br/>
awk '{print $1,$2,$3}' /var/log/syslog<br/>
sed 's/old/new/g' /var/log/app.log<br/>
cut -d' ' -f1,4 /var/log/nginx/access.log<br/><br/>
---<br/>
## Multiple Logs<br/>
multitail /var/log/nginx/error.log /var/log/syslog<br/>
tail -f /var/log/nginx/*.log<br/>
watch -n1 'tail -n 20 /var/log/syslog'<br/><br/>
---<br/>
## Log Rotation<br/>
cat /etc/logrotate.d/nginx<br/>
logrotate -d /etc/logrotate.conf<br/>
logrotate -f /etc/logrotate.d/nginx<br/>
ls -lh /var/log/*.gz<br/><br/>
---<br/>
## Writing Logs<br/>
logger "Backup started"<br/>
logger -t myapp -p local0.err "Failed"<br/>
echo "test" | systemd-cat -t myapp<br/><br/>
---<br/>
## Kernel Logs<br/>
dmesg -T | tail<br/>
dmesg -w<br/>
journalctl -k -p err<br/>
dmesg | grep -i oom<br/><br/>
---<br/>
## Common Locations<br/>
ls /var/log/<br/>
tail -f /var/log/auth.log<br/>
tail -f /var/log/nginx/error.log<br/>
tail -f /var/log/mysql/error.log<br/>
journalctl -u sshd -f<br/>
