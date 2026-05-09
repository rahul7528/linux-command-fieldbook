#!/bin/bash
# 02 - Files and Folders - Demo
cd /tmp
rm -rf files-demo
mkdir files-demo
cd files-demo

echo "=========================================="
echo "FILES AND FOLDERS - LIVE DEMO"
echo "=========================================="
pause() { read -p "--- Press Enter ---"; }

echo ">>> 1. mkdir -p"
mkdir -p project/src/tests
tree project 2>/dev/null || find project
pause

echo ">>> 2. touch multiple"
touch file1.txt file2.txt file3.txt
ls
pause

echo ">>> 3. cp"
cp file1.txt backup.txt
cp -v file2.txt file2-copy.txt
pause

echo ">>> 4. cp -r"
cp -r project project-backup
ls
pause

echo ">>> 5. mv rename"
mv file3.txt renamed.txt
ls
pause

echo ">>> 6. rm multiple with wildcard"
touch a.tmp b.tmp c.log
rm *.tmp
ls
pause

echo ">>> 7. rm with prefix/suffix"
touch backup-1.txt backup-2.txt test-old.log
rm backup-*
rm *-old.log
ls
pause

echo ">>> 8. rm with brace"
touch file1.txt file2.txt file3.txt
rm file{1..3}.txt
ls
pause

echo ">>> 9. rmdir"
mkdir empty1 empty2
rmdir empty1
ls
pause

echo ">>> 10. Loop with cp"
touch img1.jpg img2.jpg
mkdir images
for f in *.jpg; do cp "$f" images/; done
ls images
pause

echo ">>> 11. Loop with mv and prefix"
for f in *.jpg; do mv "$f" "old-$f"; done
ls
pause

echo ">>> 12. Remove empty dirs with find"
mkdir -p a/b/c
find . -type d -empty -delete
find .
pause

echo "Cleanup"
cd /tmp
rm -rf files-demo
echo "Demo complete."
