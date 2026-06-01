# Users and Permissions

Managing users, groups, sudo, and file permissions. Think of your tapri as having staff roles and locked cupboards.

## Chai Tapri Analogy

- **User** = staff member (rahul, deploy, chaiwala)
- **Group** = team (kitchen, cashiers, managers)
- **root** = shop owner, has all keys
- **sudo** = temporary owner powers for specific task
- **chmod** = setting who can open which dabba (read, write, execute)
- **chown** = changing who owns the dabba
- **umask** = default lock setting for new dabbas

## Users — Staff Management

### View users
```bash
whoami
id
id rahul
cat /etc/passwd | grep rahul
```

**Chai view:** `whoami` = which staff badge you're wearing. `id` = your teams.

### Create user
```bash
sudo adduser chaiwala
sudo useradd -m -s /bin/bash deploy
sudo passwd chaiwala
```

**Chai view:** Hire new staff, give locker (home), set uniform (shell).

### Delete user
```bash
sudo deluser chaiwala
sudo deluser --remove-home chaiwala
```

## Groups — Teams

```bash
groups
groups rahul
sudo groupadd kitchen
sudo usermod -aG kitchen rahul
sudo gpasswd -d rahul kitchen
```

**Chai view:** Add rahul to kitchen team. `-aG` = append to group, don't remove others.

Check:
```bash
getent group kitchen
```

## sudo — Temporary Owner Powers

```bash
sudo ls /root
sudo -i
sudo -u postgres psql
```

**Chai view:** sudo = ask owner for master key for one task. You don't become owner permanently.

Configure:
```bash
sudo visudo
```

Add line:
```
deploy ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart nginx
```

**Chai view:** Allow deploy staff to restart nginx without password, nothing else.

Check sudo rights:
```bash
sudo -l
```

## File Permissions — chmod

```bash
ls -l
-rwxr-xr-- 1 rahul kitchen 1024 May 18 file.txt
```

**Chai view:** Three groups: owner (rahul), team (kitchen), others (customers).
- r = read (can open dabba and see)
- w = write (can add/remove items)
- x = execute (can use as tool, or enter folder)

Numbers:
- 4 = read, 2 = write, 1 = execute
- 7 = 4+2+1 = rwx
- 6 = 4+2 = rw-
- 5 = 4+1 = r-x

```bash
chmod 755 script.sh    # rwxr-xr-x
chmod 640 secret.txt   # rw-r-----
chmod u+x script.sh    # add execute for owner
chmod g-w file.txt     # remove write for group
chmod o-rwx private/   # no access for others
```

**Chai view:** 755 = owner can do everything, team and customers can read and run but not modify. Good for scripts.

## Ownership — chown and chgrp

```bash
sudo chown rahul:kitchen file.txt
sudo chown -R www-data:www-data /var/www/
sudo chgrp kitchen shared/
```

**Chai view:** Change who owns dabba and which team can access. `-R` = recursive for whole shelf.

## Special Permissions

```bash
chmod 4755 /usr/bin/myapp   # setuid
chmod 2755 shared/          # setgid
chmod 1777 /tmp             # sticky bit
```

**Chai view:**
- setuid (4) = anyone running gets owner powers temporarily (like using owner's special knife)
- setgid (2) = new files inherit team
- sticky (1) = in /tmp, anyone can add but only owner can delete own files (like community board)

## umask — Default Permissions

```bash
umask
umask 022
```

**Chai view:** Default lock for new dabbas. umask 022 = new files 644 (rw-r--r--), new dirs 755 (rwxr-xr-x). Calculation: 666-022=644.

Set in ~/.bashrc for user.

## ACLs — Fine-grained

```bash
getfacl file.txt
setfacl -m u:chaiwala:rw file.txt
setfacl -m g:kitchen:rwx shared/
setfacl -x u:chaiwala file.txt
```

**Chai view:** Normal permissions = 3 teams. ACL = give specific staff member special access without changing team.

## lsattr and chattr — Immutable

```bash
lsattr file.txt
sudo chattr +i important.conf
sudo chattr -i important.conf
```

**Chai view:** `+i` = weld dabba shut, even owner can't modify without removing weld. Protects critical configs.

## su — Switch User

```bash
su - postgres
su chaiwala
```

**Chai view:** su = fully become other staff (need their password). sudo = borrow powers with your password.

## Real-world Scenarios

**Scenario 1: Deploy user needs access to app folder**
```bash
sudo groupadd deploy
sudo usermod -aG deploy rahul
sudo chown -R deploy:deploy /var/www/app
sudo chmod -R 775 /var/www/app
sudo chmod g+s /var/www/app   # new files keep group
```

**Chai view:** Create deploy team, give them ownership of app shelf, set so new files stay in team.

**Scenario 2: Secure SSH keys**
```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
chmod 600 ~/.ssh/authorized_keys
```

**Chai view:** SSH refuses if keys are readable by others — like leaving shop keys on counter.

**Scenario 3: Shared folder for team**
```bash
sudo mkdir /srv/shared
sudo chown root:kitchen /srv/shared
sudo chmod 2770 /srv/shared
```

**Chai view:** 2770 = team can read/write/enter, others blocked, setgid ensures new files stay in kitchen team.

**Scenario 4: Give limited sudo**
```bash
sudo visudo
# Add:
chaiwala ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart chai-app
```

## What to Remember

- id, groups — check your teams
- usermod -aG — append, don't replace
- chmod numbers: 7=rwx, 6=rw, 5=rx, 4=r
- chown changes owner, chmod changes permissions
- 755 for scripts, 644 for files, 700 for private dirs
- sudo -l shows your powers
- umask 022 is safe default
- setgid 2770 for shared team folders
- chattr +i protects critical files
- Never chmod 777 — like leaving shop open to public
