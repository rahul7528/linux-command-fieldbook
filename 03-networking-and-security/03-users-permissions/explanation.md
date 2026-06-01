# Users and Permissions - Command Explanations with Chai Analogy

## whoami / id
**What:** Shows current user and groups.
**Chai:** Check your staff badge and which teams you belong to.
**Use:** Confirm you're not root before dangerous command.

## adduser vs useradd
**What:** adduser is interactive friendly, useradd is low-level.
**Chai:** adduser = HR hires with full onboarding. useradd = just add name to roster.
**Use:** Use adduser for humans, useradd -m for scripts.

## usermod -aG kitchen rahul
**What:** Adds rahul to kitchen group without removing other groups.
**Chai:** Add staff to new team, keep existing teams. `-a` is critical — without it, removes all other groups.
**Use:** Grant access to shared folder.

## sudo -l
**What:** Lists your sudo privileges.
**Chai:** Check which master keys you're allowed to borrow.
**Use:** Debug "not in sudoers" errors.

## chmod 755
**What:** Sets rwxr-xr-x.
**Chai:** Owner can read/write/execute, team and others can read/execute but not modify. Perfect for scripts.
**Use:** Make script executable by all.

## chmod 644
**What:** Sets rw-r--r--.
**Chai:** Owner can read/write, everyone else read-only. For config files.
**Use:** Default for files.

## chmod 600
**What:** Sets rw-------.
**Chai:** Only owner can read/write, like personal locker. SSH keys must be 600.
**Use:** Private keys, secrets.

## chown -R www-data:www-data
**What:** Recursively changes owner and group.
**Chai:** Give entire shelf to web server staff so they can serve files.
**Use:** Fix web server permission errors.

## chmod g+s
**What:** Setgid bit on directory.
**Chai:** New dabbas created in shared folder automatically belong to team, not creator's personal group.
**Use:** Shared project folders.

## chmod 1777 /tmp
**What:** Sticky bit with full permissions.
**Chai:** Community board — anyone can pin note, but only owner can remove their own note. Prevents deleting others' temp files.
**Use:** /tmp, shared upload dirs.

## umask 022
**What:** Sets default permission mask.
**Chai:** New dabbas automatically get 644 (files) and 755 (dirs). 022 subtracts write for group/others.
**Use:** Set in ~/.bashrc for secure defaults.

## setfacl -m u:chaiwala:rw
**What:** Gives specific user rw access via ACL.
**Chai:** Normal permissions allow 3 categories. ACL lets you give one specific staff member access without adding to team.
**Use:** Grant temporary access to single user.

## chattr +i
**What:** Makes file immutable.
**Chai:** Weld dabba shut. Even owner can't modify until unweld. Protects from accidental deletion.
**Use:** Protect /etc/passwd, critical configs.

## su - vs sudo
**What:** su switches user (needs target password), sudo runs as other (needs your password).
**Chai:** su = become other staff fully. sudo = borrow owner key for one task.
**Use:** sudo for admin tasks, su - for debugging as other user.

## Common Mistakes

**chmod 777:** Gives everyone full access. Like leaving shop unlocked overnight. Never use in production.

**usermod -G without -a:** Removes user from all other groups. Always use -aG.

**Wrong ownership on .ssh:** SSH will refuse keys if ~/.ssh is not 700 or keys not 600.

**Recursive chown on /**: Catastrophic. Always double-check path.

## Patterns

**Web app deployment:**
chown -R deploy:www-data /var/www
find /var/www -type d -exec chmod 775 {} \;
find /var/www -type f -exec chmod 664 {} \;

**Secure home:**
chmod 700 ~
chmod 700 ~/.ssh

**Shared team folder:**
mkdir /srv/team
chown root:team /srv/team
chmod 2770 /srv/team
