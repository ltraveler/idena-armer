#!/usr/bin/bash
ARMER_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
username=$(echo "$ARMER_DIR" | awk -F\/ '{print $3}')
if [ -d "/home/$username/idena-go" ] 
then
	service idena stop
else
	echo "Error: IDENA ARMer is not installed."
	exit
fi

cd /home/$username/idena-go/
read -p "Would you like me to compile idena-go bin file from the source code?" -n 1 -r
echo "Let's do some updates..." 
if [[ $REPLY =~ ^[Yy]$ ]]
then
        if ! command -v go &> /dev/null
        then
                echo "Compiling idena-go..."
                wget -O go1.17.13.linux-arm64.tar.gz https://go.dev/dl/go1.17.13.linux-arm64.tar.gz
                tar -xvf go1.17.13.linux-arm64.tar.gz
                rm go1.17.13.linux-arm64.tar.gz
                fi

        GOROOT=/home/$username/idena-go/go
        GOPATH=/home/$username/idena-go/go
        PATH=$GOPATH/bin:$PATH

        gover=$(curl -s https://api.github.com/repos/idena-network/idena-go/releases/latest | grep -Po '"tag_name":.*?[^\\]",' | sed 's/"tag_name": "v//g' |  sed 's/",//g')
        wget -O v$gover.tar.gz https://github.com/idena-network/idena-go/archive/refs/tags/v$gover.tar.gz
        tar -xzf v$gover.tar.gz && rm v$gover.tar.gz
        cd idena-go-$gover

        go build -ldflags "-X main.version=$gover" && chmod +x idena-go && cp -r idena-go /home/$username/idena-go/ && cd /home/$username/idena-go && rm -rf ./idena-go-$gover ./go
	service idena start
else
        wget -O idena-go https://github.com/ltraveler/idena-go-arm64/raw/main/idena-go && chmod +x idena-go
	service idena start
fi

