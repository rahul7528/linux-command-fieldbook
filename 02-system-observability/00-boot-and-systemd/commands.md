# 00 - Boot and systemd - Command Reference<br><br>
<br>
---<br>
<br>
## systemctl basics<br>
`systemctl status nginx` → status<br>
`systemctl start nginx` → start now<br>
`systemctl stop nginx` → stop<br>
`systemctl restart nginx` → restart<br>
`systemctl reload nginx` → reload config<br>
`systemctl is-active nginx` → check running<br>
<br>
---<br>
<br>
## Enable at boot<br>
`systemctl enable nginx`<br>
`systemctl disable nginx`<br>
`systemctl is-enabled nginx`<br>
`systemctl reenable nginx`<br>
<br>
---
<br>
## List units<br>
`systemctl list-units --type=service`<br>
`systemctl list-units --state=failed`<br>
`systemctl --failed`<br>
<br>
---<br>
<br>
## Boot analysis<br>
`systemd-analyze` → total time<br>
`systemd-analyze blame` → slowest services<br>
`systemd-analyze critical-chain` → blocking chain<br>
`systemd-analyze plot > boot.svg` → visual<br>
<br>
---<br>
<br>
## Targets
`systemctl get-default`<br>
`systemctl set-default multi-user.target`<br>
`systemctl set-default graphical.target`<br>
`systemctl isolate rescue.target`<br>
<br>
---<br>
<br>
## journalctl<br>
`journalctl -b` → this boot<br>
`journalctl -b -1` → previous boot<br>
`journalctl -f` → follow<br>
`journalctl -u nginx` → service logs<br>
`journalctl -u nginx --since "1h ago"`<br>
`journalctl -p err` → errors only<br>
`journalctl --since yesterday`<br>
`journalctl --disk-usage`<br>
<br>
---<br>
<br>
## Service management<br>
`systemctl mask nginx` → prevent start<br>
`systemctl unmask nginx`<br>
`systemctl cat nginx` → show file<br>
`systemctl edit nginx` → override<br>
`systemctl daemon-reload` → reload units<br>
`systemctl list-dependencies nginx`<br>
<br>
---<br>
<br>
## Cleanup<br>
`journalctl --vacuum-size=100M`<br>
`journalctl --vacuum-time=7d`<br>
