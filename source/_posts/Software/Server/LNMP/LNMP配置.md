---
title: LNMP 配置
categories:
- Software
- Server
- LNMP
---
# LNMP 配置

## 默认位置

```
Nginx 目录: /usr/local/nginx/
MySQL 目录 : /usr/local/mysql/
MySQL数据库所在目录:/usr/local/mysql/var/
PHP目录 : /usr/local/php/
默认网站目录 : /home/wwwroot/default/
Nginx日志目录:/home/wwwlogs/
```

## 配置文件

```
Nginx主配置(默认虚拟主机)文件:/usr/local/nginx/conf/nginx.conf
添加的虚拟主机配置文件:/usr/local/nginx/conf/vhost/域名.conf
MySQL配置文件:/etc/my.cnf
PHP配置文件:/usr/local/php/etc/php.ini
php-fpm配置文件:/usr/local/php/etc/php-fpm.conf
```

## 常用命令

```
重启nginx/mysql/php:lnmp nginx/mysql/php restart
重启所有:lnmp restart
添加站点:lnmp vhost add
添加ssl证书: lnmp ssl add
添加数据库:lnmp database add
查看帮助:lnmp
```

