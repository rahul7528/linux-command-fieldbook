# Disk I/O

Production disk usage, I/O saturation, and performance diagnosis. Your disk is the godown where all chai ingredients are stored.

## Chai Tapri Analogy

- **Disk** = big steel dabbas in godown (atta, sugar, tea leaves)
- **RAM** = counter where you actually make chai
- **iowait** = chaiwala standing idle waiting for sugar to arrive from godown
- **%util** = how busy the godown worker is (100% = can't fetch faster)
- **await** = time taken to bring one dabba from shelf
- **IOPS** = number of dabbas fetched per second

## df, du, inodes — Space Usage

```bash
df -hT
df -i
```

**Chai view:** `df` shows how full each godown shelf is. `df -i` shows number of small boxes (inodes). You can have empty shelf space but no empty boxes — still can't store.

```bash
du -hxd1 / | sort -hr | head
```

**Chai view:** Go shelf by shelf, weigh each dabba. `-x` means don't go to other godown.

Real use:
```bash
# Find what's filling root
du -x / -d1 2>/dev/null | sort -rn | head

# Find files bigger than 1GB
find / -xdev -type f -size +1G -exec ls -lh {} \; 2>/dev/null
```

## lsblk, findmnt — Devices

```bash
lsblk -f
lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT,ROTA
```

**Chai view:** `ROTA=1` = old godown with ladder (HDD), slow. `ROTA=0` = modern rack with instant access (SSD/NVMe).

## iostat — Device Utilization

```bash
iostat -x 1 3
```

**Chai view:**
- **%util 95%** = godown worker is running non-stop, can't fetch faster
- **await 80ms** = takes 80ms to bring one dabba (should be <20ms for SSD)
- **avgqu-sz 10** = 10 people waiting at godown door
- **r/s w/s** = dabbas read/written per second

```bash
# Find saturated disk
iostat -x 1 | awk '$NF>80 {print $1, "BUSY:", $NF"%"}'
```

Real use: MySQL slow. `iostat -x` shows nvme0n1 at 99% util, await 120ms = disk is bottleneck, not CPU.

## vmstat — IO Wait Context

```bash
vmstat 1
```

**Chai view:** `wa` column = percentage of chaiwalas standing idle waiting for ingredients. `wa` 40% = 40% of staff doing nothing because godown is slow.

## iotop and pidstat -d — Who is Hammering Disk

```bash
sudo iotop -oPa
pidstat -d 1 5
```

**Chai view:** Instead of blaming godown, find which customer is ordering 100kg sugar at once. `iotop` shows backup script writing 500MB/s.

```bash
# Only show processes doing IO
sudo iotop -o
```

## dstat — Combined View

```bash
dstat -cdngy 1
```

**Chai view:** One screen shows chaiwalas (cpu), godown traffic (disk), customers arriving (net), and water refills (paging).

## sar — Historical IO

```bash
sar -d 1 3
sar -b 1 3
```

**Chai view:** Replay yesterday's footage. See godown was at 100% at 3am during backup.

## /proc/diskstats — Raw Counters

```bash
grep sda /proc/diskstats
```

**Chai view:** Direct counter of how many dabbas moved, how long worker spent fetching.

## lsof +L1 — Deleted Files Holding Space

```bash
lsof +L1
```

**Chai view:** You threw away dabba but someone is still holding it. `df` shows godown full, `du` shows space free. The dabba is in someone's hand, not on shelf.

Fix without restart:
```bash
: > /proc/1234/fd/3
```

**Chai view:** Empty the dabba while person is holding it, instead of snatching it away.

## find — Large and Old Files

```bash
# Largest files
find /var -xdev -type f -printf '%s %p\n' | sort -rn | head -10 | numfmt --to=iec

# Inode hogs
find /var/spool -xdev -printf '%h\n' | sort | uniq -c | sort -rn | head
```

**Chai view:** Find which shelf has thousands of tiny masala packets filling all boxes.

## ionice — IO Priority

```bash
ionice -c3 -p 1234
```

**Chai view:** Class 3 = backup worker waits politely, lets customers go first. Class 2 n0 = VIP customer, gets ingredients immediately.

## fio — Quick Performance Test

```bash
fio --name=test --rw=randread --bs=4k --size=256M --runtime=10 --direct=1 --filename=/tmp/fiotest
```

**Chai view:** Test how fast godown worker can fetch small masala packets (4k random) vs big rice bags (1M sequential). Do this in empty corner (/tmp), never in main godown.

## smartctl — Disk Health

```bash
sudo smartctl -H /dev/sda
sudo smartctl -a /dev/sda | grep -E "Reallocated|Pending"
```

**Chai view:** Check if steel dabbas are rusting. `Reallocated_Sector_Ct` >0 = dabba has holes, replace soon.

## atop — Disk View

```bash
atop
# Press D
```

**Chai view:** Shows which chaiwala is spending most time waiting at godown.

## Mount Options

```bash
findmnt -o TARGET,OPTIONS /data
```

**Chai view:** `noatime` = don't write timestamp every time you touch dabba. Saves trips to godown.

## Inode Exhaustion

```bash
df -i /
```

**Chai view:** Godown has space but you ran out of labels for boxes. Common with millions of session files — like having 10 lakh tiny chai cups but no place to write names.

## What to Remember

- df -h first, then df -i — space and boxes are different
- iostat %util >80 = godown saturated
- await >20ms SSD, >50ms HDD = slow worker
- wa high = chaiwalas waiting, not CPU problem
- lsof +L1 solves mystery full disk
- iotop -o finds who is ordering bulk
- ionice -c3 for backups
- NVMe shows as nvme0n1, check ROTA=0
- Never test fio on production data
