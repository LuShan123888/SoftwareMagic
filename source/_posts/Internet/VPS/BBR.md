---
title: BBR
categories:
- Internet
- VPS
---
# BBR

BBR是 Google 提出的一种新型拥塞控制算法，可以使 Linux 服务器显著地提高吞吐量和减少 TCP 连接的延迟

## 安装wget

系统默认是不带wget的，所以要首先安装wget

```bash
yum -y install wget
```

## 一键安装魔改版bbr

依次执行如下三行代载一键安装脚本->赋予执行权限->执行脚本

```bash
wget --no-check-certificate -O tcp.sh https://github.com/cx9208/Linux-NetSpeed/raw/master/tcp.sh && chmod +x tcp.sh && ./tcp.sh
```
