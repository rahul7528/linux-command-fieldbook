# 00 - Boot and systemd - Command Reference

---

## systemctl basics
`systemctl status nginx` → status
`systemctl start nginx` → start now
`systemctl stop nginx` → stop
`systemctl restart nginx` → restart
`systemctl reload nginx` → reload config
`systemctl is-active nginx` → check running

---

## Enable at boot
`systemctl enable nginx`
`systemctl disable nginx`
`systemctl is-enabled nginx`
`systemctl reenable nginx`

---

## List units
`systemctl list-units --type=service`
`systemctl list-units --state=failed`
`systemctl --failed`

---

## Boot analysis
`systemd-analyze` → total time
`systemd-analyze blame` → slowest services
`systemd-analyze critical-chain` → blocking chain
`systemd-analyze plot > boot.svg` → visual

---

## Targets
`systemctl get-default`
`systemctl set-default multi-user.target`
`systemctl set-default graphical.target`
`systemctl isolate rescue.target`

---

## journalctl
`journalctl -b` → this boot
`journalctl -b -1` → previous boot
`journalctl -f` → follow
`journalctl -u nginx` → service logs
`journalctl -u nginx --since "1h ago"`
`journalctl -p err` → errors only
`journalctl --since yesterday`
`journalctl --disk-usage`

---

## Service management
`systemctl mask nginx` → prevent start
`systemctl unmask nginx`
`systemctl cat nginx` → show file
`systemctl edit nginx` → override
`systemctl daemon-reload` → reload units
`systemctl list-dependencies nginx`

---

## Cleanup
`journalctl --vacuum-size=100M`
`journalctl --vacuum-time=7d`
