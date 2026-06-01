# Packages - Quick Reference

## APT Update/Upgrade
sudo apt update
sudo apt upgrade
sudo apt upgrade -y
sudo apt full-upgrade
sudo apt dist-upgrade
---
## APT Install/Remove
sudo apt install nginx
sudo apt install nginx=1.18.0-1
sudo apt remove nginx
sudo apt purge nginx
sudo apt autoremove
sudo apt autoremove --purge
---
## APT Search/Info
apt search nginx
apt show nginx
apt list --installed
apt list --upgradable
apt list -a nginx
apt-cache policy nginx
---
## APT Clean
sudo apt clean
sudo apt autoclean
---
## APT Hold
sudo apt-mark hold nginx
sudo apt-mark unhold nginx
sudo apt-mark showhold
---
## DNF/YUM
sudo dnf check-update
sudo dnf upgrade
sudo dnf install nginx
sudo dnf remove nginx
sudo dnf autoremove
dnf search nginx
dnf info nginx
dnf list installed
dnf repolist
sudo dnf versionlock add nginx
---
## DPKG/RPM
sudo dpkg -i package.deb
sudo dpkg -l | grep nginx
sudo dpkg -r nginx
dpkg -S /usr/bin/nginx
sudo rpm -ivh package.rpm
sudo rpm -qa | grep nginx
rpm -qf /usr/bin/nginx
---
## Snap/Flatpak
sudo snap install code --classic
snap list
sudo snap refresh
flatpak install flathub org.gimp.GIMP
flatpak list
---
## Repositories
cat /etc/apt/sources.list
ls /etc/apt/sources.list.d/
sudo add-apt-repository ppa:nginx/stable
sudo add-apt-repository --remove ppa:nginx/stable
sudo dnf config-manager --add-repo URL
---
## Troubleshooting
sudo rm /var/lib/apt/lists/lock
sudo rm /var/cache/apt/archives/lock
sudo dpkg --configure -a
sudo apt --fix-broken install
sudo apt install -f
---
## Quick Checks
apt list --upgradable
dnf check-update
dpkg -l | wc -l
rpm -qa | wc -l
