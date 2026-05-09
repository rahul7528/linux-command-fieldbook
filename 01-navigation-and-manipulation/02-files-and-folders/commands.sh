#!/bin/bash
# 02 - Files and Folders - All commands demo
# Run: bash commands.sh

echo "=========================================="
echo "FILES AND FOLDERS - LIVE DEMO"
echo "=========================================="
cd /tmp
rm -rf demo-files
mkdir demo-files
cd demo-files

pause() { echo ""; echo "--- Press Enter ---"; read; }

echo ">>> 1. mkdir projects"
mkdir projects
ls -ld projects
pause

echo ">>> 2. mkdir -p projects/linux/logs"
mkdir -p projects/linux/logs
tree projects 2>/dev/null || find projects
pause

echo ">>> 3. touch file1.txt file2.txt"
touch file1.txt file2.txt
ls -lh
pause

echo ">>> 4. touch file1.txt (updates time)"
sleep 1
touch file1.txt
ls -lt
pause

echo ">>> 5. cp file1.txt backup.txt"
cp file1.txt backup.txt
ls
pause

echo ">>> 6. cp -v file2.txt /tmp/"
cp -v file2.txt /tmp/
pause

echo ">>> 7. cp -r projects projects-backup"
cp -r projects projects-backup
ls -d projects*
pause

echo ">>> 8. cp -iv file1.txt backup.txt (will ask)"
cp -iv file1.txt backup.txt
pause

echo ">>> 9. mv backup.txt renamed.txt"
mv backup.txt renamed.txt
ls
pause

echo ">>> 10. mv renamed.txt projects/"
mv renamed.txt projects/
ls projects/
pause

echo ">>> 11. mv -v file2.txt file2-moved.txt"
mv -v file2.txt file2-moved.txt
pause

echo ">>> 12. cp -a projects projects-archive"
cp -a projects projects-archive
ls -ld projects*
pause

echo ">>> 13. rmdir (fails on non-empty)"
mkdir empty
rmdir empty
echo "empty deleted"
mkdir nonempty
touch nonempty/x
rmdir nonempty 2>&1 || echo "rmdir refused - folder not empty"
pause

echo ">>> 14. rm file2-moved.txt"
rm file2-moved.txt
ls
pause

echo ">>> 15. rm -ri projects-backup (interactive)"
rm -ri projects-backup
pause

echo ">>> 16. rm -rf projects-archive (force)"
rm -rf projects-archive
ls
pause

echo ">>> 17. Safety demo: install with permissions"
echo "#!/bin/bash" > script.sh
install -m 755 script.sh /tmp/myscript
ls -l /tmp/myscript
pause

echo ""
echo "Demo complete. Cleaning /tmp/demo-files"
cd /tmp
rm -rf demo-files
echo "Done."
