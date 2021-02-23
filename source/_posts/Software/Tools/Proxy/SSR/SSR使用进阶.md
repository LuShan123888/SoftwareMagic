---
title: SSR 使用进阶
categories:
- Software
- Tools
- Proxy
- SSR
---
# SSR 使用进阶

## 相关操作ssr命令

- 启动:`/etc/init.d/shadowsocks start `
-  停止:`/etc/init.d/shadowsocks stop `
-  重启:`/etc/init.d/shadowsocks restart`
-  状态:`/etc/init.d/shadowsocks status `
-  配置文件路径:`/etc/shadowsocks.json`
- 日志文件路径:`/var/log/shadowsocks.log `
- 代码安装目录:`/usr/local/shadowsocks `
- 卸载ssr服务:` ./shadowsocksR.sh uninstall `

## 配置多端口

- 编辑`/etc/shadowsocks.json`

```json
{
 "server": "0.0.0.0",
 "server_ipv6": "::",
 "local_address": "127.0.0.1",
 "local_port": 1081,
 "port_password":{
    "端口1":"密码1",
    "端口2":"密码2",
    "端口3":"密码3",
   "端口4":"密码4"
},
 "timeout": 120,
 "udp_timeout": 60,
 "method": "chacha20",
 "protocol": "auth_sha1_compatible",
 "protocol_param": "",
 "obfs": "http_simple_compatible",
 "obfs_param": "",
 "dns_ipv6": false,
 "connect_verbose_info": 0,
 "redirect": "",
 "fast_open": false,
 "workers": 1

}
```

- 输入`/etc/init.d/shadowsocks restart`重启ssr