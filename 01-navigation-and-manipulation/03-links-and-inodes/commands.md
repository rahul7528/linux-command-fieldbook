# 03 - Links and Inodes - Command Reference

Complete reference for inodes, hard links, and symlinks.

---

## ls -i
**Command:** `ls -i file.txt`
**Output:** `1234567 file.txt`
**Meaning:** Shows inode number. Same number = same file data.

**With multiple:**
```bash
ls -li file1 file2
```
Output shows inode in first column.

---

## stat
**Command:** `stat original.txt`
**Output:**
```
File: original.txt
Size: 6
Blocks: 8
Inode: 1234567
Links: 2
Access: 2024-05-09
```
**Key fields:**
- Inode: unique ID
- Links: how many filenames point here
- Size: actual data size

After creating hard link, Links becomes 2.

---

## ln (hard link)
**Command:** `ln source.txt hard.txt`
**Verify:**
```bash
ls -li source.txt hard.txt
```
**Output:** both show same inode, Links: 2

**Behavior:**
- Edit hard.txt → source.txt changes
- rm source.txt → hard.txt still works
- Disk usage unchanged (`du` shows same total)

**Error - cross filesystem:**
```bash
ln /tmp/a /home/b
```
Output: `Invalid cross-device link`
Hard links cannot cross disks.

**Error - directories:**
```bash
ln /etc /tmp/etc-link
```
Output: `hard link not allowed for directory`

---

## ln -s (symlink)
**Command:** `ln -s /var/log/syslog mylog`
**Verify:** `ls -l mylog`
**Output:** `lrwxrwxrwx 1 ... mylog -> /var/log/syslog`

**l** = link type, arrow shows target

**Read:** `cat mylog` reads target file

**Absolute vs relative:**
- `ln -s /full/path link` → works from anywhere
- `ln -s ../file link` → breaks if you move link

Best practice: use absolute paths for system links.

**Broken link:**
After deleting target:
```bash
ls -l mylog
```
Shows red flashing, target missing
`cat mylog` → No such file or directory

**Find broken:**
```bash
find . -xtype l
```

---

## readlink
**Command:** `readlink mylog`
**Output:** `/var/log/syslog`

**readlink -f**
Follows chain to final file:
```bash
readlink -f mylog
```
Output: `/var/log/syslog` (absolute)

Use in scripts to get real path.

---

## unlink
**Command:** `unlink mylog`
Deletes symlink only, never target. Safer than `rm` for links.

---

## find by inode
**Command:** `find /home -inum 1234567 2>/dev/null`
Finds all hard links to that inode. Useful for cleanup.

**find same file:**
```bash
find / -samefile original.txt 2>/dev/null
```
Same as -inum but easier.

---

## Common Questions

**Q: How to tell link type?**
`ls -l` → first char l = symlink, - = regular file. Check Links count in stat for hard links.

**Q: Which uses more space?**
Hard link: 0 bytes extra. Symlink: about length of path (20-50 bytes).

**Q: Can I hard link a symlink?**
Yes, but you link to the symlink file itself, not target. Rarely useful.

**Q: Why Links count 2 for directories?**
Every directory has . (self) and .. entries. That's why new empty dir shows Links: 2.
