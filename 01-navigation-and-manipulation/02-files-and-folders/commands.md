# 02 - Files and Folders - Command Reference

Every create, copy, move, delete command with output and safety notes.

---

## mkdir
**Command:** `mkdir projects`
**Output:** (none, check with ls)
**Verify:** `ls -ld projects` → `drwxr-xr-x 2 rahul rahul 4096 May 9 11:00 projects`

**mkdir -p**
**Command:** `mkdir -p a/b/c`
**Output:** Creates a, a/b, a/b/c even if none exist
**Use:** Scripts, nested structures

---

## touch
**Command:** `touch file.txt`
**Output:** (none)
**Verify:** `ls -l file.txt` → `-rw-r--r-- 1 rahul rahul 0 May 9 11:01 file.txt`
**Size 0** means empty file created

**Update time:**
```bash
touch file.txt
```
Second run updates timestamp, doesn't delete content

---

## cp
**Basic file:**
**Command:** `cp file.txt backup.txt`
**Verify:** both files exist, same size

**cp -v**
**Output:** `'file.txt' -> 'backup.txt'`

**cp -r folder**
**Command:** `cp -r projects projects2`
**Output with -v:** lists every file copied

**cp -i (interactive)**
**Command:** `cp -i file.txt backup.txt`
**If backup exists:** `cp: overwrite 'backup.txt'? y`
**Safety:** prevents accidental overwrite

**cp -u**
Copies only if source newer. No output if skipped.

**cp -a**
**Command:** `cp -a /etc/nginx ~/backup`
Preserves permissions, owner, timestamps, symlinks
**Check:** `ls -l` shows same permissions as original

---

## mv
**Rename:**
**Command:** `mv old.txt new.txt`
**Output:** (none)
**Verify:** old.txt gone, new.txt exists

**Move:**
**Command:** `mv new.txt /tmp/`
**Verify:** `ls /tmp/new.txt`

**mv -i**
**If target exists:** `mv: overwrite '/tmp/new.txt'?`
**Use always** for important files

**mv -v**
**Output:** `renamed 'old.txt' -> 'new.txt'`

---

## rm
**File:**
**Command:** `rm file.txt`
**Output:** (none)
**Danger:** No trash, file is gone

**rm -i**
**Command:** `rm -i *.txt`
**Output:** `rm: remove regular file 'a.txt'?`
Type y for each

**rm -r folder**
**Command:** `rm -r projects/`
Deletes folder and all contents

**rm -rf**
**Command:** `rm -rf /tmp/test`
**No output, no asking.** Most dangerous command in Linux.

**Safety check:**
```bash
ls /tmp/test
rm -ri /tmp/test
```

**rmdir**
**Command:** `rmdir empty/`
**If not empty:** `rmdir: failed to remove 'empty/': Directory not empty`
Safer than rm -r because it refuses non-empty

---

## Pro commands

**install**
**Command:** `install -m 755 script.sh /usr/local/bin/script`
**Output:** (none)
**Verify:** `ls -l /usr/local/bin/script` → `-rwxr-xr-x` (755)
Does cp + chmod in one

**stat**
**Command:** `stat file.txt`
**Output:**
```
File: file.txt
Size: 0  Blocks: 0
Access: 2024-05-09 11:01:00
Modify: 2024-05-09 11:01:00
```
Shows timestamps touch updates

---

## Common Errors

**cp: omitting directory**
Cause: forgot -r
Fix: `cp -r source dest`

**rm: cannot remove: Permission denied**
Cause: not owner or file is write-protected
Fix: `sudo rm` or `chmod u+w file`

**mv: target is not a directory**
Cause: `mv file1 file2 file3` without destination folder
Fix: `mv file1 file2 file3 dest-folder/`

**mkdir: File exists**
Cause: folder already there
Fix: use `mkdir -p` which ignores existing
