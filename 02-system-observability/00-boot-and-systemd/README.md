## 00 - Boot and systemd

> Understand how Linux starts, and control every service that runs.

## Boot Process - 4 Stages

1. **BIOS/UEFI** → firmware, finds boot device
2. **Bootloader (GRUB)** → loads kernel
3. **Kernel** → mounts root, starts init
4. **systemd (PID 1)** → starts everything else

systemd replaced SysV init. It starts services in parallel and tracks them.

---

## 1. `systemctl` - Control Services

### Check status
```bash
systemctl status sshd
systemctl status nginx
systemctl is-active sshd
```

### Start, stop, restart
```bash
sudo systemctl start nginx
sudo systemctl stop nginx
sudo systemctl restart nginx
sudo systemctl reload nginx    # reload config without restart
```

### Enable at boot
```bash
sudo systemctl enable nginx     # start on boot
sudo systemctl disable nginx    # don't start on boot
sudo systemctl is-enabled nginx
```

### List services
```bash
systemctl list-units --type=service
systemctl list-units --type=service --state=running
systemctl list-units --type=service --state=failed
```

---

## 2. Boot Analysis

### How long did boot take?
```bash
systemd-analyze
```
Output: kernel + userspace time

### What slowed boot?
```bash
systemd-analyze blame
```
Shows each service time, slowest first

### Critical path
```bash
systemd-analyze critical-chain
```
Shows what blocked boot

### Visual boot chart
```bash
systemd-analyze plot > boot.svg
```
Open SVG to see timeline

---

## 3. Targets - Like Runlevels

```bash
systemctl get-default           # graphical.target or multi-user.target
systemctl set-default multi-user.target   # boot to console
systemctl set-default graphical.target   # boot to GUI

systemctl isolate rescue.target # switch to rescue now
```

Common targets:
- `poweroff.target`
- `rescue.target` (single user)
- `multi-user.target` (console)
- `graphical.target` (GUI)

---

## 4. `journalctl` - System Logs

systemd logs everything here.

### Current boot logs
```bash
journalctl -b
```

### Follow live
```bash
journalctl -f
```

### Service logs
```bash
journalctl -u nginx
journalctl -u nginx -f
journalctl -u sshd --since "1 hour ago"
```

### By priority
```bash
journalctl -p err               # errors only
journalctl -p warning..err      # warning to error
```

### Last boot failure
```bash
journalctl -b -1 -p err
```

### Time range
```bash
journalctl --since "2024-05-10 09:00" --until "2024-05-10 10:00"
journalctl --since yesterday
```

### Disk usage
```bash
journalctl --disk-usage
sudo journalctl --vacuum-size=100M
```

---

## 5. Service Management

### Mask (prevent start completely)
```bash
sudo systemctl mask nginx
sudo systemctl unmask nginx
```

### Edit service
```bash
sudo systemctl edit nginx       # override
sudo systemctl daemon-reload    # after editing
```

### Show config
```bash
systemctl cat nginx
systemctl show nginx
```

---

## 6. Troubleshooting Boot

**Service failed:**
```bash
systemctl --failed
systemctl status <service>
journalctl -u <service> -b
```

**Slow boot:**
```bash
systemd-analyze blame | head -10
```

**Boot into rescue:**
At GRUB → press e → add `systemd.unit=rescue.target` to kernel line → Ctrl+X

**Check dependencies:**
```bash
systemctl list-dependencies nginx
```

---

## 7. Creating a Simple Service

`/etc/systemd/system/myapp.service`:
```ini
[Unit]
Description=My App
After=network.target

[Service]
ExecStart=/usr/local/bin/myapp
Restart=always
User=appuser

[Install]
WantedBy=multi-user.target
```

Then:
```bash
sudo systemctl daemon-reload
sudo systemctl enable myapp
sudo systemctl start myapp
```

---

## Real Examples

**Restart failed services:**
```bash
systemctl --failed
sudo systemctl restart nginx
```

**Check why server slow to boot:**
```bash
systemd-analyze blame | head
```

**Watch SSH logins live:**
```bash
journalctl -u sshd -f
```

**Clean old logs:**
```bash
sudo journalctl --vacuum-time=7d
```

**Disable GUI on server:**
```bash
sudo systemctl set-default multi-user.target
```

---

## What to Remember

- systemd is PID 1, controls everything
- systemctl status/start/stop/enable/disable
- systemd-analyze blame finds slow boot
- journalctl -u <service> -b for logs
- Targets replace runlevels
- enable = start on boot, start = now
- Always check journalctl when service fails
