# 05 - Redirection and Pipes - Command Reference<br/>
<br/>
Every redirection operator with output examples.<br/>
<br/>
---<br/><br/>
<br/>
## > overwrite<br/>
**Command:** `echo hello > out.txt`<br/>
**Result:** out.txt contains "hello", previous content deleted<br/>
**Verify:** `cat out.txt` → hello<br/>
<br/>
**Command:** `ls /etc > list.txt`<br/>
list.txt now has directory listing, nothing printed to screen<br/>
<br/>
---<br/><br/>
<br/>
## >> append<br/>
**Command:** `echo world >> out.txt`<br/>
**Result:** out.txt now has two lines<br/>
**Verify:** `cat out.txt`<br/>
```
hello
world
```
<br/>
Use for logs to preserve history.<br/>
<br/>
---<br/><br/>
<br/>
## 2> stderr<br/>
**Command:** `ls /fake 2> err.txt`<br/>
**Screen:** (nothing)<br/>
**err.txt:** `ls: cannot access '/fake': No such file or directory`<br/>
<br/>
**Combine:**
```bash
ls /etc /fake > out.txt 2> err.txt
```
out.txt has /etc listing, err.txt has error<br/>
<br/>
---<br/><br/>
<br/>
## &> both<br/>
**Command:** `ls /etc /fake &> both.txt`<br/>
**both.txt contains:** listing + error message<br/>
<br/>
**Equivalent:** `> both.txt 2>&1`<br/>
<br/>
---<br/><br/>
<br/>
## < input<br/>
**Command:** `wc -l < /etc/passwd`<br/>
**Output:** `45` (number of lines)<br/>
Reads file directly, no cat needed<br/>
<br/>
---<br/><br/>
<br/>
## | pipe<br/>
**Command:** `ls /etc | grep ssh`<br/>
**Output:** ssh sshd_config etc lines containing ssh<br/>
<br/>
**Chain:** `ps aux | grep nginx | awk '{print $2}'`<br/>
Output: list of PIDs<br/>
<br/>
---<br/><br/>
<br/>
## tee<br/>
**Command:** `echo test | tee file.txt`<br/>
**Screen:** test<br/>
**file.txt:** test<br/>
<br/>
**Append:** `echo test2 | tee -a file.txt`<br/>
file.txt now has two lines<br/>
<br/>
**With pipe:** `ls | tee all.txt | grep conf`<br/>
all.txt has full ls, screen shows only conf matches<br/>
<br/>
---<br/><br/>
<br/>
## xargs<br/>
**Command:** `echo "a.txt b.txt" | xargs rm`<br/>
Runs: rm a.txt b.txt<br/>
<br/>
**With find:** `find . -name "*.tmp" | xargs -I {} mv {} /tmp/`<br/>
Moves each file<br/>
<br/>
**Safe:** `find . -print0 | xargs -0 rm`<br/>
Handles spaces correctly<br/>
<br/>
---<br/><br/>
<br/>
## /dev/null<br/>
**Command:** `command > /dev/null 2>&1`<br/>
No output anywhere. Exit code still available via `$?`<br/>
<br/>
---<br/><br/>
<br/>
## Here document<br/>
**Command:**<br/>
```bash
cat << EOF > test.txt
line1
line2
EOF
```
test.txt contains two lines<br/>
<br/>
---<br/><br/>
<br/>
## Common patterns<br/>
**Log with date:** `cmd &> log-$(date +%F).txt`<br/>
<br/>
**Errors only to file:** `cmd 2> errors.log`<br/>
<br/>
**Silent cron job:** `* * * * * /script.sh > /dev/null 2>&1`<br/>
<br/>
**Count matches:** `grep error log.txt | wc -l`<br/>
<br/>
