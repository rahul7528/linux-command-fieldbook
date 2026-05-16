# Disk I/O

Production disk usage, I/O saturation, and performance diagnosis. Find what is filling disks, what process is hammering IO, and why iowait is high.

## df, du, inodes — Space Usage

### df
```bash
df -hT
df -hT -x tmpfs -x devtmpfs
df -i                    # inodes
```

Interpretation: Use `-T` for filesystem type. 100% use on `/` stops writes. Check inodes separately — full inodes = "No space left" even with free blocks.

### du
```bash
du -hxd1 / | sort -hr | head -15
du -sh /var/log/*
ncdu /                   # interactive
```

Flags: `-x` stay on one filesystem, `-d1` depth 1, `-h` human.

Real-world:
```bash
# Find top 10 directories on root
du -x / -d2 2>/dev/null | sort -rn | head

# Find files >1GB
find / -xdev -type f -size +1G -exec ls -lh {} \; 2>/dev/null
```

Gotcha: `du` vs `df` mismatch means deleted files held open. Use `lsof +L1`.

## lsblk, findmnt, blkid — Devices and Mounts

```bash
lsblk -f
lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT,ROTA
findmnt
findmnt /var
blkid
```

`ROTA=1` = spinning disk, `0` = SSD/NVMe.

## iostat — Device Utilization

From sysstat.

```bash
iostat -x 1 3
iostat -xz 1              # ignore zero-activity
iostat -p sda 1
```

Key columns:
- **%util**: device saturation ( >80% = bottleneck)
- **await**: average wait ms ( >20ms SSD, >50ms HDD = slow)
- **avgqu-sz**: queue depth ( >2 = saturated)
- **r/s w/s**: IOPS
- **rkB/s wkB/s**: throughput

Real use:
```bash
# Find saturated disk
iostat -x 1 | awk '$NF>80'

# Check NVMe latency
iostat -x nvme0n1 1
```

## vmstat — IO Wait Context

```bash
vmstat 1
```

Focus: `bi`/`bo` (blocks in/out), `wa` (CPU iowait %). `wa` > 30% consistently = disk bound.

## iotop and pidstat -d — Per-Process IO

```bash
sudo iotop -oPa          # only processes doing IO, accumulated
sudo iotop -b -n5

pidstat -d 1 5           # kB_rd/s kB_wr/s
pidstat -d -p 1234 1
```

Real use: MySQL slow. `iotop -o` shows backup script writing 200MB/s to same disk.

Flags: `-o` only active, `-P` show processes not threads, `-a` accumulated.

## dstat — Combined View

```bash
dstat -cdngy 1
dstat --top-io --top-bio
```

Shows cpu, disk, net, paging together.

## sar — Historical IO

```bash
sar -d 1 3               # per device
sar -b 1 3               # overall IO
sar -d -p                # pretty device names

# Yesterday 2pm
sar -d -f /var/log/sysstat/sa13 -s 14:00:00
```

## /proc/diskstats — Raw Counters

```bash
cat /proc/diskstats
# Fields: reads completed, reads merged, sectors read, ms reading, writes completed...
```

Quick check:
```bash
grep sda /proc/diskstats | awk '{print "reads:",$4,"writes:",$8}'
```

## lsof +L1 — Deleted Files Holding Space

```bash
lsof +L1
lsof +L1 / | awk '$7 > 1048576'   # >1GB deleted
```

Fix: restart the process holding the file, or truncate via `/proc/<pid>/fd`.

```bash
# Truncate without restart
: > /proc/1234/fd/3
```

## find — Large and Old Files

```bash
# Largest files
find /var -xdev -type f -printf '%s %p\n' | sort -rn | head -20 | numfmt --to=iec

# Files not accessed in 90 days
find /data -atime +90 -ls

# Inode hogs (many small files)
find /var/spool -xdev -printf '%h\n' | sort | uniq -c | sort -rn | head
```

## ionice — IO Priority

```bash
ionice -c3 -p 1234       # idle class for backup
ionice -c2 -n0 backup.sh # best-effort high priority

ionice -p $$             # check current
```

Classes: 1=realtime, 2=best-effort (0-7), 3=idle.

## fio — Quick Performance Test

Safe read-only test on /tmp.

```bash
# Random read IOPS
fio --name=test --ioengine=libaio --rw=randread --bs=4k --size=256M --runtime=10 --time_based --direct=1 --filename=/tmp/fiotest

# Sequential write
fio --name=seq --rw=write --bs=1M --size=512M --direct=1 --filename=/tmp/fiotest2
```

Cleanup after. Never run on production data volumes.

## smartctl — Disk Health

```bash
sudo smartctl -a /dev/sda | grep -E "Model|Reallocated|Pending|Temperature"
sudo smartctl -H /dev/sda
sudo smartctl -t short /dev/sda
```

Watch `Reallocated_Sector_Ct`, `Current_Pending_Sector` > 0 = replace disk.

## atop — Disk View

```bash
atop
# Press D for disk, then s for sorting
atop -r /var/log/atop/atop_20260513
```

## Mount Options and Performance

```bash
findmnt -o TARGET,OPTIONS /data
mount -o remount,noatime /data
```

`noatime` reduces writes. Check for `barrier=0` (dangerous) on databases.

## Inode Exhaustion

```bash
df -i /
find / -xdev -printf '%h\n' | sort | uniq -c | sort -rn | head -5
```

Common cause: millions of files in `/var/spool/postfix` or session directory.

## What to Remember

- `df -hT` first, then `df -i` — space and inodes are separate
- `du -x` to stay on one filesystem
- `iostat -x 1`: watch %util >80 and await >20ms
- `wa` in vmstat >30% = disk bound, not CPU
- `lsof +L1` solves df/du mismatch
- `iotop -oPa` finds the IO hog process instantly
- Deleted files: restart service or truncate via /proc/<pid>/fd
- Use `ionice -c3` for backups to avoid impact
- Check `smartctl -H` monthly for predictive failures
- NVMe shows as nvme0n1, not sda — use lsblk
