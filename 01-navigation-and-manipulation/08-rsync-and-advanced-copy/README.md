## 08 - Rsync and Advanced Copy

> cp is for local quick copies. rsync is for real work — backups, servers, resumes, and keeping folders in sync.

## 1. `rsync` - The Better cp

**Basic local copy:**
```bash
rsync -avh source/ dest/
```
- `-a` = archive (preserves permissions, times, symlinks)
- `-v` = verbose
- `-h` = human-readable sizes
- Trailing `/` on source matters: `source/` copies contents, `source` copies folder

**Output:**
```
sending incremental file list
file1.txt
file2.txt
sent 200 bytes
```

### Why rsync beats cp
- Copies only changed files (fast)
- Can resume interrupted transfers
- Works over SSH
- Shows progress
- Can delete extra files to mirror

### Remote copy (over SSH)
```bash
rsync -avh project/ user@server:/backup/project/
```

**With progress bar:**
```bash
rsync -avh --progress bigfile.iso user@server:/tmp/
```

### Mirror and delete
```bash
rsync -avh --delete source/ dest/
```
Deletes files in dest that don't exist in source. Perfect for backups.

**Dry run first:**
```bash
rsync -avh --delete --dry-run source/ dest/
```
Shows what would happen, doesn't delete.

### Exclude patterns
```bash
rsync -avh --exclude='*.log' --exclude='node_modules/' source/ dest/
```

### Resume partial transfer
```bash
rsync -avh --partial --progress bigfile user@server:/tmp/
```
--partial keeps partial files if interrupted.

---

## 2. `scp` - Simple SSH copy

For one-off copies, scp is simpler than rsync.

**Copy to server:**
```bash
scp file.txt user@server:/tmp/
```

**Copy folder:**
```bash
scp -r project/ user@server:/home/user/
```

**Copy from server:**
```bash
scp user@server:/var/log/nginx/access.log .
```

**Different port:**
```bash
scp -P 2222 file.txt user@server:/tmp/
```

**When to use scp vs rsync:** scp for single files, rsync for folders and resumes.

---

## 3. `mktemp` - Safe temporary files

Never use fixed /tmp names in scripts. Use mktemp.

**Create temp file:**
```bash
tmp=$(mktemp)
echo "data" > "$tmp"
```
Output: `/tmp/tmp.abc123`

**Create temp directory:**
```bash
tmpdir=$(mktemp -d)
cd "$tmpdir"
```

**With template:**
```bash
mktemp /tmp/myapp.XXXXXX
```

**Auto cleanup in script:**
```bash
tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT
```

---

## 4. `truncate` - Resize files instantly

Create or shrink files without editor.

**Create 1GB file:**
```bash
truncate -s 1G test.img
```

**Shrink log to 0:**
```bash
truncate -s 0 /var/log/app.log
```
Faster than `> file`, keeps inode.

**Extend file:**
```bash
truncate -s +100M data.bin
```

---

## 5. `shred` - Secure delete

rm only removes directory entry. shred overwrites data first.

```bash
shred -u secret.txt
```
- Overwrites 3 times by default
- `-u` = remove after shredding

**More passes:**
```bash
shred -u -n 10 -z passwords.txt
```
-n 10 = 10 passes, -z = final overwrite with zeros

**Warning:** Doesn't work reliably on SSDs or journaled filesystems. For SSDs, use encryption + key deletion.

---

## 6. `rename` - Bulk rename

Ubuntu/Debian has perl rename.

**Change extension:**
```bash
rename 's/\.txt$/.md/' *.txt
```

**Add prefix:**
```bash
rename 's/^/backup-/' *.log
```

**Replace spaces:**
```bash
rename 's/ /_/g' *
```

**Dry run:**
```bash
rename -n 's/\.jpeg$/.jpg/' *
```
-n shows what would happen.

**On systems without perl rename, use loop:**
```bash
for f in *.txt; do mv "$f" "${f%.txt}.md"; done
```

---

## Real Problems

**Problem 1: Backup home to external drive**
```bash
rsync -avh --progress --delete --exclude='.cache' /home/rahul/ /mnt/backup/
```

**Problem 2: Sync to server nightly**
```bash
rsync -avh -e "ssh -p 2222" --delete project/ user@server:/var/www/
```

**Problem 3: Copy only changed files**
```bash
rsync -avh --update src/ dest/
```
--update skips files that are newer on destination

**Problem 4: Create temp work dir in script**
```bash
work=$(mktemp -d)
cd "$work"
# do work
rm -rf "$work"
```

**Problem 5: Clear logs without restarting service**
```bash
truncate -s 0 /var/log/nginx/access.log
```
Service keeps writing, no restart needed.

---

## What to Remember

- rsync -avh for everything, add --delete for mirrors
- Always --dry-run first when using --delete
- scp for quick single files, rsync for folders
- mktemp for safe scripts
- truncate for instant resize
- shred -u for sensitive files (not SSD)
- rename for bulk renames, or use for loop

These tools turn basic copy/move into production-ready workflows.

---
Next: Update 02-files-and-folders with loops
