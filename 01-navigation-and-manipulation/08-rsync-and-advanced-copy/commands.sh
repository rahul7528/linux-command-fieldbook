#!/bin/bash
# 08 - Rsync and Advanced Copy - Demo
cd /tmp
rm -rf rsync-demo
mkdir -p rsync-demo/src
echo "v1" > rsync-demo/src/file1.txt
echo "v1" > rsync-demo/src/file2.txt

echo "=========================================="
echo "RSYNC AND ADVANCED COPY - LIVE DEMO"
echo "=========================================="

pause() { echo ""; echo "--- Press Enter ---"; read; }

echo ">>> 1. rsync basic"
rsync -avh rsync-demo/src/ rsync-demo/dest/
pause

echo ">>> 2. rsync only changed"
echo "v2" > rsync-demo/src/file1.txt
rsync -avh rsync-demo/src/ rsync-demo/dest/
pause

echo ">>> 3. rsync --delete"
rm rsync-demo/src/file2.txt
rsync -avh --delete rsync-demo/src/ rsync-demo/dest/
ls rsync-demo/dest
pause

echo ">>> 4. rsync --dry-run"
touch rsync-demo/src/new.txt
rsync -avh --delete --dry-run rsync-demo/src/ rsync-demo/dest/
pause

echo ">>> 5. mktemp"
tmp=$(mktemp)
echo "temp data" > "$tmp"
cat "$tmp"
tmpdir=$(mktemp -d)
echo "temp dir: $tmpdir"
pause

echo ">>> 6. truncate"
truncate -s 5M /tmp/test.bin
ls -lh /tmp/test.bin
truncate -s 0 /tmp/test.bin
ls -lh /tmp/test.bin
pause

echo ">>> 7. shred (demo file)"
echo "secret" > /tmp/secret.txt
shred -u -n 3 /tmp/secret.txt
ls /tmp/secret.txt 2>&1
pause

echo ">>> 8. rename / loop"
cd /tmp/rsync-demo/src
touch a.txt b.txt
rename -n 's/\.txt$/.md/' *.txt 2>/dev/null || for f in *.txt; do echo "would rename $f to ${f%.txt}.md"; done
for f in *.txt; do mv "$f" "${f%.txt}.md"; done
ls
pause

echo ""
echo "Cleanup"
rm -rf /tmp/rsync-demo /tmp/test.bin
echo "Demo complete."
