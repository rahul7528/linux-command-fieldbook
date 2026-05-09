## 01 - Core Navigation

> If you can't move, you can't work. Learn these three commands and you can go anywhere in Linux.

## Start With What You Know

In Windows you use:
- Address bar to see where you are
- Double-click folder to go inside
- Back button to go back
- File list to see what's there

Linux has the same three ideas:
- `pwd` = address bar
- `cd` = double-click / back button
- `ls` = file list

## The 3 Commands That Move You

### 1. `pwd` - Print Working Directory

Shows your current location.

```bash
pwd
```
**Output:**
```
/home/rahul/projects
```

**Why it matters:** You always need to know where you are before you run a command. No guessing.

---

### 2. `cd` - Change Directory

Move to a different folder.

**The patterns you will use every day:**

| Command | What it does | Example |
|---------|--------------|---------|
| `cd /etc` | Go to absolute path | `cd /etc/nginx` |
| `cd ..` | Go up one level | From /home/rahul to /home |
| `cd ../..` | Go up two levels | From /var/log/nginx to /var |
| `cd ~` or `cd` | Go to your home | Always works |
| `cd -` | Go back to previous folder | Toggle between two places |
| `cd ./scripts` | Go to subfolder | Relative path |

**Try this sequence:**
```bash
pwd
cd /var/log
pwd
cd ..
pwd
cd -
pwd
```

**Output:**
```
/home/rahul
/var/log
/var
/var/log
```

**Why `-` matters:** It's your back button. When you're editing config in /etc and checking logs in /var/log, `cd -` saves 10 seconds every time.

---

### 3. `ls` - List

See what's in the folder.

**Basic:**
```bash
ls
```
Shows names only.

**The flags you actually need:**

| Flag | Means | Why use it |
|------|-------|------------|
| `-l` | long format | See permissions, owner, size, date |
| `-a` | all | Show hidden files starting with . |
| `-h` | human readable | Show 2.1K not 2100 bytes |
| `-t` | sort by time | Newest first |
| `-r` | reverse | Oldest first |
| `-R` | recursive | List subfolders too |

**Combine them:**
```bash
ls -lh
```
**Output:**
```
total 24K
drwxr-xr-x 2 rahul rahul 4.0K May 9 10:00 projects
-rw-r--r-- 1 rahul rahul  220 May 9 09:00 .bashrc
-rw-r--r-- 1 rahul rahul 1.5K May 8 15:00 notes.txt
```

**Reading `-lh` output:**
- `d` = directory, `-` = file
- `rwxr-xr-x` = permissions (who can read/write)
- `rahul rahul` = owner and group
- `4.0K` = size (human readable because of -h)
- `May 9 10:00` = last modified
- `projects` = name

```bash
ls -lart
```
Shows all files including hidden, sorted oldest first. Perfect for finding what you just created.

```bash
ls -la ~
```
Shows your home including hidden config files like .bashrc and .ssh

---

## Pro Moves

### 1. `pushd` and `popd` - Remember multiple places

```bash
pushd /etc/nginx
pushd /var/log
dirs
popd
```

**Output of dirs:**
```
0 /var/log
1 /etc/nginx
2 /home/rahul
```

**Why:** pushd saves location on a stack. popd returns. Better than cd when juggling 3 folders.

### 2. `realpath` - Get absolute path

```bash
realpath ../scripts
```
**Output:**
```
/home/rahul/projects/scripts
```

**Why:** Scripts need full paths. Relative paths break when you run from elsewhere.

### 3. `tree -L 2`
```bash
tree -L 2 /home/rahul
```
Shows 2 levels deep as a tree. Much faster than ls -R.

---

## Real Problems You Will Face

**Problem 1: "I am lost"**
```bash
pwd
ls -la
```
Always run these two first. pwd tells you where, ls tells you what's here.

**Problem 2: "Where did I just create that file?"**
```bash
ls -lt | head
```
-lt sorts by time, newest first. head shows top 5. Your file is at top.

**Problem 3: "I need to toggle between code and logs"**
```bash
cd /var/log/nginx
# check logs
cd - 
# back to code
cd -
# back to logs
```
Use cd - like alt-tab.

**Problem 4: "Hidden config file missing"**
```bash
ls -a ~
```
Without -a you won't see .bashrc, .profile, .ssh. These control your shell.

---

## What to Remember

- `pwd` before you do anything
- `cd ..` goes up, `cd -` goes back
- `ls -lh` for details, `ls -la` for hidden, `ls -lt` for newest
- `pushd/popd` when working in 3+ folders
- Absolute path starts with `/`, relative does not

Learn these and you will never get lost on any Linux server.

---
Next: 02 - Creating and Moving Files (mkdir, touch, cp, mv, rm)
