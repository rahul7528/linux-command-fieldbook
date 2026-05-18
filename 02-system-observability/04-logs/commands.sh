#!/bin/bash
# 04-logs demo - safe operations using /tmp
set -euo pipefail

pause() {
    echo ""
    read -rp "Press Enter to continue..."
    echo ""
}

LOGDIR="/tmp/demo-logs"
mkdir -p "$LOGDIR"

cleanup() {
    rm -rf "$LOGDIR"
}
trap cleanup EXIT

echo "=== 02-system-observability/04-logs DEMO ==="
echo ""

echo "1. Create demo log files"
echo "---"
cat > "$LOGDIR/app.log" << 'EOF'
2026-05-18 10:00:01 INFO Starting chai tapri
2026-05-18 10:00:05 INFO Customer 1 ordered masala chai
2026-05-18 10:00:10 ERROR Milk delivery delayed
2026-05-18 10:00:15 WARN Low sugar
2026-05-18 10:00:20 INFO Customer 2 ordered cutting
2026-05-18 10:00:25 ERROR Out of ginger
2026-05-18 10:00:30 INFO Restocked
EOF
echo "Created $LOGDIR/app.log"
pause

echo "2. tail and head"
echo "---"
echo "$ tail -n 3 $LOGDIR/app.log"
tail -n 3 "$LOGDIR/app.log"
echo ""
echo "$ head -n 2 $LOGDIR/app.log"
head -n 2 "$LOGDIR/app.log"
pause

echo "3. grep searching"
echo "---"
echo "$ grep ERROR $LOGDIR/app.log"
grep ERROR "$LOGDIR/app.log"
echo ""
echo "$ grep -i -C1 'milk\|ginger' $LOGDIR/app.log"
grep -i -C1 'milk\|ginger' "$LOGDIR/app.log"
pause

echo "4. tail -f simulation"
echo "---"
echo "Starting background writer..."
( sleep 1; echo "2026-05-18 10:00:35 INFO New customer" >> "$LOGDIR/app.log"; sleep 1; echo "2026-05-18 10:00:36 ERROR Chai too hot" >> "$LOGDIR/app.log" ) &
timeout 3 tail -f "$LOGDIR/app.log" &
wait
pause

echo "5. awk parsing"
echo "---"
echo "$ awk '{print \$4}' $LOGDIR/app.log | sort | uniq -c"
awk '{print $4}' "$LOGDIR/app.log" | sort | uniq -c
pause

echo "6. journalctl examples (system logs)"
echo "---"
echo "$ journalctl -n 3 --no-pager"
journalctl -n 3 --no-pager
echo ""
echo "$ journalctl -p err -n 2 --no-pager"
journalctl -p err -n 2 --no-pager || echo "No errors"
pause

echo "7. logger - write to syslog"
echo "---"
logger -t demo-tapri "Chai demo log entry"
echo "Wrote to syslog. Check with:"
echo "$ journalctl -t demo-tapri -n 1 --no-pager"
journalctl -t demo-tapri -n 1 --no-pager
pause

echo "8. Compressed logs"
echo "---"
gzip -c "$LOGDIR/app.log" > "$LOGDIR/app.log.1.gz"
echo "$ zgrep ERROR $LOGDIR/app.log.1.gz"
zgrep ERROR "$LOGDIR/app.log.1.gz"
pause

echo "9. multitail simulation"
echo "---"
echo "Creating second log..."
echo "2026-05-18 10:01:00 INFO Kitchen started" > "$LOGDIR/kitchen.log"
echo "$ tail -f $LOGDIR/app.log $LOGDIR/kitchen.log (showing first 2 lines each)"
tail -n 2 "$LOGDIR/app.log" "$LOGDIR/kitchen.log"
pause

echo "10. logrotate dry run"
echo "---"
cat > "$LOGDIR/logrotate.conf" << EOF
$LOGDIR/app.log {
    daily
    rotate 3
    compress
}
EOF
logrotate -d "$LOGDIR/logrotate.conf" 2>&1 | head -10
pause

echo "11. watch simulation"
echo "---"
echo "$ watch -n1 'wc -l $LOGDIR/app.log' (running 3 seconds)"
timeout 3 watch -n1 "wc -l $LOGDIR/app.log" 2>/dev/null || echo "watch demo complete"
pause

echo "12. Cleanup"
cleanup
echo "Removed demo logs"

echo ""
echo "=== DEMO COMPLETE ==="
echo "All operations used /tmp only."
