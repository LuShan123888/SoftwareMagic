---
title: ZooKeeper ACl
categories:
- Software
- BackEnd
- Distributed
- ZooKeeper
---
# ZooKeeper ACl

- ACL(Access Control List,访问控制表)权限可以针对节点设置相关读写等权限，保障数据安全性
- permissions 可以指定不同的权限范围及角色

## ACL 命令

- **getAcl 命令**:获取某个节点的 acl 权限信息
- **setAcl 命令**:设置某个节点的 acl 权限信息
- **addauth 命令**:输入认证授权信息，注册时输入明文密码，加密形式保存

## ACL 构成

- zookeeper 的 acl 通过 `[scheme:id:permissions]`来构成权限列表
    1. **scheme**:代表采用的某种权限机制，包括 world,auth,digest,ip,super 几种
    2. **id**:代表允许访问的用户
    3. **permissions**:权限组合字符串，由 cdrwa 组成，其中每个字母代表支持不同权限，创建权限 create(c),删除权限 delete(d),读权限 read(r),写权限 write(w),管理权限admin(a)

## permissions

查看默认节点权限，再更新节点 permissions 权限部分为 cdwa,结果查询节点失败，其中 world 代表开放式权限

```
[zk: localhost:2181(CONNECTED) 36] getAcl /test
'world,'anyone
: cdrwa
[zk: localhost:2181(CONNECTED) 47] setAcl /test world:anyone:cdwa
cZxid = 0x36
ctime = Mon Jun 14 23:04:28 CST 2021
mZxid = 0x36
mtime = Mon Jun 14 23:04:28 CST 2021
pZxid = 0x36
cversion = 0
dataVersion = 0
aclVersion = 1
ephemeralOwner = 0x0
dataLength = 1
numChildren = 0
[zk: localhost:2181(CONNECTED) 53] get /test
Authentication is not valid : /test
```

### auth

auth 用于授予权限，注意需要先创建用户

```
[zk: localhost:2181(CONNECTED) 56] addauth digest user1:123456
```

```
[zk: localhost:2181(CONNECTED) 57] setAcl /test auth:user1:123456:cdrwa
cZxid = 0x3a
ctime = Mon Jun 14 23:06:09 CST 2021
mZxid = 0x3a
mtime = Mon Jun 14 23:06:09 CST 2021
pZxid = 0x3a
cversion = 0
dataVersion = 0
aclVersion = 2
ephemeralOwner = 0x0
dataLength = 1
numChildren = 0
[zk: localhost:2181(CONNECTED) 58] getAcl /test
'digest,'user1:HYGa7IZRm2PUBFiFFu8xY2pPP/s=
: cdrwa
[zk: localhost:2181(CONNECTED) 59]
```

### digest

退出当前用户，重新连接终端,digest 可用于账号密码登录和验证

```
[zk: localhost:2181(CONNECTED) 59] setAcl /test digest:user1:HYGa7IZRm2PUBFiFFu8xY2pPP/s=:cdra
cZxid = 0x3a
ctime = Mon Jun 14 23:06:09 CST 2021
mZxid = 0x3a
mtime = Mon Jun 14 23:06:09 CST 2021
pZxid = 0x3a
cversion = 0
dataVersion = 0
aclVersion = 3
ephemeralOwner = 0x0
dataLength = 1
numChildren = 0
```

**注意**:加密密码创建创建user1是返回的

### IP

限制 IP 地址的访问权限，把权限设置给 IP 地址为 192.168.3.2 后,IP 为 127.0.0.1 已经没有访问权限

```
[zk: localhost:2181(CONNECTED) 62] setAcl /test ip:192.158.3.2:cdrwa
cZxid = 0x3a
ctime = Mon Jun 14 23:06:09 CST 2021
mZxid = 0x3a
mtime = Mon Jun 14 23:06:09 CST 2021
pZxid = 0x3a
cversion = 0
dataVersion = 0
aclVersion = 4
ephemeralOwner = 0x0
dataLength = 1
numChildren = 0
[zk: localhost:2181(CONNECTED) 63] get /test
Authentication is not valid : /test
```