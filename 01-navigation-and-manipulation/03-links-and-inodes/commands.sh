#!/bin/bash
# 03 - Links and Inodes - Demo
# Run: bash commands.sh

echo "=========================================="
echo "LINKS AND INODES - LIVE DEMO"
echo "=========================================="
cd /tmp
rm -rf link-demo
mkdir link-demo
cd link-demo

pause() { echo ""; echo "--- Press Enter ---"; read; }

echo ">>> 1. Create file and check inode"
echo "hello" > original.txt
ls -i original.txt
stat original.txt | grep -E "Inode|Links"
pause

echo ">>> 2. Create hard link"
ln original.txt hardlink.txt
ls -li original.txt hardlink.txt
pause

echo ">>> 3. Edit through hard link"
echo "world" >> hardlink.txt
cat original.txt
pause

echo ">>> 4. Delete original, hard link survives"
rm original.txt
cat hardlink.txt
ls -li hardlink.txt
pause

echo ">>> 5. Create symlink to /etc/hosts"
ln -s /etc/hosts myhosts
ls -l myhosts
cat myhosts | head -2
pause

echo ">>> 6. readlink"
readlink myhosts
readlink -f myhosts
pause

echo ">>> 7. Create broken symlink"
ln -s /nonexistent broken
ls -l broken
cat broken 2>&1
pause

echo ">>> 8. Find broken links"
find . -xtype l
pause

echo ">>> 9. Symlink to directory"
ln -s /var/log logs-link
ls -ld logs-link
ls logs-link | head -3
pause

echo ">>> 10. Hard link fails across devices (demo)"
# Simulate by trying to link to /proc (different fs)
ln /proc/cpuinfo test-hard 2>&1 || echo "Expected fail: cross-device"
pause

echo ">>> 11. Find all hard links by inode"
INODE=$(ls -i hardlink.txt | awk '{print $1}')
echo "Inode is $INODE"
find . -inum $INODE
pause

echo ">>> 12. Unlink vs rm"
ln -s /etc/passwd testlink
unlink testlink
ls testlink 2>&1 || echo "link removed, target safe"
pause

echo ""
echo "Cleanup"
cd /tmp
rm -rf link-demo
echo "Demo complete."
