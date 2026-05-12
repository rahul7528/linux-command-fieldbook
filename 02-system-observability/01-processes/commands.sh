#!/bin/bash
# 01-processes demo - safe, read-only with temporary processes
set -euo pipefail

pause() {
    echo ""
    read -rp "Press Enter to continue..."
    echo ""
}

cleanup() {
    echo "Cleaning up demo processes..."
    pkill -f "sleep 300 #demo-proc" 2>/dev/null || true
    pkill -f "sleep 400 #demo-worker" 2>/dev/null || true
    rm -f /tmp/demo_out.log
}
trap cleanup EXIT

echo "=== 02-system-observability/01-processes DEMO ==="
echo ""

echo "1. Creating demo processes"
echo "---"
nohup bash -c 'sleep 300 #demo-proc' > /tmp/demo_out.log 2>&1 &
DEMO_PID=$!
sleep 400 #demo-worker &
WORKER_PID=$!
echo "Started demo PIDs: $DEMO_PID, $WORKER_PID"
pause

echo "2. ps - top consumers"
echo "---"
echo "$ ps -eo pid,%cpu,%mem,cmd --sort=-%cpu | head -6"
ps -eo pid,%cpu,%mem,cmd --sort=-%cpu | head -6
pause

echo "3. Find processes with pgrep"
echo "---"
echo "$ pgrep -f 'demo-proc'"
pgrep -f "demo-proc" || true
echo ""
echo "$ pgrep -a -f demo"
pgrep -a -f "demo" || true
pause

echo "4. Process tree"
echo "---"
echo "$ pstree -p $$ | head -10"
pstree -p $$ | head -10
pause

echo "5. /proc inspection"
echo "---"
echo "$ cat /proc/$DEMO_PID/status | grep -E 'Name|State|VmRSS'"
cat /proc/$DEMO_PID/status | grep -E 'Name|State|VmRSS' || true
echo ""
echo "$ ls -l /proc/$DEMO_PID/fd"
ls -l /proc/$DEMO_PID/fd
pause

echo "6. lsof - open files"
echo "---"
echo "$ lsof -p $DEMO_PID | head -5"
lsof -p $DEMO_PID | head -5 || true
pause

echo "7. Priority adjustment"
echo "---"
echo "$ renice +5 -p $DEMO_PID"
renice +5 -p $DEMO_PID
echo ""
echo "$ nice -n 10 sleep 1 &"
nice -n 10 sleep 1 &
wait
pause

echo "8. Signals - test existence"
echo "---"
echo "$ kill -0 $DEMO_PID && echo 'Process alive'"
kill -0 $DEMO_PID && echo "Process alive"
pause

echo "9. strace sample (non-invasive)"
echo "---"
echo "$ timeout 2 strace -c -p $DEMO_PID"
timeout 2 strace -c -p $DEMO_PID 2>&1 | head -15 || echo "strace requires privileges or process exited"
pause

echo "10. pidstat (if available)"
echo "---"
if command -v pidstat >/dev/null; then
    pidstat -p $DEMO_PID 1 1
else
    echo "pidstat not installed, skipping"
fi
pause

echo "11. lsof +L1 - deleted files"
echo "---"
echo "$ lsof +L1 | head -3"
lsof +L1 | head -3 || echo "No deleted files held"
pause

echo "12. Watch and timeout demo"
echo "---"
echo "$ timeout 3 watch -n1 'ps -o pid,cmd -p $DEMO_PID'"
timeout 3 watch -n1 "ps -o pid,cmd -p $DEMO_PID" || true
pause

echo "13. Graceful kill pattern"
echo "---"
echo "$ kill -TERM $WORKER_PID"
kill -TERM $WORKER_PID
sleep 1
echo "$ kill -0 $WORKER_PID 2>/dev/null && echo 'still alive' || echo 'terminated'"
kill -0 $WORKER_PID 2>/dev/null && echo "still alive" || echo "terminated"
pause

echo "14. Zombie check"
echo "---"
echo "$ ps aux | awk '\$8 ~ /^Z/'"
ps aux | awk '$8 ~ /^Z/' || echo "No zombies"
pause

echo "15. Cleanup"
cleanup

echo ""
echo "=== DEMO COMPLETE ==="
echo "All demo processes terminated. No system changes made."
