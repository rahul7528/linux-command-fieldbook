## 02 - Files and Folders

> Creating, copying, moving, deleting. These are the commands you will use 100 times a day. Learn them right and you won't delete production.

## Start With What You Know

In Windows:
- Right-click > New Folder = mkdir
- Right-click > New Text File = touch
- Ctrl+C, Ctrl+V = cp
- Drag and drop = mv
- Delete key = rm

Linux does the same, but with text commands that work on servers without a mouse.

## The 5 Core Commands

### 1. `mkdir` - Make Directory

Create folders.

```bash
mkdir projects
```

**Create nested folders in one go:**
```bash
mkdir -p projects/linux/logs
```
**Why -p matters:** Without -p, mkdir fails if parent doesn't exist. With -p, it creates the whole path. Always use -p in scripts.

**Output:** No output if successful. Verify with `ls`.

---

### 2. `touch` - Create empty file or update time

```bash
touch notes.txt
```

**What it really does:** Creates file if missing, updates last-modified time if exists.

**Create multiple:**
```bash
touch file1.txt file2.txt file3.txt
```

**Why use it:** Quick way to create placeholder files for testing. Also used to "touch" a file to make backup tools think it's new.

---

### 3. `cp` - Copy

**Copy file:**
```bash
cp notes.txt notes-backup.txt
```

**Copy to folder:**
```bash
cp notes.txt /tmp/
```

**Copy folder (needs -r):**
```bash
cp -r projects projects-backup
```
**Why -r:** r = recursive. Copies folder and everything inside. Without -r, cp fails on directories.

**Safe copy flags you should always use:**
```bash
cp -iv notes.txt /backup/
```
- `-i` = interactive, asks before overwriting
- `-v` = verbose, shows what it's doing

**Output with -v:**
```
'notes.txt' -> '/backup/notes.txt'
```

**Update only newer files:**
```bash
cp -u *.log /backup/
```
-u copies only if source is newer. Perfect for backups.

---

### 4. `mv` - Move or Rename

Same command does both.

**Rename:**
```bash
mv oldname.txt newname.txt
```

**Move:**
```bash
mv newname.txt /tmp/
```

**Move multiple to folder:**
```bash
mv file1.txt file2.txt projects/
```

**Safe move:**
```bash
mv -i important.txt /backup/
```
-i asks before overwriting. Use this always for important files.

**Why mv is instant:** It doesn't copy data, just changes the directory entry. Even 10GB files move instantly on same disk.

---

### 5. `rm` - Remove (Delete)

**Delete file:**
```bash
rm notes.txt
```

**Delete folder and everything inside:**
```bash
rm -r projects/
```
-r = recursive. Required for folders.

**Force delete without asking:**
```bash
rm -rf /tmp/old-data
```
**DANGER:** -f = force, never asks. rm -rf is the command that deletes production. Never type rm -rf / or rm -rf ~ by mistake.

**Safe delete:**
```bash
rm -i *.txt
```
-i asks for each file. Use when unsure.

**Empty folder only:**
```bash
rmdir empty-folder
```
rmdir only works if folder is empty. Safer than rm -r.

---

## Pro Moves

### 1. `cp -a` - Archive copy (preserves everything)
```bash
cp -a /etc/nginx /backup/nginx-2024-05-09
```
-a = archive. Keeps permissions, timestamps, symlinks. Use for backups.

### 2. `mv` with backup
```bash
mv --backup=numbered config.conf config.conf.new
```
Creates config.conf.~1~ automatically. Never lose old version.

### 3. `install` - Copy with permissions
```bash
install -m 755 script.sh /usr/local/bin/
```
Copies and sets executable permission in one command. Better than cp + chmod.

### 4. Check before deleting
```bash
ls -lh /tmp/old-data
du -sh /tmp/old-data
rm -ri /tmp/old-data
```
Always ls and du first. -i makes rm ask each time.

---

## Real Problems You Will Face

**Problem 1: "I need same folder structure on 10 servers"**
```bash
mkdir -p /opt/app/{logs,config,data}
```
Creates three subfolders in one command. Braces expand.

**Problem 2: "I copied but permissions broke"**
```bash
cp -a source/ dest/
```
Use -a not -r for configs and scripts. Preserves executable bit.

**Problem 3: "I accidentally overwrote file"**
Prevention:
```bash
alias cp='cp -i'
alias mv='mv -i'
```
Add to ~/.bashrc. Now cp and mv always ask.

**Problem 4: "How to delete everything except one file?"**
```bash
ls | grep -v keep.txt | xargs rm
```
Or safer: move keep.txt away, rm -r *, move back.

**Problem 5: "rm -rf stuck, is it working?"**
```bash
rm -rv /big-folder
```
-v shows each file as deleted. You see progress.

---

## Safety Rules

1. Never run rm -rf as root unless you typed the path twice
2. Always use `ls` on the path first
3. Use `rm -i` for important folders
4. For scripts, use `rm -rf "$VAR"/` with quotes, never `rm -rf $VAR/`
5. Test with `echo rm -rf /path` first

---

## What to Remember

- `mkdir -p` creates full path
- `cp -r` for folders, `cp -iv` for safety
- `mv` renames instantly
- `rm -r` deletes folders, `rm -rf` is dangerous
- `rmdir` only for empty folders
- Always ls before rm

Master these and you can build and clean any project structure.

---
Next: 03 - Viewing and Editing Files (cat, less, head, tail, nano)
