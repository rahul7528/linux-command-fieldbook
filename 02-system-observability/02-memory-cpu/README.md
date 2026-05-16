# Memory and CPU

Production observability for memory usage, leaks, swapping, CPU saturation, and load. Think of your server as a busy chai tapri.

## Chai Tapri Analogy

- **RAM** = counter space where you make chai. Fast, limited.
- **CPU cores** = number of chaiwalas working.
- **Load average** = customers waiting in line.
- **Cache/buffers** = pre-boiled water and pre-cut ginger — ready to use, but you can clear it if you need space.
- **Swap** = back storeroom. You can keep cups there, but fetching takes time.
- **Disk I/O wait** = waiting for milk delivery truck.

## free and /proc/meminfo — Memory Overview

### free
```bash
free -h
free -w -h
```

**Chai view:** `free` shows empty counter space. `available` is real free space including what you can clear (pre-boiled water). Don't panic if `used` is high — Linux keeps water hot.

Interpretation:
- **available**: memory for new customers without using storeroom
- **buff/cache**: pre-boiled water, reclaimable instantly

```bash
grep -E "MemTotal|MemAvailable|Swap" /proc/meminfo
```

Real use: Alert says 95% memory. Check `MemAvailable`. If 2GB available, it's just hot water, not a leak.

## vmstat — System-wide Memory and CPU

```bash
vmstat 1 5
```

**Chai view:**
- `r` = customers currently being served
- `b` = customers blocked waiting for milk (disk)
- `si/so` = cups moving to/from storeroom (swap in/out). Any `so` > 0 means you're using back room — slow.
- `wa` = chaiwalas idle waiting for milk delivery

```bash
# Check for swapping
vmstat 1 | awk '$8>0 || $9>0 {print "SWAPPING:",$8,$9}'
```

## top, htop — Per-Process Memory

```bash
top
# Press M to sort by memory
```

**Chai view:** See which customer order is taking up the whole counter. One Java process using 8GB = one guy ordered 100 cups.

```bash
top -b -n1 -o %MEM | head -15
```

## smem and pmap — Accurate Process Memory

`ps` RSS counts shared ginger twice. PSS is truth.

```bash
smem -s pss
pmap -x 1234
```

**Chai view:** Multiple chaiwalas share same ginger jar. RSS says each has full jar. PSS divides it fairly.

Real use: Find memory leak. Run `smem -P gunicorn`, wait 10 minutes, run again. PSS growing = leak.

## slabtop — Kernel Memory

```bash
slabtop -o | head -20
```

**Chai view:** This is memory the kitchen staff (kernel) uses for their own tools — ladles, strainers. If `dentry` cache is huge, kernel is remembering too many file names.

Clear safely:
```bash
sync; echo 2 > /proc/sys/vm/drop_caches  # clear recipe memory only
```

## Swap Analysis

```bash
swapon --show
cat /proc/sys/vm/swappiness
```

**Chai view:** Swappiness = how eager you are to use storeroom. 60 = normal shop, 10 = premium tapri (avoid storeroom, keep everything on counter). Databases want 10.

```bash
vmstat 1 | awk '{print $8,$9}'  # si so
```

If `so` constantly >0, you're serving from storeroom — customers will complain about slow chai.

## lscpu and /proc/cpuinfo — CPU Topology

```bash
lscpu
nproc
```

**Chai view:** `nproc` = number of chaiwalas. `lscpu` shows if each has two hands (hyperthreading).

## uptime and Load Average

```bash
uptime
```

**Chai view:** Load 4.5 on 4 cores = 4 chaiwalas, but 4-5 customers waiting. Line is building. Load 12 on 4 cores = crowd outside, chai will be slow.

Rule: load / cores > 1.0 = queuing.

```bash
CORES=$(nproc); LOAD=$(awk '{print $1}' /proc/loadavg); echo "scale=2; $LOAD/$CORES" | bc
```

## mpstat — Per-CPU Stats

```bash
mpstat -P ALL 1
```

**Chai view:**
- `%usr` = making chai
- `%sys` = cleaning counter
- `%iowait` = waiting for milk
- `%steal` = landlord took your chaiwala to work elsewhere (cloud noisy neighbor)
- `%idle` = chaiwala sitting free

Real use: `%steal` >10% on AWS = move to bigger instance.

## pidstat — Per-Process CPU and Memory

```bash
pidstat -u 1 5
pidstat -r 1 5
```

**Chai view:** Track which specific order is burning gas. High voluntary switches = chaiwala keeps getting interrupted.

## sar — Historical Data

```bash
sar -r 1 3
sar -u 1 3
```

**Chai view:** Replay yesterday's rush hour. See when counter filled up at 2am.

## perf top — Hot Functions

```bash
sudo perf top
```

**Chai view:** Instead of watching chaiwalas, watch their hands. See if they're spending time chopping ginger or waiting for water to boil.

## numastat and NUMA

```bash
numastat
```

**Chai view:** Two kitchens (NUMA nodes). If chaiwala in kitchen 1 keeps fetching milk from kitchen 2, it's slow. `numa_miss` high = bad layout.

## PSI — Pressure Stall Information

```bash
cat /proc/pressure/memory
```

**Chai view:** Real customer pain. `some avg10=35` means 35% of time in last 10 seconds, customers waited because counter was full.

## OOM Killer

```bash
dmesg -T | grep -i "oom"
ps -eo pid,comm,oom_score --sort=-oom_score | head
```

**Chai view:** Counter completely full, no space even in storeroom. Manager (kernel) throws out biggest customer (kills process) to save shop.

## What to Remember

- Available > free — check MemAvailable, not free
- si/so >0 = using storeroom = slow
- Load / cores >1 = line forming
- wa high = waiting for milk, not CPU problem
- PSS from smem is real memory, RSS lies
- steal >5% = cloud host stealing your chaiwala
- PSI tells you actual customer waiting time
