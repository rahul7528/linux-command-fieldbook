# Users and Permissions - Quick Reference

## Users<br/>
whoami<br/>
id<br/>
id rahul<br/>
cat /etc/passwd<br/>
sudo adduser username<br/>
sudo useradd -m -s /bin/bash username<br/>
sudo passwd username<br/>
sudo deluser username<br/>
sudo deluser --remove-home username<br/>
---<br/><br/>
## Groups<br/>
groups<br/>
groups rahul<br/>
getent group<br/>
sudo groupadd kitchen<br/>
sudo usermod -aG kitchen rahul<br/>
sudo gpasswd -d rahul kitchen<br/>
sudo delgroup kitchen<br/>
---<br/><br/>
## sudo<br/>
sudo -l<br/>
sudo -i<br/>
sudo -u postgres psql<br/>
sudo visudo<br/>
---<br/><br/>
## Permissions<br/>
ls -l<br/>
ls -ld /path<br/>
chmod 755 script.sh<br/>
chmod 644 file.txt<br/>
chmod 600 ~/.ssh/id_ed25519<br/>
chmod 700 ~/.ssh<br/>
chmod u+x file<br/>
chmod g-w file<br/>
chmod o-rwx dir<br/>
chmod -R 755 /var/www<br/>
---<br/><br/>
## Ownership<br/>
chown user:group file<br/>
chown -R www-data:www-data /var/www<br/>
chgrp kitchen file<br/>
chown user file<br/>
---<br/><br/>
## Special Bits<br/>
chmod 4755 file<br/>
chmod 2755 dir<br/>
chmod 1777 /tmp<br/>
chmod u+s file<br/>
chmod g+s dir<br/>
chmod +t dir<br/>
---<br/><br/>
## umask<br/>
umask<br/>
umask 022<br/>
umask 077<br/>
---<br/><br/>
## ACLs<br/>
getfacl file<br/>
setfacl -m u:username:rw file<br/>
setfacl -m g:groupname:rwx dir<br/>
setfacl -x u:username file<br/>
setfacl -b file<br/>
---<br/><br/>
## Immutable<br/>
lsattr file<br/>
sudo chattr +i file<br/>
sudo chattr -i file<br/>
sudo chattr +a logfile<br/>
---<br/><br/>
## Switch User<br/>
su - username<br/>
su username<br/>
exit<br/>
---<br/><br/>
## Quick Fixes<br/>
sudo chown -R $USER:$USER ~/project<br/>
find /var/www -type d -exec chmod 755 {} \;<br/>
find /var/www -type f -exec chmod 644 {} \;<br/>
chmod -R u+rwX,go+rX,go-w /path<br/>
