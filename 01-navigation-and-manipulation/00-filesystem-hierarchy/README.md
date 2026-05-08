# 00 - Filesystem Hierarchy

> Linux has no C: drive. It has one tree that starts at `/`. Learn it once, never get lost again.

## Start With What You Know

Every project you build looks like this:

project/

├── config/ # where settings live

├── logs/ # where errors are written

├── scripts/ # tools you run

├── backups/ # copies you keep

├── data/ # database and uploads

└── src/ # your actual code


You already separate things by purpose. Linux does the exact same thing for the whole computer.

## Linux Uses The Same Idea

| Your Project | Linux System | Real Path | Why |
|---|---|---|---|
| config/ | System settings | /etc | All apps read settings from here |
| logs/ | System logs | /var/log | Every error is written here |
| scripts/ | Basic commands | /bin, /usr/bin | ls, cp, mv live here |
| data/ | Growing data | /var | Websites and databases grow here |
| your code | Your files | /home | Your personal workspace |


## The 15 Folders Explained

### 1. `/` - The Root
This is the very top. Everything is inside it.
- Try: `ls /` - this lists the top folders, like opening C:\

### 2. `/home` - Your Workspace
This is where YOU work. Each user gets their own folder.
- Try: `cd /home/rahul` then `pwd` - shows where you are
- Like your Documents folder in Windows

### 3. `/root` - Admin's Home
Only for the root superuser. You should not work here.
- Try: `sudo ls /root` - needs admin rights

### 4. `/bin` and `/usr/bin` - Everyday Commands
This is where programs like ls, cat, cp live.
- Try: `which ls` - shows the full path: /usr/bin/ls
- Why it matters: if this folder breaks, no commands work

### 5. `/sbin` and `/usr/sbin` - Admin Commands
Tools for managing the system: reboot, fdisk.
- Try: `which reboot`
- You need sudo to run most of these

### 6. `/etc` - The Config Folder
Every setting for every program is a text file here.
- Try: `ls /etc` - you will see hundreds of config files
- Try: `cat /etc/hostname` - shows your computer name
- Why it matters: change a file here, you change how Linux behaves

### 7. `/var` - Data That Grows
Websites, databases, caches. This folder gets bigger over time.
- Try: `ls /var`

### 8. `/var/log` - The Log Folder
This is the black box recorder. Every app writes what happened here.
- Try: `ls /var/log` - see all log files
- Try: `tail /var/log/syslog` - shows last 10 lines of system log
- Why it matters: when something breaks, the answer is here

### 9. `/tmp` - Temporary Storage
Files here are deleted when you reboot. Good for quick tests.
- Try: `touch /tmp/mytest.txt` then reboot - file will be gone
- Never keep important work here

### 10. `/usr/local` - Your Own Programs
When you compile software yourself, it goes here. Safe from system updates.
- Try: `ls /usr/local/bin`

### 11. `/opt` - Big Applications
Large apps like Google Chrome or Slack install here.
- Try: `ls /opt`

### 12. `/dev` - Devices
Linux treats hardware as files. Your hard disk is /dev/sda.
- Try: `lsblk` - lists all disks in a readable way
- Try: `ls /dev/sda*` - shows disk partitions

### 13. `/proc` and `/sys` - Live System Info
These are not real folders on disk. They show what the kernel is doing right now.
- Try: `cat /proc/cpuinfo` - shows your CPU details
- Try: `cat /proc/meminfo` - shows memory usage
- Why it matters: you can read system status without any special tool

### 14. `/mnt` and `/media` - Where You Plug Things In
USB drives and extra hard disks appear here after you mount them.
- Try: `ls /media` - see plugged USB drives

### 15. `/lib` - Shared Code
Libraries that programs need to run. Like DLL files in Windows.
- Try: `ls /lib` - do not delete anything here


## Three Ways to Explore

**1. Simple list**
`ls /` shows the top level folders. This is like opening This PC in Windows. You see the names only.

**2. Tree view**
`tree` draws folders like a family tree so you can see the structure. It is much easier to understand than a flat list.
- Install: `sudo apt install tree`
- Try: `tree -L 1 /` - the -L 1 means show only 1 level deep

**3. Search for files**
`find` searches for files by name, like Windows search but works in terminal.
- Try: `find /etc -name "*.conf"` - finds all config files in /etc
- The `| head` at the end just shows first 10 results so screen does not flood


## Real Problems You Will Face

**Problem 1: App won't start**
When Nginx or any app fails, it writes the reason to a log file. You read that file to know why.
- `tail -f /var/log/nginx/error.log`
- `tail` shows end of file. `-f` means follow, it stays open and shows new lines live. This is how you watch errors as they happen.


**Problem 2: Disk is full**
Servers stop working when disk reaches 100 percent. You need to find what is using space.
- `df -h` - df means disk free. -h means human readable (shows GB not bytes). This shows how full each disk is.
- `du -sh /var/*` - du means disk usage. -s means summary. -h means human. This shows size of each folder in /var.
- `| sort -hr` sorts biggest first so you find the culprit fast.



**Problem 3: Where is the setting?**
All settings are in /etc. If you want to change SSH port, you edit the SSH config.
- `cat /etc/ssh/sshd_config` - cat shows the file contents
- This file controls how SSH works



## What to Remember

- Your work goes in /home
- Settings go in /etc
- Logs go in /var/log
- Temporary files go in /tmp
- Programs go in /usr/bin

Learn these five and you can work on any Linux server.

---
Next: 01-pwd-cd-ls - how to move around these folders
