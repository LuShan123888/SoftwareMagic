---
title: Docker Swarm
categories:
- Software
- DevOps
- Docker
---
# Docker Swarm

## 概念

- Docker Swarm 是 Docker 的集群管理工具，它将 Docker 主机池转变为单个虚拟 Docker 主机，Docker Swarm 提供了标准的 Docker API，所有任何已经与 Docker 守护程序通信的工具都可以使用 Swarm 轻松地扩展到多个主机。

### 节点

- 运行 Docker 的主机可以主动初始化一个 `Swarm` 集群或者加入一个已存在的 `Swarm` 集群，这样这个运行 Docker 的主机就成为一个 `Swarm` 集群的节点（`node`)
- 节点分为管理（`manager`) 节点和工作（`worker`) 节点。
    - 管理节点用于 `Swarm` 集群的管理，`docker swarm` 命令基本只能在管理节点执行。
        - 一个 `Swarm` 集群可以有多个管理节点，但只有一个管理节点可以成为 `leader`,`leader` 通过 `raft` 协议实现。
        - `raft`协议至少是基于3个主节点，当管理节点大多数可用时，整个集群是可用的。
    - 工作节点是任务执行节点，管理节点将服务（`service`) 下发至工作节点执行。
    - 管理节点默认也作为工作节点，你也可以通过配置让服务只运行在管理节点。
- 来自 Docker 官网的这张图片形象的展示了集群中管理节点与工作节点的关系。

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-02-15-swarm-diagram.png)

###  服务和任务

- 任务（`Task`)是 `Swarm` 中的最小的调度单位，目前来说就是一个单一的容器。
- 服务（`Services`)是指一组任务的集合，服务定义了任务的属性。
- 服务有两种模式：
    - `replicated services` 按照一定规则在各个工作节点上运行指定个数的任务。
    - `global services` 每个工作节点上运行一个任务两种模式通过 `docker service create` 的 `--mode` 参数指定。
- 来自 Docker 官网的这张图片形象的展示了容器，任务，服务的关系。

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-02-15-services-diagram-20210215180815269.png)

## 创建Swarm集群

### 初始化集群

- 首先创建一个 Docker 主机作为管理节点。

```
$ docker-machine create -d virtualbox manager
```

- 进入管理节点并初始化集群。

```
$ docker-machine ssh manager

docker@manager:~$ docker swarm init --advertise-addr 192.168.99.101
Swarm initialized: current node (w7md97939hauk58sogs4g2z23) is now a manager.
To add a worker to this swarm, run the following command:
    docker swarm join --token SWMTKN-1-4pk8cjoduk06tm2buh989p0bszlqbhst69h0xoqgxg1pttiddf-d3ppau9w5q326b1xo21jw3367 192.168.99.101:2377
To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```

-  `--advertise-addr` ：指定本节点的广播IP
- 需要把`join-token`复制，在增加工作节点时会用到。

### 添加工作节点

- 创建两个 Docker 主机作为工作节点，并加入到集群中。

```
$ docker-machine create -d virtualbox worker1
$ docker-machine create -d virtualbox worker2
```

- 分别进入两个机器里，指定添加至上一步中创建的集群，这里会用到上一步复制的内容。

```
$ docker-machine ssh worker1

docker@worker1:~$ docker swarm join \
--token SWMTKN-1-4pk8cjoduk06tm2buh989p0bszlqbhst69h0xoqgxg1pttiddf-d3ppau9w5q326b1xo21jw3367 \
192.168.99.101:2377

This node joined a swarm as a worker.

$ docker-machine ssh worker2

docker@worker1:~$ docker swarm join \
--token SWMTKN-1-4pk8cjoduk06tm2buh989p0bszlqbhst69h0xoqgxg1pttiddf-d3ppau9w5q326b1xo21jw3367 \
192.168.99.101:2377

This node joined a swarm as a worker.
```

### 查看集群信息

- 在管理节点使用 `docker node ls` 查看集群。

