# 02 - Files and Folders - Command Reference
<br/>
---<br/>
<br/>
## mkdir<br/>
`mkdir dir` → create folder<br/>
`mkdir -p a/b/c` → create parents<br/>
`mkdir dir1 dir2 dir3` → multiple<br/>
<br/>
---<br/>
<br/>
## touch<br/>
`touch file.txt` → create or update time<br/>
`touch f1 f2 f3` → multiple<br/>
`touch -t 202401011200 file` → set time<br/>
<br/>
---<br/>
<br/>
## cp<br/>
`cp file dest/` → copy file<br/>
`cp -r dir dest/` → copy folder<br/>
`cp -a src dest` → preserve all<br/>
`cp -i file dest` → interactive<br/>
`cp -u *.txt backup/` → only newer<br/>
`cp -v file dest` → verbose
<br/>
---<br/>
<br/>
## mv<br/>
`mv old new` → rename<br/>
`mv file /tmp/` → move<br/>
`mv -i file dest` → ask before overwrite<br/>
`mv *.log logs/` → multiple<br/>
`mv -t dest/ f1 f2 f3` → target first<br/>
<br/>
---<br/>
<br/>
## rm<br/>
`rm file` → delete<br/>
`rm -i file` → confirm<br/>
`rm -f file` → force<br/>
`rm file1 file2` → multiple<br/>
`rm *.tmp` → wildcard suffix<br/>
`rm backup-*` → prefix<br/>
`rm *old*` → contains<br/>
`rm file{1,2,3}.txt` → brace<br/>
`rm -r dir` → recursive<br/>
`rm -rf dir` → force recursive<br/>
<br/>
---<br/>
<br/>
## rmdir<br/>
`rmdir empty/` → removes only if empty<br/>
`find . -type d -empty -delete` → remove all empty<br/>
<br/>
---<br/>
<br/>
## Loops<br/>
`for f in *.jpg; do cp "$f" /backup/; done`<br/>
`for f in *.txt; do mv "$f" "old-$f"; done`<br/>
`for f in *.txt; do cp "$f" "${f%.txt}.bak"; done`<br/>
<br/>
**Safe with spaces:**<br/>
`find . -name "*.mp4" -print0 | while IFS= read -r -d '' f; do mv "$f" /dest/; done`<br/>
<br/>
---<br/>
<br/>
## install<br/>
`install -m 755 script.sh /usr/local/bin/` → copy with mode<br/>
