#!/bin/bash
#> /home/$username/idena-go/idena_screen.log 
echo "$(tail -n 50 /home/$username/idena-go/idena_screen.log)" > /home/$username/idena-go/idena_screen.log
