## 05 - Redirection and Pipes

> The real power of Linux is connecting commands. Send output to files, chain commands together, and capture errors.

## Start With What You Know

Every command has three default streams:
- **stdin (0)** - input from keyboard
- **stdout (1)** - normal output to screen
- **stderr (2)** - errors to screen

Redirection changes where these go. Pipes connect them.

## Output Redirection

### 1. `>` - Overwrite file

```bash
ls /etc > files.txt
```
Sends output of ls to files.txt instead of screen. If files.txt exists, it's overwritten.

**Verify:**
```bash
cat files.txt
```

### 2. `>>` - Append to file

```bash
date >> files.txt
echo "backup done" >> files.txt
```
Adds to end, doesn't delete existing content.

**Use case:** Log files. Always use >> for logs.

### 3. `2>` - Redirect errors only

```bash
ls /nope 2> errors.log
```
Normal output still goes to screen, errors go to file.

**Check:**
```bash
cat errors.log
```
Output: ls: cannot access '/nope': No such file or directory

### 4. `&>` or `> file 2>&1` - Redirect both

```bash
command &> all.log
```
Captures stdout and stderr together.

**Old style (same):**
```bash
command > all.log 2>&1
```
2>&1 means "send stderr to wherever stdout is going"

### 5. `/dev/null` - Throw away output

```bash
command > /dev/null 2>&1
```
Silences command completely. Useful in scripts.

---

## Input Redirection

### `<` - Read from file

```bash
wc -l < files.txt
```
wc counts lines, but reads from file instead of keyboard.

**Same as:**
```bash
cat files.txt | wc -l
```
But < is faster, no extra process.

### `<<` - Here document

```bash
cat << EOF > config.txt
server {
    port 80
}
EOF
```
Creates file with multi-line content. EOF can be any word.

---

## Pipes `|` - Connect commands

Send output of left command as input to right.

```bash
ls /etc | grep nginx
```
1. ls lists /etc
2. grep filters lines containing nginx

**Chain multiple:**
```bash
cat /var/log/syslog | grep error | head -5
```
Find errors, show first 5.

**Common pipeline:**
```bash
ps aux | grep python | awk '{print $2}' | xargs kill
```
Find python processes, extract PID, kill them.

---

## tee - Write to file and screen

```bash
ls /etc | tee list.txt | grep conf
```
Saves full list to list.txt, but grep still sees it and filters.

**Append with tee:**
```bash
command | tee -a log.txt
```

**Use case:** You want to see output and save it for later.

---

## xargs - Turn output into arguments

```bash
find . -name "*.tmp" | xargs rm
```
find outputs filenames, xargs passes them to rm.

**Safer with spaces:**
```bash
find . -name "*.tmp" -print0 | xargs -0 rm
```

**Example:**
```bash
ls *.log | xargs -I {} mv {} backup/{}
```
Moves each .log to backup folder.

---

## Real Examples

**1. Save errors separately:**
```bash
./deploy.sh > deploy.out 2> deploy.err
```
Normal log in .out, errors in .err

**2. Log everything with timestamp:**
```bash
./backup.sh &> backup-$(date +%F).log
```

**3. Count files by type:**
```bash
ls | grep -E "\.txt$" | wc -l
```

**4. Find biggest files:**
```bash
du -sh /var/* | sort -hr | head -10
```
du outputs sizes, sort sorts, head takes top 10.

**5. Watch live and save:**
```bash
tail -f /var/log/nginx/access.log | tee -a today.log | grep 404
```
See live, save all, filter 404s on screen.

---

## Common Mistakes

**Mistake 1: `>` vs `>>`**
`>` deletes file first. Use `>>` for logs or you lose history.

**Mistake 2: Order matters**
```bash
command 2>&1 > file   # wrong, errors still to screen
command > file 2>&1   # correct
```

**Mistake 3: Pipe only sends stdout**
```bash
command 2>&1 | grep error   # need 2>&1 first to pipe errors too
```

**Mistake 4: xargs with spaces**
Always use `-print0 | xargs -0` for filenames with spaces.

---

## Pro Tips

**1. Redirect to multiple files:**
```bash
command | tee file1.txt file2.txt > /dev/null
```

**2. Swap stdout and stderr:**
```bash
command 3>&1 1>&2 2>&3
```

**3. Suppress errors but keep output:**
```bash
ls /etc /nope 2> /dev/null
```

**4. Here-string:**
```bash
grep error <<< "$logdata"
```
Same as echo "$logdata" | grep error

---

## What to Remember

- `>` overwrite, `>>` append
- `2>` errors only, `&>` both
- `|` connects stdout to stdin
- `tee` saves and passes through
- `xargs` converts output to arguments
- `/dev/null` discards output
- Always test with small data first

Master redirection and you can build complex workflows from simple commands.

---
Next: 02 - Text Processing Basics
