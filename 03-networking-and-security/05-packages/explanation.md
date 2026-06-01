# Packages - Command Explanations with Chai Analogy

## apt update
**What:** Downloads latest package lists from repositories.
**Chai:** Calls supplier, gets latest catalog with prices. Does NOT install anything.
**Use:** Always run before install or upgrade.

## apt upgrade
**What:** Upgrades all packages to latest versions.
**Chai:** Replaces old ingredients with fresh ones from catalog. Keeps configs.
**Use:** Regular maintenance.

## apt full-upgrade
**What:** Upgrades and may remove packages to resolve dependencies.
**Chai:** If new tea requires new sugar type, removes old sugar. More aggressive.
**Use:** Distribution upgrades.

## apt install nginx
**What:** Installs package and dependencies.
**Chai:** Orders nginx from supplier, also orders required items like libraries.
**Use:** Install software.

## apt remove vs purge
**What:** remove deletes package, purge deletes package + configs.
**Chai:** remove = throw away ingredient but keep recipe card. purge = throw away both.
**Use:** purge for clean reinstall.

## apt autoremove
**What:** Removes automatically installed packages no longer needed.
**Chai:** Cleans empty boxes left after removing main item.
**Use:** Free disk space.

## apt-mark hold
**What:** Prevents package from being upgraded.
**Chai:** Tell supplier "don't touch this ingredient, keep current version".
**Use:** Pin production versions.

## dnf upgrade
**What:** RHEL/Fedora equivalent of apt upgrade.
**Chai:** Same as apt but for different supplier (Red Hat).
**Use:** On CentOS/RHEL/Fedora systems.

## dpkg -i
**What:** Installs .deb file directly.
**Chai:** Unpack box manually without checking if you have required tools. May fail.
**Use:** Only when apt not available. Prefer `apt install ./package.deb`

## snap install
**What:** Installs snap package (containerized).
**Chai:** Pre-packed meal kit with all ingredients included. Isolated from system.
**Use:** Newer apps, but larger size.

## add-apt-repository
**What:** Adds PPA or external repo.
**Chai:** Add new supplier to your supplier list.
**Use:** Get newer versions not in official repos.

## apt --fix-broken install
**What:** Fixes broken dependencies.
**Chai:** Supplier delivered half order, this completes it.
**Use:** After failed install or interrupted upgrade.

## Common Patterns

**Safe update:**
apt update && apt list --upgradable → review → apt upgrade

**Install specific version:**
apt list -a nginx → apt install nginx=version → apt-mark hold nginx

**Clean system:**
apt autoremove --purge && apt clean

**Find package for command:**
apt-file search bin/command (Debian)
dnf provides */command (RHEL)
