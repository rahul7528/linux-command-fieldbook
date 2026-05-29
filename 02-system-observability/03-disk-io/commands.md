# Disk I/O - Quick Reference<br/><br/>
<br/>
## Space Usage<br/>
df -hT<br/>
df -hT -x tmpfs -x devtmpfs<br/>
df -i<br/>
du -hxd1 / | sort -hr | head<br/>
du -sh /var/*<br/>
ncdu /<br/>
find / -xdev -type f -size +1G -exec ls -lh {} \; 2>/dev/null<br/><br/>
---<br/>
## Devices and Mounts<br/>
lsblk -f<br/>
lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT,ROTA<br/>
findmnt<br/>
findmnt /var<br/>
blkid<br/>
mount | column -t<br/><br/>
---<br/>
## IO Statistics<br/>
iostat -x 1 3<br/>
iostat -xz 1<br/>
iostat -p sda 1<br/>
vmstat 1<br/>
vmstat -d<br/>
dstat -cdngy 1<br/>
dstat --top-io<br/><br/>
---<br/>
## Per-Process IO<br/>
sudo iotop -oPa<br/>
sudo iotop -b -n5<br/>
pidstat -d 1 5<br/>
pidstat -d -p 1234 1<br/>
atop<br/><br/>
---<br/>
## Historical<br/>
sar -d 1 3<br/>
sar -b 1 3<br/>
sar -d -p<br/>
sar -d -f /var/log/sysstat/sa13<br/><br/>
---<br/>
## Deleted Files and Space<br/>
lsof +L1<br/>
lsof +L1 / | awk '$7 > 1048576'<br/>
: > /proc/1234/fd/3<br/><br/>
---<br/>
## Find Large Files<br/>
find /var -xdev -type f -printf '%s %p\n' | sort -rn | head -20<br/>
find / -xdev -atime +90 -ls<br/>
find / -xdev -printf '%h\n' | sort | uniq -c | sort -rn | head<br/><br/>
---<br/>
## IO Priority<br/>
ionice -c3 -p 1234<br/>
ionice -c2 -n0 -p 1234<br/>
ionice -p $$<br/><br/>
---<br/>
## Disk Health<br/>
sudo smartctl -a /dev/sda<br/>
sudo smartctl -H /dev/sda<br/>
sudo smartctl -t short /dev/sda<br/><br/>
---<br/>
## Performance Test<br/>
fio --name=randread --rw=randread --bs=4k --size=256M --runtime=10 --direct=1 --filename=/tmp/fiotest<br/>
fio --name=seqwrite --rw=write --bs=1M --size=512M --direct=1 --filename=/tmp/fiotest2<br/><br/>
---<br/>
## Raw Stats<br/>
cat /proc/diskstats<br/>
grep sda /proc/diskstats<br/>
