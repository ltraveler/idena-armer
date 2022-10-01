#!/usr/bin/bash
ARMER_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
username=$(echo "$ARMER_DIR" | awk -F\/ '{print $3}')

if ! screen -list | grep -q "$username"; then
    echo "No idena-go service found. Restarting..."
    service idena start
fi

