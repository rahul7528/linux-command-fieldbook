# Troubleshooting - Quick Reference

## 60-Second Triage
uptime
free -h
df -hT -x tmpfs
iostat -x 1 1
top -b -n1 | head -15
vmstat 1 3
---
## CPU Issues
uptime; nproc
mpstat -P ALL 1
pidstat -u 1 5
ps -eo pid,%cpu,cmd --sort=-%cpu | head
perf top
cat /proc/loadavg
---
## Memory Issues
free -h
vmstat 1 | awk '$8>0 || $9>0'
dmesg -T | grep -i oom
ps -eo pid,%mem,cmd --sort=-%mem | head
smem -s pss | tail
cat /proc/meminfo | grep -E "Available|Swap"
---
## Disk Issues
df -hT
df -i
du -hxd1 / | sort -hr | head
lsof +L1
iostat -x 1 3
iotop -oPa
find / -xdev -size +1G
---
## Process Issues
systemctl status app -l
journalctl -u app -n 50 --no-pager
ps aux | grep app
strace -p <pid> -f
lsof -p <pid>
cat /proc/<pid>/status
---
## Network Issues
ip a
ss -tulnp
ss -s
ping -c3 8.8.8.8
mtr -rwc5 google.com
curl -v http://localhost:8080
lsof -i :8080
---
## Log Correlation
journalctl --since "5 minutes ago"
tail -n 200 /var/log/syslog | grep -i error
journalctl -k -p err
dmesg -T | tail -20
grep -r "OutOfMemory" /var/log/
---
## Historical
sar -q 1 3
sar -r 1 3
sar -d 1 3
atop -r /var/log/atop/atop_$(date +%Y%m%d)
journalctl --since yesterday
---
## Emergency
pkill -TERM app; sleep 10; pkill -KILL app
kill -STOP <pid>
kill -CONT <pid>
sync; echo 2 > /proc/sys/vm/drop_caches
dmesg > /tmp/dmesg.$(date +%s)
ps auxwf > /tmp/ps.$(date +%s)
---
## Zombie and D-state
ps -eo pid,ppid,stat,cmd | awk '$3 ~ /^Z/'
ps -eo pid,stat,cmd | awk '$2 ~ /^D/'
cat /proc/<pid>/stack
