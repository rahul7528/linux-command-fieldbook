#!/bin/bash
# 02-memory-cpu demo - safe read-only operations
set -euo pipefail

pause() {
    echo ""
    read -rp "Press Enter to continue..."
    echo ""
}

echo "=== 02-system-observability/02-memory-cpu DEMO ==="
echo ""

echo "1. Memory overview"
echo "---"
free -h
echo ""
free -w -h | head -3
pause

echo "2. /proc/meminfo key values"
echo "---"
grep -E "MemTotal|MemFree|MemAvailable|Buffers|Cached|SwapTotal|SwapFree" /proc/meminfo
pause

echo "3. vmstat snapshot"
echo "---"
vmstat -w 1 3
pause

echo "4. CPU topology"
echo "---"
lscpu | grep -E "Model name|Socket|Core|Thread|CPU\(s\)"
echo ""
echo "Cores: $(nproc)"
pause

echo "5. Load average vs cores"
echo "---"
uptime
LOAD1=$(awk '{print $1}' /proc/loadavg)
CORES=$(nproc)
echo "Load 1min: $LOAD1, Cores: $CORES"
awk -v l=$LOAD1 -v c=$CORES 'BEGIN{printf "Load per core: %.2f
", l/c}'
pause

echo "6. mpstat per-CPU"
echo "---"
mpstat -P ALL 1 1 | head -15
pause

echo "7. Top memory consumers"
echo "---"
ps -eo pid,%mem,rss,cmd --sort=-%mem | head -6
pause

echo "8. smem if available"
echo "---"
if command -v smem >/dev/null; then
    smem -s pss | head -6
else
    echo "smem not installed, using ps"
    ps -eo pid,cmd,rss --sort=-rss | head -6
fi
pause

echo "9. pmap for current shell"
echo "---"
pmap -x $$ | tail -5
pause

echo "10. slabtop summary"
echo "---"
if command -v slabtop >/dev/null; then
    slabtop -o | head -10
else
    grep Slab /proc/meminfo
fi
pause

echo "11. Swap status"
echo "---"
swapon --show || echo "No swap"
cat /proc/sys/vm/swappiness
pause

echo "12. vmstat swap activity"
echo "---"
echo "si so (swap in/out)"
vmstat 1 3 | awk 'NR>2 {print $8, $9}'
pause

echo "13. pidstat sample"
echo "---"
if command -v pidstat >/dev/null; then
    pidstat -u 1 2 | head -20
else
    echo "pidstat not installed"
fi
pause

echo "14. NUMA info"
echo "---"
if command -v numastat >/dev/null; then
    numastat | head -10
else
    echo "numastat not available"
fi
pause

echo "15. Pressure Stall Information"
echo "---"
for f in /proc/pressure/cpu /proc/pressure/memory /proc/pressure/io; do
    if [ -r "$f" ]; then
        echo "--- $f ---"
        head -2 "$f"
    fi
done
pause

echo "16. sar historical (if available)"
echo "---"
if command -v sar >/dev/null; then
    sar -u 1 2
else
    echo "sar not installed"
fi
pause

echo "17. OOM score check"
echo "---"
ps -eo pid,comm,oom_score --sort=-oom_score | head -5
pause

echo "18. perf top check (requires root)"
echo "---"
if [ "$EUID" -eq 0 ] && command -v perf >/dev/null; then
    timeout 3 perf top -a -o /tmp/perf.out 2>/dev/null || echo "perf requires privileges"
    [ -f /tmp/perf.out ] && head -5 /tmp/perf.out
    rm -f /tmp/perf.out
else
    echo "Skipping perf (needs root)"
fi

echo ""
echo "=== DEMO COMPLETE ==="
echo "All operations read-only. No system changes."
