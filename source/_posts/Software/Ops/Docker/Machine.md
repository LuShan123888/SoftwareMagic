---
title: Docker Machine
categories:
- Software
- Ops
- Docker
---
# Docker Machine

- Docker Machine 是一种可以让您在虚拟主机上安装 Docker 的工具,并可以使用 docker-machine 命令来管理主机
- Docker Machine 也可以集中管理所有的 docker 主机,比如快速的给 100 台服务器安装上 docker
- Docker Machine 管理的虚拟主机可以是机上的,也可以是云供应商,如阿里云,腾讯云,AWS,或 DigitalOcean
- 使用 docker-machine 命令,您可以启动,检查,停止和重新启动托管主机,也可以升级 Docker 客户端和守护程序,以及配置 Docker 客户端与您的主机进行通信

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-02-14-2021-02-14-machine.png)

## 安装

- 安装 Docker Machine 之前你需要先安装 Docker
- Docker Machine 可以在多种平台上安装使用,包括 Linux,MacOS 以及 windows

### Linux

```bash
$ base=https://github.com/docker/machine/releases/download/v0.16.0 &&
  curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine &&
  sudo mv /tmp/docker-machine /usr/local/bin/docker-machine &&
  chmod +x /usr/local/bin/docker-machine
```

### macOS

```
$ brew install docker-machine

# 安装驱动
$ brew install --cask virtualbox
```

## 常用命令

### ls

- 列出可用的机器

```
$ docker-machine ls
```

### create

- 创建机器

```
docker-machine ceate [machine_name]
```

- `--engine-opt dns=114.114.114.114` 配置 Docker 的默认 DNS
- `--engine-registry-mirror https://hub-mirror.c.163.com` 配置 Docker 的仓库镜像
- `--virtualbox-memory 2048` 配置主机内存
- `--virtualbox-cpu-count 2` 配置主机 CPU
- 更多参数请使用 `docker-machine create --driver virtualbox --help` 命令查看

#### xhyve 驱动

- `xhyve` 驱动 GitHub: https://github.com/zchee/docker-machine-driver-xhyve
- `xhyve` 是 macOS 上轻量化的虚拟引擎,使用其创建的 Docker Machine 较 `VirtualBox` 驱动创建的运行效率要高

```
$ brew install docker-machine-driver-xhyve

# docker-machine-driver-xhyve need root owner and uid
$ sudo chown root:wheel $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
$ sudo chmod u+s $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
```

**实例**

```
docker-machine create \
      -d xhyve \
      # --xhyve-boot2docker-url ~/.docker/machine/cache/boot2docker.iso \
      --engine-opt dns=114.114.114.114 \
      --engine-registry-mirror https://hub-mirror.c.163.com \
      --xhyve-memory-size 2048 \
      --xhyve-rawdisk \
      --xhyve-cpu-count 2 \
      xhyve
```

- **-d,--driver**:指定用来创建机器的驱动类型

> **注意**:非首次创建时建议加上 `--xhyve-boot2docker-url ~/.docker/machine/cache/boot2docker.iso`参数,避免每次创建时都从 GitHub 下载 ISO 镜像

### ip

- 查看机器的 ip

```
$ docker-machine ip [machine_name]
```

### start

- 启动机器

```
$ docker-machine start [machine_name]
```

### stop

- 停止机器

```
$ docker-machine stop [machine_name]
```

### env

- 设置环境变量,使shell的docker命令应用与指定的machine

```
$ docker-machine env [OPTIONS] [arg...]
```

- `--unset, -u`:Unset variables instead of setting them

### ssh

- 使用ssh连接机器

```
$ docker-machine ssh [machine_name]
```

### scp

- 使用scp传输文件

```
$ docker-machine scp /localpath/ machinename:/machinepath
```

- `-r`:传输文件夹

**实例**

```
docker-machine scp ~/Downloads/compose.yml manager:/home/docker
```

## docker-machine命令

- **active**:查看当前激活状态的 Docker 主机
- **config**:查看当前激活状态 Docker 主机的连接信息
- **creat**:创建 Docker 主机
- **env**:显示连接到某个主机需要的环境变量
- **inspect**:	以 json 格式输出指定Docker的详细信息
- **ip**:	获取指定 Docker 主机的地址
- **kill**:	直接杀死指定的 Docker 主机
- **ls**:	列出所有的管理主机
- **provision**:	重新配置指定主机
- **regenerate-certs**:	为某个主机重新生成 TLS 信息
- **restart**:	重启指定的主机
- **rm**:	删除某台 Docker 主机,对应的虚拟机也会被删除
- **ssh**:	通过 SSH 连接到主机上,执行命令
- **scp**:	在 Docker 主机之间以及 Docker 主机和本地主机之间通过 scp 远程复制数据
- **mount**:	使用 SSHFS 从计算机装载或卸载目录
- **start**:	启动一个指定的 Docker 主机,如果对象是个虚拟机,该虚拟机将被启动
- **status**:	获取指定 Docker 主机的状态(包括:Running,Paused,Saved,Stopped,Stopping,Starting,Error)等
- **stop**:	停止一个指定的 Docker 主机
- **upgrade**:	将一个指定主机的 Docker 版本更新为最新
- **url**:	获取指定 Docker 主机的监听 URL
- **version**:	显示 Docker Machine 的版本或者主机 Docker 版本
- **help**:	显示帮助信息