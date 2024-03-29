---
title: Redis String
categories:
  - Software
  - BackEnd
  - Database
  - Redis
  - 数据类型
  - 基础数据类型
---
# Redis String

- Redis 字符串数据类型的相关命令用于管理 Redis 字符串值，基本语法如下：

```shell
$ COMMAND KEY_NAME
```

**实例**

```shell
$ SET testKey redis
OK
$ GET testKey
"redis"
```

- 在以上实例中我们使用了 **SET** 和 **GET** 命令，键为 **testKey**
- 可通过设计key为key:{父属性}:{子属性}...存储对象。

```shell
$ SET key:person:age 1
```

## Redis 字符串命令

- 下表列出了常用的 Redis 字符串命令：

| 序号 | 命令及描述                                                   |
| :--- | :----------------------------------------------------------- |
| 1    | SET key value  设置指定 key 的值                             |
| 2    | GET key  获取指定 key 的值，                                  |
| 3    | GETRANGE key start end  返回 key 中字符串值的子字符          |
| 4    | GETSET key value 将给定 key 的值设为 value ，并返回 key 的旧值（old value), |
| 5    | GETBIT key offset 对 key 所储存的字符串值，获取指定偏移量上的位（bit), |
| 6    | [MGET key1 key2..\] 获取所有（一个或多个）给定 key 的值，       |
| 7    | SETBIT key offset value 对 key 所储存的字符串值，设置或清除指定偏移量上的位（bit), |
| 8    | SETEX key seconds value 将值 value 关联到 key ，并将 key 的过期时间设为 seconds （以秒为单位）, |
| 9    | SETNX key value 只有在 key 不存在时设置 key 的值，            |
| 10   | SETRANGE key offset value 用 value 参数覆写给定 key 所储存的字符串值，从偏移量 offset 开始， |
| 11   | STRLEN key 返回 key 所储存的字符串值的长度，                  |
| 12   | [MSET key value key value ...\] 同时设置一个或多个 key-value 对， |
| 13   | [MSETNX key value key value ...\]  同时设置一个或多个 key-value 对，当且仅当所有给定 key 都不存在， |
| 14   | PSETEX key milliseconds value 这个命令和 SETEX 命令相似，但它以毫秒为单位设置 key 的生存时间，而不是像 SETEX 命令那样，以秒为单位， |
| 15   | INCR key 将 key 中储存的数字值增一，                          |
| 16   | INCRBY key increment 将 key 所储存的值加上给定的增量值（increment) , |
| 17   | INCRBYFLOAT key increment 将 key 所储存的值加上给定的浮点增量值（increment) , |
| 18   | DECR key 将 key 中储存的数字值减一，                          |
| 19   | DECRBY key decrement key 所储存的值减去给定的减量值（decrement) , |
| 20   | APPEND key value 如果 key 已经存在并且是一个字符串， APPEND 命令将指定的 value 追加到该 key 原来值（value）的末尾，如果不存在，相当于SET |