# Remote Access - Command Explanations with Chai Analogy

## ssh user@host
**What:** Opens secure shell to remote server.
**Chai:** Drive to other tapri via private secure road. Guard checks your key or password.
**Use:** Daily remote work.

## ssh -p 2222
**What:** Connect to non-standard port.
**Chai:** Main gate 22 is crowded, use side gate 2222.
**Use:** Servers with custom SSH port for security.

## ssh-keygen -t ed25519
**What:** Creates public/private key pair.
**Chai:** Makes lock (public) and key (private). You keep key, install lock on remote gates. ed25519 is modern, fast.
**Use:** Passwordless login, automation.

## ssh-copy-id
**What:** Copies public key to remote authorized_keys.
**Chai:** Installs your lock on their gate automatically.
**Use:** After generating key, run once per server.

## ~/.ssh/config
**What:** SSH client configuration file.
**Chai:** Phonebook with shortcuts. Define Host prod with full address, user, port, key.
**Use:** `ssh prod` instead of long command. Essential for many servers.

## scp file host:/path
**What:** Secure copy over SSH.
**Chai:** Send dabba via secure courier. Encrypts during travel.
**Use:** Quick single file transfer.

## scp -r
**What:** Recursive copy directory.
**Chai:** Send whole shelf of dabbas, not just one.
**Use:** Copy folder to remote.

## sftp
**What:** Interactive FTP over SSH.
**Chai:** Walk into remote godown, browse, pick files interactively. More flexible than scp.
**Use:** Explore remote filesystem, download multiple files.

## rsync -avz
**What:** Sync files efficiently.
**Flags:** a=archive preserve permissions, v=verbose, z=compress
**Chai:** Compare two inventory lists, only send changed items. Much faster than scp for updates.
**Use:** Deploy code, backups.

## rsync --delete
**What:** Delete files on destination not in source.
**Chai:** Make remote godown exact mirror of local. Remove extra dabbas.
**Use:** Dangerous — ensure source is correct, else deletes data.

## ssh -L 3306:db:3306 bastion
**What:** Local port forward.
**Chai:** Create secret pipe: your laptop:3306 → bastion → db:3306. Access private DB via localhost.
**Use:** Access private resources behind bastion.

## ssh -R
**What:** Remote port forward.
**Chai:** Opposite direction. Open pipe from remote server back to your laptop.
**Use:** Expose local dev server to internet via public host.

## ssh -D 1080
**What:** Dynamic SOCKS proxy.
**Chai:** Use bastion as market gateway. All your traffic goes through it.
**Use:** Browse as if from bastion network.

## ssh-agent
**What:** Holds decrypted keys in memory.
**Chai:** Keyring in pocket. Unlock once, use many times without retyping passphrase.
**Use:** Avoid typing passphrase for each connection.

## chmod 600 ~/.ssh/id_*
**What:** Sets private key permissions.
**Chai:** SSH refuses key if others can read it (like leaving shop key on counter). Must be owner-only.
**Use:** Fix "Permissions too open" error.

## ssh -v
**What:** Verbose mode.
**Chai:** Guard narrates each step: checking key, trying methods, why failed.
**Use:** Debug connection issues.

## Common Patterns

**First-time setup:**
ssh-keygen → ssh-copy-id → ssh config → ssh host

**Deploy code:**
rsync -avz --exclude '.git' ./ prod:/var/www/

**Access private DB:**
ssh -fN -L 5432:db.internal:5432 bastion → psql -h localhost

**Copy logs from many:**
for h in web{1..5}; do scp $h:/var/log/nginx/access.log logs/$h.log; done
