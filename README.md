# DynamicNginxConfig
Using Openresty to monitor change in nginx config file, when nginx config is changed nginx will detect for it and then update its configuration file.

Problem:
    If you want to add new location entry (or anything new) in nginx conf file dynamically at runtime then you need to update nginx.conf file manually and then reload nginx. But it is difficult in kubernates environment.
Solution:
    In order to smooth this process of updating nginx configuration, I have used openresty nginx as base image. Where "inotifywait" utility is used to detect change in nginx.conf file. If this file is changed then copy updated file to running nginx.conf file.
    After this check if nginx configuration is valid and then reload nginx.

Steps:

