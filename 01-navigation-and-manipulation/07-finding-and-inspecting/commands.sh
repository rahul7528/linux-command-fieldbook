#!/bin/bash
# 07 - Finding and Inspecting - Complete Demo
cd /tmp
rm -rf find-full
mkdir -p find-full/{logs,empty}
echo "test" > find-full/file1.txt
echo "test" > find-full/file2.log
echo "old" > find-full/old.log
touch -d "40 days ago" find-full/old.log
touch find-full/emptyfile
dd if=/dev/zero of=find-full/big.bin bs=1M count=2 2>/dev/null
touch find-full/prefix-test1.txt find-full/prefix-test2.txt
touch find-full/test-suffix.log
chmod 777 find-full/file1.txt

cd find-full

echo "=========================================="
echo "FINDING - FULL DEMO"
echo "=========================================="
pause() { echo ""; read -p "--- Press Enter ---"; }

echo ">>> 1. Syntax: find where conditions"
find . -type f -name "*.txt"
pause

echo ">>> 2. Prefix and suffix"
find . -name "prefix-*"
find . -name "*-suffix.log"
pause

echo ">>> 3. Type f vs d"
find . -type f
find . -type d
pause

echo ">>> 4. Find and delete"
touch deleteme.tmp
find . -name "*.tmp" -delete
ls *.tmp 2>&1
pause

echo ">>> 5. Empty files and dirs"
find . -type f -empty
find . -type d -empty
find . -type d -empty -delete
pause

echo ">>> 6. Size"
find . -size +1M
find . -size 0
pause

echo ">>> 7. Date modified"
find . -mtime -1
find . -mtime +30
pause

echo ">>> 8. Permission"
find . -perm 777
pause

echo ">>> 9. Remove multiple methods"
touch a.tmp b.tmp c.tmp
rm *.tmp
ls *.tmp 2>&1
touch file1.txt file2.txt file3.txt
rm file{1..3}.txt
pause

echo ">>> 10. Loops with cp"
mkdir backup
for f in *.log; do cp "$f" backup/; done
ls backup
pause

echo ">>> 11. Loop with mv and prefix"
for f in backup/*.log; do mv "$f" "backup/archived-$(basename $f)"; done
ls backup
pause

echo ">>> 12. grep inside files"
echo "error found" > test.log
grep "error" *.log
grep -r "error" .
pause

echo ">>> 13. basename dirname file"
basename /var/log/nginx/access.log
basename /var/log/nginx/access.log .log
dirname /var/log/nginx/access.log
file test.log
pause

echo ">>> 14. find + grep combo"
find . -name "*.log" -exec grep -l "error" {} \;
pause

echo "Cleanup"
cd /tmp
rm -rf find-full
echo "Demo complete."
