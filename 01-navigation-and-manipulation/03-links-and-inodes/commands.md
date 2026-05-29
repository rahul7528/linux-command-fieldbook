# 03 - Links and Inodes - Command Reference
<br/>
Complete reference for inodes, hard links, and symlinks.
<br/>
---<br/>
<br/>
## ls -i
**Command:** `ls -i file.txt`<br/>
**Output:** `1234567 file.txt`<br/>
**Meaning:** Shows inode number. Same number = same file data.<br/>

**With multiple:**
```bash
ls -li file1 file2
```
Output shows inode in first column.<br/>
<br/>
---<br/>
<br/>
## stat<br/>
**Command:** `stat original.txt`<br/>
**Output:**<br/>
```
File: original.txt
Size: 6
Blocks: 8
Inode: 1234567
Links: 2
Access: 2024-05-09
```
**Key fields:**<br/>
- Inode: unique ID<br/>
- Links: how many filenames point here<br/>
- Size: actual data size
<br/>
After creating hard link, Links becomes 2.<br/>
<br/>
---<br/>
<br/>
## ln (hard link)<br/>
**Command:** `ln source.txt hard.txt`<br/>
**Verify:**<br/>
```bash
ls -li source.txt hard.txt
```
**Output:** both show same inode, Links: 2<br/>
<br/>
**Behavior:**<br/>
- Edit hard.txt → source.txt changes<br/>
- rm source.txt → hard.txt still works<br/>
- Disk usage unchanged (`du` shows same total)<br/>
<br/>
**Error - cross filesystem:**<br/>
```bash
ln /tmp/a /home/b
```
Output: `Invalid cross-device link`<br/>
Hard links cannot cross disks.<br/>
<br/>
**Error - directories:**<br/>
```bash
ln /etc /tmp/etc-link
```
Output: `hard link not allowed for directory`<br/>
<br/>
---<br/>
<br/>
## ln -s (symlink)<br/>
**Command:** `ln -s /var/log/syslog mylog`<br/>
**Verify:** `ls -l mylog`<br/>
**Output:** `lrwxrwxrwx 1 ... mylog -> /var/log/syslog`<br/>

**l** = link type, arrow shows target<br/>
<br/>
**Read:** `cat mylog` reads target file<br/>
<br/>
**Absolute vs relative:**<br/>
- `ln -s /full/path link` → works from anywhere<br/>
- `ln -s ../file link` → breaks if you move link<br/>
<br/>
Best practice: use absolute paths for system links.<br/>
<br/>
**Broken link:**<br/>
After deleting target:<br/>
```bash
ls -l mylog
```
Shows red flashing, target missing<br/>
`cat mylog` → No such file or directory<br/>
<br/>
**Find broken:**<br/>
```bash
find . -xtype l
```
<br/>
---<br/>
<br/>
## readlink<br/>
**Command:** `readlink mylog`<br/>
**Output:** `/var/log/syslog`<br/>
<br/>
Follows chain to final file:<br/>
```bash
readlink -f mylog
```
Output: `/var/log/syslog` (absolute)<br/>

Use in scripts to get real path.<br/>
<br/>
---<br/>
<br/>
## unlink<br/>
**Command:** `unlink mylog`<br/>
Deletes symlink only, never target. Safer than `rm` for links.<br/>
<br/>
---<br/>
<br/>
## find by inode<br/>
**Command:** `find /home -inum 1234567 2>/dev/null`<br/>
Finds all hard links to that inode. Useful for cleanup.<br/>
<br/>
**find same file:**<br/>
```bash
find / -samefile original.txt 2>/dev/null
```
Same as -inum but easier.<br/>
<br/>
---<br/>
<br/>
## Common Questions<br/>

**Q: How to tell link type?**<br/>
`ls -l` → first char l = symlink, - = regular file. Check Links count in stat for hard links.<br/>
<br/>
**Q: Which uses more space?**<br/>
Hard link: 0 bytes extra. Symlink: about length of path (20-50 bytes).<br/>
<br/>
**Q: Can I hard link a symlink?**<br/>
Yes, but you link to the symlink file itself, not target. Rarely useful.<br/>
<br/>
**Q: Why Links count 2 for directories?**<br/>
Every directory has . (self) and .. entries. That's why new empty dir shows Links: 2.<br/>
