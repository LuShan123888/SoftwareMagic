---
title: Nginx SSL证书部署
categories:
- Software
- BackEnd
- Server
- Nginx
---
# Nginx SSL证书部署

## 获取证书

- Nginx文件夹内获得SSL证书文件 ``1_www.domain.com_bundle.crt`和私钥文件 `2_www.domain.com.key`
    - `1_www.domain.com_bundle.crt` 文件包括两段证书代码 "-----BEGIN CERTIFICATE-----”和"-----END CERTIFICATE-----”
    - `2_www.domain.com.key`文件包括一段私钥代码"-----BEGIN RSA PRIVATE KEY-----”和"-----END RSA PRIVATE KEY-----”

## 证书安装

- 将域名 `www.domain.com` 的证书文件`1_www.domain.com_bundle.crt` ,私钥文件`2_www.domain.com.key`保存到同一个目录，例如`/usr/local/nginx/conf`目录下
- 更新Nginx根目录下 conf/nginx.conf 文件如下:

```nginx
server {
    listen 443;
    server_name www.domain.com; #填写绑定证书的域名
    ssl on;
    ssl_certificate 1_www.domain.com_bundle.crt;
    ssl_certificate_key 2_www.domain.com.key;
    ssl_session_timeout 5m;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2; #按照这个协议配置
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:HIGH:!aNULL:!MD5:!RC4:!DHE;#按照这个套件配置
    ssl_prefer_server_ciphers on;
    location / {
        root   html; #站点目录
        index  index.html index.htm;
    }
}
```