```
$ docker-machine ssh manager
$ docker node ls

ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
w7md97939hauk58sogs4g2z23 *   manager             Ready               Active              Leader              19.03.12
j0clwh8gnpnp9mmtuk49d431x     worker1             Ready               Active                                  19.03.12
nb4pzo265tt5gxgf9oxk6jp7w     worker2             Ready               Active                                  19.03.12
```

## swarm命令

- 初始化与管理swarm集群。

### init

- 初始化swarm，该节点自动成为manager

```
$ docker swarm init
```

-  `--advertise-addr` ：指定本节点的广播IP

### join

- 将本机以worker或者manager的身份加入swarm，取决于`join-taken`

```
$ docker swarm join [OPTIONS] HOST:PORT
```

- `--token`：加入集群的token

### join-token

- 查看本swram集群的连接token，包括worker和manager

```
$ docker swarm join-token [OPTIONS] (worker|manager)
```

### leave

- 在工作节点中运行以下命令，即可将工作节点移除。

```
$ docker swarm leave
```

## service命令

- 服务的部署与管理。
- **注意**：跟集群管理有关的任何操作，都是在管理节点上操作的。

### create

- 新建服务。

```
$ docker service create [OPTIONS] IMAGE [COMMAND] [ARG...]
```

**实例**

- 在 `Swarm` 集群中运行一个名为 `nginx` 服务。

```
$ docker service create --replicas 3 -p 80:80 --name nginx nginx:1.13.7-alpine
```

- `--replicas`:task的数量。
- `--mode`：服务运行的的模式。
    - replicated：按照一定规则在各个工作节点上运行指定个数的任务。
    - global：每个工作节点上运行一个任务。
- `--secret source=docker_secret,target=目标路径`：指定`docker secret`
    - 如果没有在 `target` 中显式的指定路径时，默认以 `tmpfs` 文件系统挂载到容器的 `/run/secrets` 目录中。
- `--config  source=docker_config,target=目标路径`：指定`docker config`
    - 如果没有在 `target` 中显式的指定路径时，默认以 `tmpfs` 文件系统挂载到容器的 `/config.conf`

**实例**

```bash
$ docker service create \
     --name mysql \
     --replicas 1 \
     --network mysql_private \
     --mount type=volume,source=mydata,destination=/var/lib/mysql \
     --secret source=mysql_root_password,target=mysql_root_password \
     --secret source=mysql_password,target=mysql_password \
     -e MYSQL_ROOT_PASSWORD_FILE="/run/secrets/mysql_root_password" \
     -e MYSQL_PASSWORD_FILE="/run/secrets/mysql_password" \
     -e MYSQL_USER="wordpress" \
     -e MYSQL_DATABASE="wordpress" \
     mysql:latest
```

### ls

- 查看当前 `Swarm` 集群运行的服务。

```
$ docker service ls
```

### ps

- 查看某个服务的Task

```
$ docker service ps [OPTIONS] SERVICE [SERVICE...]
```

### inpect

- 查看某个服务的详细信息。

```
$ docker service inspect [OPTIONS] SERVICE [SERVICE...]
```

### logs

- 查看某个服务的日志。

```
$ docker service logs [OPTIONS] SERVICE [SERVICE...]
```

### update

- 更新服务的信息。

```
$ docker service update [OPTIONS] SERVICE
```

-  `--image` ：更新服务的镜像。
- `--secret-add` ：增加一个密钥。
- `--secret-rm` 删除一个密钥。

**实例**

- 将 `NGINX` 版本升级到 `1.13.12`

```
$ docker service update \
    --image nginx:1.13.12-alpine \
    nginx
```

### rollback

- Revert changes to a service's configuration

```
$ docker service rollback [OPTIONS] SERVICE
```

**实例**

- 现在假设发现 `nginx` 服务的镜像升级到 `nginx:1.13.12-alpine` 出现了一些问题，我们可以使用命令一键回退。

```
$ docker service rollback nginx
```

- 使用 `docker service ps` 命令查看 `nginx` 服务详情。

