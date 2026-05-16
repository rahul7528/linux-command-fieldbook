#!/bin/bash
# 03-disk-io demo - safe read-only operations
set -euo pipefail

pause() {
    echo ""
    read -rp "Press Enter to continue..."
    echo ""
}

echo "=== 02-system-observability/03-disk-io DEMO ==="
echo ""

echo "1. Disk space overview"
echo "---"
df -hT -x tmpfs -x devtmpfs | head -10
echo ""
df -i | head -5
pause

echo "2. Largest directories"
echo "---"
du -hxd1 / 2>/dev/null | sort -hr | head -8
pause

echo "3. Devices and mounts"
echo "---"
lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT,ROTA | head -15
echo ""
findmnt --real | head -10
pause

echo "4. iostat extended"
echo "---"
if command -v iostat >/dev/null; then
    iostat -x 1 2
else
    echo "iostat not installed"
fi
pause

echo "5. vmstat IO"
echo "---"
vmstat 1 3
pause

echo "6. /proc/diskstats"
echo "---"
head -5 /proc/diskstats
pause

echo "7. Per-process IO (if root)"
echo "---"
if [ "$EUID" -eq 0 ] && command -v pidstat >/dev/null; then
    pidstat -d 1 2 | head -15
else
    echo "Skipping pidstat -d (needs root or not installed)"
fi
pause

echo "8. Deleted files holding space"
echo "---"
lsof +L1 | head -5 || echo "None found"
pause

echo "9. Find large files in /tmp"
echo "---"
find /tmp -xdev -type f -printf '%s %p\n' 2>/dev/null | sort -rn | head -5 | numfmt --to=iec --field=1 || echo "No files"
pause

echo "10. dstat combined"
echo "---"
if command -v dstat >/dev/null; then
    dstat -cdngy 1 3
else
    echo "dstat not installed"
fi
pause

echo "11. sar disk"
echo "---"
if command -v sar >/dev/null; then
    sar -d 1 2 | head -15
else
    echo "sar not installed"
fi
pause

echo "12. ionice current"
echo "---"
ionice -p $$
pause

echo "13. fio safe test in /tmp"
echo "---"
if command -v fio >/dev/null; then
    fio --name=demo --rw=randread --bs=4k --size=64M --runtime=5 --time_based --direct=1 --filename=/tmp/fio_demo --output=/tmp/fio.out >/dev/null 2>&1
    grep -E "read:|IOPS" /tmp/fio.out || true
    rm -f /tmp/fio_demo /tmp/fio.out
else
    echo "fio not installed, skipping"
fi
pause

echo "14. smartctl check (if available)"
echo "---"
if command -v smartctl >/dev/null && [ "$EUID" -eq 0 ]; then
    DEV=$(lsblk -dn -o NAME | head -1)
    [ -n "$DEV" ] && sudo smartctl -H /dev/$DEV 2>/dev/null | head -4 || echo "No device"
else
    echo "Skipping smartctl (needs root)"
fi

echo ""
echo "=== DEMO COMPLETE ==="
echo "All operations read-only except temporary fio file in /tmp (cleaned)."
