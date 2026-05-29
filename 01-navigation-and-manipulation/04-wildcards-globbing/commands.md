# 04 - Wildcards - Quick Reference<br/>
<br/>
---<br/><br/>
<br/>
## *<br/>
`*.txt` → all txt<br/>
`file*` → starts with file<br/>
`*2024*` → contains 2024<br/>
`*old.log` → ends with old.log<br/>
<br/><br/>
**Delete:**<br/>
`rm *.log`<br/>
`rm backup-*` → prefix<br/>
`rm *-old` → suffix<br/>
<br/>
---<br/><br/>
<br/>
## ?<br/>
`file?.txt` → file1.txt, fileA.txt<br/>
`???.log` → exactly 3 chars<br/>
<br/>
---<br/><br/>
<br/>
## []<br/>
`[abc].txt` → a.txt, b.txt, c.txt<br/>
`[1-5].txt` → 1-5<br/>
`[a-z].txt` → a-z<br/>
`[^0-9]*` → not starting with digit<br/>
<br/>
---<br/><br/>
<br/>
## {}<br/>
`file{1,2,3}.txt` → file1 file2 file3<br/>
`{a,b}.log` → a.log b.log<br/>
`file{1..10}.txt` → 1 through 10<br/>
`cp f.txt{,.bak}` → copy to f.txt.bak<br/>
<br/>
**Delete with brace:**<br/>
`rm file{1..100}.tmp`<br/>
<br/>
---<br/><br/>
<br/>
## Combinations<br/>
`*.txt *.md` → multiple types<br/>
`backup-*-2024*` → prefix + contains + suffix<br/>
`ls !(*.sh)` → requires shopt -s extglob<br/>
<br/>
---<br/><br/>
<br/>
## Safety<br/>
`echo rm *` → test<br/>
`ls *.tmp` → preview<br/>
`ls .*` → hidden files<br/>
