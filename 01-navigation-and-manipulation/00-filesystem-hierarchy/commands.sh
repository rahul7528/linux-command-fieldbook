#!/bin/bash
# 00 - Filesystem Hierarchy
# This script runs every command mentioned in the README
# Run: bash commands.sh
# Output will vary by system - that's normal

echo "=========================================="
echo "LINUX FILESYSTEM HIERARCHY - LIVE DEMO"
echo "=========================================="
echo ""

pause() {
  echo ""
  echo "--- Press Enter to continue ---"
  read
}

# 1. Root
echo ">>> 1. ls /  (lists top folders)"
ls /
pause

# 2. Home
echo ">>> 2. cd /home/$USER && pwd"
cd /home/$USER 2>/dev/null || cd ~
pwd
pause

# 3. Root home
echo ">>> 3. sudo ls /root  (admin home)"
sudo ls /root 2>/dev/null || echo "Need sudo password or no access"
pause

# 4. Where is ls
echo ">>> 4. which ls"
which ls
pause

# 5. Where is reboot
echo ">>> 5. which reboot"
which reboot
pause

# 6. Config folder
echo ">>> 6. ls /etc | head -20"
ls /etc | head -20
pause

# 7. Hostname
echo ">>> 7. cat /etc/hostname"
cat /etc/hostname
pause

# 8. Var
echo ">>> 8. ls /var"
ls /var
pause

# 9-10. Logs
echo ">>> 9. ls /var/log | head -15"
ls /var/log | head -15
echo ""
echo ">>> 10. tail /var/log/syslog (last 5 lines)"
tail -n 5 /var/log/syslog 2>/dev/null || tail -n 5 /var/log/messages 2>/dev/null || echo "No syslog found"
pause

# 11. Tmp
echo ">>> 11. touch /tmp/mytest.txt"
touch /tmp/mytest.txt
ls -l /tmp/mytest.txt
pause

# 12-13. Programs
echo ">>> 12. ls /usr/local/bin"
ls /usr/local/bin 2>/dev/null || echo "(empty)"
echo ""
echo ">>> 13. ls /opt"
ls /opt 2>/dev/null || echo "(empty)"
pause

# 14-15. Devices
echo ">>> 14. lsblk"
lsblk
echo ""
echo ">>> 15. ls /dev/sd* or /dev/nvme*"
ls /dev/sd* 2>/dev/null || ls /dev/nvme* 2>/dev/null || echo "No disks matched"
pause

# 16-17. Proc
echo ">>> 16. cat /proc/cpuinfo | head -15"
cat /proc/cpuinfo | head -15
echo ""
echo ">>> 17. cat /proc/meminfo | head -10"
cat /proc/meminfo | head -10
pause

# 18. Media
echo ">>> 18. ls /media"
ls /media
pause

# 19. Lib
echo ">>> 19. ls /lib | head -15"
ls /lib | head -15
pause

# 20-21. Tree
echo ">>> 20. Installing tree (if needed)"
sudo apt install tree -y > /dev/null 2>&1 || echo "tree already installed or not Debian-based"
echo ""
echo ">>> 21. tree -L 1 /"
tree -L 1 /
pause

# 22. Find
echo ">>> 22. find /etc -name "*.conf" | head -10"
find /etc -name "*.conf" 2>/dev/null | head -10
pause

# 23. Tail -f demo (non-blocking)
echo ">>> 23. tail -f example (showing 3 lines then exit)"
timeout 2 tail -f /var/log/syslog 2>/dev/null || echo "Demo: tail -f keeps file open live"
pause

# 24-26. Disk space
echo ">>> 24. df -h"
df -h
echo ""
echo ">>> 25-26. du -sh /var/* | sort -hr | head -10"
sudo du -sh /var/* 2>/dev/null | sort -hr | head -10
pause

# 27. SSH config
echo ">>> 27. cat /etc/ssh/sshd_config | head -20"
cat /etc/ssh/sshd_config 2>/dev/null | head -20 || echo "SSH not installed"
pause

echo ""
echo "=========================================="
echo "Demo complete. All commands from README covered."
echo "=========================================="
