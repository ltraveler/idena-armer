#!/data/data/com.termux/files/usr/bin/sh

#ASCII color assign
RED="\033[0;31m"
LRED="\033[1;31m"
YELLOW="\033[0;33m"
LYELLOW="\033[1;33m"
GREEN="\033[0;32m"
LGREEN="\033[1;32m"
BLUE="\033[0;34m"
LBLUE="\033[1;34m"
PURPLE="\033[0;35m"
LPURPLE="\033[1;35m"
CYAN="\033[0;36m"
LCYAN="\033[1;36m"
NC="\033[0m" # No Color

pkg upgrade -y
pkg install openssh -y
pkg install wget -y
pkg install nano -y
passwd
sshd
mkdir -p /data/data/com.termux/files/home/.termux/boot
ifconfig
echo -e "${LRED}Please save your IP address. ${LYELLOW}Your port number for ${LRED}SSH${LYELLOW} has been set to ${LRED}8022${LYELLOW}. Keep ${LRED}username${LYELLOW} field empty and use the previously set ${LRED}password${LYELLOW} to log in via ${LRED}SSH.\n${LRED}Press any key to continue...${NC}"
read -p

pkg install wget openssl-tool proot -y && hash -r && wget https://raw.githubusercontent.com/EXALAB/AnLinux-Resources/master/Scripts/Installer/Kali/kali.sh && bash kali.sh

touch /data/data/com.termux/files/home/.bashrc
grep -q 'bash /data/data/com.termux/files/home/start-kali.sh' '/data/data/com.termux/files/home/.bashrc' || echo "bash /data/data/com.termux/files/home/start-kali.sh" >> /data/data/com.termux/files/home/.bashrc
grep -q '# allow-external-apps = true' '/data/data/com.termux/files/home/.termux/termux.properties' || sed -i '/allow-external-apps/s/^#//g' /data/data/com.termux/files/home/.termux/termux.properties

