#!/bin/bash
# 00-boot-and-systemd demo - safe, read-only operations
# All operations use /tmp and do not modify system state

set -euo pipefail

pause() {
    echo ""
    read -rp "Press Enter to continue..."
    echo ""
}

echo "=== 02-system-observability/00-boot-and-systemd DEMO ==="
echo ""

echo "1. System state overview"
echo "---"
uptime -p
echo ""
hostnamectl status | head -5
echo ""
timedatectl status | grep -E "Time zone|NTP"
pause

echo "2. systemctl - service status"
echo "---"
echo "$ systemctl status sshd --no-pager -l"
systemctl status sshd --no-pager -l || true
echo ""
echo "$ systemctl is-active sshd"
systemctl is-active sshd || true
pause

echo "3. List units"
echo "---"
echo "$ systemctl list-units -t service --state=running | head -10"
systemctl list-units -t service --state=running | head -10
echo ""
echo "$ systemctl --failed"
systemctl --failed || true
pause

echo "4. journalctl - recent logs"
echo "---"
echo "$ journalctl -n 5 --no-pager -o short"
journalctl -n 5 --no-pager -o short
echo ""
echo "$ journalctl -p err -b --no-pager -n 3"
journalctl -p err -b --no-pager -n 3 || echo "No errors"
pause

echo "5. journalctl by unit"
echo "---"
# Use a common service that likely exists
UNIT="systemd-journald"
echo "$ journalctl -u $UNIT -n 3 --no-pager"
journalctl -u $UNIT -n 3 --no-pager
pause

echo "6. Boot analysis"
echo "---"
echo "$ systemd-analyze"
systemd-analyze || true
echo ""
echo "$ systemd-analyze blame | head -5"
systemd-analyze blame | head -5 || true
pause

echo "7. Critical chain"
echo "---"
echo "$ systemd-analyze critical-chain | head -15"
systemd-analyze critical-chain | head -15 || true
pause

echo "8. dmesg kernel messages"
echo "---"
echo "$ dmesg -T | tail -5"
dmesg -T | tail -5
pause

echo "9. User sessions"
echo "---"
echo "$ w"
w
echo ""
echo "$ last -x reboot | head -3"
last -x reboot | head -3
pause

echo "10. Generate boot plot to /tmp"
echo "---"
PLOT="/tmp/boot.svg"
systemd-analyze plot > "$PLOT" 2>/dev/null && echo "Created $PLOT" || echo "Plot generation skipped"
ls -lh "$PLOT" 2>/dev/null || true
pause

echo "11. Journal disk usage"
echo "---"
journalctl --disk-usage
pause

echo "12. Cleanup"
echo "---"
rm -f "$PLOT"
echo "Removed temporary files"

echo ""
echo "=== DEMO COMPLETE ==="
echo "All commands were read-only. No system changes made."
