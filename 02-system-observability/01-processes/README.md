# Processes

Production process inspection, control, and debugging. Find CPU hogs, kill safely, trace syscalls, and understand process state.

## ps — Process Snapshot

The foundation. Always use custom formats in production.

### Syntax
```bash
ps aux
ps -ef
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu
```

### Common Flags
- `aux`: BSD style, all users
- `-ef`: System V style, full format
- `-eLf`: show threads (LWP)
- `-o`: custom columns
- `--sort=-%cpu`: sort descending
- `-p <pid>`: specific PID
- `-C <name>`: by command name
- `--forest`: tree view

### Real-world Examples
```bash
# Top 10 CPU consumers with full command
ps -eo pid,ppid,%cpu,%mem,cmd --sort=-%cpu | head -11

# Top 10 memory consumers
ps -eo pid,%mem,rss,cmd --sort=-%mem | head -11

# Find all python processes with args
ps -C python3 -o pid,user,%cpu,cmd

# Show process tree for nginx
ps -ef --forest | grep -A5 nginx

# Threads for a Java process
ps -p 1234 -Lf

# Processes older than 7 days
ps -eo pid,lstart,cmd | awk '$3 < "2026"'

# Zombie check
ps aux | awk '$8 ~ /^Z/'
```

### Gotchas
- `ps aux` truncates cmd. Use `ps -ww` for wide output.
- RSS is in KB, not percentage. Use %MEM for comparison.
- Without `--sort`, output is arbitrary.

## top, htop, atop — Live Monitoring

### top
```bash
top
# Inside top: P=cpu sort, M=mem sort, 1=per-cpu, c=full cmd, k=kill, H=threads
top -b -n1 -o %CPU | head -20
top -p 1234,5678
```

### htop (if installed)
Better UI, tree view with F5, kill with F9, no need for PID lookup.

### atop
Records history. Critical for post-mortem.
```bash
atop -r /var/log/atop/atop_20260513
# Press t to advance, m for memory, d for disk
```

Real use: server load spikes at 2am. Use `atop -r` to replay.

## pgrep, pkill, pidof — Safe Selection

Never parse `ps | grep` in scripts.

```bash
# Find PID by name
pgrep -f "gunicorn: worker"
pgrep -u www-data nginx

# Kill by pattern, safely
pkill -f "celery worker"           # SIGTERM
pkill -9 -f "stuck_script.sh"      # SIGKILL

# Exact match
pgrep -x sshd

# Newest/oldest
pgrep -n nginx    # newest
pgrep -o nginx    # oldest

# pidof for binaries
pidof nginx
```

Flags: `-f` matches full cmdline, `-u` user, `-n` newest, `-c` count only.

Gotcha: `pkill -f` matches itself. Use `pgrep` first to verify.

## kill, killall — Signals

### Syntax
```bash
kill -<signal> <pid>
killall <name>
```

### Essential Signals
- `TERM (15)`: graceful, default
- `HUP (1)`: reload config
- `INT (2)`: Ctrl-C
- `KILL (9)`: force, no cleanup
- `STOP (19)`: pause, `CONT (18)` resume
- `0`: test if process exists

### Real-world Examples
```bash
# Graceful nginx reload
kill -HUP $(cat /var/run/nginx.pid)

# Test if PID exists without killing
kill -0 1234 && echo "alive"

# Kill process group (negative PID)
kill -TERM -1234

# Kill all node processes for user deploy
killall -u deploy node

# Graceful then force pattern
pkill -TERM myapp; sleep 10; pkill -KILL myapp

# Stop/continue for debugging
kill -STOP 1234
# ... inspect ...
kill -CONT 1234
```

Safety: never start with `-9`. It leaves sockets, lock files, and corrupts data. Always try TERM, then INT, then KILL.

## pstree — Hierarchy

```bash
pstree -p
pstree -p 1
pstree -s 1234    # show parents
pstree -u          # show user
```

Use to find parent of zombie processes.

## lsof and fuser — Open Files and Ports

### lsof
```bash
# What's using port 3000
lsof -i :3000
lsof -iTCP -sTCP:LISTEN

# Files opened by process
lsof -p 1234

# Deleted files holding disk space
lsof +L1

# Network connections by process
lsof -i -P -n | grep ESTABLISHED

# User's open files
lsof -u www-data
```

