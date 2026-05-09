## 06 - Archiving and Compression

> Package files for backup, transfer, or storage. Learn tar, gzip, and zip — the three tools you'll use everywhere.

## Start With What You Know

In Windows you right-click > Send to > Compressed folder.

Linux separates two steps:
1. **Archive** - bundle many files into one (tar)
2. **Compress** - make it smaller (gzip, bzip2, xz)

You usually do both together.

## tar - Tape Archive

### Create archive
```bash
tar -cvf backup.tar /home/rahul/projects
```
- `-c` = create
- `-v` = verbose (show files)
- `-f` = filename

**Output:**
```
projects/
projects/file1.txt
projects/file2.txt
```

Creates backup.tar (not compressed, just bundled).

### Extract archive
```bash
tar -xvf backup.tar
```
- `-x` = extract
- `-v` = verbose
- `-f` = filename

Extracts to current folder.

### List contents without extracting
```bash
tar -tvf backup.tar
```
- `-t` = list

Shows files inside.

---

## tar + gzip (most common)

### Create compressed archive
```bash
tar -czvf backup.tar.gz projects/
```
- `-z` = gzip compression
- Creates .tar.gz or .tgz

**Size comparison:**
- backup.tar = 100MB
- backup.tar.gz = 20MB

### Extract
```bash
tar -xzvf backup.tar.gz
```
Same flags, just add z.

### Create with date
```bash
tar -czvf backup-$(date +%F).tar.gz /etc/nginx
```
Creates backup-2024-05-09.tar.gz

---

## tar + other compressors

**bzip2 (smaller, slower):**
```bash
tar -cjvf backup.tar.bz2 projects/
tar -xjvf backup.tar.bz2
```

**xz (smallest, slowest):**
```bash
tar -cJvf backup.tar.xz projects/
tar -xJvf backup.tar.xz
```

**No compression (fastest):**
```bash
tar -cvf backup.tar projects/
```

---

## zip and unzip (for Windows compatibility)

### Create zip
```bash
zip -r backup.zip projects/
```
- `-r` = recursive

### Extract zip
```bash
unzip backup.zip
```

### List zip
```bash
unzip -l backup.zip
```

**When to use zip:** Sharing with Windows users. Otherwise use tar.gz on Linux.

---

## gzip and gunzip (single files)

**Compress file:**
```bash
gzip access.log
```
Creates access.log.gz, deletes original.

**Decompress:**
```bash
gunzip access.log.gz
```

**Keep original:**
```bash
gzip -k access.log
```

**View without decompressing:**
```bash
zcat access.log.gz | head
```

---

## Real Examples

**1. Backup home excluding cache:**
```bash
tar -czvf home-backup.tar.gz --exclude='*.cache' --exclude='.npm' /home/rahul
```

**2. Backup and send to remote:**
```bash
tar -czvf - /etc | ssh user@server "cat > /backup/etc.tar.gz"
```
`-` means write to stdout, piped to ssh.

**3. Extract to specific folder:**
```bash
tar -xzvf backup.tar.gz -C /tmp/restore
```
-C changes directory before extract.

**4. Incremental backup:**
```bash
tar -czvf backup-full.tar.gz /data
tar -czvf backup-inc.tar.gz --newer backup-full.tar.gz /data
```

**5. Split large archive:**
```bash
tar -czvf - bigfolder | split -b 100M - backup-part-
```
Creates 100MB parts. Rejoin with `cat backup-part-* > backup.tar.gz`

---

## Common Flags Reference

| Flag | Meaning |
|------|---------|
| -c | create |
| -x | extract |
| -t | list |
| -v | verbose |
| -f | file name |
| -z | gzip |
| -j | bzip2 |
| -J | xz |
| -C | change directory |
| --exclude | skip pattern |

**Memory aid:** "tar -czvf = Create Zip Verbose File"

---

## Pro Tips

**1. Preserve permissions:**
```bash
tar -czvpf backup.tar.gz /etc
```
-p preserves permissions (important for restores)

**2. Verify archive:**
```bash
tar -tzvf backup.tar.gz > /dev/null
```
If no error, archive is good.

**3. Extract single file:**
```bash
tar -xzvf backup.tar.gz etc/nginx/nginx.conf
```

**4. Compress without tar (for single file):**
```bash
xz -9 bigfile.sql   # best compression
```

---

## What to Remember

- tar bundles, gzip compresses
- Use `tar -czvf` to create, `tar -xzvf` to extract
- `.tar.gz` is standard on Linux, `.zip` for Windows
- Always test extract with `-t` first
- Use `--exclude` to skip cache and logs
- `-C` extracts to different folder

Master tar and you can backup and move any project.

---
Next: 02 - Text Processing
