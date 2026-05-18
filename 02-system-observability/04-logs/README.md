# Logs

Production log reading, following, searching, and rotation. Your logs are the tapri's complaint register — every mistake is written down.

## Chai Tapri Analogy

- **/var/log** = big register book on counter
- **tail -f** = standing at counter watching new orders come in live
- **grep** = flipping pages to find all "cold chai" complaints
- **journalctl** = digital register that records everything automatically
- **logrotate** = at night, you move old pages to godown, start fresh book
- **dmesg** = kitchen equipment error log (stove overheating)

## tail, head, less — Basic Reading

### tail
```bash
tail -n 100 /var/log/nginx/error.log
tail -f /var/log/syslog
tail -F /var/log/app.log    # follows even if rotated
```

**Chai view:** `tail -f` = you stand at register, watch waiter write new complaints in real-time. Don't walk away.

Flags: `-n` lines, `-f` follow, `-F` follow name, `+100` start at line 100.

### head
```bash
head -n 20 /var/log/auth.log
```

**Chai view:** Read first page of new register to see when shop opened.

### less
```bash
less /var/log/syslog
# Inside less: /error to search, n next, N prev, G end, g start, F follow mode
```

**Chai view:** less is like reading register with ability to flip back and forth. `F` turns it into live watch.

Real use:
```bash
# Follow multiple logs
tail -f /var/log/nginx/*.log

# Last 500 lines and follow
tail -n 500 -f /var/log/syslog
```

## grep, rg, zgrep — Searching

### grep
```bash
grep -i "error" /var/log/syslog
grep -r "OutOfMemory" /var/log/
grep -A5 -B5 "panic" /var/log/kern.log
```

**Chai view:** `grep "cold"` = find every time customer complained chai was cold. `-A5` shows 5 lines after — what waiter did next.

Flags: `-i` ignore case, `-r` recursive, `-A` after, `-B` before, `-C` context, `-v` invert, `-E` regex, `--color`.

### ripgrep (rg) — faster
```bash
rg "500 Internal" /var/log/nginx/
rg -t log "timeout" /var/log
```

**Chai view:** rg is like having assistant who knows exactly which page to flip.

### Compressed logs
```bash
zgrep "error" /var/log/syslog.1.gz
zcat /var/log/nginx/access.log.*.gz | grep " 500 "
```

**Chai view:** Old registers kept in plastic wrap (gz). zgrep reads without unwrapping fully.

## journalctl — Systemd Logs

```bash
journalctl -u nginx -f
journalctl --since "30 minutes ago" -p err
journalctl -b -1 -p err
journalctl -k -f
```

**Chai view:** Digital register that never loses pages. `-u nginx` = filter only chai counter complaints, not kitchen.

Key filters:
```bash
journalctl -u nginx --since today
journalctl _PID=1234
journalctl -p 0..3    # emerg to err
journalctl -o json-pretty | jq
```

Real use: app crashed at 2am. `journalctl -u myapp --since "02:00" --until "02:05"` shows exact error.

## awk, sed — Parsing Logs

```bash
# Top 10 IPs in nginx access log
awk '{print $1}' /var/log/nginx/access.log | sort | uniq -c | sort -rn | head

# Extract 5xx errors
awk '$9 >= 500' /var/log/nginx/access.log

# Get timestamp and message
awk '{print $1,$2,$3,$NF}' /var/log/syslog
```

**Chai view:** awk = you have register with columns: time, table, complaint. awk picks just table number and complaint.

```bash
# Replace IP with anonymized
sed 's/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/X.X.X.X/g' access.log
```

## multitail — Multiple Logs

```bash
multitail /var/log/nginx/error.log /var/log/syslog
multitail -s 2 -f /var/log/*.log
```

**Chai view:** Watch two registers side by side — counter complaints and kitchen errors at same time.

## logrotate — Managing Size

```bash
cat /etc/logrotate.d/nginx
logrotate -d /etc/logrotate.conf    # debug, dry run
logrotate -f /etc/logrotate.d/nginx # force rotate
```

**Chai view:** Every night at 12, you take full register, put in godown with date stamp, start fresh page. Keeps counter clean.

Config example:
```
/var/log/nginx/*.log {
    daily
    rotate 14
    compress
    missingok
    notifempty
    postrotate
        systemctl reload nginx
    endscript
}
```

Real use: disk full because logs not rotating. Check `logrotate -d`, fix permissions.

## logger — Write to Syslog

```bash
logger "Backup started"
logger -t myapp -p local0.err "Database connection failed"
```

**Chai view:** You write your own entry in register: "12:30 — started cleaning". Later you can grep for it.

## watch — Polling Logs

```bash
watch -n1 'tail -n 20 /var/log/syslog | grep error'
watch -d 'wc -l /var/log/nginx/access.log'
```

**Chai view:** Instead of staring at register, you ask assistant to check every second and shout if new complaint appears.

## dmesg and Kernel Logs

```bash
dmesg -T | tail
dmesg -w
journalctl -k -p err
```

**Chai view:** Kitchen equipment log. Stove overheating, gas low, fridge door open.

## Real-world Scenarios

**Scenario 1: App returning 500**
```bash
tail -f /var/log/nginx/error.log | grep -i php
journalctl -u php-fpm -f
```
**Chai view:** Watch counter register for "bad chai" complaints while watching kitchen register for stove errors.

**Scenario 2: Disk filling fast**
```bash
watch -n5 'du -sh /var/log/* | sort -hr | head'
lsof +L1 /var/log
```
**Chai view:** Register book growing too fast. Find which waiter is writing too much.

**Scenario 3: Find when service restarted**
```bash
journalctl -u nginx --since "today" | grep -i "starting\|stopping"
grep "systemd.*Started" /var/log/syslog
```

**Scenario 4: Correlate across logs**
```bash
# Same timestamp in nginx and app
grep "14:32:15" /var/log/nginx/error.log
journalctl --since "14:32:10" --until "14:32:20"
```

## Log Locations

```bash
/var/log/syslog        # general system
/var/log/auth.log      # SSH logins
/var/log/kern.log      # kernel
/var/log/nginx/        # web server
/var/log/mysql/        # database
journalctl             # everything systemd
```

**Chai view:** Different registers for different counters — main counter, kitchen, cash, delivery.

## What to Remember

- `tail -F` not `-f` for logs that rotate
- `journalctl -f -u` replaces tail for systemd services
- `grep -C5` gives context, not just match
- `zgrep` for compressed old logs
- `less +F` = tail -f but with scrollback
- logrotate keeps disk from filling — check it monthly
- Use `logger` to add your own markers in logs
- Correlate timestamps across multiple logs
- `awk '{print $1}'` extracts IPs fast
- Never `cat` huge log, use `less` or `tail`