### fuser
```bash
# Kill everything using port 8080
fuser -k 8080/tcp

# Show PIDs using /var/log
fuser -v /var/log
```

Real use: `df` shows disk full but `du` doesn't. Run `lsof +L1`, find deleted log held by java, restart service.

## strace, ltrace — System Call Tracing

Use for "why is it hanging" without restarting.

```bash
# Trace opens and network
strace -e trace=open,connect -p 1234

# Follow forks
strace -f -p 1234

# Count time per syscall
strace -c -p 1234

# Trace new process
strace -o /tmp/trace.log nginx -t

# ltrace for library calls
ltrace -p 1234
```

Flags: `-p` attach, `-f` follow children, `-e` filter, `-c` summary, `-tt` timestamps.

Gotcha: high overhead. Don't strace production database under load. Use for short samples.

## /proc — Instant Inspection

No tools needed, just cat.

```bash
# Command line
cat /proc/1234/cmdline | tr '\0' ' '

# Environment
cat /proc/1234/environ | tr '\0' '\n'

# Open file descriptors
ls -l /proc/1234/fd

# Memory map
cat /proc/1234/maps

# Current status
cat /proc/1234/status | grep -E "State|VmRSS|Threads"

# Limits
cat /proc/1234/limits

# Parent/children
cat /proc/1234/stat
```

Real use: process won't die, check `/proc/1234/status` for State: D (uninterruptible IO).

## nice, renice, ionice, taskset — Priority

```bash
# Start with low priority
nice -n 19 backup.sh

# Change running process
renice +10 -p 1234
renice -n -5 -u www-data

# IO priority (best-effort class 2, priority 7 lowest)
ionice -c2 -n7 -p 1234

# CPU affinity
taskset -cp 0-3 1234
taskset -c 0,2 myapp
```

Range: nice -20 (highest) to 19 (lowest). Only root can set negative.

## pidstat — Per-Process Metrics

From sysstat package.

```bash
# CPU per process every 2 seconds
pidstat -u 2

# Memory
pidstat -r -p 1234 1

# IO
pidstat -d 1

# Threads
pidstat -t -p 1234 1
```

Better than top for logging to file.

## Zombies, Orphans, D State

- **Z (zombie/defunct)**: child exited, parent didn't wait. Find parent: `ps -o ppid= -p <zombie>`, then restart parent.
- **D (uninterruptible)**: usually IO wait. Cannot kill with -9. Check `dmesg` for storage issues.
- **Orphan**: parent died, adopted by PID 1.

```bash
# Find zombies
ps -eo pid,ppid,stat,cmd | awk '$3 ~ /^Z/'

# Kill parent to clean zombies
kill -HUP $(ps -o ppid= -p <zombie_pid>)
```

## nohup, disown, timeout, watch — Job Control

```bash
# Keep running after logout
nohup long_job.sh > /tmp/out.log 2>&1 &

# Disown existing job
./script.sh &
disown %1

# Run with time limit
timeout 300 backup.sh

# Watch process count
watch -n1 'ps aux | grep -c nginx'
```

## OOM Killer and Load

```bash
# Check if OOM killed recently
dmesg -T | grep -i "out of memory"
journalctl -k -p err | grep -i kill

# OOM score (higher = more likely to kill)
cat /proc/1234/oom_score

# Adjust (requires root)
echo -1000 > /proc/1234/oom_score_adj

# Load average interpretation
uptime
# 1,5,15 min averages. Compare to CPU cores: load > cores = queuing
```

Real use: app killed at night. `journalctl -k -b -1 | grep -i oom` shows kernel killed it due to memory leak.

## What to Remember

- Use `ps -eo pid,%cpu,%mem,cmd --sort=-%cpu` not `ps aux | head`
- Never `kill -9` first; use TERM then wait then KILL
- `pgrep -f` replaces fragile grep pipelines
- `lsof -i :port` finds port users instantly
- `lsof +L1` solves mystery disk-full issues
- Zombies mean broken parent, kill parent not zombie
- D-state processes cannot be killed, fix IO
- `strace -p` for quick hangs, but low overhead only
- Check `/proc/<pid>/fd` and `status` before restarting
- Load average > CPU cores means saturation
