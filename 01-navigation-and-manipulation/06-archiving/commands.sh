#!/bin/bash
# 06 - Archiving - Demo
cd /tmp
rm -rf archive-demo
mkdir -p archive-demo/project/{src,docs}
echo "hello" > archive-demo/project/file1.txt
echo "world" > archive-demo/project/src/main.py
cd /tmp

echo "=========================================="
echo "ARCHIVING - LIVE DEMO"
echo "=========================================="

pause() { echo ""; echo "--- Press Enter ---"; read; }

echo ">>> 1. tar create"
tar -cvf backup.tar archive-demo/project
ls -lh backup.tar
pause

echo ">>> 2. tar list"
tar -tvf backup.tar
pause

echo ">>> 3. tar extract"
mkdir restore1
tar -xvf backup.tar -C restore1
ls restore1/archive-demo/project
pause

echo ">>> 4. tar.gz create"
tar -czvf backup.tar.gz archive-demo/project
ls -lh backup.tar*
pause

echo ">>> 5. tar.gz extract"
mkdir restore2
tar -xzvf backup.tar.gz -C restore2
pause

echo ">>> 6. zip create"
zip -r backup.zip archive-demo/project
ls -lh backup.zip
pause

echo ">>> 7. unzip"
mkdir restore3
unzip -q backup.zip -d restore3
ls restore3/archive-demo/project
pause

echo ">>> 8. gzip single file"
echo "log data" > test.log
gzip test.log
ls test.log.gz
gunzip test.log.gz
pause

echo ">>> 9. tar with exclude"
tar -czvf backup-no-src.tar.gz --exclude='src' archive-demo/project
tar -tzvf backup-no-src.tar.gz
pause

echo ">>> 10. Create with date"
tar -czvf backup-$(date +%F).tar.gz archive-demo/project
ls backup-*.tar.gz
pause

echo ""
echo "Cleanup"
rm -rf /tmp/archive-demo /tmp/restore* /tmp/backup.*
echo "Demo complete."
