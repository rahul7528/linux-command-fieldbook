## 07 - Finding and Inspecting Files

> You can't manipulate what you can't find. Learn to locate any file in seconds, filter by anything, and know what it is before you open it.

## How `find` Works - Syntax

```bash
find [where] [conditions] [actions]
```

- **where** = starting folder (`.` for current, `/` for whole system)
- **conditions** = what to match (-name, -type, -size, -mtime)
- **actions** = what to do (-print, -delete, -exec)

**Example breakdown:**
```bash
find /var/log -type f -name "*.log" -mtime -7 -size +1M
```
Find in /var/log, files only, named *.log, modified in last 7 days, larger than 1MB.

---

## 1. Find by Name - Prefix and Suffix

**Suffix (ends with):**
```bash
find . -name "*.txt"
find . -name "*backup*"
```

**Prefix (starts with):**
```bash
find . -name "config-*"
find . -name "2024-*"
```

**Exact and patterns:**
```bash
find . -name "file?.txt"    # file1.txt, fileA.txt
find . -iname "*.JPG"       # case-insensitive
```

---

## 2. Find by Type - File or Directory

```bash
find . -type f    # files only
find . -type d    # directories only
find . -type l    # symlinks only
```

**Combine:**
```bash
find /etc -type f -name "*.conf"
```

---

## 3. Find and Delete Files

**Delete multiple files at once:**
```bash
find . -name "*.tmp" -delete
```

**Safer - see first, then delete:**
```bash
find . -name "*.bak"
find . -name "*.bak" -delete
```

**With exec (more control):**
```bash
find . -name "*.log" -exec rm -v {} \;
```
`{}` = each file, `\;` ends command

**Delete with confirmation:**
```bash
find . -name "*.tmp" -ok rm {} \;
```

---

## 4. Find Empty Files and Directories

**Empty files:**
```bash
find . -type f -empty
```

**Empty directories:**
```bash
find . -type d -empty
```

**Remove empty directories:**
```bash
find . -type d -empty -delete
```

**Remove empty files:**
```bash
find . -type f -empty -delete
```

---

## 5. Find by Size

```bash
find . -size +100M      # larger than 100MB
find . -size -10k       # smaller than 10KB
find . -size 0          # exactly 0 bytes (empty)
```

**Units:** c=bytes, k=KB, M=MB, G=GB

**Find big files and sort:**
```bash
find / -type f -size +500M -exec ls -lh {} \; 2>/dev/null | sort -k5 -hr
```

---

## 6. Find by Date - Modified, Accessed, Created

Linux tracks three times:
- **mtime** = modified (content changed)
- **atime** = accessed (read)
- **ctime** = changed (metadata, closest to "created")

```bash
find . -mtime -7      # modified in last 7 days
find . -mtime +30     # modified more than 30 days ago
find . -mtime 0       # modified today

find . -mmin -60      # modified in last 60 minutes
find . -atime -1      # accessed in last day
```

**Date range:**
```bash
find . -type f -newermt "2024-05-01" ! -newermt "2024-05-10"
```
Files modified between May 1 and May 10.

---

## 7. Find by Permission

```bash
find . -perm 777              # exact permission
find . -perm -4000            # setuid files
find . -type f -perm /111     # executable by anyone
find . -type f ! -perm 644    # not 644
```

---

## 8. Removing Multiple Files - Different Methods

**Method 1 - Wildcards (fastest):**
```bash
rm *.tmp *.bak
```

**Method 2 - Brace expansion:**
```bash
rm file{1,2,3}.txt
rm backup-{jan,feb,mar}.tar.gz
```

**Method 3 - Prefix/Suffix:**
```bash
rm prefix-*      # all starting with prefix-
rm *-suffix.log  # all ending with -suffix.log
```

**Method 4 - Find (safest for thousands):**
```bash
find . -name "*.cache" -delete
find . -name "temp-*" -mtime +7 -delete
```

---

## 9. Loops with cp and mv

**Loop with cp - copy multiple with pattern:**
```bash
for f in *.jpg; do cp "$f" /backup/images/; done
```

**Loop with mv - rename with prefix:**
```bash
for f in *.txt; do mv "$f" "archive-$f"; done
```

**Loop with find results:**
```bash
for f in $(find . -name "*.log" -mtime +30); do
  gzip "$f"
done
```

**Safer with while (handles spaces):**
```bash
find . -name "*.mp4" -print0 | while IFS= read -r -d '' f; do
  mv "$f" /videos/
done
```

---

## 10. `locate` - Instant Name Search

```bash
sudo updatedb
locate nginx.conf
locate -i "*.pdf" | head -10
```

Faster than find, but doesn't filter by date/size.

---

## 11. `grep` - Find Inside Files

find locates files, grep searches content.

```bash
grep "error" /var/log/syslog
grep -r "TODO" project/          # recursive
grep -i "warning" *.log          # case-insensitive
grep -l "password" *             # list filenames only
```

**Combine find + grep:**
```bash
find . -name "*.conf" -exec grep -l "port 8080" {} \;
```
Finds .conf files containing "port 8080"

---

## 12. `basename`, `dirname`, `file`

**basename - get filename:**
```bash
basename /var/log/nginx/access.log
# Output: access.log

basename /var/log/nginx/access.log .log
# Output: access
```

**dirname - get folder:**
```bash
dirname /var/log/nginx/access.log
# Output: /var/log/nginx
```

**file - identify type:**
```bash
file mystery
# Output: PNG image data
file script.sh
# Output: Bourne-Again shell script
```

---

## 13. `which`, `whereis`, `type`

```bash
which python3        # /usr/bin/python3
whereis nginx         # binary, config, man
type ls               # shows alias
type cd               # shows builtin
```

---

## Real Examples - Putting It Together

**Clean logs older than 30 days:**
```bash
find /var/log -name "*.log" -mtime +30 -delete
```

**Find and compress big files:**
```bash
find . -type f -size +100M -exec gzip {} \;
```

**Remove empty dirs recursively:**
```bash
find . -type d -empty -delete
```

**Find files you edited today and backup:**
```bash
find . -type f -mtime 0 -exec cp {} /backup/today/ \;
```

**Find executable files that are world-writable (security):**
```bash
find / -type f -perm -002 -executable 2>/dev/null
```

---

## What to Remember

- find syntax: where → conditions → actions
- -name for prefix/suffix, -type f/d, -size, -mtime
- -delete for quick removal, -exec for complex actions
- -empty finds empty files and dirs
- Use wildcards or brace for simple deletes, find for complex
- Loops: `for f in *.txt; do cp "$f" dest/; done`
- grep searches inside files, find searches filenames
- basename/dirname parse paths, file identifies types

Master find and you control the filesystem.
