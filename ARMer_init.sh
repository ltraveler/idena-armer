#!/bin/bash 
#
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

set -o pipefail -o nounset -o noclobber -o allexport
ARMER_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

#Installing all required packages
apt update
apt upgrade -y

reqpkgs=('moreutils' 'original-awk' 'cron' 'procps' 'gettext' 'jq' 'gcc' 'sudo' 'git' 'curl' 'wget' 'nano' 'screen' 'psmisc' 'unzip' 'htop')
for x in "${reqpkgs[@]}"; do
dpkg -s "$x" &> /dev/null
if [ $? != 0 ]; then
    echo -e "${LRED}Package $x is not instlled. Installing...${NC}"
    apt-get install -y $x; 
#
fi
done

#Adding new user for idena-go client
echo -e "${LYELLOW}Please enter a ${LRED}username${NC} and ${LRED}password${LYELLOW} that you would like to use for this ${LGREEN}Idena Node Daemon${LYELLOW} instance.${NC}"
while
echo -e "${NC}Please do not use ${LGREEN}root${NC} as a username"
read -p "Enter username : " username
[[ $username = 'root' ]]
do true; done

#Some preliminary check
if screen -ls | grep -q "$username"; then
    echo "The given username $username has a running idena-go client.\nTerminating..."
    service idena stop
fi


#If user exists we have to save our beans
if id "$username" >/dev/null 2>&1; then
        echo "User $username exists. All keys are saved in ./armer_backup directory"
	mkdir /home/$username/ARMer_backup/
	cp -r --backup=t /home/$username/idena-go/datadir/api.key /home/$username/idena-go/datadir/keystore/nodekey /home/$username/ARMer_backup/ 
	rm -rf /home/$username/idena-go
else
        echo "Creating a user $username..."
	password="$username"
	salt=$(cat /dev/urandom | tr -dc A-Za-z0-9/_- | head -c16)
	pass=$(openssl passwd -5 -salt "$salt" "$password")
	useradd -s /bin/bash -m -p "$pass" "$username"
fi

mkdir /home/$username/idena-go
cd /home/$username/idena-go
wget -O idena-go https://github.com/ltraveler/idena-go-arm64/raw/main/idena-go
chmod +x idena-go
mkdir -p /home/$username/idena-go/datadir/idenachain.db
cd /home/$username/idena-go/datadir/idenachain.db
wget -O main.zip https://github.com/ltraveler/idenachain.db/archive/refs/heads/main.zip
unzip -jo main.zip
rm main.zip
cd /home/$username/idena-go
wget -O config.json https://raw.githubusercontent.com/ltraveler/idena-runner/main/config.json
#chown -R $username:$username /home/$username/idena-go

screen -S idena -dm /home/$username/idena-go/idena-go --config=/home/$username/idena-go/config.json --datadir=/home/$username/idena-go/datadir

until [ -s /home/$username/idena-go/datadir/api.key ]
do
     sleep 5
done
until [ -s /home/$username/idena-go/datadir/keystore/nodekey ]
do
     sleep 5
done
screen -S idena -X kill

#Private rollback segment
apikey=$( cat /home/$username/idena-go/datadir/api.key )
echo -e ${LBLUE}Your IDENA-node API key is: ${YELLOW}$apikey
prvkey=$( cat /home/$username/idena-go/datadir/keystore/nodekey )
echo -e ${LBLUE}Your IDENA-node PRIVATE key is: ${YELLOW}$prvkey${NC}

while true; do
    read -p "$(echo -e ${LYELLOW}Would you like to add your own ${LGREEN}IDENA NODE PRIVATE KEY${LYELLOW} \(aka ${LRED}nodekey${LYELLOW}\)?$'\n'${LGREEN}Default path: ${LRED}../idena-go/datadir/keystore/nodekey ${LGREEN}[y/N]${NC} )" yn
    case $yn in
        [Yy]* ) read -p "$(echo -e ${LYELLOW}Please enter your IDENA private key:${NC} )"; echo "$REPLY" >| /home/$username/idena-go/datadir/keystore/nodekey; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "$(echo -e ${LYELLOW}Would you like to add your own ${LGREEN}IDENA NODE API KEY${LYELLOW} \(aka ${LRED}api.key${LYELLOW}\)?$'\n'${LGREEN}Default path: ${LRED}../idena-go/datadir/api.key  ${LGREEN}[y/N]${NC} )" yn
    case $yn in
        [Yy]* ) read -p "$(echo -e ${LYELLOW}Please enter your IDENA node key: ${NC})"; echo "$REPLY" >| /home/$username/idena-go/datadir/api.key; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

#System curtain-raiser

cd $ARMER_DIR/armer/ 
envsubst < idena > /etc/init.d/idena
update-rc.d idena defaults

#Measure thrice and cut once
tail --lines=+2 idena_bash.sh | envsubst > idenabash.tmp 
awk 'FNR == NR { lines[$0] = 1; next } ! ($0 in lines) {print}' /root/.bashrc idenabash.tmp | sponge -a /root/.bashrc
#
#idenachain.db health check
mkdir /home/$username/scripts
cd /home/$username/scripts
envsubst < idena_selfcheck.sh > /home/$username/scripts/idena_selfcheck.sh
envsubst < idena_removelogs.sh > /home/$username/scripts/idena_removelogs.sh
crontab -u $username -l > idenacron
#Particular error cases pre-check
echo "*/30 * * * * /home/$username/scripts/idena_selfcheck.sh" >> idenacron
#idena-go stdout truncate
echo "*/78 * * * * /home/$username/scripts/idena_removelogs.sh" >> idenacron
crontab -u $username idenacron
rm idenacron
cd $ARMER_DIR/armer/
rm -rf *.tmp
service idena start
exit
