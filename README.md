# Linux Command Fieldbook

> The operating system underneath everything. Learn to move without a mouse.

This repo is not a list of commands. It's a map of **how to operate a Linux machine** — from creating a folder to debugging why production is down at 2am.

---

## What is Linux?

Before Windows had a Start menu (1995) or Mac had a Dock, computers were just a black screen and a shell.

- **1969:** UNIX invented the idea: "everything is a file, everything is a command"
- **1991:** Linus Torvalds rebuilt it as **Linux** — a free kernel that talks directly to hardware
- **Today:** Linux runs your phone (Android), your cloud (AWS), your router, your car. Windows runs desktops. Linux runs the world.

**How it works:**
`You → Terminal → Shell (bash/zsh) → Kernel → CPU/Disk/Network`

Windows hides this behind Explorer. Linux gives you the steering wheel.


## Shell vs Bash

| | What it is |
|---|---|
| **Terminal** | The window (iTerm, GNOME Terminal) |
| **Shell** | The interpreter — any language that runs commands |
| **Bash** | The most common shell on servers. `bash` = Bourne Again SHell |

All bash commands are shell commands, but not all shells are bash.

## Why use commands when Windows exists?

Because production servers don't have a mouse.

1. **Speed:** `mkdir -p app/{logs,src,config}` = 3 folders in 0.1s
2. **Scale:** You can't right-click on 50 servers. You `ssh` and run a script.
3. **Repeatable:** Commands go in Git. Clicks don't.
4. **Visibility:** `ls -l` shows permissions, owner, size. Properties window hides it.


## Linux Architecture — Explained Like a Human Body

Linux works in 5 layers, from bottom to top. Think of your computer like a person:


HARDWARE ← The body (CPU, RAM, Disk, Keyboard)
↓
KERNEL ← The brain (Linux)
↓
SYSTEM LIBRARIES ← Common tools (toolbox)
↓
SHELL ← Your voice (bash)
↓
USER APPS ← What you use (Chrome, VS Code, ls, nginx)


### 1. HARDWARE — The Body
The physical stuff. CPU, RAM, hard disk. Does nothing alone — like a body without a brain.
**Example:** Your hard disk is a cupboard. It can't open itself.

### 2. KERNEL — The Brain
The Linux program that controls everything. Decides who uses CPU, gives memory, reads/writes disk, sends network.
**Example:** When you save a file, the kernel is the one who actually writes 1s and 0s to disk.

### 3. SYSTEM LIBRARIES — The Toolbox
Ready-made tools (main one is `glibc`). So apps don't have to learn brain-language.
**Example:** Every app uses `open()` to open files — like using the same screwdriver instead of making your own.

### 4. SHELL — Your Voice
`bash` — the black screen where you type. Translates your words into instructions.
**Example:** You type `mkdir photos`. Shell hears it and passes it up.

### 5. USER APPLICATIONS — Your Hands
Programs you run — `ls`, `chrome`, `python`. They do the actual work.
**Example:** `ls` just asks "show me files".

**Memory trick:** Hardware → Brain → Nerves → Voice → Hands


---


## THE 4 PILLARS — How this repo is organized

### 1. Navigation-and-Manipulation
**Everything about moving around the system without a mouse.**

Goal: Never get lost in the filesystem.

You'll learn:
- **Core navigation:** `pwd`, `cd`, `ls`, `ll`, `tree`, `pushd`/`popd`, `dirs`, `realpath`, `readlink` — plus absolute vs relative paths (`/var/log` vs `../logs` vs `~/projects`)
- **Files & folders:** `mkdir`, `rmdir`, `touch`, `rm -rf`, `cp`, `mv`, `ln` (hard/soft links), `unlink`, `stat`, `file`, `basename`, `dirname` — plus brace expansion `touch file_{1..100}.log` and loops
- **Search & find:** `find`, `locate`/`updatedb`, `which`, `whereis`, `type`, `grep`, `egrep`, `rg`, `ack`, `xargs`
- **Shell fundamentals:** `> >> < 2> &> | tee`, `; && || &`, `* ? [] {} ~ $`, `history`, `alias`, `export`, `env`, variables `$HOME $PATH`, why `rm -rf /` is nuclear

**Real scenario:** You SSH into a fresh EC2. In 60 seconds you build the full app structure without touching a GUI.

> CLI vs GUI: Right-click → New Folder vs `mkdir -p project/{src,tests}`

### 2. System-Observability
**Everything related to `top`, `df`, `free`, `tail -f`, `dmesg`**

Goal: Understanding why the application is crashing or slow.

You'll learn:
- **Process view:** `ps`, `pgrep`, `pkill`, `pidof`, `top`, `htop`, `atop`, `uptime`, `w`, `who`
- **Resources:** `free`, `vmstat`, `mpstat`, `df -h`, `du -sh`, `ncdu`, `lsblk`, `iostat`, `sar`
- **Live logs & services:** `tail -f`, `head`, `less`, `journalctl`, `dmesg`, `systemctl status`, `watch`
- **Deep debug:** `lsof`, `lsof -i :8080`, `fuser`, `strace`, `ltrace`, `timeout`

**Real scenario:** App is slow. You run `top` → see 1 process at 400% CPU, `df -h` → disk at 100%, `tail -f` → logs filling disk. Fix in 3 commands.

### 3. Networking-and-Security
**Securing the blast radius and ensuring services can talk to each other.**

Goal: Connect to machines, move files, lock them down.

You'll learn:
- **Networking basics:** `ip a`, `hostname`, `ping`, `traceroute`, `mtr`, `ss -tulnp`, `netstat`, `curl`, `wget`, `dig`, `nslookup`, `host`, `nc`
- **Remote access:** `ssh`, `ssh-keygen`, `scp`, `sftp`, `rsync`
- **Users & permissions:** `id`, `whoami`, `groups`, `su`, `sudo`, `passwd`, `chmod`, `chown`, `chgrp`, `umask`, `getfacl`, `setfacl`, `lsattr`, `chattr`
- **Firewall & packages:** `ufw`, `iptables`, `nft`, `apt`, `yum`/`dnf`, `systemctl`

**Real scenario:** You can't reach the API. `ss -tulnp` shows nothing on port 8080, `curl localhost:8080` fails, `chmod +x` fixes the startup script.

### 4. Automation
**Never doing the same task twice.**

Goal: Turn commands into systems.

You'll learn:
- **Bash basics:** `echo`, `printf`, `read`, `test`, `[ ]`, `[[ ]]`, `if`, `for`, `while`, `case`, `functions`
- **Scripting power:** `set -e`, `$?`, `$0 $1`, `source`, `.`, exit codes, error handling, logging
- **Scheduling:** `crontab -e`, `at`, `systemd timers`, `systemctl enable`
- **Environment:** `export`, `env`, `printenv`, `$PATH`, `.bashrc`, `.profile`, `alias`, `unalias`

**Real scenario:** Instead of manually compressing logs daily, you write a 10-line script + cron that rotates, gzips, and uploads to S3 every night.


## How to read a command

Open any folder — every lesson follows the same 4-part structure inside.


---
⭐ **If this helped you understand Linux better than a 2-hour video, star the repo.** It helps others find it.

Built by [@rahul7528](https://github.com/rahul7528) — learning in public.
