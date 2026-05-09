# 05 - Redirection and Pipes - Command Reference

Every redirection operator with output examples.

---

## > overwrite
**Command:** `echo hello > out.txt`
**Result:** out.txt contains "hello", previous content deleted
**Verify:** `cat out.txt` → hello

**Command:** `ls /etc > list.txt`
list.txt now has directory listing, nothing printed to screen

---

## >> append
**Command:** `echo world >> out.txt`
**Result:** out.txt now has two lines
**Verify:** `cat out.txt`
```
hello
world
```

Use for logs to preserve history.

---

## 2> stderr
**Command:** `ls /fake 2> err.txt`
**Screen:** (nothing)
**err.txt:** `ls: cannot access '/fake': No such file or directory`

**Combine:**
```bash
ls /etc /fake > out.txt 2> err.txt
```
out.txt has /etc listing, err.txt has error

---

## &> both
**Command:** `ls /etc /fake &> both.txt`
**both.txt contains:** listing + error message

**Equivalent:** `> both.txt 2>&1`

---

## < input
**Command:** `wc -l < /etc/passwd`
**Output:** `45` (number of lines)
Reads file directly, no cat needed

---

## | pipe
**Command:** `ls /etc | grep ssh`
**Output:** ssh sshd_config etc lines containing ssh

**Chain:** `ps aux | grep nginx | awk '{print $2}'`
Output: list of PIDs

---

## tee
**Command:** `echo test | tee file.txt`
**Screen:** test
**file.txt:** test

**Append:** `echo test2 | tee -a file.txt`
file.txt now has two lines

**With pipe:** `ls | tee all.txt | grep conf`
all.txt has full ls, screen shows only conf matches

---

## xargs
**Command:** `echo "a.txt b.txt" | xargs rm`
Runs: rm a.txt b.txt

**With find:** `find . -name "*.tmp" | xargs -I {} mv {} /tmp/`
Moves each file

**Safe:** `find . -print0 | xargs -0 rm`
Handles spaces correctly

---

## /dev/null
**Command:** `command > /dev/null 2>&1`
No output anywhere. Exit code still available via `$?`

---

## Here document
**Command:**
```bash
cat << EOF > test.txt
line1
line2
EOF
```
test.txt contains two lines

---

## Common patterns
**Log with date:** `cmd &> log-$(date +%F).txt`

**Errors only to file:** `cmd 2> errors.log`

**Silent cron job:** `* * * * * /script.sh > /dev/null 2>&1`

**Count matches:** `grep error log.txt | wc -l`
