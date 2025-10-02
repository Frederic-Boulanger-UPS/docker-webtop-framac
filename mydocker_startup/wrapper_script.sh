#!/bin/bash

cp    -TRn /init-config/ /config
chown -R   abc:abc       /config

# MyDocker sends a username in $1 and a password in $2
if [ "$2" ]; then
    export CUSTOM_USER=$1
    export PASSWORD=$2
fi

exec /init
