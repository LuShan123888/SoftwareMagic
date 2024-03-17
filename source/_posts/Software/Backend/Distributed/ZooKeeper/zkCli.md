---
title: Zookeeper zkCli
categories:
- Software
- BackEnd
- Distributed
- ZooKeeper
---
# Zookeeper zkCli

## 连接zkServer

```shell
$ zkCli
Connecting to localhost:2181
Welcome to ZooKeeper!
JLine support is enabled
[zk: localhost:2181(CONNECTING) 0]
```

## ls 命令

- ls 命令用于查看某个路径下目录列表

```
ls path
```

- 查看`/zookeeper`路径

```
[zk: localhost:2181(CONNECTED) 13] ls /zookeeper
[quota]
```

## ls2 命令

- ls2 命令用于查看某个路径下目录列表，它比 ls 命令列出更多的详细信息

```
ls2 path
```

- 详细查看`/zookeeper`路径

```
[zk: localhost:2181(CONNECTED) 12] ls2 /zookeeper
[quota]
cZxid = 0x0
ctime = Thu Jan 01 08:00:00 CST 1970
mZxid = 0x0
mtime = Thu Jan 01 08:00:00 CST 1970
pZxid = 0x0
cversion = -1
dataVersion = 0
aclVersion = 0
ephemeralOwner = 0x0
dataLength = 0
numChildren = 1
```

## create 命令

- create 命令用于创建节点并赋值

```
create [-s] [-e] path data acl
```

- **[-s] [-e]**:-s 和 -e 都是可选的,-s 代表顺序节点,-e 代表临时节点，注意其中 -s 和 -e 可以同时使用的，并且临时节点不能再创建子节点,session 关闭，临时节点清除
- **path**:指定要创建节点的路径，比如 **/test**
- **data**:要在此节点存储的数据
- **acl**:访问权限相关，默认是 world,相当于全世界都能访问

**实例**

- 添加临时顺序节点test

```
[zk: localhost:2181(CONNECTED) 22] create -s -e /test 0
Created /test0000000003
[zk: localhost:2181(CONNECTED) 23] create -s -e /test 0
Created /test0000000004
[zk: localhost:2181(CONNECTED) 24] create -s -e /test 0
Created /test0000000005
```

- 创建的节点既是有序，又是临时节点

## get 命令

- get 命令用于获取节点数据和状态信息

```
get path [watch]
```

- **path**:代表路径
- **[watch]**:对节点进行事件监听

**实例**

- 终端一

```
$ get /test watch
```

- 在终端二对此节点进行修改:

```
$ set /test "Hello"
```

- 终端一自动显示 NodeDataChanged 事件:

```shell
WatchedEvent state:SyncConnected type:NodeDataChanged path:/test
```

## stat 命令

- stat 命令用于查看节点状态信息

```
stat path [watch]
```

- **path**:代表路径
- **[watch]**:对节点进行事件监听

**实例**

- 查看`test`节点状态:

```
[zk: localhost:2181(CONNECTED) 20] stat /test
cZxid = 0x23
ctime = Mon Jun 14 22:12:20 CST 2021
mZxid = 0x24
mtime = Mon Jun 14 22:12:41 CST 2021
pZxid = 0x23
cversion = 0
dataVersion = 1
aclVersion = 0
ephemeralOwner = 0x0
dataLength = 5
numChildren = 0
```

## set 命令

- set 命令用于修改节点存储的数据

```
set path data [version]
```

- **path**:节点路径
- **data**:需要存储的数据
- **[version]**:可选项，版本号(可用作乐观锁)

**实例**

- 以下实例开启两个终端，也可以在同一终端操作:

```
[zk: localhost:2181(CONNECTED) 26] get /test
0
cZxid = 0x26
ctime = Mon Jun 14 22:15:04 CST 2021
mZxid = 0x26
mtime = Mon Jun 14 22:15:04 CST 2021
pZxid = 0x26
cversion = 0
dataVersion = 0
aclVersion = 0
ephemeralOwner = 0x10013ac9ce90001
dataLength = 1
numChildren = 0
```

- 只有正确的版本号才能设置成功:

```
[zk: localhost:2181(CONNECTED) 27] set /test 0 1
version No is not valid : /test
[zk: localhost:2181(CONNECTED) 28] set /test 0 0
cZxid = 0x26
ctime = Mon Jun 14 22:15:04 CST 2021
mZxid = 0x2a
mtime = Mon Jun 14 22:17:40 CST 2021
pZxid = 0x26
cversion = 0
dataVersion = 1
aclVersion = 0
ephemeralOwner = 0x10013ac9ce90001
dataLength = 1
numChildren = 0
```

## delete 命令

- delete 命令用于删除某节点

```
delete path [version]
```

- **path**:节点路径
- **[version]**:可选项，版本号(同 set 命令)

**实例**

- 删除`/test`节点

```
[zk: localhost:2181(CONNECTED) 33]
```