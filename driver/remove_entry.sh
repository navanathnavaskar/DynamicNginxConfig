#!/usr/bin/bash

CWD=$(pwd)
CONF_FILE="/mnt/pw/nathnginx/nginx.conf"
DB_FILE=$CWD"/db.txt"
alarmbox_token=$1

echo -e "Step 1 - Check if alarmbox is present in conf file."

if grep -q "$alarmbox_token" $DB_FILE;
then
        echo -e "\nResult - Alarmbox entry present for $alarmbox_token"
	
	echo -e "\nStep 2 - Remove entry from conf file."
	sed -i "/upstream ${alarmbox_token}/,+2d" $CONF_FILE

	sed -i "/location.*${alarmbox_token}/,+3d" $CONF_FILE	

	sed -i "/${alarmbox_token}/d" $DB_FILE
	echo -e "\nResult - Successfully removed entry from conf file"
        exit 0
else
        echo -e "\nResult - Alarmbox Entry not present in conf file."
	exit 1;
fi
