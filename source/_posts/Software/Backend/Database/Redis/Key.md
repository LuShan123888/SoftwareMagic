---
title: Redis key
categories:
- Software
- BackEnd
- Database
- Redis
---
# Redis key

- Redis的键key只能为字符串。
- Redis 键命令用于管理 Redis 的键。

```
$ COMMAND KEY_NAME
```

**实例**

```
$ SET testkey redis
OK
$ DEL testkey
(integer) 1
```

- 在以上实例中 **DEL** 是一个命令， **testkey** 是一个键，如果键被删除成功，命令执行后输出 **(integer) 1**，否则将输出 **(integer) 0**

## Redis keys 命令

- 下表给出了与 Redis 键相关的基本命令：

| 序号 | 命令及描述                                                   |
| :--- | :----------------------------------------------------------- |
| 1    | DEL key 该命令用于在 key 存在时删除 key,                     |
| 2    | DUMP key  序列化给定 key ，并返回被序列化的值，                |
| 3    | EXISTS key  检查给定 key 是否存在，                           |
| 4    | EXPIRE key seconds 为给定 key 设置过期时间，以秒计，           |
| 5    | EXPIREAT key timestamp  EXPIREAT 的作用和 EXPIRE 类似，都用于为 key 设置过期时间，不同在于 EXPIREAT 命令接受的时间参数是 UNIX 时间戳（unix timestamp), |
| 6    | PEXPIRE key milliseconds  设置 key 的过期时间以毫秒计，       |
| 7    | PEXPIREAT key milliseconds-timestamp  设置 key 过期时间的时间戳（unix timestamp）以毫秒计 |
| 8    | KEYS pattern  查找所有符合给定模式（ pattern）的 key ,         |
| 9    | MOVE key db  将当前数据库的 key 移动到给定的数据库 db 当中，  |
| 10   | PERSIST key  移除 key 的过期时间，key 将持久保持，             |
| 11   | PTTL key  以毫秒为单位返回 key 的剩余的过期时间，             |
| 12   | TTL key  以秒为单位，返回给定 key 的剩余生存时间（TTL, time to live), |
| 13   | RANDOMKEY  从当前数据库中随机返回一个 key ,                  |
| 14   | RENAME key newkey  修改 key 的名称                           |
| 15   | RENAMENX key newkey  仅当 newkey 不存在时，将 key 改名为 newkey , |
| 16   | SCAN cursor [MATCH pattern\] [COUNT count]  迭代数据库中的数据库键， |
| 17   | TYPE key  返回 key 所储存的值的类型，                         |