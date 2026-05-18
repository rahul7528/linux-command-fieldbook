#!/bin/bash
# 05-troubleshooting demo - safe simulation
set -euo pipefail

pause() {
    echo ""
    read -rp "Press Enter to continue..."
    echo ""
}

echo "=== 02-system-observability/05-troubleshooting DEMO ==="
echo ""

echo "1. 60-Second Triage"
echo "---"
echo "$ uptime"
uptime
echo ""
echo "$ free -h"
free -h
echo ""
echo "$ df -hT -x tmpfs | head -5"
df -hT -x tmpfs | head -5
echo ""
echo "$ iostat -x 1 1 | head -10"
iostat -x 1 1 2>/dev/null | head -10 || echo "iostat not available"
pause

echo "2. Simulate high CPU"
echo "---"
echo "Starting CPU hog in background..."
timeout 10 bash -c 'while true; do :; done' &
HOG_PID=$!
sleep 1
echo "$ ps -p $HOG_PID -o pid,%cpu,cmd"
ps -p $HOG_PID -o pid,%cpu,cmd
echo ""
echo "$ top -b -n1 | head -12"
top -b -n1 | head -12
kill $HOG_PID 2>/dev/null || true
pause

echo "3. Memory check"
echo "---"
echo "$ vmstat 1 2"
vmstat 1 2
echo ""
echo "$ ps -eo pid,%mem,cmd --sort=-%mem | head -5"
ps -eo pid,%mem,cmd --sort=-%mem | head -5
pause

echo "4. Disk full simulation"
echo "---"
echo "$ df -h /tmp"
df -h /tmp
echo ""
echo "$ du -sh /tmp/* 2>/dev/null | head -3"
du -sh /tmp/* 2>/dev/null | head -3 || echo "No files"
echo ""
echo "$ lsof +L1 | head -3"
lsof +L1 | head -3 || echo "None"
pause

echo "5. Process won't start - check port"
echo "---"
echo "$ ss -tulnp | head -5"
ss -tulnp | head -5
echo ""
echo "$ lsof -i :22 | head -3"
lsof -i :22 | head -3 || echo "sshd not found"
pause

echo "6. Check logs"
echo "---"
echo "$ journalctl -n 3 --no-pager"
journalctl -n 3 --no-pager
echo ""
echo "$ dmesg -T | tail -3"
dmesg -T | tail -3
pause

echo "7. Correlation example"
echo "---"
TIME=$(date +"%H:%M")
logger -t demo-trouble "Test incident at $TIME"
sleep 1
echo "$ journalctl -t demo-trouble --since '1 minute ago'"
journalctl -t demo-trouble --since '1 minute ago' --no-pager
pause

echo "8. strace demo"
echo "---"
sleep 5 &
TRACE_PID=$!
echo "$ strace -c -p $TRACE_PID (2 seconds)"
timeout 2 strace -c -p $TRACE_PID 2>&1 | head -10 || echo "strace needs privileges"
kill $TRACE_PID 2>/dev/null || true
pause

echo "9. Emergency state capture"
echo "---"
OUT="/tmp/triage-$(date +%s)"
{
    echo "=== UPTIME ==="; uptime
    echo "=== FREE ==="; free -h
    echo "=== DF ==="; df -h
    echo "=== PS ==="; ps aux --sort=-%cpu | head -5
} > "$OUT.txt"
echo "Saved to $OUT.txt"
ls -lh "$OUT.txt"
rm "$OUT.txt"
pause

echo "10. Zombie check"
echo "---"
echo "$ ps -eo stat,pid,cmd | grep -E '^Z'"
ps -eo stat,pid,cmd | grep -E '^Z' || echo "No zombies found"

echo ""
echo "=== DEMO COMPLETE ==="
echo "All simulations safe, no system changes."
