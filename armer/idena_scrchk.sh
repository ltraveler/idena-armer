#!/bin/bash
ps -ef | grep -i idena-go | grep -v grep; scr=$?
#
if [ $scr -eq 0 ]; then
        echo "idena-go service is already running..."
else
        echo "No idena-go service found. Restarting..."
	/usr/sbin/service idena start
fi

