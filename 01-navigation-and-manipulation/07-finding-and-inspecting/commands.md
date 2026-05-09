# 07 - Finding and Inspecting - Complete Reference

---

## find syntax
`find [path] [tests] [actions]`
Example: `find . -type f -name "*.log" -mtime -7`

---

## Find by name (prefix/suffix)
`find . -name "*.txt"` → suffix .txt
`find . -name "backup-*"` → prefix backup-
`find . -name "*2024*"` → contains 2024
`find . -iname "*.JPG"` → case-insensitive

---

## Find by type
`find . -type f` → files
`find . -type d` → directories
`find . -type l` → symlinks

---

## Find and delete
`find . -name "*.tmp" -delete`
`find . -name "*.bak" -exec rm -v {} \;`
`find . -name "*.log" -ok rm {} \;` → prompts

---

## Find empty
`find . -type f -empty` → empty files
`find . -type d -empty` → empty dirs
`find . -type d -empty -delete` → remove empty dirs

---

## Find by size
`find . -size +100M` → >100MB
`find . -size -1k` → <1KB
`find . -size 0` → empty

---

## Find by date
`find . -mtime -7` → modified last 7 days
`find . -mtime +30` → older than 30 days
`find . -mmin -60` → last 60 minutes
`find . -atime -1` → accessed yesterday
`find . -ctime -1` → metadata changed

**Range:** `find . -newermt "2024-01-01" ! -newermt "2024-02-01"`

---

## Find by permission
`find . -perm 644`
`find . -perm -4000` → setuid
`find . -type f -perm /111` → executable

---

## Remove multiple methods
`rm *.log *.tmp` → wildcards
`rm file{1..10}.txt` → brace
`rm prefix-* *-suffix` → prefix/suffix
`find . -name "*.cache" -delete` → find

---

## Loops with cp/mv
`for f in *.jpg; do cp "$f" /backup/; done`
`for f in *.txt; do mv "$f" archive/; done`
`find . -name "*.log" -print0 | while IFS= read -r -d '' f; do gzip "$f"; done`

---

## locate
`sudo updatedb`
`locate nginx.conf`
`locate -l 5 "*.conf"`

---

## grep
`grep "error" file.log`
`grep -r "TODO" src/`
`grep -i "fail" *.log`
`grep -l "password" *`
`find . -name "*.conf" -exec grep -l "8080" {} \;`

---

## basename / dirname / file
`basename /a/b/c.txt` → c.txt
`basename /a/b/c.txt .txt` → c
`dirname /a/b/c.txt` → /a/b
`file document` → type

---

## which / whereis / type
`which python` → path
`whereis python` → binary, man
`type ls` → alias or builtin
