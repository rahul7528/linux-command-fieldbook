# 08 - Rsync and Advanced Copy - Command Reference

---

## rsync basic
**Command:** `rsync -avh src/ dest/`
**Output:** lists files copied
**-a** preserves all, **-v** verbose, **-h** human

**With trailing slash:** src/ = contents, src = folder itself

---

## rsync remote
**Command:** `rsync -avh project/ user@host:/backup/`
Copies over SSH

**Progress:** `rsync -avh --progress big.iso user@host:/tmp/`
Shows % and speed

---

## rsync --delete
**Command:** `rsync -avh --delete src/ dest/`
Makes dest identical to src, deletes extras

**Dry run:** `--dry-run` shows actions without doing

---

## rsync exclude
**Command:** `rsync -avh --exclude='*.tmp' --exclude='cache/' src/ dest/`

---

## scp
**To server:** `scp file.txt user@host:/tmp/`
**Folder:** `scp -r dir/ user@host:/tmp/`
**From server:** `scp user@host:/tmp/file .`
**Port:** `scp -P 2222 file user@host:/tmp/`

---

## mktemp
**File:** `mktemp` → `/tmp/tmp.XYZ123`
**Dir:** `mktemp -d` → `/tmp/tmp.ABC456`
**Template:** `mktemp /tmp/app.XXXXXX`

---

## truncate
**Create:** `truncate -s 100M file.bin`
**Clear:** `truncate -s 0 log.txt`
**Extend:** `truncate -s +10M file.bin`

---

## shred
**Basic:** `shred -u secret.txt`
**10 passes:** `shred -u -n 10 -z file.txt`

---

## rename
**Change ext:** `rename 's/\.txt$/.md/' *.txt`
**Prefix:** `rename 's/^/old-/' *`
**Dry run:** `rename -n 's/ /_/g' *`

**Loop alternative:**
`for f in *.jpeg; do mv "$f" "${f%.jpeg}.jpg"; done`
