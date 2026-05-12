# Processes - Quick Reference

## Snapshot
ps aux
ps -ef
ps -eo pid,ppid,%cpu,%mem,cmd --sort=-%cpu | head
ps -eo pid,%mem,rss,cmd --sort=-%mem | head
ps -C nginx -o pid,user,cmd
ps -p 1234 -Lf
ps aux | awk '$8 ~ /^Z/'
ps -ef --forest
---
## Live Monitoring
top
top -b -n1 -o %CPU | head -20
top -p 1234,5678
htop
atop
atop -r /var/log/atop/atop_20260513
---
## Find and Kill
pgrep -f "pattern"
pgrep -u www-data -x nginx
pgrep -n nginx
pidof nginx
pkill -f "celery worker"
pkill -TERM myapp; sleep 10; pkill -KILL myapp
kill -0 1234
kill -HUP $(cat /var/run/nginx.pid)
kill -TERM -1234
killall -u deploy node
kill -STOP 1234; kill -CONT 1234
---
## Hierarchy
pstree -p
pstree -s 1234
pstree -u
---
## Open Files and Ports
lsof -i :3000
lsof -iTCP -sTCP:LISTEN
lsof -p 1234
lsof +L1
lsof -u www-data
lsof -i -P -n
fuser -v 8080/tcp
fuser -k 8080/tcp
---
## Tracing
strace -p 1234
strace -f -e trace=open,connect -p 1234
strace -c -p 1234
strace -o /tmp/trace.log -f command
ltrace -p 1234
---
## /proc Inspection
cat /proc/1234/cmdline | tr '\0' ' '
cat /proc/1234/environ | tr '\0' '\n'
ls -l /proc/1234/fd
cat /proc/1234/status
cat /proc/1234/limits
cat /proc/1234/maps
---
## Priority
nice -n 19 backup.sh
renice +10 -p 1234
renice -n -5 -u www-data
ionice -c2 -n7 -p 1234
taskset -cp 0-3 1234
---
## Metrics
pidstat -u 2
pidstat -r -p 1234 1
pidstat -d 1
pidstat -t -p 1234 1
vmstat 1
---
## Zombies and State
ps -eo pid,ppid,stat,cmd | awk '$3 ~ /^Z/'
ps -o ppid= -p <zombie>
kill -HUP <parent_pid>
---
## Job Control
nohup ./script.sh > /tmp/out.log 2>&1 &
disown %1
timeout 300 command
watch -n1 'ps aux | grep nginx'
---
## OOM and Load
dmesg -T | grep -i "out of memory"
journalctl -k -p err | grep -i kill
cat /proc/1234/oom_score
uptime
nproc
