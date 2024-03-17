---
title: macOS Apache
categories:
- Software
- System
- macOS
---
# macOS Apache

## Apache 文件默认位置

- Mac OS 的 Apache2 的配置文件（httpd.config):

```
/etc/apache2
```

- Mac OS 的 Apache2 的程序文件（httpd, ab):

```shell
/usr/sbin/
```

- Mac OS 的 Apache2 的默认根目录：

```shell
/Library/WebServer/Documents
```

## Apache命令

```cpp
// 启动服务器。
sudo apachectl -k start
sudo apachectl start

// 关闭服务器。
sudo apachectl -k stop
sudo apachectl stop

// 重启服务器。
sudo apachectl -k restart
sudo apachectl restart
```

## 关闭apache随系统启动

```shell
sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist
```

