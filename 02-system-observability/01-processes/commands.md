# Processes - Quick Reference
<br><br/>
## Snapshot<br>
ps aux <br>
ps -ef <br>
ps -eo pid,ppid,%cpu,%mem,cmd --sort=-%cpu | head <br>
ps -eo pid,%mem,rss,cmd --sort=-%mem | head <br>
ps -C nginx -o pid,user,cmd <br>
ps -p 1234 -Lf <br>
ps aux | awk '$8 ~ /^Z/' <br>
ps -ef --forest <br>
---<br><br/>
## Live Monitoring<br>
top<br>
top -b -n1 -o %CPU | head -20<br>
top -p 1234,5678<br>
htop<br>
atop<br>
atop -r /var/log/atop/atop_20260513<br>
---<br><br/>
## Find and Kill<br>
pgrep -f "pattern"<br>
pgrep -u www-data -x nginx<br>
pgrep -n nginx<br>
pidof nginx<br>
pkill -f "celery worker"<br>
pkill -TERM myapp; sleep 10; pkill -KILL myapp<br>
kill -0 1234<br>
kill -HUP $(cat /var/run/nginx.pid)<br>
kill -TERM -1234<br>
killall -u deploy node<br>
kill -STOP 1234; kill -CONT 1234<br>
---<br><br/>
## Hierarchy<br>
pstree -p<br>
pstree -s 1234<br>
pstree -u<br>
---<br><br/>
## Open Files and Ports<br>
lsof -i :3000<br>
lsof -iTCP -sTCP:LISTEN<br>
lsof -p 1234<br>
lsof +L1<br>
lsof -u www-data<br>
lsof -i -P -n<br>
fuser -v 8080/tcp<br>
fuser -k 8080/tcp<br>
---<br><br/>
## Tracing<br>
strace -p 1234<br>
strace -f -e trace=open,connect -p 1234<br>
strace -c -p 1234<br>
strace -o /tmp/trace.log -f command<br>
ltrace -p 1234<br>
---<br><br/>
## /proc Inspection<br>
cat /proc/1234/cmdline | tr '\0' ' '<br>
cat /proc/1234/environ | tr '\0' '\n'<br>
ls -l /proc/1234/fd<br>
cat /proc/1234/status<br>
cat /proc/1234/limits<br>
cat /proc/1234/maps<br>
---<br><br/>
## Priority<br>
nice -n 19 backup.sh<br>
renice +10 -p 1234<br>
renice -n -5 -u www-data<br>
ionice -c2 -n7 -p 1234<br>
taskset -cp 0-3 1234<br>
---<br><br/>
## Metrics<br>
pidstat -u 2<br>
pidstat -r -p 1234 1<br>
pidstat -d 1<br>
pidstat -t -p 1234 1<br>
vmstat 1<br>
---<br><br/>
## Zombies and State<br>
ps -eo pid,ppid,stat,cmd | awk '$3 ~ /^Z/'<br>
ps -o ppid= -p <zombie><br>
kill -HUP <parent_pid><br>
---<br><br/>
## Job Control<br>
nohup ./script.sh > /tmp/out.log 2>&1 &<br>
disown %1<br>
timeout 300 command<br>
watch -n1 'ps aux | grep nginx'<br>
---<br><br/>
## OOM and Load<br>
dmesg -T | grep -i "out of memory"<br>
journalctl -k -p err | grep -i kill<br>
cat /proc/1234/oom_score<br>
uptime<br>
nproc<br>
