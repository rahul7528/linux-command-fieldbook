# Troubleshooting

Production incident response workflow. When chai tapri is slow, customers shouting — this is your checklist.

## Chai Tapri Analogy

Troubleshooting = customer says "chai is taking 20 minutes". You don't randomly change recipe. You check in order:

1. **Is counter full?** (memory)
2. **Are chaiwalas busy?** (CPU)
3. **Is godown blocked?** (disk)
4. **Is milk delivery stuck?** (network)
5. **What does register say?** (logs)

## The 60-Second Triage

Run these 5 commands first, every time.

```bash
uptime                  # load
free -h                 # memory
df -hT -x tmpfs         # disk space
iostat -x 1 1           # disk busy?
top -b -n1 | head -15   # top process
```

**Chai view:**
- load 12 on 4 cores = 12 customers, 4 chaiwalas — line too long
- MemAvailable 200MB = counter almost full
- / at 100% = godown full, can't store new ingredients
- %util 99% = godown worker stuck
- top shows java 400% = one customer ordered 400 cups

## Step-by-Step Playbooks

### 1. "Server is slow"

**Checklist:**
```bash
uptime; nproc
# load > cores*2 = CPU queue

vmstat 1 3
# wa >30 = waiting for disk

mpstat -P ALL 1
# steal >10 = cloud host issue

pidstat -u 1
# find CPU hog
```

**Chai view:** Customers waiting. First check if chaiwalas are free (idle), or waiting for milk (wa), or landlord took them (steal).

Fix:
- CPU hog: `renice +10 -p <pid>` or kill
- iowait: `iotop -o` find writer, `ionice -c3`
- steal: resize instance

### 2. "Out of memory / OOM killed"

```bash
free -h
dmesg -T | grep -i oom
journalctl -k -p err | grep -i kill
ps -eo pid,%mem,cmd --sort=-%mem | head
smem -s pss | tail
```

**Chai view:** Counter overflowed, manager threw out biggest order. Check who was using counter.

Fix:
- Find leak: `smem -P app`, watch PSS grow
- Check swap: `vmstat 1` si/so
- Emergency: `echo 3 > /proc/sys/vm/drop_caches` (clears pre-boiled water, not orders)

### 3. "Disk full"

```bash
df -hT
df -i
du -hxd1 / | sort -hr | head
lsof +L1
```

**Chai view:** Godown full. Check shelves (df), check boxes (inodes), find biggest dabba (du), find dabba in someone's hand (lsof).

Fix:
```bash
# Find and compress old logs
find /var/log -name "*.log" -size +100M

# Truncate without restart
: > /proc/<pid>/fd/3

# Clean deleted
systemctl restart <service>
```

### 4. "Application won't start / port in use"

```bash
systemctl status app -l
journalctl -u app -n 50
ss -tulnp | grep :8080
lsof -i :8080
```

**Chai view:** New counter won't open. Check register (journalctl) for reason. Check if another tapri already using that table number (port).

Fix:
```bash
# Kill old process
fuser -k 8080/tcp
# Or fix config
systemctl edit app
```

### 5. "High load, can't SSH"

```bash
# From console
uptime
ps -eo pid,ppid,cmd,%cpu --sort=-%cpu | head
kill -STOP <pid>   # pause, don't kill
```

**Chai view:** Too many customers, can't even enter shop. Pause biggest order (STOP), fix, then CONT.

Emergency:
```bash
# Kill runaway fork bomb
pkill -STOP -u baduser
```

### 6. "Network timeout"

```bash
ip a
ss -tulnp
ping -c3 8.8.8.8
mtr -rwc5 google.com
curl -v http://localhost:8080
```

**Chai view:** Milk delivery truck not arriving. Check if road is open (ip a), if gate is open (ss), if truck can reach (ping), where it stops (mtr).

### 7. "Intermittent slowness"

```bash
sar -q -f /var/log/sysstat/sa$(date +%d -d yesterday)
sar -r -f /var/log/sysstat/sa$(date +%d -d yesterday)
atop -r /var/log/atop/atop_$(date +%Y%m%d -d yesterday)
```

**Chai view:** Replay yesterday's CCTV. See when crowd formed.

## Correlation Workflow

Don't check one log. Check three at same timestamp.

```bash
# Get exact time from nginx error
TIME="14:32:15"

journalctl --since "14:32:10" --until "14:32:20"
grep "$TIME" /var/log/syslog
dmesg -T | grep "$TIME"
```

**Chai view:** Customer complained at 2:32. Check counter register, kitchen log, and delivery log all at 2:32.

## strace Quick Debug

```bash
# App hanging
strace -p <pid> -f -e trace=network,file

# What files it's opening
strace -c -p <pid>
```

**Chai view:** Stand behind chaiwala, watch exactly what he's doing — opening sugar dabba, waiting for water.

## The 5 Whys — Chai Version

Problem: Site slow
1. Why? CPU 100% — `top` shows java
2. Why java high? `pidstat` shows GC thrashing
3. Why GC? `free -h` shows swap active
4. Why swap? `smem` shows memory leak
5. Why leak? `journalctl` shows deployment at 2am introduced bug

Fix leak, not buy bigger server.

## Emergency Commands

```bash
# Save system state before reboot
dmesg > /tmp/dmesg.$(date +%s)
ps auxwf > /tmp/ps.$(date +%s)
ss -tunap > /tmp/ss.$(date +%s)

# Kill safely
pkill -TERM app; sleep 10; pkill -KILL app

# Free memory without killing
sync; echo 2 > /proc/sys/vm/drop_caches

# Find zombie parent
ps -eo pid,ppid,stat,cmd | awk '$3~/^Z/{print $2}' | sort -u
```

## What to Log in Incident

1. `uptime`, `free -h`, `df -h`, `iostat -x 1 1`
2. `journalctl --since "5 minutes ago"`
3. `top -b -n1`
4. Exact commands run

**Chai view:** Write in register: time, how many customers waiting, counter space, godown status. Next shift can see pattern.

## What to Remember

- Always triage in order: load → memory → disk → network → logs
- Never reboot first — collect state
- Use `tail -F` and `journalctl -f` together
- Correlate timestamps across logs
- `wa` high = disk, not CPU
- `steal` high = cloud issue
- lsof +L1 solves mystery disk full
- Pause with STOP, don't kill immediately
- Document what you found for next time
