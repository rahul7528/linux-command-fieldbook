# 00 - Filesystem Hierarchy - Complete Command Reference book

This is your master cheat sheet. Every command from the README, what it does, what output looks like, and what to say if someone asks.

---

## 1. ls /
**Purpose:** List the top-level folders.
**What it does:** Shows everything directly under root.
**Typical output:**
```
bin  boot  dev  etc  home  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
```
**Explain:** These are the 15 folders from the lesson. If someone asks "where is etc", point here.

---

## 2. cd /home/$USER && pwd
**Purpose:** Go to your home and confirm location.
**What it does:** cd changes directory, pwd prints working directory.
**Typical output:**
```
/home/rahul
```
**Explain:** $USER is your username. pwd always tells you where you are. This is your safe workspace.

---

## 3. sudo ls /root
**Purpose:** Peek into admin's home.
**What it does:** Lists files in /root, needs sudo.
**Typical output:**
```
snap
```
or permission denied without sudo.
**Explain:** /root is not for normal users. You need sudo because only root can read it.

---

## 4. which ls
**Purpose:** Find where a command lives.
**What it does:** Shows full path of executable.
**Typical output:**
```
/usr/bin/ls
```
**Explain:** Every command is a file. which tells you which file runs when you type ls.

---

## 5. which reboot
**Purpose:** Find admin command location.
**Typical output:**
```
/usr/sbin/reboot
```
**Explain:** It's in sbin, not bin, because only admin should reboot.

---

## 6. ls /etc | head -20
**Purpose:** See config files.
**Typical output:**
```
adduser.conf
apache2
apt
bash.bashrc
cron.d
hostname
hosts
nginx
passwd
ssh
```
**Explain:** /etc has hundreds of text files. Each folder like nginx or ssh contains settings. head limits output.

---

## 7. cat /etc/hostname
**Purpose:** Show computer name.
**Typical output:**
```
ubuntu-server
```
**Explain:** cat prints file contents. Hostname is set here.

---

## 8. ls /var
**Purpose:** See data folders.
**Typical output:**
```
cache  lib  log  mail  spool  tmp  www
```
**Explain:** /var grows. log is inside here, www is where websites live.

---

## 9. ls /var/log | head -15
**Purpose:** List log files.
**Typical output:**
```
auth.log
kern.log
syslog
nginx
apt
```
**Explain:** Every app writes here. auth.log is logins, syslog is system events.

---

## 10. tail -n 5 /var/log/syslog
**Purpose:** See recent system events.
**Typical output:**
```
May 9 10:23:01 server CRON[1234]: (root) CMD (command)
May 9 10:23:15 server systemd[1]: Started Session
```
**Explain:** tail shows end of file. -n 5 means last 5 lines. This is how you debug.

---

## 11. touch /tmp/mytest.txt && ls -l /tmp/mytest.txt
**Purpose:** Create temporary file.
**Typical output:**
```
-rw-r--r-- 1 rahul rahul 0 May 9 10:25 /tmp/mytest.txt
```
**Explain:** touch creates empty file. /tmp is cleared on reboot. Good for tests, bad for storage.

---

## 12. ls /usr/local/bin
**Purpose:** See your custom programs.
**Typical output:**
```
(empty) or mytool
```
**Explain:** Software you compile yourself goes here. Safe from system updates.

---

## 13. ls /opt
**Purpose:** See big third-party apps.
**Typical output:**
```
google  slack
```
**Explain:** Chrome, Slack, JetBrains install here. Each app gets its own folder.

---

## 14. lsblk
**Purpose:** List block devices.
**Typical output:**
```
NAME   MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
sda      8:0    0  50G  0 disk
├─sda1   8:1    0   1G  0 part /boot
└─sda2   8:2    0  49G  0 part /
```
**Explain:** Shows disks and partitions. sda is first disk, sda1 and sda2 are partitions. MOUNTPOINT shows where it's mounted.

---

