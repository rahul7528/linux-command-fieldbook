# Disk I/O - Quick Reference

## Space Usage
df -hT
df -hT -x tmpfs -x devtmpfs
df -i
du -hxd1 / | sort -hr | head
du -sh /var/*
ncdu /
find / -xdev -type f -size +1G -exec ls -lh {} \; 2>/dev/null
---
## Devices and Mounts
lsblk -f
lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT,ROTA
findmnt
findmnt /var
blkid
mount | column -t
---
## IO Statistics
iostat -x 1 3
iostat -xz 1
iostat -p sda 1
vmstat 1
vmstat -d
dstat -cdngy 1
dstat --top-io
---
## Per-Process IO
sudo iotop -oPa
sudo iotop -b -n5
pidstat -d 1 5
pidstat -d -p 1234 1
atop
---
## Historical
sar -d 1 3
sar -b 1 3
sar -d -p
sar -d -f /var/log/sysstat/sa13
---
## Deleted Files and Space
lsof +L1
lsof +L1 / | awk '$7 > 1048576'
: > /proc/1234/fd/3
---
## Find Large Files
find /var -xdev -type f -printf '%s %p\n' | sort -rn | head -20
find / -xdev -atime +90 -ls
find / -xdev -printf '%h\n' | sort | uniq -c | sort -rn | head
---
## IO Priority
ionice -c3 -p 1234
ionice -c2 -n0 -p 1234
ionice -p $$
---
## Disk Health
sudo smartctl -a /dev/sda
sudo smartctl -H /dev/sda
sudo smartctl -t short /dev/sda
---
## Performance Test
fio --name=randread --rw=randread --bs=4k --size=256M --runtime=10 --direct=1 --filename=/tmp/fiotest
fio --name=seqwrite --rw=write --bs=1M --size=512M --direct=1 --filename=/tmp/fiotest2
---
## Raw Stats
cat /proc/diskstats
grep sda /proc/diskstats
