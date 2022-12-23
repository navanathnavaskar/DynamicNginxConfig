#!/bin/bash
###########

while true
do
 	inotifywait --exclude .swp -e create -e modify -e delete -e move /opt/conf/nginx.conf
 	nginx -t
 	if [ $? -eq 0 ]
 	then
  		echo "Detected Nginx Configuration Change"
  		echo "Executing: nginx -s reload"
  		# Take backup of old nginx.conf before coping
		cp /usr/local/openresty/nginx/conf/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf.bkp
  		cp /opt/conf/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
		# check if config is valid
  		nginx -t 2>/dev/null > /dev/null
		if [[ $? == 0 ]]; then
			echo "New nginx config is valid. Hence reloading..."
		else
			echo "New nginx config has some issues. Please check..."
			cp /usr/local/openresty/nginx/conf/nginx.conf.bkp /usr/local/openresty/nginx/conf/nginx.conf
		fi
  		nginx -s reload
 	fi
done
