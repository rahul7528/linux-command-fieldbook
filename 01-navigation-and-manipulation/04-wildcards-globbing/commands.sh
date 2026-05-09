#!/bin/bash
# 04 - Wildcards - Demo
cd /tmp
rm -rf wild-demo
mkdir wild-demo
cd wild-demo

echo "=========================================="
echo "WILDCARDS - LIVE DEMO"
echo "=========================================="
pause() { read -p "--- Press Enter ---"; }

touch file1.txt file2.txt file10.txt fileA.txt
touch backup-jan.log backup-feb.log app-old.log
touch test1.log test2.log test3.log
touch a.txt b.txt c.md

echo ">>> 1. * wildcard"
ls *.txt
pause

echo ">>> 2. Prefix and suffix delete"
ls backup-*
ls *-old.log
pause

echo ">>> 3. ? single char"
ls file?.txt
pause

echo ">>> 4. [] character set"
ls file[12].txt
ls file[1-3].txt
ls [ab].txt
pause

echo ">>> 5. {} brace expansion"
echo file{1,2,3}.txt
ls file{1,2}.txt
pause

echo ">>> 6. Delete with patterns"
touch temp-1.tmp temp-2.tmp delete-old.log
ls temp-*
rm temp-*
ls temp-* 2>&1
pause

echo ">>> 7. Brace delete"
touch file1.tmp file2.tmp file3.tmp
rm file{1..3}.tmp
ls *.tmp 2>&1
pause

echo ">>> 8. Test before delete"
touch a.bak b.bak
echo "Would delete:"
echo *.bak
rm *.bak
pause

echo "Cleanup"
cd /tmp
rm -rf wild-demo
echo "Demo complete."
