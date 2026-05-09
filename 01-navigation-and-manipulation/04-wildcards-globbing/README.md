## 04 - Wildcards and Globbing

> Type less, do more. Wildcards let you select dozens of files with 3 characters.

## The Big Four

### `*` - Anything (including nothing)
```bash
ls *.txt              # all txt files
ls file*              # file, file1, file_backup
ls *2024*             # anything containing 2024
```

**Delete by suffix:**
```bash
rm *.log              # all ending .log
rm *-old.log          # all ending -old.log
```

**Delete by prefix:**
```bash
rm backup-*           # all starting with backup-
rm temp-*             # all starting with temp-
```

### `?` - Exactly one character
```bash
ls file?.txt          # file1.txt, fileA.txt (not file10.txt)
ls ???.log            # exactly 3 chars + .log
```

### `[]` - One of these characters
```bash
ls file[123].txt      # file1.txt, file2.txt, file3.txt
ls file[1-5].txt      # file1 through file5
ls file[a-z].txt      # filea through filez
ls *[0-9].log         # ends with digit
```

### `{}` - Brace expansion (not a wildcard, but works like one)
```bash
ls file{1,2,3}.txt    # file1.txt file2.txt file3.txt
ls {a,b,c}.log        # a.log b.log c.log
rm file{1..10}.txt    # delete file1 through file10
cp file.txt{,.bak}    # copy to file.txt.bak
mkdir project-{src,tests,docs}
```

---

## Real Combinations

**Multiple patterns:**
```bash
ls *.txt *.md
rm *.tmp *.bak *.log
```

**Prefix and suffix together:**
```bash
ls backup-*-2024.tar.gz
rm log-*-error.txt
```

**Exclude with extglob (enable first):**
```bash
shopt -s extglob
ls !(*.txt)           # everything except txt
rm !(*.sh|*.py)       # delete all except scripts
```

---

## Safety with Wildcards

**Always test first:**
```bash
echo rm *.tmp
# shows what would be deleted
ls *.tmp
rm *.tmp
```

**Quote to prevent expansion:**
```bash
echo "*"              # prints *
echo *                # expands to files
```

**Hidden files:**
```bash
ls *                  # doesn't show dotfiles
ls .*                 # shows .hidden
ls .[^.]*             # hidden but not . and ..
```

---

## Common Patterns

| Pattern | Matches |
|---------|---------|
| `*.txt` | All txt files |
| `file*` | Starts with file |
| `*backup*` | Contains backup |
| `?-test.log` | 1 char + -test.log |
| `[abc]*.txt` | Starts a, b, or c |
| `*.[ch]` | Ends .c or .h |
| `file{1..5}.txt` | file1 to file5 |

---

## What to Remember

- `*` = anything, `?` = one char, `[]` = one of set, `{}` = list
- Test with `ls` or `echo` before `rm`
- Prefix: `backup-*`, Suffix: `*-old`
- Brace expansion is powerful for bulk operations
- Quote wildcards when passing to commands like find

Wildcards turn 100 file operations into one command.
