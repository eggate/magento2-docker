### Docker image to install Magento 2.4.4 and nginx
~~### Not working image~~
It's my first trial to use docker 

### Succeeded 
- install Nginx + php8.1-fpm 
-  add magento2.local to /etc/hosts
- add magento2.local config file to nginx
- install makecert to create self signed cert
- install composer and copy auth.json to $COMPOSER_HOME
- download Magento2.4.4 using composer
- run magento2 installation on magento2.local
- added redis and opensearch service

~~### Failed~~
~~- tried many ways to connect db service to web service to install magento but with no luck~~


### I'm still trying to make it work and I will


### Update

It's working now