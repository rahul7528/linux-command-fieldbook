## 02 - Files and Folders

> Create, copy, move, delete. Master these and you control 80% of daily Linux work.

## 1. Creating

### `mkdir` - make directory
```bash
mkdir project
mkdir -p project/src/project/tests
```
-p creates parent folders, no error if exists.

### `touch` - create empty file or update time
```bash
touch notes.txt
touch file1.txt file2.txt file3.txt
touch -t 202401011200 oldfile.txt   # set specific time
```

---

## 2. Copying

### `cp` - copy files
```bash
cp file.txt backup/
cp file.txt backup/copy.txt
```

**Copy folder:**
```bash
cp -r project/ backup/
```

**Preserve everything:**
```bash
cp -a project/ backup/
```
-a = archive, keeps permissions, times, symlinks

**Interactive (ask before overwrite):**
```bash
cp -i file.txt dest/
```

**Verbose:**
```bash
cp -v *.txt /tmp/
```

---

## 3. Moving and Renaming

`mv` does both.

```bash
mv old.txt new.txt          # rename
mv file.txt /tmp/           # move
mv -i file.txt /tmp/        # ask before overwrite
```

**Move multiple:**
```bash
mv *.log logs/
```

---

## 4. Deleting

### `rm` - remove files
```bash
rm file.txt
rm -i file.txt              # confirm
rm -f file.txt              # force, no error if missing
```

**Delete multiple at once:**
```bash
rm file1.txt file2.txt file3.txt
rm *.tmp *.bak
```

**With prefix and suffix:**
```bash
rm backup-*                 # all starting with backup-
rm *-old.log                # all ending with -old.log
rm *2024*.txt               # contains 2024
```

**With brace expansion:**
```bash
rm file{1,2,3}.txt
rm log-{jan,feb,mar}.txt
```

**Recursive delete folder:**
```bash
rm -r folder/
rm -rf folder/              # force, dangerous
```

### `rmdir` - remove empty directory
```bash
rmdir empty_folder/
```
Fails if not empty. Safer than rm -r.

**Remove empty dirs recursively:**
```bash
find . -type d -empty -delete
```

---

## 5. Loops with cp and mv - Bulk Operations

When wildcards aren't enough, use loops.

**Copy all jpg files to backup:**
```bash
for f in *.jpg; do cp "$f" /backup/images/; done
```

**Move and add prefix:**
```bash
for f in *.txt; do mv "$f" "archive-$f"; done
```

**Copy with renaming:**
```bash
for f in *.txt; do cp "$f" "/backup/${f%.txt}.bak"; done
```
${f%.txt} removes .txt suffix

**Move files by date (using find):**
```bash
for f in $(find . -name "*.log" -mtime +30); do
  mv "$f" /archive/
done
```

**Safe loop (handles spaces):**
```bash
find . -name "*.mp4" -print0 | while IFS= read -r -d '' f; do
  cp "$f" /videos/
done
```

---

## 6. Advanced Copy/Move

**Copy and preserve:**
```bash
cp -av source/ dest/
```

**Copy only newer files:**
```bash
cp -u *.txt /backup/
```

**Move with target directory first:**
```bash
mv -t /dest/ file1 file2 file3
```

**Install (copy with permissions):**
```bash
install -m 755 script.sh /usr/local/bin/
```

---

## 7. Safety Tips

**Always test with echo first:**
```bash
echo rm *.tmp
# shows what would be deleted
rm *.tmp
```

**Use -i when unsure:**
```bash
rm -i *
```

**Never `rm -rf /` or `rm -rf ~`**

**Check before recursive:**
```bash
ls folder/
rm -r folder/
```

---

## Real Examples

**Backup today's work:**
```bash
mkdir -p backup/$(date +%F)
cp -av project/* backup/$(date +%F)/
```

**Clean downloads:**
```bash
cd ~/Downloads
rm *.tmp *.part
for f in *\ *; do mv "$f" "${f// /_}"; done   # replace spaces
```

**Archive old files:**
```bash
for f in *.log; do
  if [ $(stat -c %Y "$f") -lt $(date -d "30 days ago" +%s) ]; then
    mv "$f" archive/
  fi
done
```

**Remove all empty folders:**
```bash
find . -type d -empty -delete
```

---

## What to Remember

- mkdir -p creates full path
- cp -a preserves everything, cp -r for simple copy
- mv renames and moves
- rm with wildcards, brace, prefix/suffix for bulk delete
- rmdir only removes empty, safer
- Use for loops for complex bulk cp/mv
- Always quote "$f" in loops to handle spaces
- Test with echo or ls before destructive commands
