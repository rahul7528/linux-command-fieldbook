# 07 - Finding and Inspecting - Complete Reference<br/>
<br/>
---<br/><br/>
<br/>
## find syntax<br/>
`find [path] [tests] [actions]`<br/>
Example: `find . -type f -name "*.log" -mtime -7`<br/>
<br/>
---<br/><br/>
<br/>
## Find by name (prefix/suffix)<br/>
`find . -name "*.txt"` → suffix .txt<br/>
`find . -name "backup-*"` → prefix backup-<br/>
`find . -name "*2024*"` → contains 2024<br/>
`find . -iname "*.JPG"` → case-insensitive<br/>
<br/>
---<br/><br/>
<br/>
## Find by type<br/>
`find . -type f` → files<br/>
`find . -type d` → directories<br/>
`find . -type l` → symlinks<br/>
<br/>
---<br/><br/>
<br/>
## Find and delete<br/>
`find . -name "*.tmp" -delete`<br/>
`find . -name "*.bak" -exec rm -v {} \;`<br/>
`find . -name "*.log" -ok rm {} \;` → prompts<br/>
<br/>
---<br/><br/>
<br/>
## Find empty<br/>
`find . -type f -empty` → empty files<br/>
`find . -type d -empty` → empty dirs<br/>
`find . -type d -empty -delete` → remove empty dirs<br/>
<br/>
---<br/><br/>
<br/>
## Find by size<br/>
`find . -size +100M` → >100MB<br/>
`find . -size -1k` → <1KB<br/>
`find . -size 0` → empty<br/>
<br/>
---<br/><br/>
<br/>
## Find by date<br/>
`find . -mtime -7` → modified last 7 days<br/>
`find . -mtime +30` → older than 30 days<br/>
`find . -mmin -60` → last 60 minutes<br/>
`find . -atime -1` → accessed yesterday<br/>
`find . -ctime -1` → metadata changed<br/>
<br/>
**Range:** `find . -newermt "2024-01-01" ! -newermt "2024-02-01"`<br/>
<br/>
---<br/><br/>
<br/>
## Find by permission<br/>
`find . -perm 644`<br/>
`find . -perm -4000` → setuid<br/>
`find . -type f -perm /111` → executable<br/>
<br/>
---<br/><br/>
<br/>
## Remove multiple methods<br/>
`rm *.log *.tmp` → wildcards<br/>
`rm file{1..10}.txt` → brace<br/>
`rm prefix-* *-suffix` → prefix/suffix<br/>
`find . -name "*.cache" -delete` → find<br/>
<br/>
---<br/><br/>
<br/>
## Loops with cp/mv<br/>
`for f in *.jpg; do cp "$f" /backup/; done`<br/>
`for f in *.txt; do mv "$f" archive/; done`<br/>
`find . -name "*.log" -print0 | while IFS= read -r -d '' f; do gzip "$f"; done`<br/>
<br/>
---<br/><br/>
<br/>
## locate<br/>
`sudo updatedb`<br/>
`locate nginx.conf`<br/>
`locate -l 5 "*.conf"`<br/>
<br/>
---<br/><br/>
<br/>
## grep<br/>
`grep "error" file.log`<br/>
`grep -r "TODO" src/`<br/>
`grep -i "fail" *.log`<br/>
`grep -l "password" *`<br/>
`find . -name "*.conf" -exec grep -l "8080" {} \;`<br/>
<br/>
---<br/><br/>
<br/>
## basename / dirname / file<br/>
`basename /a/b/c.txt` → c.txt<br/>
`basename /a/b/c.txt .txt` → c<br/>
`dirname /a/b/c.txt` → /a/b<br/>
`file document` → type<br/>
<br/>
---<br/><br/>
<br/>
## which / whereis / type<br/>
`which python` → path<br/>
`whereis python` → binary, man<br/>
`type ls` → alias or builtin<br/>
