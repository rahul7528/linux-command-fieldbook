# Users and Permissions - Quick Reference

## Users
whoami
id
id rahul
cat /etc/passwd
sudo adduser username
sudo useradd -m -s /bin/bash username
sudo passwd username
sudo deluser username
sudo deluser --remove-home username
---
## Groups
groups
groups rahul
getent group
sudo groupadd kitchen
sudo usermod -aG kitchen rahul
sudo gpasswd -d rahul kitchen
sudo delgroup kitchen
---
## sudo
sudo -l
sudo -i
sudo -u postgres psql
sudo visudo
---
## Permissions
ls -l
ls -ld /path
chmod 755 script.sh
chmod 644 file.txt
chmod 600 ~/.ssh/id_ed25519
chmod 700 ~/.ssh
chmod u+x file
chmod g-w file
chmod o-rwx dir
chmod -R 755 /var/www
---
## Ownership
chown user:group file
chown -R www-data:www-data /var/www
chgrp kitchen file
chown user file
---
## Special Bits
chmod 4755 file
chmod 2755 dir
chmod 1777 /tmp
chmod u+s file
chmod g+s dir
chmod +t dir
---
## umask
umask
umask 022
umask 077
---
## ACLs
getfacl file
setfacl -m u:username:rw file
setfacl -m g:groupname:rwx dir
setfacl -x u:username file
setfacl -b file
---
## Immutable
lsattr file
sudo chattr +i file
sudo chattr -i file
sudo chattr +a logfile
---
## Switch User
su - username
su username
exit
---
## Quick Fixes
sudo chown -R $USER:$USER ~/project
find /var/www -type d -exec chmod 755 {} \;
find /var/www -type f -exec chmod 644 {} \;
chmod -R u+rwX,go+rX,go-w /path
