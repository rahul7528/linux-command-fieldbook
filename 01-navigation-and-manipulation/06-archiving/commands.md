# 06 - Archiving - Command Reference

Complete tar, gzip, zip commands with outputs.

---

## tar create
**Command:** `tar -cvf archive.tar folder/`<br/>
**Output:**
```
folder/
folder/file1.txt
folder/file2.txt
```
Creates uncompressed archive<br/>

**Verify:** `ls -lh archive.tar`<br/>

---

## tar extract<br/>
**Command:** `tar -xvf archive.tar`<br/>
**Output:** same file list<br/>
Extracts to current directory<br/>
<br/>
---<br/>
<br/>
## tar list<br/>
**Command:** `tar -tvf archive.tar`<br/>
**Output:**
```
drwxr-xr-x rahul/rahul 0 2024-05-09 12:00 folder/
-rw-r--r-- rahul/rahul 15 2024-05-09 12:00 folder/file1.txt
```
<br/>
---<br/>
<br/>
## tar.gz create<br/>
**Command:** `tar -czvf archive.tar.gz folder/`
**Output:** same list, file is compressed<br/>
**Check size:** `du -h archive.tar.gz`<br/>
<br/>
---<br/>
<br/>
## tar.gz extract<br/>
**Command:** `tar -xzvf archive.tar.gz`<br/>
**Output:** extracts files<br/>
<br/>
**To specific dir:** `tar -xzvf archive.tar.gz -C /tmp`<br/>
<br/>
---<br/>
<br/>
## tar.bz2<br/>
**Create:** `tar -cjvf archive.tar.bz2 folder/`<br/>
**Extract:** `tar -xjvf archive.tar.bz2`<br/>

Smaller than gzip, slower.<br/>
<br/>
---<br/>
<br/>
## tar.xz
**Create:** `tar -cJvf archive.tar.xz folder/`<br/>
**Extract:** `tar -xJvf archive.tar.xz`<br/>

Best compression.
<br/>
---<br/>
<br/>
## zip
**Create:** `zip -r archive.zip folder/`<br/>
**Output:**
```
adding: folder/ (stored 0%)
adding: folder/file1.txt (deflated 20%)
```

**Extract:** `unzip archive.zip`<br/>
<br/>
**List:** `unzip -l archive.zip`<br/>
<br/>
---<br/><br/>
<br/>
## gzip<br/>
**Command:** `gzip file.log`<br/>
**Result:** file.log.gz created, original deleted<br/>
**Decompress:** `gunzip file.log.gz`<br/>

**Keep original:** `gzip -k file.log`<br/>

**View:** `zcat file.log.gz | head`<br/>
<br/>
---<br/><br/>
<br/>
## Common patterns<br/>
**Backup with exclude:**<br/>
`tar -czvf backup.tar.gz --exclude='*.log' --exclude='node_modules' project/`<br/>

**Remote backup:**<br/>
`tar -czf - /data | ssh backup@server "cat > /backup/data.tar.gz"`<br/>

**Verify:**<br/>
`tar -tzf backup.tar.gz > /dev/null && echo OK`<br/>

**Extract one file:**<br/>
`tar -xzvf backup.tar.gz path/to/file.conf`<br/>
