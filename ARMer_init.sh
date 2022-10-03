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

reqpkgs=('moreutils' 'original-awk' 'systemd-cron' 'cron' 'procps' 'gettext' 'jq' 'gcc' 'sudo' 'git' 'curl' 'wget' 'nano' 'screen' 'psmisc' 'unzip' 'htop')
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
[[ $username = 'root' ]] || [[ -z $username ]]
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
	rm -f /etc/init.d/idena
else
        echo "Creating a user $username..."
	password="$username"
	salt=$(cat /dev/urandom | tr -dc A-Za-z0-9/_- | head -c16)
	pass=$(openssl passwd -5 -salt "$salt" "$password")
	useradd -s /bin/bash -m -p "$pass" "$username"
fi

mkdir /home/$username/idena-go
cd /home/$username/idena-go

read -p "Would you like me to compile idena-go bin file from the source code? " -n 1 -r
echo  "Let's do some updates" 
if [[ $REPLY =~ ^[Yy]$ ]]
then
        if ! command -v go &> /dev/null
        then
                echo "Compiling idena-go..."
                wget -O go1.18.6.linux-arm64.tar.gz https://go.dev/dl/go1.18.6.linux-arm64.tar.gz
                tar -xvf go1.18.6.linux-arm64.tar.gz
                rm go1.18.6.linux-arm64.tar.gz
                fi

        GOROOT=/home/$username/idena-go/go
        GOPATH=/home/$username/idena-go/go
        PATH=$GOPATH/bin:$PATH

        gover=$(curl -s https://api.github.com/repos/idena-network/idena-go/releases/latest | grep -Po '"tag_name":.*?[^\\]",' | sed 's/"tag_name": "v//g' |  sed 's/",//g')
        wget -O v$gover.tar.gz https://github.com/idena-network/idena-go/archive/refs/tags/v$gover.tar.gz
        tar -xzf v$gover.tar.gz && rm v$gover.tar.gz
        cd idena-go-$gover

        go get github.com/lucas-clemente/quic-go@v0.26.0
        go build -ldflags "-X main.version=$gover" && chmod +x idena-go && cp -r idena-go /home/$username/idena-go/ && cd /home/$username/idena-go && rm -rf ./idena-go-$gover ./go
else
        wget -O idena-go https://github.com/ltraveler/idena-go-arm64/raw/main/idena-go
fi

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
envsubst < idena >| /etc/init.d/idena
chmod +x /etc/init.d/idena
update-rc.d idena defaults

#Measure thrice and cut once
tail --lines=+2 idena_bash.sh | envsubst >| idenabash.tmp 
awk 'FNR == NR { lines[$0] = 1; next } ! ($0 in lines) {print}' /root/.bashrc idenabash.tmp | sponge -a /root/.bashrc
rm idenabash.tmp 
#
#idenachain.db health check
mkdir /home/$username/scripts
envsubst < idena_selfcheck.sh >| /home/$username/scripts/idena_selfcheck.sh
envsubst < idena_removelogs.sh >| /home/$username/scripts/idena_removelogs.sh
# idena-go manual update
cp ../armer_update.sh /home/$username/scripts/
cp ./idena_scrchk.sh /home/$username/scripts/
chmod +x /home/$username/scripts/*.sh
cd /home/$username/scripts
crontab -u root -l >| idenacron
#Particular error cases pre-check
echo "*/30 * * * * /home/$username/scripts/idena_selfcheck.sh" >> idenacron
#idena-go stdout truncate
echo "*/78 * * * * /home/$username/scripts/idena_removelogs.sh" >> idenacron
#idena-go daemon run check
echo "*/13 * * * * /home/$username/scripts/idena_scrchk.sh" >> idenacron
crontab -u root idenacron
rm idenacron
/etc/init.d/cron restart
cd $ARMER_DIR
service idena start
# Installation has been successfully completed
echo -e "${LRED}IDENA NODE HAS BEEN SUCCESSFULLY INSTALLED" 
echo -e "${LGREEN}FOR IDENA DONATIONS:${NC} 0xf041640788910fc89a211cd5bcbf518f4f14d831"
echo -e "${YELLOW}CONTACT AUTHOR:${NC} ltraveler@protonmail.com"
echo -e "${LBLUE}IDENA PERSONALIZED SHARED NODE SERVICE:${NC} https://t.me/ltrvlr"
exit

