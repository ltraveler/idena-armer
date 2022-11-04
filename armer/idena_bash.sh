#!/bin/bash
screen -wipe
if ! screen -ls | grep -q "$username"; then
    echo "Your name is $username. Running IDENA..."
    service idena start
fi
/etc/init.d/cron restart
PATH=$PATH:/home/$username/idena-coacher
