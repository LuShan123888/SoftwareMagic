---
title: Docker Volume
categories:
- Software
- DevOps
- Docker
---
# Docker Volume

## 创建 volume

```shell
$ docker volume create vol_name
```

## 查看 volume

### 查看所有 volume 情况

```shell
$ docker volume ls

DRIVER    VOLUME NAME
local     portainer_data
```

### 查看 volum e信息

- 所有的docker容器内的卷，没有指定目录的情况下都是在`/var/lib/docker/volumes/xxxx/_data`

```json
$ docker volume inspect vol_name

docker volume inspect nginx
[
    {
        "CreatedAt": "2020-09-27T23:21:48+08:00",
        "Driver": "local",
        "Labels": null,
        "Mountpoint": "/var/lib/docker/volumes/nginx/_data",
        "Name": "nginx",
        "Options": null,
        "Scope": "local"
    }
]
```

### 查看容器挂载的 volume 

```json
$ docker inspect vol_name

"Mounts": [
{
    "Type": "bind",
    "Source": "/home/mysql/conf",
    "Destination": "/etc/mysql/conf.d",
    "Mode": "",
    "RW": true,
    "Propagation": "rprivate"
},
```

## 删除 volume 

- 删除指定的 volume

```bash
$ docker volume rm vol_name
```

- 清理所有无用 volume，有些删除的容器还会有卷的残留。

```shell
$ docker volume prune
```

## 挂载 volume 

- 实现容器中数据持久化的问题。
- 主机目录与容器目录为双向绑定。

### 数据的覆盖问题

- 当挂载宿主机文件夹时，会覆盖容器中的文件夹。
- 当挂宿载主机文件时，需要确保本机存在该文件，否则docker自动创建为目录。
- 如果挂载一个空的 volume 到容器中的一个非空目录中，那么这个目录下的文件会被复制到 volume 中。
- 如果挂载一个非空的 volume 到容器中的一个目录中，那么容器中的目录中会显示 volume 中的数据，如果原来容器中的目录中有数据，那么这些原始数据会被隐藏掉。

### 路径映射挂载

- **注意**：容器删除后，主机目录仍然存在。

```shell
$ docker run -v 主机目录：容器目录镜像名。
```

- 通过在容器目录后加上`:ro`或`:rw`可指定读写权限。

```shell
$ docker run -d -P --name nginx1 -v /home/nginx:/etc/nginx:ro nginx # 只读。
$ docker run -d -P --name nginx2 -v /home/nginx:/etc/nginx:rw nginx # 可读可写。
```

- `ro`：说明这个路径只能通过宿主机操作，容器内部无法操作。

###  volume 挂载

- 没有指定主机地址但指定了volume名。

```shell
$ docker run  -v vol_name：容器目录镜像名。

$ docker run -d -P --name nginx02 -v nginx:/etc/nginx nginx
DRIVER              VOLUME NAME
local               93fd4d232eeee6c2993acafb46d64bba0d56d1991253185ec0902756d6341644
local               nginx
```

### 匿名挂载

- 没有指定主机地址和volume名。

```shell
$ docker run  -v 容器目录镜像名。

$ docker run -d -P --name nginx01 -v /etc/nginx nginx
DRIVER              VOLUME NAME
local               93fd4d232eeee6c2993acafb46d64bba0d56d1991253185ec0902756d6341644
```

### 挂载共享

```shell
$ docker run --volumes-from 被共享容器名镜像名。
```

- 挂载共享 volume 的操作实际上是对被共享容器的外部匿名 volume 的挂载分享。
- `--volumes-from`：新容器通过复制了旧容器的mounts配置的`source`和`destination`来实现的，并且优先于`dockerfile`中的卷挂载定义。

**实例**

- 多个mysql实现数据共享。

```shell
$ docker run -d -p 3306:3306 \
--name mysq01 \
-v /var/lib/mysql \
-v /etc/mysql/conf.d \
-e MYSQL_ROOT_PASSWORD=123456 \
-d mysql:5.7

$ docker run -d -p 3307:3306 \
--name mysql02 \
--volumes-from mysql01 \
-e MYSQL_ROOT_PASSWORD=123456 \
-d mysql:5.7
```

- 容器之间配置信息的传递， volume 容器的生命周期一直持续到没有容器使用为止。
- 但是如果容器 volume 持久化到本地目录，则不会被删除。
