# Remote Access

SSH, SCP, SFTP, and Rsync for secure remote work. Think of SSH as a private secure road between your chai tapris.

## Chai Tapri Analogy

- **SSH** = private secure road with guard, only people with key can enter
- **ssh-keygen** = making a pair of special keys (public key = lock you give out, private key = key you keep)
- **scp** = sending a dabba of ingredients via secure courier
- **rsync** = syncing inventory lists between two shops, only send changes
- **SSH tunnel** = secret underground pipe to reach backroom safely
- **~/.ssh/authorized_keys** = list of trusted delivery boys allowed entry

## ssh — Secure Shell

```bash
ssh user@10.0.1.5
ssh -p 2222 user@tapri.example.com
ssh -i ~/.ssh/id_ed25519 user@host
```

**Chai view:** Drive to other tapri via secure road. `-p 2222` = use side gate instead of main gate 22. `-i` = use specific key.

First-time connection:
```bash
ssh user@host
# Accept fingerprint — like checking shop signboard matches
```

## ssh-keygen — Create Keys

```bash
ssh-keygen -t ed25519 -C "rahul@laptop"
ssh-keygen -t rsa -b 4096
```

**Chai view:** Make lock-and-key pair. Public key (id_ed25519.pub) = lock you install on remote tapri gate. Private key = key you keep in pocket, never share.

Copy to server:
```bash
ssh-copy-id user@10.0.1.5
ssh-copy-id -i ~/.ssh/id_ed25519.pub user@host
```

**Chai view:** Install your lock on their gate. Now you can enter without password.

## ssh config — Shortcuts

~/.ssh/config
```
Host prod
    HostName 10.0.1.5
    User deploy
    Port 2222
    IdentityFile ~/.ssh/id_prod
    ServerAliveInterval 60
```

**Chai view:** Save address in phonebook. Instead of typing full address, just `ssh prod`.

Use:
```bash
ssh prod
```

## scp — Secure Copy

```bash
scp file.txt user@host:/tmp/
scp -r folder/ user@host:/opt/
scp -P 2222 user@host:/var/log/app.log ./
scp -i ~/.ssh/id_prod local.txt prod:/tmp/
```

**Chai view:** Send dabba via secure courier. `-r` = send whole shelf. `-P` = use side gate.

Real use:
```bash
# Copy backup to remote
scp -C backup.tar.gz user@backup:/backups/
# -C compresses like vacuum packing
```

## sftp — Interactive File Transfer

```bash
sftp user@host
sftp -P 2222 user@host
```

Inside sftp:
```
ls
cd /var/log
get app.log
put local.txt
mget *.gz
bye
```

**Chai view:** Walk into remote godown, browse shelves, pick what you need. Safer than scp for exploring.

## rsync — Efficient Sync

```bash
rsync -avz local/ user@host:/remote/
rsync -avz --delete local/ user@host:/remote/
rsync -avz -e "ssh -p 2222" local/ user@host:/remote/
```

**Flags:** a=archive (keep permissions), v=verbose, z=compress, --delete = remove extra files

**Chai view:** Compare inventory lists between two shops. Only send items that changed, not whole godown. `--delete` = remove items from remote that you deleted locally.

Real use:
```bash
# Deploy code
rsync -avz --exclude '.git' ./ prod:/var/www/app/

# Backup with progress
rsync -avz --progress /data/ backup:/backups/
```

## SSH Tunnels — Port Forwarding

### Local forward
```bash
ssh -L 3306:db.internal:3306 user@bastion
```

**Chai view:** Create secret pipe from your laptop port 3306 to database's private backroom via bastion tapri. Now `mysql -h 127.0.0.1` reaches private DB.

### Remote forward
```bash
ssh -R 8080:localhost:3000 user@public-server
```

**Chai view:** Open pipe from public server back to your laptop. Others access public:8080 and reach your local app.

### Dynamic SOCKS proxy
```bash
ssh -D 1080 user@bastion
```

**Chai view:** Use bastion as market gateway for all traffic.

## ssh-agent — Key Management

```bash
eval $(ssh-agent)
ssh-add ~/.ssh/id_ed25519
ssh-add -l
```

**Chai view:** Keyring that holds your keys in memory, so you don't type passphrase each time.

## Troubleshooting SSH

```bash
ssh -v user@host          # verbose
ssh -vvv user@host        # debug
```

**Chai view:** `-v` = guard tells you step by step why gate won't open.

Common issues:
```bash
# Permission denied (publickey)
# Fix: check ~/.ssh permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_*
chmod 644 ~/.ssh/id_*.pub

# Check server logs
sudo journalctl -u sshd -f
```

## Real-world Scenarios

**Scenario 1: Deploy without password**
```bash
ssh-keygen -t ed25519
ssh-copy-id deploy@prod
ssh deploy@prod "systemctl restart app"
```

**Scenario 2: Copy logs from 10 servers**
```bash
for h in prod{1..10}; do
  scp $h:/var/log/app.log ./logs/$h.log
done
```

**Scenario 3: Secure database access**
```bash
ssh -fN -L 5432:db.private:5432 bastion
psql -h localhost -U app
```
**Chai view:** No direct road to DB. Go via bastion tapri through secret pipe.

**Scenario 4: Resume broken transfer**
```bash
rsync -avz --partial --progress bigfile.iso user@host:/tmp/
```
**Chai view:** Courier dropped dabba halfway. rsync resumes from where stopped.

## Security Best Practices

```bash
# Disable password login (on server)
/etc/ssh/sshd_config:
PasswordAuthentication no
PermitRootLogin no
Port 2222

sudo systemctl reload sshd
```

**Chai view:** Only allow entry with keys, not passwords. Close main gate 22, use side gate. Don't allow owner key (root).

## What to Remember

- ssh-keygen once, ssh-copy-id to each server
- Use ~/.ssh/config for shortcuts
- scp for single files, rsync for folders and sync
- rsync -avz --delete mirrors exactly
- ssh -L for local forward, -R for remote
- chmod 600 private keys or SSH refuses
- ssh -v for debugging
- Use ssh-agent to avoid passphrase prompts
- Never share private key, only public key
