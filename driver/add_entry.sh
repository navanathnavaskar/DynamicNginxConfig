#!/usr/bin/bash

CWD=$(pwd)
CONF_FILE="/mnt/pw/nathnginx/nginx.conf"
DB_FILE=$CWD"/db.txt"
alarmbox_token=$1
alarmbox_ip=$2

echo -e "Step 1 - Check if alarmbox is already added."

if grep -q "$alarmbox_token" $DB_FILE;
then
	echo -e "\nResult - Alarmbox entry already present for $alarmbox_token"
	exit 0
else
	echo -e "\nResult - Alarmbox Entry not present in conf file."
	echo -e "\nStep 2 - Add Alarmbox entry in conf file for routing."

	sed -i "/UPSTREAM ENTRY HERE/i upstream ${alarmbox_token} {\n  server ${alarmbox_ip};\n}" $CONF_FILE	
	echo -e "\nResult - Added upstream entry for alarmbox"	
		
	sed -i "/LOCATION ENTRY HERE/i location ~ ^/${alarmbox_token}/ {\n\t  rewrite ^/${alarmbox_token}/(.*)$ /\$1 break;\n\t  proxy_pass http://${alarmbox_token};\n}" $CONF_FILE
	echo -e "\nResult - Added location entry for alarmbox"
		
	echo $alarmbox_token >> $DB_FILE
	echo -e "\nSuccessfully added entry for alarmbox $alarmbox_token"
	exit 0
fi
