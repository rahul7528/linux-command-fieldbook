#!/bin/bash
# 04 - Wildcards and Globbing - Demo
# Run: bash commands.sh

echo "=========================================="
echo "WILDCARDS AND GLOBBING - LIVE DEMO"
echo "=========================================="
cd /tmp
rm -rf glob-demo
mkdir glob-demo
cd glob-demo

pause() { echo ""; echo "--- Press Enter ---"; read; }

# Setup files
touch file1.txt file2.txt file10.txt fileA.txt
touch app.log error.log access.log.1
touch image.jpg image.PNG photo.gif
touch .hidden config.bak
mkdir -p src tests

echo ">>> 1. * matches"
echo *.txt
pause

echo ">>> 2. ? matches one char"
ls file?.txt
pause

echo ">>> 3. [0-9] range"
ls file[0-9].txt
pause

echo ">>> 4. [!0-9] negation"
ls file[!0-9].txt
pause

echo ">>> 5. * with extension"
ls *.log
pause

echo ">>> 6. Brace expansion {}"
echo file{1,2,3}.txt
mkdir -p project/{src,docs,tests}
ls project
pause

echo ">>> 7. Sequence {1..5}"
touch log{01..05}.txt
ls log*.txt
pause

echo ">>> 8. Multiple extensions"
echo *.{jpg,png,gif}
pause

echo ">>> 9. Hidden files"
echo .*
ls .[^.]*  # better hidden
pause

echo ">>> 10. Escaping literal *"
touch '*.special'
ls \*.special
rm "*.special"
pause

echo ">>> 11. Safety: echo before rm"
echo "Would delete:"
echo *.log.*
pause

echo ">>> 12. Enable globstar for **"
shopt -s globstar
touch src/main.py tests/test.py
echo **/*.py
pause

echo ">>> 13. extglob - not pattern"
shopt -s extglob
echo !(*.txt)
pause

echo ">>> 14. Rename all .txt to .bak demo"
for f in file?.txt; do mv "$f" "${f%.txt}.bak"; done
ls *.bak
pause

echo ""
echo "Cleanup"
cd /tmp
rm -rf glob-demo
echo "Demo complete."
