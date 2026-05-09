# 01 - Core Navigation - Command Reference

Every navigation command, what it prints, and what to tell someone who asks.

---

## pwd
**Command:** `pwd`
**Output:**
```
/home/rahul/projects/linux-command-fieldbook
```
**Meaning:** Print Working Directory. Shows full path from root.
**When to use:** Before running any command that changes files. Always know where you are.

---

## cd
**Command:** `cd /var/log`
**Output:** (no output, just changes directory)
**Verify with:** `pwd` → `/var/log`

**Variations:**
- `cd` or `cd ~` → `/home/rahul`
- `cd ..` → go up one
- `cd ../..` → go up two
- `cd -` → go to previous, prints path: `/home/rahul`
- `cd ./scripts` → relative path from current

**Common mistake:** `cd /var log` (space) fails. Use `cd "/var log"` if folder has space.

---

## ls
**Basic:** `ls`
**Output:**
```
Desktop  Documents  projects
```

**ls -l**
```
drwxr-xr-x 2 rahul rahul 4096 May 9 10:00 projects
-rw-r--r-- 1 rahul rahul  220 May 9 09:00 file.txt
```
Columns: permissions, links, owner, group, size, date, name

**ls -a**
Shows: `.  ..  .bashrc  .ssh  projects`
`.` = current folder, `..` = parent

**ls -lh**
Size shows as 4.0K, 1.2M, 2.1G instead of bytes

**ls -lt**
Newest first. Use `ls -lt | head -5` to see recent files

**ls -lart**
All files, oldest first, with details. Shows what you created first.

**ls -R**
Recursive. Lists all subfolders. Can be huge, use with `| head`

---

## pushd / popd / dirs
**Commands:**
```bash
pushd /etc
pushd /var/log
dirs -v
```
**Output:**
```
0  /var/log
1  /etc
2  /home/rahul
```
**popd**
Returns to /etc, stack shrinks

**Use case:** Working on nginx config and logs simultaneously without losing place.

---

## realpath
**Command:** `realpath ../../scripts`
**Output:**
```
/home/rahul/projects/scripts
```
**Meaning:** Converts relative path to absolute. Essential for scripts.

---

## tree
**Command:** `tree -L 2 -a`
**Output:**
```
.
├── .git
├── README.md
└── src
    ├── main.py
    └── utils.py
```
**Flags:** -L 2 = 2 levels deep, -a = show hidden
**Install:** `sudo apt install tree`

---

## Quick Troubleshooting

**"cd: no such file or directory"**
- Run `ls` first to see exact name (Linux is case-sensitive: Projects ≠ projects)
- Use tab completion: type `cd Pro` + Tab

**"ls shows nothing"**
- Try `ls -la` — folder might only have hidden files

**"I don't know where I am"**
- `pwd` then `ls -lh`

**Need to copy path?**
- `pwd | xclip` (copies to clipboard) or just select with mouse
