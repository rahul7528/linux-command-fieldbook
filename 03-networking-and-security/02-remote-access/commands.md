# Remote Access - Quick Reference

## SSH Basic
ssh user@host
ssh -p 2222 user@host
ssh -i ~/.ssh/id_ed25519 user@host
ssh -v user@host
ssh -o StrictHostKeyChecking=no user@host
---
## Keys
ssh-keygen -t ed25519 -C "email"
ssh-keygen -t rsa -b 4096
ssh-copy-id user@host
ssh-copy-id -i ~/.ssh/id.pub user@host
ssh-add ~/.ssh/id_ed25519
ssh-add -l
eval $(ssh-agent)
---
## SSH Config
cat ~/.ssh/config
ssh prod
ssh -F /tmp/config host
---
## SCP
scp file.txt user@host:/tmp/
scp -r dir/ user@host:/opt/
scp -P 2222 file user@host:/tmp/
scp user@host:/var/log/app.log ./
scp -C large.tar.gz user@host:/tmp/
---
## SFTP
sftp user@host
sftp -P 2222 user@host
get remote.txt
put local.txt
mget *.log
---
## Rsync
rsync -avz local/ user@host:/remote/
rsync -avz --delete local/ user@host:/remote/
rsync -avz -e "ssh -p 2222" src/ user@host:/dst/
rsync -avz --progress --partial big.iso user@host:/tmp/
rsync -avz --exclude '.git' ./ user@host:/app/
---
## Tunnels
ssh -L 3306:db.internal:3306 user@bastion
ssh -L 8080:localhost:80 user@host
ssh -R 9000:localhost:3000 user@public
ssh -D 1080 user@bastion
ssh -fN -L 5432:db:5432 bastion
---
## Troubleshooting
ssh -vvv user@host
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_*
sudo journalctl -u sshd -f
sudo tail -f /var/log/auth.log
ssh -o ConnectTimeout=5 user@host
---
## Quick Checks
ssh user@host "uptime"
ssh user@host "df -h"
ssh user@host "sudo systemctl status nginx"
for h in host1 host2; do ssh $h uptime; done
