# Packages

Installing, updating, and managing software with apt, dnf, yum. Think of package manager as your tapri's supplier who delivers ingredients.

## Chai Tapri Analogy

- **Package manager** = supplier (apt, dnf)
- **Repository** = supplier's warehouse catalog
- **apt update** = get latest catalog from supplier
- **apt upgrade** = replace old ingredients with fresh ones
- **apt install** = order new ingredient
- **dpkg** = low-level unpacking tool
- **snap/flatpak** = pre-packed meal kits

## APT — Debian/Ubuntu

### Update catalog
```bash
sudo apt update
```

**Chai view:** Call supplier, get latest price list. Does not install anything.

### Upgrade packages
```bash
sudo apt upgrade
sudo apt upgrade -y
sudo apt full-upgrade
```

**Chai view:** Replace all old tea leaves, sugar with fresh stock. full-upgrade can remove old packages if needed.

### Install and remove
```bash
sudo apt install nginx
sudo apt install nginx=1.18.0-1
sudo apt remove nginx
sudo apt purge nginx
sudo apt autoremove
```

**Chai view:**
- install = order new item
- remove = throw away item but keep config (recipe card)
- purge = throw away item and recipe
- autoremove = clean unused dependencies (empty boxes)

### Search and info
```bash
apt search nginx
apt show nginx
apt list --installed
apt list --upgradable
```

### Clean cache
```bash
sudo apt clean
sudo apt autoclean
```

**Chai view:** clean = empty entire storeroom of downloaded packages. autoclean = remove old versions only.

## DNF/YUM — RHEL/CentOS/Fedora

### Update and upgrade
```bash
sudo dnf check-update
sudo dnf upgrade
sudo dnf update
```

### Install and remove
```bash
sudo dnf install nginx
sudo dnf remove nginx
sudo dnf autoremove
```

### Search
```bash
dnf search nginx
dnf info nginx
dnf list installed
dnf repolist
```

## DPKG/RPM — Low-level

```bash
# Debian
sudo dpkg -i package.deb
sudo dpkg -l | grep nginx
sudo dpkg -r nginx

# RHEL
sudo rpm -ivh package.rpm
sudo rpm -qa | grep nginx
sudo rpm -e nginx
```

**Chai view:** Directly unpack box without checking dependencies. Use only if apt/dnf not available.

## Snap and Flatpak

```bash
sudo snap install code --classic
snap list
sudo snap refresh

flatpak install flathub org.gimp.GIMP
flatpak list
```

**Chai view:** Pre-packed meal kits with all dependencies included. Larger but isolated.

## Repositories

### APT sources
```bash
cat /etc/apt/sources.list
ls /etc/apt/sources.list.d/
sudo add-apt-repository ppa:nginx/stable
sudo apt update
```

**Chai view:** Add new supplier to your list.

### DNF repos
```bash
sudo dnf config-manager --add-repo https://example.com/repo.repo
sudo dnf config-manager --set-enabled powertools
```

## Holding Packages

Prevent upgrades:

```bash
# APT
sudo apt-mark hold nginx
sudo apt-mark unhold nginx
sudo apt-mark showhold

# DNF
sudo dnf versionlock add nginx
sudo dnf versionlock delete nginx
```

**Chai view:** Tell supplier "don't replace this ingredient, keep current version".

## Troubleshooting

```bash
# APT lock
sudo rm /var/lib/apt/lists/lock
sudo rm /var/cache/apt/archives/lock
sudo dpkg --configure -a

# Fix broken
sudo apt --fix-broken install
sudo apt install -f

# Check what package owns file
dpkg -S /usr/bin/nginx
rpm -qf /usr/bin/nginx
```

## Real-world Scenarios

**Scenario 1: Update all servers**
```bash
sudo apt update && sudo apt upgrade -y
```

**Scenario 2: Install specific version**
```bash
apt list -a nginx
sudo apt install nginx=1.18.0-0ubuntu1
sudo apt-mark hold nginx
```

**Scenario 3: Clean up disk**
```bash
sudo apt autoremove --purge
sudo apt clean
df -h /
```

**Scenario 4: Find which package provides command**
```bash
# Debian
apt-file search bin/htop
sudo apt install apt-file && apt-file update

# RHEL
dnf provides */htop
```

**Scenario 5: Downgrade package**
```bash
sudo apt install nginx=1.18.0-1
```

## Security Updates

```bash
# Ubuntu
sudo unattended-upgrades --dry-run
sudo apt install unattended-upgrades

# Check for security updates
apt list --upgradable | grep -i security
```

**Chai view:** Automatic delivery of security patches, like supplier replacing expired milk automatically.

## What to Remember

- Always `apt update` before `apt install`
- `upgrade` safe, `full-upgrade` can remove packages
- `remove` keeps config, `purge` removes everything
- `autoremove` cleans unused dependencies
- Use `apt-mark hold` to pin versions
- Never delete apt locks unless process dead
- `dpkg -i` bypasses dependency checks — use apt instead
- Check `apt list --upgradable` before upgrading production
