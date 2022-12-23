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

## Steps to use:
##### 1. Build image from openresty 
First step in this process is to build image for nginx that has reloader script in it.
###### Go to dircorty mynginx
    cd mynginx
###### Now build docker image and tag it as given in command(if you change tag name then remember to update same in  )
    
