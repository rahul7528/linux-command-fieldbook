# Logs - Quick Reference

## Basic Reading
tail -n 100 /var/log/syslog
tail -f /var/log/syslog
tail -F /var/log/app.log
head -n 20 /var/log/auth.log
less /var/log/syslog
less +F /var/log/syslog
---
## Searching
grep -i "error" /var/log/syslog
grep -r "OutOfMemory" /var/log/
grep -A5 -B5 "panic" /var/log/kern.log
grep -C3 "timeout" /var/log/nginx/error.log
rg "500" /var/log/nginx/
rg -t log "error" /var/log
zgrep "error" /var/log/syslog.1.gz
zcat /var/log/*.gz | grep " 500 "
---
## journalctl
journalctl -u nginx -f
journalctl --since "30 minutes ago"
journalctl --since today -p err
journalctl -b -1
journalctl -k -f
journalctl _PID=1234
journalctl -o json-pretty
journalctl --disk-usage
---
## Parsing
awk '{print $1}' /var/log/nginx/access.log | sort | uniq -c | sort -rn | head
awk '$9 >= 500' /var/log/nginx/access.log
awk '{print $1,$2,$3}' /var/log/syslog
sed 's/old/new/g' /var/log/app.log
cut -d' ' -f1,4 /var/log/nginx/access.log
---
## Multiple Logs
multitail /var/log/nginx/error.log /var/log/syslog
tail -f /var/log/nginx/*.log
watch -n1 'tail -n 20 /var/log/syslog'
---
## Log Rotation
cat /etc/logrotate.d/nginx
logrotate -d /etc/logrotate.conf
logrotate -f /etc/logrotate.d/nginx
ls -lh /var/log/*.gz
---
## Writing Logs
logger "Backup started"
logger -t myapp -p local0.err "Failed"
echo "test" | systemd-cat -t myapp
---
## Kernel Logs
dmesg -T | tail
dmesg -w
journalctl -k -p err
dmesg | grep -i oom
---
## Common Locations
ls /var/log/
tail -f /var/log/auth.log
tail -f /var/log/nginx/error.log
tail -f /var/log/mysql/error.log
journalctl -u sshd -f
