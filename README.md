<h1 align="center">
  <img alt="IDENA ARMer Bash Script - fast idena-go network node deployment for Android" src="https://raw.githubusercontent.com/ltraveler/ltraveler/main/images/IDENA_ARMer_400.png" width="400px"/><br/>
  Idena ARMer Script
</h1>
<p align="center"><b>Bash Script implementation</b> of the <b>Idena network node</b> installation wizard.<br>Install <b>Idena-Go</b> node instance on your mobile device with ARM64 architecture.<br>Simple and user-friendly way to setup your Android device as Idena node server.</p>

<p align="center"><a href="https://github.com/ltraveler/idena-runner/releases/latest" target="_blank"><img src="https://img.shields.io/badge/version-v0.1.0-blue?style=for-the-badge&logo=none" alt="idena runner latest version" /></a>&nbsp;<a href="https://wiki.ubuntu.com/FocalFossa/ReleaseNotes" target="_blank"><img src="https://img.shields.io/badge/Kali-20.04(LTS)+-00ADD8?style=for-the-badge&logo=none" alt="Kali minimum version" /></a>&nbsp;<a href="https://github.com/ltraveler/idena-runner/blob/main/CHANGELOG.md" target="_blank"><img src="https://img.shields.io/badge/Build-Stable-success?style=for-the-badge&logo=none" alt="idena-go latest release" /></a>&nbsp;<a href="https://www.gnu.org/licenses/quick-guide-gplv3.html" target="_blank"><img src="https://img.shields.io/badge/license-GPL3.0-red?style=for-the-badge&logo=none" alt="license" /></a>&nbsp;<a href="https://github.com/ltraveler/idena-armer/blob/master/README.ru-RU.md" target="_blank"><img src="https://img.shields.io/badge/readme-РУССКИЙ-orange?style=for-the-badge&logo=none" alt="Скрипт Idena ARMer" /></a></p>

## 🚀&nbsp; Summary
1. Installing **F-Droid** - an alternative app repository.
2. From **F-Droid** installing **Termux** and **Termux:boot**.
3. Running **Termux** and **Termux:boot** for the 1st time to make basic initialization process of those apps.
4. `termux-setup-storage` - giving to Termux required storage permission.
5. Adding **Termux** and **Termux:boot** to the Power Monitor exclusions.
6. `pkg upgrade -y` - updating termux packages to the latest version.
7. Downloading and running `termux_init.sh` script to prepare Termux terminal to host Kali Linux:
```
curl -O https://raw.githubusercontent.com/ltraveler/idena-armer/master/termux_init.sh
chmod +x ./termux_init.sh && ./termux_init.sh
```
8. `./start-kali.sh` - running Kali Linux.
9. `apt update && apt upgrade -y` - updating Kali Linux packages to the latest version.
10. `apt install git -y` - installing git package.
11. `git clone https://github.com/ltraveler/idena-armer.git` - cloning IDENA ARMer repository.
12. `cd idena-armer && chmod +x ARMer_init.sh &&./ARMer_init.sh` - running IDENA ARMer and following the script's installation instructions.
13. Reboot the phone.

## 📗&nbsp; The detailed installation guide has been published here:
https://medium.com/@idna.project/b9229c010440

## 👀&nbsp; IDENA Coacher — Node Management Tool
1. **IDENA ARMer** will set ***IDENA Coacher*** to manage your node.
2. It is placed on the home folder of the user that has been used to install idena.
```
cd /home/%username%/idena-coacher
```
3. Make script executable.
```
chmod +x idena_coacher.sh
```
4. Run the script.
```
./idena_coacher.sh
```
5. You should see the main window of the node management tool.

<p align="center"><br>
  <img alt="Idena Coacher Node Monitor Tool" Title="IDENA Coacher - User Interface" src="https://raw.githubusercontent.com/ltraveler/ltraveler/main/images/IDENA_Coacher_Monitor_Tool_UI.jpg">
</p>
