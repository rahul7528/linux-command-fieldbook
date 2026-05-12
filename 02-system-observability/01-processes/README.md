# Boot and Systemd

Production control of services, boot sequence, and system state on systemd-based Linux.

## systemctl — Service Control

Core command for interacting with systemd.

### Syntax
```bash
systemctl status <unit>
systemctl start|stop|restart|reload <unit>
systemctl enable|disable <unit>
systemctl is-active|is-enabled <unit>
```

### Common Flags
- `--no-pager`: avoid less, good for scripts
- `--failed`: list only failed units
- `-l`: full output, no truncation
- `-t service`: filter by type
- `--now`: enable and start in one step
- `--user`: operate on user services

### Real-world Examples
```bash
# Check why nginx won't start
systemctl status nginx -l --no-pager

# Enable and start immediately
systemctl enable --now docker

# List all failed services
systemctl --failed

# Show dependencies
systemctl list-dependencies sshd.service

# View unit file location and overrides
systemctl cat nginx.service

# Edit override safely (creates /etc/systemd/system/nginx.service.d/override.conf)
systemctl edit nginx.service

# Check if service is running in script
systemctl is-active --quiet postgresql && echo "up"
```

### Gotchas
- `restart` kills and starts; `reload` keeps PID if supported. Use reload for nginx, haproxy.
- `enable` does not start. Use `--now`.
- Editing unit files directly in /lib/systemd is overwritten on updates. Always use `systemctl edit`.

## journalctl — Centralized Logs

Query systemd journal. Replaces tailing /var/log files.

### Syntax
```bash
journalctl -u <unit> [options]
journalctl -b [boot_id] [options]
```

### Common Flags
- `-f`: follow live
- `-n 100`: last N lines
- `-u <unit>`: filter by service
- `-p <priority>`: 0=emerg to 7=debug, or err, warning, info
- `--since "1 hour ago"`, `--until "2026-05-13 10:00"`
- `-b -1`: previous boot
- `-k`: kernel messages only (like dmesg)
- `-o json-pretty`: structured output
- `_PID=1234`: filter by PID

### Real-world Examples
```bash
# Live tail nginx errors
journalctl -u nginx -p err -f

# Everything from last hour
journalctl --since "1 hour ago" --no-pager

# Previous boot crash investigation
journalctl -b -1 -p err

# Kernel ring buffer since boot
journalctl -k -b

# Service failures with context
journalctl -u docker.service --since today -o cat

# Combine units
journalctl -u nginx -u php-fpm -f

# Disk usage and cleanup
journalctl --disk-usage
sudo journalctl --vacuum-time=7d
sudo journalctl --vacuum-size=500M
```

### Gotchas
- Journal is binary; use `journalctl`, not grep on files.
- Persistent storage requires /var/log/journal. Otherwise logs lost on reboot.
- Time filters accept natural language but use UTC if TZ not set.

## systemd-analyze — Boot Performance

Find slow boot components.

```bash
# Total boot time
systemd-analyze

# Slowest units
systemd-analyze blame

# Critical path
systemd-analyze critical-chain

# Generate SVG plot
systemd-analyze plot > /tmp/boot.svg

# Check unit file security
systemd-analyze security sshd.service
```

Real use: server takes 3 minutes to boot. Run `blame`, find `networkd-wait-online.service` at 90s, mask it if not needed.

## hostnamectl / timedatectl — Identity and Time

```bash
# Set hostname permanently
hostnamectl set-hostname prod-web-01

# Check time sync
timedatectl status

# Enable NTP
timedatectl set-ntp true

# Set timezone
timedatectl set-timezone Asia/Kolkata

# List timezones
timedatectl list-timezones | grep Kolkata
```

Gotcha: changing timezone does not change hardware clock. Use UTC on servers.

## uptime, who, last, w — User and Boot State

```bash
# Load and uptime
uptime -p

# Who is logged in and what they're doing
w

# Last reboots and logins
last reboot
last -x shutdown

# Failed logins
lastb
```

## dmesg — Kernel Messages

```bash
# Human readable timestamps
dmesg -T

# Follow new messages
dmesg -w

# Errors only
dmesg -l err,warn

# Since last boot with journalctl preferred
journalctl -k -b
```

Use for hardware errors, OOM kills, filesystem corruption.

## shutdown / reboot — Safe Restarts

```bash
# Schedule reboot in 5 minutes with message
sudo shutdown -r +5 "Kernel update"

# Cancel
sudo shutdown -c

# Immediate reboot
sudo systemctl reboot

# Poweroff
sudo systemctl poweroff
```

Safety: always use `shutdown -r +1` on remote systems to allow cancel. Never `reboot -f` unless hung.

## Targets — Runlevels

```bash
# Current target
systemctl get-default

# List targets
systemctl list-units --type=target

# Switch to rescue (single-user)
sudo systemctl isolate rescue.target

# Set default to multi-user (no GUI)
sudo systemctl set-default multi-user.target
```

## What to Remember

- systemctl status -l is first debug step for any service
- journalctl -u <service> -f replaces tail -f
- Always use `enable --now` to avoid forgetting to start
- Use `journalctl -b -1` for previous boot, not guessing log files
- `systemd-analyze blame` finds boot slowness in seconds
- Never edit /lib/systemd directly; use `systemctl edit`
- For remote reboots, schedule with shutdown, not immediate reboot
