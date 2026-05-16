# Memory and CPU

Production observability for memory usage, leaks, swapping, CPU saturation, and load. Diagnose performance issues without guessing.

## free and /proc/meminfo — Memory Overview

### free
```bash
free -h
free -w -h    # wide, separates buffers and cache
watch -n1 free -h
```

Interpretation:
- **available**: memory for new apps without swapping (use this, not free)
- **used**: includes cache; Linux uses free RAM for cache
- **buff/cache**: reclaimable

### /proc/meminfo
```bash
grep -E "MemTotal|MemAvailable|Swap|Dirty|Slab" /proc/meminfo
```

Real use: alert fires "memory 95%". Check `MemAvailable`, not `MemFree`. If available > 20%, it's cache, not a leak.

## vmstat — System-wide Memory and CPU

```bash
vmstat 1 5
vmstat -w 1
vmstat -s
```

Columns:
- **procs r/b**: runnable / blocked (b > 0 = IO wait)
- **memory**: swpd, free, buff, cache
- **swap si/so**: swap in/out per second (so > 0 = swapping)
- **io bi/bo**: blocks in/out
- **system in/cs**: interrupts, context switches
- **cpu us/sy/id/wa/st**: user, system, idle, iowait, steal

Real-world:
```bash
# Check for swapping
vmstat 1 | awk '$8>0 || $9>0'

# High iowait
vmstat 1 | awk '$16>30'
```

Gotcha: `wa` high means CPU waiting on disk, not CPU bound.

## top, htop — Per-Process Memory

```bash
top
# Press M to sort by memory, E to cycle units, H for threads

top -b -n1 -o %MEM | head -15
```

htop: F6 sort by PERCENT_MEM, shows RES (resident) and VIRT.

## smem and pmap — Accurate Process Memory

`ps` RSS overcounts shared memory. Use PSS.

```bash
# Install smem if available
smem -s pss
smem -u

# Map of process
pmap -x 1234
pmap -X 1234 | tail -1

# Total PSS for process tree
smem -P nginx -c "pid command pss" -t
```

Real use: find memory leak. Run `smem -s pss | tail`, note PID, wait 10m, run again, compare PSS growth.

## slabtop — Kernel Memory

```bash
slabtop -o | head -20
cat /proc/meminfo | grep Slab
```

High slab unreclaimable = kernel leak or dentry cache bloat. Clear caches (safe, non-destructive):
```bash
sync; echo 2 > /proc/sys/vm/drop_caches  # dentries/inodes only
```

## Swap Analysis

```bash
swapon --show
cat /proc/swaps
vmstat 1 | awk '{print $8,$9}'  # si so

# Swappiness (0-100, lower = avoid swap)
cat /proc/sys/vm/swappiness
sysctl vm.swappiness=10

# What is swapped per process
for pid in /proc/[0-9]*; do awk '/Swap/{s+=$2} END{print s}' $pid/smaps 2>/dev/null; done | sort -n
```

Real use: server swapping despite free RAM. Check swappiness=60 default, lower to 10 for database servers.

## lscpu and /proc/cpuinfo — CPU Topology

```bash
lscpu
lscpu -e

grep -E "model name|cpu cores|siblings" /proc/cpuinfo | head
nproc
nproc --all
```

Check for hyperthreading: siblings > cpu cores.

## uptime and Load Average

```bash
uptime
cat /proc/loadavg
```

Three numbers: 1, 5, 15 minute load. Rule: load / cores:
- < 0.7: underutilized
- 0.7-1.0: optimal
- > 1.0: queuing
- > 5.0: saturated

```bash
# Cores
CORES=$(nproc)
LOAD=$(awk '{print $1}' /proc/loadavg)
echo "scale=2; $LOAD / $CORES" | bc
```

## mpstat — Per-CPU Stats

```bash
mpstat -P ALL 1 3
mpstat 1
```

Columns: %usr, %sys, %iowait, %steal, %idle

Real use: cloud VM with high %steal (>10) = noisy neighbor, resize instance.

## pidstat — Per-Process CPU and Memory

```bash
pidstat -u 1 5      # CPU
pidstat -r 1 5      # memory faults
pidstat -w 1        # context switches
pidstat -t -p 1234 1 # threads
```

Flags: `-u` cpu, `-r` memory, `-d` io, `-w` voluntary/involuntary switches.

## sar — Historical Data

Requires sysstat.

```bash
sar -u 1 3      # CPU
sar -r 1 3      # memory
sar -q 1 3      # load
sar -B 1 3      # paging

# Yesterday
sar -r -f /var/log/sysstat/sa13
```

Real use: investigate 3am spike. `sar -r -f` shows memory dropped, swap increased.

## perf top — Hot Functions

Low overhead sampling.

```bash
sudo perf top
sudo perf top -p 1234
sudo perf top -e cycles -K
```

Use to find which function burns CPU without code changes.

## numastat and NUMA

```bash
numastat
numactl --hardware
cat /proc/zoneinfo | grep -E "Node|free"
```

High `numa_miss` or `foreign` = cross-NUMA memory access, slows database.

## PSI — Pressure Stall Information

Modern kernels expose pressure.

```bash
cat /proc/pressure/cpu
cat /proc/pressure/memory
cat /proc/pressure/io

# Some process stalled 20% of time in last 10s
grep avg10 /proc/pressure/memory
```

Real use: application latency spikes. `memory avg10=35.12` means 35% of time tasks stalled waiting for memory.

## OOM and Memory Reclaim

```bash
dmesg -T | grep -i "oom"
journalctl -k | grep -i "killed process"

# OOM scores
ps -eo pid,comm,oom_score --sort=-oom_score | head

# Prevent kill for critical process
echo -1000 | sudo tee /proc/1234/oom_score_adj
```

## vmstat, sysctl Tuning Quick Checks

```bash
sysctl vm.min_free_kbytes
sysctl vm.overcommit_memory
sysctl vm.overcommit_ratio
```

## What to Remember

- Use `MemAvailable` from free, not `free` column
- `si` and `so` in vmstat > 0 means active swapping — fix now
- `wa` high = IO bound, not CPU; check disk
- Load average must be compared to core count
- `steal` > 5% on VM = host contention
- PSS from smem is truth for process memory, RSS lies with shared libs
- `slabtop` for kernel memory leaks
- PSI files give real application stall time
- Never clear caches with `echo 3` in production unless debugging; use `echo 2`
- For leaks: smem → pmap → repeat after interval
