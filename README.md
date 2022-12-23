# DynamicNginxConfig
Using Openresty to monitor change in nginx config file, when nginx config is changed nginx will detect for it and then update its configuration file.

## Problem:
If you want to add new location entry (or anything new) in nginx conf file dynamically at runtime then you need to update nginx.conf file manually and then reload nginx. But it is difficult in kubernates environment.
## Solution:
In order to smooth this process of updating nginx configuration, I have used openresty nginx as base image. Where "inotifywait" utility is used to detect change in nginx.conf file. If this file is changed then copy updated file to running nginx.conf file. After this check if nginx configuration is valid and then reload nginx.

## Before starting using this check following components are installed and running
1. docker
2. kubernates (k8s)
3. copy code to your local dirctory.
4. We are using mount volume hence copy nginx.conf file to "/mnt/nathnginx" directory. Create directory if not exist.

## Steps to use:
### 1. Build image from openresty 
First step in this process is to build image for nginx that has reloader script in it.
##### Go to dircorty "mynginx"
    cd mynginx
##### Now build docker image and tag it as given in command(if you change tag name then remember to update same in services/nath-nginx-service.yaml)
    docker build --no-cache --network=host -t nginx-auto-reload:local .
##### Check image created and stored in local repository
    docker image ls | grep "nginx-auto-reload"

### 2. Start k8s services
Second step in this process is to start the k8s services.
##### Go to directory "services"
    cd services
##### Create Namespace "nath"
    kubectl apply -f nath-create-namespace.yaml
##### Create persistent volume
    kubectl apply -f nath-nathnginx-volumes.yaml
##### Start nginx service
    kubectl apply -f nath-nginx-service.yaml

### 3. Run driver program to update nginx configuration at runtime
I am adding new location entry and upstream entry for same in nginx.conf whenever I need to update or remove routing to server.
##### Go to directory "driver"
    cd driver
##### Update .CONF file
set MAX_LIMIT to required max entires. If configuration file exceeds this limit then it will not allow to add new entires in nginx.conf file.
set CONF_FILE path where you have stored nginx.conf file in local directory. (this path should be same as path in nath-nathnginx-volumes.yaml path)
##### Run driver.sh script
    ./driver.sh

It will show menu based program like given below:

    ------------------------------------------------------------------------------
                                M A I N - M E N U
    ------------------------------------------------------------------------------
    1. ADD New Alarmbox
    2. REMOVE Alarmbox
    3. SHOW file
    4. Exit
    ------------------------------------------------------------------------------
    Enter your choice [1-4] :

Enter your choice and then check in logs of nginx service if configuration is updated successfully. It will show output like give below:

    kubectl logs -n nath nath-nginx-55fcfc8b76-vbr67

    Output:
    nginx: the configuration file /usr/local/openresty/nginx/conf/nginx.conf syntax is ok
    nginx: configuration file /usr/local/openresty/nginx/conf/nginx.conf test is successful
    Detected Nginx Configuration Change
    Executing: nginx -s reload
    New nginx config has some issues. Please check...
    2022/12/22 16:00:19 [notice] 15#15: signal process started
    Setting up watches.
    Watches established.


# Thank you Friends
#Reach me @ navanathnavaskar@gmail.com for queries


    
