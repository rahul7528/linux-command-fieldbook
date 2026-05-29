# Memory and CPU - Quick Reference<br/><br/>
<br/>
## Memory Overview<br/>
free -h<br/>
free -w -h<br/>
watch -n1 free -h<br/>
grep -E "MemTotal|MemAvailable|SwapCached" /proc/meminfo<br/>
cat /proc/meminfo<br/><br/>
---<br/>
## vmstat<br/>
vmstat 1<br/>
vmstat -w 1 5<br/>
vmstat -s<br/>
vmstat 1 | awk '$8>0 || $9>0'<br/><br/>
---<br/>
## Process Memory<br/>
top -b -n1 -o %MEM | head -15<br/>
htop<br/>
smem -s pss<br/>
smem -u<br/>
smem -P nginx -t<br/>
pmap -x 1234<br/>
pmap -X 1234 | tail -1<br/>
ps -eo pid,%mem,rss,cmd --sort=-%mem | head<br/><br/>
---<br/>
## Kernel Memory<br/>
slabtop -o | head -20<br/>
cat /proc/meminfo | grep Slab<br/>
sync; echo 2 > /proc/sys/vm/drop_caches<br/><br/>
---<br/>
## Swap<br/>
swapon --show<br/>
cat /proc/swaps<br/>
cat /proc/sys/vm/swappiness<br/>
sysctl vm.swappiness=10<br/>
vmstat 1 | awk '{print $8,$9}'<br/><br/>
---<br/>
## CPU Topology<br/>
lscpu<br/>
lscpu -e<br/>
nproc<br/>
nproc --all<br/>
grep "model name" /proc/cpuinfo | head -1<br/><br/>
---<br/>
## Load and CPU Usage<br/>
uptime<br/>
cat /proc/loadavg<br/>
mpstat -P ALL 1<br/>
mpstat 1 3<br/>
sar -u 1 3<br/>
sar -q 1 3<br/>
pidstat -u 1<br/><br/>
---<br/>
## Per-Process CPU/Memory<br/>
pidstat -u 1 5<br/>
pidstat -r 1 5<br/>
pidstat -w 1<br/>
pidstat -t -p 1234 1<br/><br/>
---<br/>
## NUMA<br/>
numastat<br/>
numactl --hardware<br/><br/>
---<br/>
## Pressure and OOM<br/>
cat /proc/pressure/cpu<br/>
cat /proc/pressure/memory<br/>
cat /proc/pressure/io<br/>
dmesg -T | grep -i oom<br/>
journalctl -k | grep -i kill<br/>
ps -eo pid,comm,oom_score --sort=-oom_score | head<br/><br/>
---<br/>
## Perf<br/>
sudo perf top<br/>
sudo perf top -p 1234<br/><br/>
---<br/>
## Historical<br/>
sar -r 1 3<br/>
sar -B 1 3<br/>
sar -r -f /var/log/sysstat/sa13<br/>
