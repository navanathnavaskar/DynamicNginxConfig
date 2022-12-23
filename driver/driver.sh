#!/usr/bin/bash
CWD=$(pwd)
CONF_FILE="/mnt/pw/nathnginx/nginx.conf"
ADD_SCRIPT=$CWD"/add_entry.sh"
REMOVE_SCRIPT=$CWD"/remove_entry.sh"
DB_FILE=$CWD"/db.txt"

source $CWD/.CONF

check_if_valid() {
	lines=$(cat $DB_FILE | wc -l)

	if [ $lines -ge $MAX_LIMIT ];
	then
		echo 1
	else
		echo 0	
	fi	
}

add_new_alarmbox() {
	res=$(check_if_valid)
	if [ $res -eq 0 ]
	then
		read -p 'Enter token for new alarmbox (Ex. alarmbox1) : ' alarmbox_token
		read -p 'Enter IP of new alarmbox : ' alarmbox_ip

		sh $ADD_SCRIPT $alarmbox_token $alarmbox_ip
	else
		echo "Can not add new alarmboc entry in nginx config.(LIMIT EXCEEDED)"
	fi
}

remove_alarmbox_entry() {
	read -p 'Enter token for new alarmbox (Ex. alarmbox1) : ' alarmbox_token

	sh $REMOVE_SCRIPT $alarmbox_token
}

while :
do
	# show menu
	clear
	echo "------------------------------------------------------------------------------"
	echo "	                        M A I N - M E N U"
	echo "------------------------------------------------------------------------------"
	echo "1. ADD New Alarmbox"
	echo "2. REMOVE Alarmbox"
	echo "3. SHOW file"
	echo "4. Exit"
	echo "------------------------------------------------------------------------------"
	read -r -p "Enter your choice [1-4] : " c

	echo "------------------------------------------------------------------------------"
	# take action
	case $c in
		1) add_new_alarmbox ;;
		2) remove_alarmbox_entry ;;
		3) cat $CONF_FILE ;; 
		4) break;;
		*) Pause "Select between 1 to 4 only"
	esac
	echo "------------------------------------------------------------------------------"
	read -p 'Enter any key to continue ...' key
done
