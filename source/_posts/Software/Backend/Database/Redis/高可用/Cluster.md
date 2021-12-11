---
title: Redis Cluster
categories:
- Software
- Backend
- Database
- Redis
- 高可用
---
# Redis Cluster

- Cluster 是分割数据到多个Redis实例的处理过程,因此每个实例只保存key的一个子集
- **优点**
    - 通过利用多台计算机内存,可以构造更大的数据库
    - 通过利用多台计算机的多核,允许我们扩展计算能力
    - 通过利用多台计算机的网络适配器,可以扩展网络带宽
- **Cluster 的不足**
    - 涉及多个key的操作通常是不被支持的,例如,当两个set映射到不同的redis实例上时,你就不能对这两个set执行交集操作
    - 涉及多个key的redis事务不能使用
    - 当使用分片时,数据处理较为复杂,比如需要处理多个rdb/aof文件,并且从多个实例和主机备份持久化文件
    - 增加或删除容量也比较复杂,redis集群大多数支持在运行时增加,删除节点的透明数据平衡的能力,但是类似于客户端分片,代理等其他系统则不支持这项特性,然而,一种叫做presharding的技术对此是有帮助的

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-04-23-1-20210423112023008.png)

- 如上图所示,该集群中包含 6 个 Redis 节点,3主3从,分别为M1,M2,M3,S1,S2,S3,除了主从 Redis 节点之间进行数据复制外,所有 Redis 节点之间采用 Gossip 协议进行通信,交换维护节点元数据信息

## 数据分散存储

- Redis Cluster 集群采用 HashSlot（哈希槽）分配数据，Redis 集群预先分好16384（16K）个槽，初始化集群时平均规划给每一台Redis Master
- 然后对存入的Key取哈希并对16384（16K）取模得到指定的槽，存放到包含该槽的节点服务器上

## Docker搭建分片集群

### 配置Redis集群docker虚拟网卡

```bash
$ docker network create redis_cluster
```

### Redis节点配置文件

```bash
for id in $(seq 1 6);
do
mkdir -p ~/DockerVolumes/redis_cluster/node-${id}/conf
touch ~/DockerVolumes/redis_cluster/node-${id}/conf/redis.conf
cat << EOF >~/DockerVolumes/redis_cluster/node-${id}/conf/redis.conf
port 6379
bind 0.0.0.0
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
cluster-announce-ip 172.38.0.1${id}
cluster-announce-port 6379
cluster-announce-bus-port 16379
appendonly yes
EOF
done
```

### 启动Redis集群容器

```bash
for id in $(seq 1 6);
do
docker run-d   --name redis_cluster-${id} -p 637${id}:6379 -p 1637${id}:16379  \
-v ~/DockerVolumes/redis_cluster/node-${id}/data:/data  \
-v ~/DockerVolumes/redis_cluster/node-${id}/conf/redis.conf:/etc/redis/redis.conf  \
--net redis_cluster --ip 172.38.0.1${id} redis:5.0.9-alpine3.11 redis-server /etc/redis/redis.conf \
--hostname redis_cluster-${id}
done
```

### 创建Redis集群

```bash
$ docker exec -it redis_cluster-1 /bin/bash

$redis-cli --cluster create \
172.38.0.11:6379 172.38.0.12:6379 \
172.38.0.13:6379 172.38.0.14:6379 \
172.38.0.15:6379 172.38.0.16:6379 --cluster-replicas 1
```

### 连接Redis集群

```
$ docker exec -it redis_cluster-1 /bin/bash

$ redis-cli -c   #-c表示集群
```

### 查看Redis集群信息

#### 集群配置

```shell
127.0.0.1:6379> cluster info  #集群配置
cluster_state:ok
cluster_slots_assigned:16384
cluster_slots_ok:16384
cluster_slots_pfail:0
cluster_slots_fail:0
cluster_known_nodes:6
cluster_size:3
cluster_current_epoch:6
cluster_my_epoch:1
cluster_stats_messages_ping_sent:613
cluster_stats_messages_pong_sent:614
cluster_stats_messages_sent:1227
cluster_stats_messages_ping_received:609
cluster_stats_messages_pong_received:613
cluster_stats_messages_meet_received:5
cluster_stats_messages_received:1227
```

