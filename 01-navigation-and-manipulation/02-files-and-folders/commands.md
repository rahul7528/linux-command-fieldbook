# 02 - Files and Folders - Command Reference

---

## mkdir
`mkdir dir` → create folder
`mkdir -p a/b/c` → create parents
`mkdir dir1 dir2 dir3` → multiple

---

## touch
`touch file.txt` → create or update time
`touch f1 f2 f3` → multiple
`touch -t 202401011200 file` → set time

---

## cp
`cp file dest/` → copy file
`cp -r dir dest/` → copy folder
`cp -a src dest` → preserve all
`cp -i file dest` → interactive
`cp -u *.txt backup/` → only newer
`cp -v file dest` → verbose

---

## mv
`mv old new` → rename
`mv file /tmp/` → move
`mv -i file dest` → ask before overwrite
`mv *.log logs/` → multiple
`mv -t dest/ f1 f2 f3` → target first

---

## rm
`rm file` → delete
`rm -i file` → confirm
`rm -f file` → force
`rm file1 file2` → multiple
`rm *.tmp` → wildcard suffix
`rm backup-*` → prefix
`rm *old*` → contains
`rm file{1,2,3}.txt` → brace
`rm -r dir` → recursive
`rm -rf dir` → force recursive

---

## rmdir
`rmdir empty/` → removes only if empty
`find . -type d -empty -delete` → remove all empty

---

## Loops
`for f in *.jpg; do cp "$f" /backup/; done`
`for f in *.txt; do mv "$f" "old-$f"; done`
`for f in *.txt; do cp "$f" "${f%.txt}.bak"; done`

**Safe with spaces:**
`find . -name "*.mp4" -print0 | while IFS= read -r -d '' f; do mv "$f" /dest/; done`

---

## install
`install -m 755 script.sh /usr/local/bin/` → copy with mode