```
$ docker service ps nginx

ID                  NAME                IMAGE                  NODE                DESIRED STATE       CURRENT STATE                ERROR               PORTS
rt677gop9d4x        nginx.1             nginx:1.13.7-alpine   VM-20-83-debian     Running             Running about a minute ago
d9pw13v59d00         \_ nginx.1         nginx:1.13.12-alpine  VM-20-83-debian     Shutdown            Shutdown 2 minutes ago
i7ynkbg6ybq5         \_ nginx.1         nginx:1.13.7-alpine   VM-20-83-debian     Shutdown            Shutdown 2 minutes ago
```

- 结果的输出详细记录了服务的部署，滚动升级，回退的过程。

### scale

- 将服务运行的容器数量进行伸缩。

```
$ docker service scale SERVICE=REPLICAS [SERVICE=REPLICAS...]
```

### rm

- 删除服务。

```
$ docker service rm [OPTIONS] SERVICE [SERVICE...]
```

## stack命令

- Swarm 集群中使用 `docker-compose.yml` 需要使用`docker stack` 命令来部署和管理服务。

### deploy

- 部署stack或更新已有stack
- 别名：up

```
$ docker stack deploy [OPTIONS] STACK
```

- `-c, --compose-file`：参数指定 compose 文件名。

**实例**

- 在Swarm集群中部署Visualizer

```yml
version: "3"
services:
  visualizer:
    image: dockersamples/visualizer:stable
    ports:
      - "8080:8080"
    stop_grace_period: 1m30s
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
    deploy:
      mode: replicated
      replicas: 3
```

```
$ docker stack deploy -c docker-compose.yml wordpress
```

### ls

- 查看stack

```
$ docker stack ls [OPTIONS]
```

### ps

- 查看stack中的task

```
$ docker stack ps [OPTIONS] STACK
```

### rm

- 移除服务。
- 别名：down remove

```
$ docker stack rm [OPTIONS] STACK [STACK...]
```

## secret命令

- 在动态的，大规模的分布式集群上，管理和分发 `密码`,`证书` 等敏感信息是极其重要的工作，传统的密钥分发方式（如密钥放入镜像中，设置环境变量，volume 动态挂载等）都存在着潜在的巨大的安全风险。
- Docker 目前已经提供了 `secrets` 管理功能，用户可以在 Swarm 集群中安全地管理密码，密钥证书等敏感数据，并允许在多个 Docker 容器实例之间共享访问指定的敏感数据。

### create

- Create a secret from a file or STDIN as content

```
$ docker secret create [OPTIONS] SECRET [file|-]
```

-  `-l, --label`:Secret labels

**实例**

- 以管道符的形式创建随机的 `secret`

```
$ openssl rand -base64 20 | docker secret create mysql_password -

$ openssl rand -base64 20 | docker secret create mysql_root_password -
```

### ls

- List secrets

```
$ docker secret ls [OPTIONS]
```

###crm

- Remove one or more secrets

```
$ docker secret rm SECRET [SECRET...]
```

### inspect

- Display detailed information on one or more secrets

```
$ docker secret inspect [OPTIONS] SECRET [SECRET...]
```

## config命令

- 在动态的，大规模的分布式集群上，管理和分发配置文件也是很重要的工作，传统的配置文件分发方式（如配置文件放入镜像中，设置环境变量，volume 动态挂载等）都降低了镜像的通用性。
- 在 Docker 17.06 以上版本中，Docker 新增了 `docker config` 子命令来管理集群中的配置信息，以后你无需将配置文件放入镜像或挂载到容器中就可实现对服务的配置。
- **注意**:`config` 仅能在 Swarm 集群中使用。

### create

- Create a config from a file or STDIN

```
$ docker config create [OPTIONS] CONFIG file|-
```

-  `-l, --label`:Config labels

### ls

- List configs

```
$ docker config ls [OPTIONS]
```

### rm

- Remove one or more configs

```
$ docker config rm CONFIG [CONFIG...]
```

### inpect

- Display detailed information on one or more configs

```
$ docker config inspect [OPTIONS] CONFIG [CONFIG...]
```