#!/bin/bash
# 00 - Boot and systemd - Safe Demo
# All commands are read-only, no changes made

echo "=========================================="
echo "BOOT AND SYSTEMD - LIVE DEMO (read-only)"
echo "=========================================="
pause() { read -p "--- Press Enter ---"; }

echo ">>> 1. systemd version and PID 1"
ps -p 1 -o comm=
systemctl --version | head -1
pause

echo ">>> 2. systemctl status (example)"
systemctl status systemd-journald --no-pager | head -15
pause

echo ">>> 3. Is service active?"
systemctl is-active systemd-journald
systemctl is-enabled systemd-journald 2>/dev/null || echo "enabled check requires permissions"
pause

echo ">>> 4. List running services"
systemctl list-units --type=service --state=running --no-pager | head -10
pause

echo ">>> 5. Failed units"
systemctl --failed --no-pager
pause

echo ">>> 6. Boot time analysis"
systemd-analyze
pause

echo ">>> 7. Slowest services (blame)"
systemd-analyze blame | head -10
pause

echo ">>> 8. Critical chain"
systemd-analyze critical-chain | head -20
pause

echo ">>> 9. Current target"
systemctl get-default
pause

echo ">>> 10. journalctl - this boot"
journalctl -b -n 5 --no-pager
pause

echo ">>> 11. journalctl - service logs"
journalctl -u systemd-journald -n 5 --no-pager
pause

echo ">>> 12. journalctl - errors"
journalctl -p err -n 5 --no-pager
pause

echo ">>> 13. Journal disk usage"
journalctl --disk-usage
pause

echo "Demo complete - all read-only commands."
