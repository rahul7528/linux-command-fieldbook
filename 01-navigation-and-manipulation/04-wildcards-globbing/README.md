## 04 - Wildcards and Globbing

> Stop typing every filename. Let the shell expand patterns for you. This is how you work with 1000 files in one command.

## Start With What You Know

In Windows search you type `*.txt` to find all text files.

Linux shell does the same, but before the command runs. The shell expands `*.txt` into a list of real files, then passes that list to the command.

## The 4 Basic Wildcards

### 1. `*` - Match anything (zero or more characters)

```bash
ls *.log
```
Matches: app.log, error.log, 1.log — anything ending .log

```bash
rm *.tmp
```
Deletes all .tmp files in current folder.

**Important:** `*` does NOT match hidden files starting with `.` unless you type `.*`

### 2. `?` - Match exactly one character

```bash
ls file?.txt
```
Matches: file1.txt, fileA.txt — but NOT file10.txt (that's two chars)

```bash
ls ?.log
```
Matches: a.log, 1.log — single character names only

### 3. `[abc]` - Match one character from set

```bash
ls file[123].txt
```
Matches: file1.txt, file2.txt, file3.txt

```bash
ls [aeiou]*.txt
```
Matches files starting with a vowel

**Ranges:**
```bash
ls file[0-9].txt   # file0 to file9
ls file[a-z].txt   # lowercase letter
ls file[A-Z].txt   # uppercase
```

### 4. `[!abc]` or `[^abc]` - NOT in set

```bash
ls file[!0-9].txt
```
Matches fileA.txt but not file1.txt

---

## Brace Expansion `{}` - Generate combinations

Not a wildcard, but shell expands it.

```bash
echo file{1,2,3}.txt
```
**Output:** file1.txt file2.txt file3.txt

**Create multiple folders:**
```bash
mkdir -p project/{src,tests,docs}
```
Creates three folders in one command.

**Ranges with braces:**
```bash
touch log{01..10}.txt
```
Creates log01.txt through log10.txt

**Combine:**
```bash
cp config.{bak,old}
```
Expands to: cp config.bak config.old

---

## Real Examples You Will Use

**Clean logs older than .1:**
```bash
rm *.log.1 *.log.2.gz
```

**Copy all images:**
```bash
cp *.{jpg,png,gif} /backup/images/
```

**Find config files:**
```bash
ls /etc/*.{conf,cfg}
```

**Backup with date:**
```bash
cp app.log app.log.{$(date +%F)}
```
Creates app.log.2024-05-09

**Match hidden files:**
```bash
ls .*
```
Shows .bashrc, .profile etc. Be careful, includes . and ..

Better:
```bash
ls .[^.]*
```
Matches hidden files but not . and ..

---

## Escaping - When you don't want expansion

**Problem:** File literally named `*.txt`
```bash
rm "*.txt"    # quotes prevent expansion
rm \*.txt     # backslash escapes *
```

**When to quote:**
```bash
find . -name "*.log"   # find needs the *, not shell
```
Without quotes, shell expands *.log first, find breaks.

---

## Pro Patterns

### 1. `**` - Recursive (needs globstar)
```bash
shopt -s globstar
ls **/*.py
```
Finds all .py files in all subfolders.

### 2. Match everything except
```bash
ls !(*.tmp)   # needs extglob
```
Shows all files except .tmp

Enable:
```bash
shopt -s extglob
```

### 3. Case-insensitive
```bash
shopt -s nocaseglob
ls *.JPG   # matches .jpg and .JPG
```

---

## Common Mistakes

**Mistake 1: `rm *` in wrong folder**
Always `pwd` and `ls` first. Then `echo *` to see what will be deleted.

**Mistake 2: Spaces in names**
```bash
rm My File.txt   # tries to delete My and File.txt
rm "My File.txt" # correct
rm My*.txt       # expands to My File.txt, still breaks
```
Use quotes or escape: `rm My\ File.txt`

**Mistake 3: Hidden files not matched**
`*` doesn't match `.env`. Use `.*` or `shopt -s dotglob`

**Mistake 4: No matches**
```bash
ls *.xyz
```
If no .xyz files, bash passes literal `*.xyz` to ls, which errors.
Fix: `shopt -s nullglob` makes it expand to nothing.

---

## Real Problems

**Problem 1: Delete 1000 log files except today's**
```bash
ls -t *.log | tail -n +2 | xargs rm
```
ls -t sorts newest first, tail skips first, xargs deletes rest.

**Problem 2: Rename all .txt to .md**
```bash
for f in *.txt; do mv "$f" "${f%.txt}.md"; done
```
${f%.txt} removes .txt suffix.

**Problem 3: Copy files with numbers 1-50**
```bash
cp file{[1-9],[1-4][0-9],50}.txt /dest/
```
Brace expansion handles ranges.

---

## What to Remember

- `*` = anything, `?` = one char, `[abc]` = one of these
- `{}` generates names, doesn't match files
- Shell expands before command runs
- Quote patterns when passing to find, grep
- Always `echo *.ext` before `rm *.ext`
- `shopt -s globstar` for ** recursive

Master globbing and you can manage thousands of files with one line.

---
Next: 05 - Finding Files (find, locate)
