#!/bin/bash
# 01 - Core Navigation - All commands from README
# Run: bash commands.sh

echo "=========================================="
echo "CORE NAVIGATION - LIVE DEMO"
echo "=========================================="
echo ""

pause() { echo ""; echo "--- Press Enter ---"; read; }

# Setup demo folder
mkdir -p /tmp/nav-demo/projects/scripts
cd /tmp/nav-demo
touch file1.txt file2.txt
touch .hiddenfile

echo ">>> 1. pwd"
pwd
pause

echo ">>> 2. cd /var/log && pwd"
cd /var/log
pwd
pause

echo ">>> 3. cd .. && pwd"
cd ..
pwd
pause

echo ">>> 4. cd - && pwd"
cd -
pwd
pause

echo ">>> 5. cd ~ && pwd"
cd ~
pwd
pause

echo ">>> 6. ls"
cd /tmp/nav-demo
ls
pause

echo ">>> 7. ls -l"
ls -l
pause

echo ">>> 8. ls -a"
ls -a
pause

echo ">>> 9. ls -lh"
ls -lh
pause

echo ">>> 10. ls -lt"
ls -lt
pause

echo ">>> 11. ls -lart"
ls -lart
pause

echo ">>> 12. pushd /etc && pushd /var/log && dirs -v"
pushd /etc > /dev/null
pushd /var/log > /dev/null
dirs -v
pause

echo ">>> 13. popd && pwd"
popd > /dev/null
pwd
pause

echo ">>> 14. realpath ../scripts"
cd /tmp/nav-demo/projects
realpath ../scripts
pause

echo ">>> 15. tree -L 2 /tmp/nav-demo"
tree -L 2 /tmp/nav-demo 2>/dev/null || echo "Install tree: sudo apt install tree"
pause

echo ">>> 16. Real problem: find newest file"
cd /tmp/nav-demo
ls -lt | head -3
pause

echo ""
echo "Demo complete. Clean up: rm -rf /tmp/nav-demo"
