# 04 - Wildcards - Quick Reference

---

## *
`*.txt` → all txt
`file*` → starts with file
`*2024*` → contains 2024
`*old.log` → ends with old.log

**Delete:**
`rm *.log`
`rm backup-*` → prefix
`rm *-old` → suffix

---

## ?
`file?.txt` → file1.txt, fileA.txt
`???.log` → exactly 3 chars

---

## []
`[abc].txt` → a.txt, b.txt, c.txt
`[1-5].txt` → 1-5
`[a-z].txt` → a-z
`[^0-9]*` → not starting with digit

---

## {}
`file{1,2,3}.txt` → file1 file2 file3
`{a,b}.log` → a.log b.log
`file{1..10}.txt` → 1 through 10
`cp f.txt{,.bak}` → copy to f.txt.bak

**Delete with brace:**
`rm file{1..100}.tmp`

---

## Combinations
`*.txt *.md` → multiple types
`backup-*-2024*` → prefix + contains + suffix
`ls !(*.sh)` → requires shopt -s extglob

---

## Safety
`echo rm *` → test
`ls *.tmp` → preview
`ls .*` → hidden files
