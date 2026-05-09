#!/bin/bash
# 05 - Redirection and Pipes - Demo
cd /tmp
rm -rf redir-demo
mkdir redir-demo
cd redir-demo

echo "=========================================="
echo "REDIRECTION AND PIPES - LIVE DEMO"
echo "=========================================="

pause() { echo ""; echo "--- Press Enter ---"; read; }

echo ">>> 1. > overwrite"
ls > files.txt
cat files.txt
pause

echo ">>> 2. >> append"
date >> files.txt
echo "appended" >> files.txt
tail -2 files.txt
pause

echo ">>> 3. 2> errors"
ls /nope 2> err.log
echo "Screen is empty, error in file:"
cat err.log
pause

echo ">>> 4. &> both"
ls . /nope &> both.log
cat both.log
pause

echo ">>> 5. < input"
wc -l < files.txt
pause

echo ">>> 6. | pipe"
ls | grep txt
pause

echo ">>> 7. Chain pipes"
echo -e "apple
banana
apple" | sort | uniq -c
pause

echo ">>> 8. tee"
ls | tee copy.txt | grep files
echo "copy.txt contains:"
cat copy.txt
pause

echo ">>> 9. xargs"
touch a.tmp b.tmp
ls *.tmp | xargs rm -v
pause

echo ">>> 10. /dev/null"
ls /nope > /dev/null 2>&1
echo "No output, exit code: $?"
pause

echo ">>> 11. Here document"
cat << EOF > config.conf
port=8080
host=localhost
EOF
cat config.conf
pause

echo ">>> 12. Real pipeline"
ps aux | head -5 | awk '{print $1, $11}' | tee processes.txt
pause

echo ""
echo "Cleanup"
cd /tmp
rm -rf redir-demo
echo "Demo complete."
