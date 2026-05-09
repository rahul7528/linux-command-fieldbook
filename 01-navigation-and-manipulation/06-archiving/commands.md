# 06 - Archiving - Command Reference

Complete tar, gzip, zip commands with outputs.

---

## tar create
**Command:** `tar -cvf archive.tar folder/`
**Output:**
```
folder/
folder/file1.txt
folder/file2.txt
```
Creates uncompressed archive

**Verify:** `ls -lh archive.tar`

---

## tar extract
**Command:** `tar -xvf archive.tar`
**Output:** same file list
Extracts to current directory

---

## tar list
**Command:** `tar -tvf archive.tar`
**Output:**
```
drwxr-xr-x rahul/rahul 0 2024-05-09 12:00 folder/
-rw-r--r-- rahul/rahul 15 2024-05-09 12:00 folder/file1.txt
```

---

## tar.gz create
**Command:** `tar -czvf archive.tar.gz folder/`
**Output:** same list, file is compressed
**Check size:** `du -h archive.tar.gz`

---

## tar.gz extract
**Command:** `tar -xzvf archive.tar.gz`
**Output:** extracts files

**To specific dir:** `tar -xzvf archive.tar.gz -C /tmp`

---

## tar.bz2
**Create:** `tar -cjvf archive.tar.bz2 folder/`
**Extract:** `tar -xjvf archive.tar.bz2`

Smaller than gzip, slower.

---

## tar.xz
**Create:** `tar -cJvf archive.tar.xz folder/`
**Extract:** `tar -xJvf archive.tar.xz`

Best compression.

---

## zip
**Create:** `zip -r archive.zip folder/`
**Output:**
```
adding: folder/ (stored 0%)
adding: folder/file1.txt (deflated 20%)
```

**Extract:** `unzip archive.zip`

**List:** `unzip -l archive.zip`

---

## gzip
**Command:** `gzip file.log`
**Result:** file.log.gz created, original deleted
**Decompress:** `gunzip file.log.gz`

**Keep original:** `gzip -k file.log`

**View:** `zcat file.log.gz | head`

---

## Common patterns
**Backup with exclude:**
`tar -czvf backup.tar.gz --exclude='*.log' --exclude='node_modules' project/`

**Remote backup:**
`tar -czf - /data | ssh backup@server "cat > /backup/data.tar.gz"`

**Verify:**
`tar -tzf backup.tar.gz > /dev/null && echo OK`

**Extract one file:**
`tar -xzvf backup.tar.gz path/to/file.conf`
