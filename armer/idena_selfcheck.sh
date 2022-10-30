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
chain_err=('Cannot transform consensus config' 'corrupted or incomplete')
for x in "${chain_err[@]}"; do
head /home/$username/idena-go/datadir/logs/output.log | grep -iwq "$x" && echo "It seems like ${LYELLOW}idenachain.db${NC} in trouble. The pattern: ${LRED}$x${NC} has been found." && /usr/sbin/service idena restart
done
