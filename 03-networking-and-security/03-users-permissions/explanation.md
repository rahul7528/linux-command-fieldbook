# Users and Permissions - Command Explanations with Chai Analogy

## whoami / id<br/>
**What:** Shows current user and groups.<br/>
**Chai:** Check your staff badge and which teams you belong to.<br/>
**Use:** Confirm you're not root before dangerous command.<br/>

## adduser vs useradd<br/>
**What:** adduser is interactive friendly, useradd is low-level.<br/>
**Chai:** adduser = HR hires with full onboarding. useradd = just add name to roster.<br/>
**Use:** Use adduser for humans, useradd -m for scripts.<br/>

## usermod -aG kitchen rahul<br/>
**What:** Adds rahul to kitchen group without removing other groups.<br/>
**Chai:** Add staff to new team, keep existing teams. `-a` is critical — without it, removes all other groups.<br/>
**Use:** Grant access to shared folder.<br/>

## sudo -l<br/>
**What:** Lists your sudo privileges.<br/>
**Chai:** Check which master keys you're allowed to borrow.<br/>
**Use:** Debug "not in sudoers" errors.<br/>

## chmod 755<br/>
**What:** Sets rwxr-xr-x.<br/>
**Chai:** Owner can read/write/execute, team and others can read/execute but not modify. Perfect for scripts.<br/>
**Use:** Make script executable by all.<br/>

## chmod 644<br/>
**What:** Sets rw-r--r--.<br/>
**Chai:** Owner can read/write, everyone else read-only. For config files.<br/>
**Use:** Default for files.<br/>

## chmod 600<br/>
**What:** Sets rw-------.<br/>
**Chai:** Only owner can read/write, like personal locker. SSH keys must be 600.<br/>
**Use:** Private keys, secrets.<br/>

## chown -R www-data:www-data<br/>
**What:** Recursively changes owner and group.<br/>
**Chai:** Give entire shelf to web server staff so they can serve files.<br/>
**Use:** Fix web server permission errors.<br/>

## chmod g+s<br/>
**What:** Setgid bit on directory.<br/>
**Chai:** New dabbas created in shared folder automatically belong to team, not creator's personal group.<br/>
**Use:** Shared project folders.<br/>

## chmod 1777 /tmp<br/>
**What:** Sticky bit with full permissions.<br/>
**Chai:** Community board — anyone can pin note, but only owner can remove their own note. Prevents deleting others' temp files.<br/>
**Use:** /tmp, shared upload dirs.<br/>

## umask 022<br/>
**What:** Sets default permission mask.<br/>
**Chai:** New dabbas automatically get 644 (files) and 755 (dirs). 022 subtracts write for group/others.<br/>
**Use:** Set in ~/.bashrc for secure defaults.<br/>

## setfacl -m u:chaiwala:rw<br/>
**What:** Gives specific user rw access via ACL.<br/>
**Chai:** Normal permissions allow 3 categories. ACL lets you give one specific staff member access without adding to team.<br/>
**Use:** Grant temporary access to single user.<br/>

## chattr +i<br/>
**What:** Makes file immutable.<br/>
**Chai:** Weld dabba shut. Even owner can't modify until unweld. Protects from accidental deletion.<br/>
**Use:** Protect /etc/passwd, critical configs.<br/>

## su - vs sudo<br/>
**What:** su switches user (needs target password), sudo runs as other (needs your password).<br/>
**Chai:** su = become other staff fully. sudo = borrow owner key for one task.<br/>
**Use:** sudo for admin tasks, su - for debugging as other user.<br/>
<br/>
## Common Mistakes<br/>
<br/>
**chmod 777:** Gives everyone full access. Like leaving shop unlocked overnight. Never use in production.<br/>
<br/>
**usermod -G without -a:** Removes user from all other groups. Always use -aG.<br/>
<br/>
**Wrong ownership on .ssh:** SSH will refuse keys if ~/.ssh is not 700 or keys not 600.<br/>
<br/>
**Recursive chown on /**: Catastrophic. Always double-check path.<br/>
<br/>
## Patterns
<br/>
**Web app deployment:**<br/>
chown -R deploy:www-data /var/www<br/>
find /var/www -type d -exec chmod 775 {} \;<br/>
find /var/www -type f -exec chmod 664 {} \;<br/>
<br/>
**Secure home:**<br/>
chmod 700 ~<br/>
chmod 700 ~/.ssh<br/>
<br/>
**Shared team folder:**<br/>
mkdir /srv/team<br/>
chown root:team /srv/team<br/>
chmod 2770 /srv/team<br/>