## 15. ls /dev/sd* or /dev/nvme*
**Purpose:** Show disk device files.
**Typical output:**
```
/dev/sda  /dev/sda1  /dev/sda2
```
**Explain:** Linux treats hardware as files. /dev/sda is the whole disk.

---

## 16. cat /proc/cpuinfo | head -15
**Purpose:** See CPU details.
**Typical output:**
```
processor   : 0
vendor_id   : GenuineIntel
model name  : Intel(R) Xeon CPU
cpu cores   : 2
```
**Explain:** /proc is not real files, it's live kernel info. cpuinfo shows each core.

---

## 17. cat /proc/meminfo | head -10
**Purpose:** See memory usage.
**Typical output:**
```
MemTotal:       4020200 kB
MemFree:        1234567 kB
MemAvailable:   2345678 kB
```
**Explain:** Shows RAM in kilobytes. MemAvailable is what you can actually use.

---

## 18. ls /media
**Purpose:** See mounted USB drives.
**Typical output:**
```
rahul  (then inside: USB_DRIVE)
```
**Explain:** When you plug USB, Ubuntu auto-mounts here.

---

## 19. ls /lib | head -15
**Purpose:** See shared libraries.
**Typical output:**
```
modules  x86_64-linux-gnu
```
**Explain:** Like DLLs in Windows. Programs share code from here. Never delete.

---

## 20. sudo apt install tree -y
**Purpose:** Install tree command.
**Typical output:**
```
Reading package lists... Done
Unpacking tree...
```
**Explain:** tree is not installed by default on Ubuntu. This installs it.

---

## 21. tree -L 1 /
**Purpose:** Show folder structure as tree.
**Typical output:**
```
/
├── bin -> usr/bin
├── boot
├── dev
├── etc
├── home
...
```
**Explain:** -L 1 means only 1 level deep. Much easier to visualize than ls.

---

## 22. find /etc -name "*.conf" | head -10
**Purpose:** Search for config files.
**Typical output:**
```
/etc/adduser.conf
/etc/ca-certificates.conf
/etc/host.conf
```
**Explain:** find searches recursively. -name filters by pattern. Use this to locate settings.

---

## 23. tail -f /var/log/syslog
**Purpose:** Follow log live.
**What happens:** Terminal stays open, new lines appear as they are written.
**Explain:** -f means follow. Press Ctrl+C to stop. This is how you watch errors in real time during app restart.

---

## 24. df -h
**Purpose:** Check disk space.
**Typical output:**
```
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda2        49G   12G   35G  26% /
tmpfs           2.0G     0  2.0G   0% /dev/shm
```
**Explain:** df = disk free. -h = human readable. Use% at 100% means server will crash. Check / first.

---

## 25-26. sudo du -sh /var/* | sort -hr | head -10
**Purpose:** Find what's using space in /var.
**Typical output:**
```
3.2G    /var/lib
1.1G    /var/log
450M    /var/cache
```
**Explain:** du = disk usage, -s = summary, -h = human. sort -hr sorts biggest first. This finds the culprit when disk is full.

---

## 27. cat /etc/ssh/sshd_config | head -20
**Purpose:** View SSH server settings.
**Typical output:**
```
# Port 22
# PermitRootLogin prohibit-password
PasswordAuthentication yes
```
**Explain:** This file controls SSH. Change Port here to change SSH port. Always backup before editing.

---

## Quick Answers for Common Questions

**Q: Why is everything a file?**
A: Because /dev/sda, /proc/cpuinfo are files you can read with cat. Makes scripting easy.

**Q: Where do I put my project?**
A: /home/rahul/projects, never in /tmp or /root.

**Q: App crashed, where to look?**
A: cd /var/log then tail -f the app's log.

**Q: Disk full, what first?**
A: Run df -h, then du -sh /* to find big folder.

**Q: Difference between /bin and /usr/bin?**
A: Historically separate, now on modern Ubuntu /bin is symlink to /usr/bin. Both work.

Keep this file next to your README. If someone asks in 6 months, you have exact output and explanation ready.
