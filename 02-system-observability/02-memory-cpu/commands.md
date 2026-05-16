# Memory and CPU - Quick Reference

## Memory Overview
free -h
free -w -h
watch -n1 free -h
grep -E "MemTotal|MemAvailable|SwapCached" /proc/meminfo
cat /proc/meminfo
---
## vmstat
vmstat 1
vmstat -w 1 5
vmstat -s
vmstat 1 | awk '$8>0 || $9>0'
---
## Process Memory
top -b -n1 -o %MEM | head -15
htop
smem -s pss
smem -u
smem -P nginx -t
pmap -x 1234
pmap -X 1234 | tail -1
ps -eo pid,%mem,rss,cmd --sort=-%mem | head
---
## Kernel Memory
slabtop -o | head -20
cat /proc/meminfo | grep Slab
sync; echo 2 > /proc/sys/vm/drop_caches
---
## Swap
swapon --show
cat /proc/swaps
cat /proc/sys/vm/swappiness
sysctl vm.swappiness=10
vmstat 1 | awk '{print $8,$9}'
---
## CPU Topology
lscpu
lscpu -e
nproc
nproc --all
grep "model name" /proc/cpuinfo | head -1
---
## Load and CPU Usage
uptime
cat /proc/loadavg
mpstat -P ALL 1
mpstat 1 3
sar -u 1 3
sar -q 1 3
pidstat -u 1
---
## Per-Process CPU/Memory
pidstat -u 1 5
pidstat -r 1 5
pidstat -w 1
pidstat -t -p 1234 1
---
## NUMA
numastat
numactl --hardware
---
## Pressure and OOM
cat /proc/pressure/cpu
cat /proc/pressure/memory
cat /proc/pressure/io
dmesg -T | grep -i oom
journalctl -k | grep -i kill
ps -eo pid,comm,oom_score --sort=-oom_score | head
---
## Perf
sudo perf top
sudo perf top -p 1234
---
## Historical
sar -r 1 3
sar -B 1 3
sar -r -f /var/log/sysstat/sa13
