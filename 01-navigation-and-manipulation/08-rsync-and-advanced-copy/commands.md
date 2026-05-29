# 08 - Rsync and Advanced Copy - Command Reference
<br/>
---<br/><br/>
<br/>
## rsync basic<br/>
**Command:** `rsync -avh src/ dest/`<br/>
**Output:** lists files copied<br/>
**-a** preserves all, **-v** verbose, **-h** human<br/>
<br/>
**With trailing slash:** src/ = contents, src = folder itself<br/>
<br/>
---<br/><br/>
<br/>
## rsync remote<br/>
**Command:** `rsync -avh project/ user@host:/backup/`<br/>
Copies over SSH<br/>
<br/>
**Progress:** `rsync -avh --progress big.iso user@host:/tmp/`<br/>
Shows % and speed<br/>
<br/>
---<br/><br/>
<br/>
## rsync --delete<br/>
**Command:** `rsync -avh --delete src/ dest/`<br/>
Makes dest identical to src, deletes extras<br/>
<br/>
**Dry run:** `--dry-run` shows actions without doing<br/>
<br/>
---<br/><br/>
<br/>
## rsync exclude<br/>
**Command:** `rsync -avh --exclude='*.tmp' --exclude='cache/' src/ dest/`<br/>
<br/>
---<br/><br/>
<br/>
## scp<br/>
**To server:** `scp file.txt user@host:/tmp/`<br/>
**Folder:** `scp -r dir/ user@host:/tmp/`<br/>
**From server:** `scp user@host:/tmp/file .`<br/>
**Port:** `scp -P 2222 file user@host:/tmp/`<br/>
<br/>
---<br/>
<br/>
## mktemp<br/>
**File:** `mktemp` → `/tmp/tmp.XYZ123`<br/>
**Dir:** `mktemp -d` → `/tmp/tmp.ABC456`<br/>
**Template:** `mktemp /tmp/app.XXXXXX`<br/>
<br/>
---<br/><br/>
<br/>
## truncate<br/>
**Create:** `truncate -s 100M file.bin`<br/>
**Clear:** `truncate -s 0 log.txt`<br/>
**Extend:** `truncate -s +10M file.bin`<br/>
<br/>
---<br/><br/>
<br/>
## shred<br/>
**Basic:** `shred -u secret.txt`<br/>
**10 passes:** `shred -u -n 10 -z file.txt`<br/>
<br/>
---<br/><br/>
<br/>
## rename<br/>
**Change ext:** `rename 's/\.txt$/.md/' *.txt`<br/>
**Prefix:** `rename 's/^/old-/' *`<br/>
**Dry run:** `rename -n 's/ /_/g' *`<br/>
<br/>
**Loop alternative:**<br/>
`for f in *.jpeg; do mv "$f" "${f%.jpeg}.jpg"; done`<br/>
