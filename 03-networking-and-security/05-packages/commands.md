# Packages - Quick Reference

## APT Update/Upgrade
sudo apt update<br/>
sudo apt upgrade<br/>
sudo apt upgrade -y<br/>
sudo apt full-upgrade<br/>
sudo apt dist-upgrade<br/>
---
## APT Install/Remove
sudo apt install nginx<br/>
sudo apt install nginx=1.18.0-1<br/>
sudo apt remove nginx<br/>
sudo apt purge nginx<br/>
sudo apt autoremove<br/>
sudo apt autoremove --purge<br/>
---
## APT Search/Info
apt search nginx<br/>
apt show nginx<br/>
apt list --installed<br/>
apt list --upgradable<br/>
apt list -a nginx<br/>
apt-cache policy nginx<br/>
---
## APT Clean
sudo apt clean<br/>
sudo apt autoclean<br/>
---
## APT Hold
sudo apt-mark hold nginx<br/>
sudo apt-mark unhold nginx<br/>
sudo apt-mark showhold<br/>
---
## DNF/YUM
sudo dnf check-update<br/>
sudo dnf upgrade<br/>
sudo dnf install nginx<br/>
sudo dnf remove nginx<br/>
sudo dnf autoremove<br/>
dnf search nginx<br/>
dnf info nginx<br/>
dnf list installed<br/>
dnf repolist<br/>
sudo dnf versionlock add nginx<br/>
---
## DPKG/RPM
sudo dpkg -i package.deb<br/>
sudo dpkg -l | grep nginx<br/>
sudo dpkg -r nginx<br/>
dpkg -S /usr/bin/nginx<br/>
sudo rpm -ivh package.rpm<br/>
sudo rpm -qa | grep nginx<br/>
rpm -qf /usr/bin/nginx<br/>
---
## Snap/Flatpak
sudo snap install code --classic<br/>
snap list<br/>
sudo snap refresh<br/>
flatpak install flathub org.gimp.GIMP<br/>
flatpak list<br/>
---
## Repositories
cat /etc/apt/sources.list<br/>
ls /etc/apt/sources.list.d/<br/>
sudo add-apt-repository ppa:nginx/stable<br/>
sudo add-apt-repository --remove ppa:nginx/stable<br/>
sudo dnf config-manager --add-repo URL<br/>
---
## Troubleshooting
sudo rm /var/lib/apt/lists/lock<br/>
sudo rm /var/cache/apt/archives/lock<br/>
sudo dpkg --configure -a<br/>
sudo apt --fix-broken install<br/>
sudo apt install -f<br/>
---
## Quick Checks
apt list --upgradable<br/>
dnf check-update<br/>
dpkg -l | wc -l<br/>
rpm -qa | wc -l<br/>
