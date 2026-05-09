## 03 - Links and Inodes

> Understanding links saves disk space and prevents broken deployments. Every file has a secret ID number called an inode.

## Start With What You Know

In Windows you have shortcuts on Desktop. Delete the original file, shortcut breaks.

Linux has two types:
1. **Hard link** = same file with two names (like two doors to same room)
2. **Symbolic link (symlink)** = shortcut that points to a path (like Windows shortcut)

## The Secret: Inodes

Every file on Linux has an inode number — think of it as an ID card.

```bash
ls -i notes.txt
```
**Output:**
```
1234567 notes.txt
```
1234567 is the inode. The filename is just a label pointing to this ID.

**Check with stat:**
```bash
stat notes.txt
```
**Output:**
```
File: notes.txt
Size: 15
Inode: 1234567
Links: 1
```
Links: 1 means one filename points to this inode.

---

## 1. Hard Links - `ln`

Create a second name for the same file.

```bash
echo "hello" > original.txt
ln original.txt hardlink.txt
```

**Check:**
```bash
ls -li original.txt hardlink.txt
```
**Output:**
```
1234567 -rw-r--r-- 2 rahul rahul 6 May 9 12:00 original.txt
1234567 -rw-r--r-- 2 rahul rahul 6 May 9 12:00 hardlink.txt
```

Notice:
- Same inode number 1234567
- Links count is now 2
- Both files show same size

**What happens:**
```bash
echo "world" >> hardlink.txt
cat original.txt
```
Output: hello world — because it's the same file.

**Delete original:**
```bash
rm original.txt
cat hardlink.txt
```
Still works. Data stays until all links are deleted.

**Rules for hard links:**
- Cannot link directories (prevents loops)
- Cannot cross filesystems (both must be on same disk)
- No extra disk space used

**Use case:** Keep same config file in two places without copying.

---

## 2. Symbolic Links - `ln -s`

Create a shortcut that points to a path.

```bash
ln -s /var/log/nginx/access.log ~/nginx-log
```

**Check:**
```bash
ls -l ~/nginx-log
```
**Output:**
```
lrwxrwxrwx 1 rahul rahhul 25 May 9 12:01 nginx-log -> /var/log/nginx/access.log
```
`l` at start means link. Arrow shows target.

**Read through link:**
```bash
cat ~/nginx-log
```
Shows log file contents.

**What if target deleted:**
```bash
rm /var/log/nginx/access.log
cat ~/nginx-log
```
Output: No such file or directory — broken link.

**Check broken links:**
```bash
find ~ -xtype l
```

**Rules for symlinks:**
- Can link directories
- Can cross filesystems
- Can point to non-existent files
- Uses tiny bit of space (stores path text)

**Use case:** Link /opt/app/current to /opt/app/v2.3.1 for zero-downtime deployments.

---

## Key Commands

| Command | Purpose |
|---------|---------|
| `ls -i` | Show inode numbers |
| `stat file` | Show inode, links, size |
| `ln source link` | Create hard link |
| `ln -s target link` | Create symlink |
| `readlink -f link` | Show absolute target path |
| `unlink link` | Delete link (safe) |
| `find . -inum 1234567` | Find all hard links to inode |

---

## Real Problems

**Problem 1: "Disk full but du shows space free"**
```bash
df -h  # shows 100%
du -sh /*  # shows only 50% used
```
Cause: Deleted file still open by process. File has no name but inode still used.
Fix:
```bash
lsof | grep deleted
```
Restart process to free inode.

**Problem 2: "Deployment broke after update"**
You had: `ln -s /opt/app/v1 current`
After update, you did `rm -rf /opt/app/v1`
Now `current` is broken.
Fix: Create new symlink first, then delete old:
```bash
ln -sfn /opt/app/v2 current
```

**Problem 3: "Find all copies of this file"**
```bash
ls -i important.conf
# get inode 987654
find / -inum 987654 2>/dev/null
```
Finds every hard link, even if renamed.

**Problem 4: "Is this a link or real file?"**
```bash
ls -l config
```
If starts with `l` and shows `->`, it's symlink. Use `readlink -f config` to see real path.

---

## Hard Link vs Symlink

| Feature | Hard Link | Symlink |
|---------|-----------|---------|
| Same inode | Yes | No |
| Works after original deleted | Yes | No (breaks) |
| Cross disks | No | Yes |
| Link directories | No | Yes |
| Size | 0 extra | stores path |
| Command | `ln` | `ln -s` |

---

## Safety Rules

1. Use symlinks for configs and deployments (easy to update)
2. Use hard links for backups on same disk (saves space)
3. Never `ln` without -s unless you understand inodes
4. Check links before deleting target: `find -L /path -xtype l`
5. In scripts, use `readlink -f` to get real path

---

## What to Remember

- Every file has inode number (`ls -i`)
- Hard link = two names, same data (`ln`)
- Symlink = shortcut to path (`ln -s`)
- Delete original: hard link survives, symlink breaks
- `stat` shows Links count
- `readlink -f` resolves symlink chain

Understand inodes and you understand how Linux really stores files.

---
Next: 04 - Permissions Basics (chmod, chown)
