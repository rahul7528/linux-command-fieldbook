# Troubleshooting - Quick Reference<br/>
<br/>
## 60-Second Triage<br/>
uptime<br/>
free -h<br/>
df -hT -x tmpfs<br/>
iostat -x 1 1<br/>
top -b -n1 | head -15<br/>
vmstat 1 3<br/><br/>
---<br/>
## CPU Issues<br/>
uptime; nproc<br/>
mpstat -P ALL 1<br/>
pidstat -u 1 5<br/>
ps -eo pid,%cpu,cmd --sort=-%cpu | head<br/>
perf top<br/>
cat /proc/loadavg<br/><br/>
---<br/>
## Memory Issues<br/>
free -h<br/>
vmstat 1 | awk '$8>0 || $9>0'<br/>
dmesg -T | grep -i oom<br/>
ps -eo pid,%mem,cmd --sort=-%mem | head<br/>
smem -s pss | tail<br/>
cat /proc/meminfo | grep -E "Available|Swap"<br/><br/>
---<br/>
## Disk Issues<br/>
df -hT<br/>
df -i<br/>
du -hxd1 / | sort -hr | head<br/>
lsof +L1<br/>
iostat -x 1 3<br/>
iotop -oPa<br/>
find / -xdev -size +1G<br/><br/>
---<br/>
## Process Issues<br/>
systemctl status app -l<br/>
journalctl -u app -n 50 --no-pager<br/>
ps aux | grep app<br/>
strace -p <pid> -f<br/>
lsof -p <pid><br/>
cat /proc/<pid>/status<br/><br/>
---<br/>
## Network Issues<br/>
ip a<br/>
ss -tulnp<br/>
ss -s<br/>
ping -c3 8.8.8.8<br/>
mtr -rwc5 google.com<br/>
curl -v http://localhost:8080<br/>
lsof -i :8080<br/><br/>
---<br/>
## Log Correlation<br/>
journalctl --since "5 minutes ago"<br/>
tail -n 200 /var/log/syslog | grep -i error<br/>
journalctl -k -p err<br/>
dmesg -T | tail -20<br/>
grep -r "OutOfMemory" /var/log/<br/><br/>
---<br/>
## Historical<br/>
sar -q 1 3<br/>
sar -r 1 3<br/>
sar -d 1 3<br/>
atop -r /var/log/atop/atop_$(date +%Y%m%d)<br/>
journalctl --since yesterday<br/><br/>
---<br/>
## Emergency<br/>
pkill -TERM app; sleep 10; pkill -KILL app<br/>
kill -STOP <pid><br/>
kill -CONT <pid><br/>
sync; echo 2 > /proc/sys/vm/drop_caches<br/>
dmesg > /tmp/dmesg.$(date +%s)<br/>
ps auxwf > /tmp/ps.$(date +%s)<br/><br/>
---<br/>
## Zombie and D-state<br/>
ps -eo pid,ppid,stat,cmd | awk '$3 ~ /^Z/'<br/>
ps -eo pid,stat,cmd | awk '$2 ~ /^D/'<br/>
cat /proc/<pid>/stack<br/>
