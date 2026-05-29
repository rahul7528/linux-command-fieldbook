# Remote Access - Command Explanations with Chai Analogy

## ssh user@host
**What:** Opens secure shell to remote server.<br/>
**Chai:** Drive to other tapri via private secure road. Guard checks your key or password.<br/>
**Use:** Daily remote work.<br/>

## ssh -p 2222
**What:** Connect to non-standard port.<br/>
**Chai:** Main gate 22 is crowded, use side gate 2222.<br/>
**Use:** Servers with custom SSH port for security.<br/>

## ssh-keygen -t ed25519
**What:** Creates public/private key pair.<br/>
**Chai:** Makes lock (public) and key (private). You keep key, install lock on remote gates. ed25519 is modern, fast.<br/>
**Use:** Passwordless login, automation.<br/>

## ssh-copy-id
**What:** Copies public key to remote authorized_keys.<br/>
**Chai:** Installs your lock on their gate automatically.<br/>
**Use:** After generating key, run once per server.<br/>

## ~/.ssh/config
**What:** SSH client configuration file.<br/>
**Chai:** Phonebook with shortcuts. Define Host prod with full address, user, port, key.<br/>
**Use:** `ssh prod` instead of long command. Essential for many servers.<br/>

## scp file host:/path
**What:** Secure copy over SSH.<br/>
**Chai:** Send dabba via secure courier. Encrypts during travel.<br/>
**Use:** Quick single file transfer.<br/>

## scp -r
**What:** Recursive copy directory.<br/>
**Chai:** Send whole shelf of dabbas, not just one.<br/>
**Use:** Copy folder to remote.<br/>

## sftp
**What:** Interactive FTP over SSH.<br/>
**Chai:** Walk into remote godown, browse, pick files interactively. More flexible than scp.<br/>
**Use:** Explore remote filesystem, download multiple files.<br/>

## rsync -avz
**What:** Sync files efficiently.<br/>
**Flags:** a=archive preserve permissions, v=verbose, z=compress<br/>
**Chai:** Compare two inventory lists, only send changed items. Much faster than scp for updates.<br/>
**Use:** Deploy code, backups.<br/>

## rsync --delete
**What:** Delete files on destination not in source.<br/>
**Chai:** Make remote godown exact mirror of local. Remove extra dabbas.<br/>
**Use:** Dangerous — ensure source is correct, else deletes data.<br/>

## ssh -L 3306:db:3306 bastion
**What:** Local port forward.<br/>
**Chai:** Create secret pipe: your laptop:3306 → bastion → db:3306. Access private DB via localhost.<br/>
**Use:** Access private resources behind bastion.<br/>

## ssh -R
**What:** Remote port forward.<br/>
**Chai:** Opposite direction. Open pipe from remote server back to your laptop.<br/>
**Use:** Expose local dev server to internet via public host.<br/>

## ssh -D 1080
**What:** Dynamic SOCKS proxy.<br/>
**Chai:** Use bastion as market gateway. All your traffic goes through it.<br/>
**Use:** Browse as if from bastion network.<br/>

## ssh-agent
**What:** Holds decrypted keys in memory.<br/>
**Chai:** Keyring in pocket. Unlock once, use many times without retyping passphrase.<br/>
**Use:** Avoid typing passphrase for each connection.<br/>

## chmod 600 ~/.ssh/id_*
**What:** Sets private key permissions.<br/>
**Chai:** SSH refuses key if others can read it (like leaving shop key on counter). Must be owner-only.<br/>
**Use:** Fix "Permissions too open" error.<br/>

## ssh -v
**What:** Verbose mode.<br/>
**Chai:** Guard narrates each step: checking key, trying methods, why failed.<br/>
**Use:** Debug connection issues.<br/>

## Common Patterns

**First-time setup:**<br/>
ssh-keygen → ssh-copy-id → ssh config → ssh host<br/>

**Deploy code:**<br/>
rsync -avz --exclude '.git' ./ prod:/var/www/<br/>

**Access private DB:**<br/>
ssh -fN -L 5432:db.internal:5432 bastion → psql -h localhost<br/>

**Copy logs from many:**<br/>
for h in web{1..5}; do scp $h:/var/log/nginx/access.log logs/$h.log; done<br/>