#### 节点信息

```bash
127.0.0.1:6379> cluster nodes # 集群节点信息
887c5ded66d075b6d29602f89a6adc7d1471d22c 172.38.0.11:6379@16379 myself,master - 0 1598439359000 1 connected 0-5460
e6b5521d86abc96fe2e51e40be8fbb1f23da9fe7 172.38.0.15:6379@16379 slave 887c5ded66d075b6d29602f89a6adc7d1471d22c 0 1598439359580 5 connected
d75a9db032f13d9484909b2d0d4724f44e3f1c23 172.38.0.14:6379@16379 slave db3caa7ba307a27a8ef30bf0b26ba91bfb89e932 0 1598439358578 4 connected
b6add5e06fd958045f90f29bcbbf219753798ef6 172.38.0.16:6379@16379 slave 7684dfd02929085817de59f334d241e6cbcd1e99 0 1598439358578 6 connected
7684dfd02929085817de59f334d241e6cbcd1e99 172.38.0.12:6379@16379 master - 0 1598439360082 2 connected 5461-10922
db3caa7ba307a27a8ef30bf0b26ba91bfb89e932 172.38.0.13:6379@16379 master - 0 1598439359079 3 connected 10923-16383
```

## 集群测试

- 高可用测试

```bash
127.0.0.1:6379> set msg "hello,I like your blog!" # 设置值
-> Redirected to slot [6257] located at 172.38.0.12:6379
OK
172.38.0.12:6379> get msg #取值
"hello,I like your blog!"

# 用docker stop模拟存储msg值的redis主机宕机
$ docker ps
CONTAINER ID        IMAGE                    COMMAND                  CREATED             STATUS              PORTS                                              NAMES
705e41851450        redis:5.0.9-alpine3.11   "docker-entrypoint.s..."   20 minutes ago      Up 20 minutes       0.0.0.0:6376->6379/tcp, 0.0.0.0:16376->16379/tcp   redis-6
89844e29f714        redis:5.0.9-alpine3.11   "docker-entrypoint.s..."   20 minutes ago      Up 20 minutes       0.0.0.0:6375->6379/tcp, 0.0.0.0:16375->16379/tcp   redis-5
8f1ead5ca10a        redis:5.0.9-alpine3.11   "docker-entrypoint.s..."   20 minutes ago      Up 20 minutes       0.0.0.0:6374->6379/tcp, 0.0.0.0:16374->16379/tcp   redis-4
f77c5d93a97a        redis:5.0.9-alpine3.11   "docker-entrypoint.s..."   21 minutes ago      Up 21 minutes       0.0.0.0:6373->6379/tcp, 0.0.0.0:16373->16379/tcp   redis-3
cc2a93a6b4dd        redis:5.0.9-alpine3.11   "docker-entrypoint.s..."   21 minutes ago      Up 21 minutes       0.0.0.0:6372->6379/tcp, 0.0.0.0:16372->16379/tcp   redis-2
6c9c3b813129        redis:5.0.9-alpine3.11   "docker-entrypoint.s..."   26 minutes ago      Up 26 minutes       0.0.0.0:6371->6379/tcp, 0.0.0.0:16371->16379/tcp   redis-1
$ docker stop redis-2
redis-2

# 重新进入集群交互界面,并尝试获取msg消息
/data # exit
$ docker exec -it redis-1 /bin/sh
/data # redis-cli -c
127.0.0.1:6379> get ms
-> Redirected to slot [13186] located at 172.38.0.13:6379
(nil)
172.38.0.13:6379> get msg
-> Redirected to slot [6257] located at 172.38.0.16:6379 # 此时由备用机返回msg
"hello,I like your blog!"
```