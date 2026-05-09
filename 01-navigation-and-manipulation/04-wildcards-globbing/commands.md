# 04 - Wildcards and Globbing - Command Reference

Every pattern, what it matches, and sample output.

---

## * asterisk
**Command:** `echo *.txt`
**If files exist:** file1.txt file2.txt notes.txt
**If none:** *.txt (literal)
**Matches:** zero or more characters, except leading .

**Examples:**
- `ls *.log` → app.log error.log
- `rm *~` → deletes backup files ending ~
- `cp /var/log/* .` → copies all non-hidden files

**Does not match:** .hidden (use `.*`)

---

## ? question
**Command:** `ls file?.txt`
**Matches:** file1.txt, fileA.txt
**Not:** file10.txt, file.txt

**Use:** when you know exact length

---

## [set]
**Command:** `ls [abc]*`
**Matches:** apple.txt, banana.log, cherry
**Not:** dog.txt

**Ranges:**
- `[0-9]` → any digit
- `[a-z]` → lowercase
- `[A-Z]` → uppercase
- `[0-9a-f]` → hex digit

**Command:** `ls file[1-3].txt`
**Output:** file1.txt file2.txt file3.txt

---

## [!set] negation
**Command:** `ls file[!0-9].txt`
**Matches:** fileA.txt file_.txt
**Not:** file1.txt

**Alternative:** `[^0-9]` same meaning

---

## {} brace expansion
**Not globbing** - generates strings before matching

**Command:** `echo {a,b,c}.txt`
**Output:** a.txt b.txt c.txt

**Command:** `mkdir {src,bin,lib}`
Creates three directories

**Sequence:**
- `{1..5}` → 1 2 3 4 5
- `{01..10}` → 01 02 ... 10
- `{a..e}` → a b c d e

**Nested:**
`{a,b}{1,2}` → a1 a2 b1 b2

---

## Combining
**Command:** `ls *.[ch]`
**Matches:** main.c main.h test.c
**Meaning:** * then dot then c or h

**Command:** `cp *.{jpg,JPG,png} images/`
Copies all three extensions

---

## Escaping
**Literal asterisk file:**
```bash
touch '*.txt'
ls \*.txt    # shows *.txt
rm "*.txt"   # deletes it
```

**Pass to find:**
```bash
find . -name "*.log"   # quotes prevent shell expansion
```
Without quotes, shell expands first, find gets wrong args.

---

## Advanced globs
**Enable:** `shopt -s globstar extglob nocaseglob`

** ** recursive:**
`ls **/*.py` → finds all Python files in subdirs

** extglob patterns:**
- `!(pattern)` → not match
- `*(pattern)` → zero or more
- `+(pattern)` → one or more

Example: `ls !(*.bak)` → all except .bak

---

## Safety checks
**Before delete:**
```bash
echo rm *.tmp
# shows what would be deleted
rm *.tmp
```

**Count matches:**
```bash
ls *.log | wc -l
```

**With spaces:**
```bash
for f in *.txt; do echo "$f"; done
```
Always quote "$f"
