# Packages - Command Explanations with Chai Analogy

## apt update
**What:** Downloads latest package lists from repositories.<br/>
**Chai:** Calls supplier, gets latest catalog with prices. Does NOT install anything.<br/>
**Use:** Always run before install or upgrade.<br/>

## apt upgrade
**What:** Upgrades all packages to latest versions.<br/>
**Chai:** Replaces old ingredients with fresh ones from catalog. Keeps configs.<br/>
**Use:** Regular maintenance.<br/>

## apt full-upgrade
**What:** Upgrades and may remove packages to resolve dependencies.<br/>
**Chai:** If new tea requires new sugar type, removes old sugar. More aggressive.<br/>
**Use:** Distribution upgrades.<br/>

## apt install nginx
**What:** Installs package and dependencies.<br/>
**Chai:** Orders nginx from supplier, also orders required items like libraries.<br/>
**Use:** Install software.<br/>

## apt remove vs purge
**What:** remove deletes package, purge deletes package + configs.<br/>
**Chai:** remove = throw away ingredient but keep recipe card. purge = throw away both.<br/>
**Use:** purge for clean reinstall.<br/>

## apt autoremove
**What:** Removes automatically installed packages no longer needed.<br/>
**Chai:** Cleans empty boxes left after removing main item.<br/>
**Use:** Free disk space.<br/>

## apt-mark hold
**What:** Prevents package from being upgraded.<br/>
**Chai:** Tell supplier "don't touch this ingredient, keep current version".<br/>
**Use:** Pin production versions.<br/>

## dnf upgrade
**What:** RHEL/Fedora equivalent of apt upgrade.<br/>
**Chai:** Same as apt but for different supplier (Red Hat).<br/>
**Use:** On CentOS/RHEL/Fedora systems.<br/>

## dpkg -i
**What:** Installs .deb file directly.<br/>
**Chai:** Unpack box manually without checking if you have required tools. May fail.<br/>
**Use:** Only when apt not available. Prefer `apt install ./package.deb`<br/>

## snap install
**What:** Installs snap package (containerized).<br/>
**Chai:** Pre-packed meal kit with all ingredients included. Isolated from system.<br/>
**Use:** Newer apps, but larger size.<br/>

## add-apt-repository
**What:** Adds PPA or external repo.<br/>
**Chai:** Add new supplier to your supplier list.<br/>
**Use:** Get newer versions not in official repos.<br/>

## apt --fix-broken install
**What:** Fixes broken dependencies.<br/>
**Chai:** Supplier delivered half order, this completes it.<br/>
**Use:** After failed install or interrupted upgrade.<br/>

## Common Patterns

**Safe update:**
apt update && apt list --upgradable → review → apt upgrade<br/>

**Install specific version:**
apt list -a nginx → apt install nginx=version → apt-mark hold nginx<br/>

**Clean system:**
apt autoremove --purge && apt clean<br/>

**Find package for command:**
apt-file search bin/command (Debian)<br/>
dnf provides */command (RHEL)<br/>
