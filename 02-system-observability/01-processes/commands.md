# Boot and Systemd - Quick Reference

## Service Control
systemctl status <unit> -l --no-pager
systemctl start|stop|restart|reload <unit>
systemctl enable --now <unit>
systemctl disable --now <unit>
systemctl is-active <unit>
systemctl is-enabled <unit>
systemctl --failed
systemctl list-units -t service --state=running
systemctl list-dependencies <unit>
systemctl cat <unit>
systemctl edit <unit>
systemctl daemon-reload
systemctl reset-failed
---
## Logs
journalctl -u <unit> -f
journalctl -u <unit> --since "1 hour ago"
journalctl -p err -b
journalctl -b -1
journalctl -k -f
journalctl --since today -o short-iso
journalctl _PID=1234
journalctl -u <unit> -n 100 --no-pager
journalctl --disk-usage
sudo journalctl --vacuum-time=7d
sudo journalctl --vacuum-size=500M
---
## Boot Analysis
systemd-analyze
systemd-analyze blame
systemd-analyze critical-chain
systemd-analyze plot > boot.svg
systemd-analyze security <unit>
---
## System State
hostnamectl status
hostnamectl set-hostname <name>
timedatectl status
timedatectl set-timezone <zone>
timedatectl set-ntp true
uptime -p
w
who
last reboot
last -x
lastb
---
## Kernel and Power
dmesg -T
dmesg -w
dmesg -l err,warn
sudo shutdown -r +5 "message"
sudo shutdown -c
systemctl reboot
systemctl poweroff
systemctl isolate rescue.target
systemctl get-default
systemctl set-default multi-user.target
