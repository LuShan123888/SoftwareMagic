---
title: Redis Set
categories:
  - Software
  - BackEnd
  - Database
  - Redis
  - 数据类型
  - 基础数据类型
---
# Redis Set

- Redis 的 Set 是 String 类型的无序集合，集合成员是唯一的，这就意味着集合中不能出现重复的数据。
- Redis 中集合是通过Hash表实现的，所以添加，删除，查找的复杂度都是 O(1)
- 集合中最大的成员数为 232 - 1 (4294967295，每个集合可存储40多亿个成员）

**实例**

```
$ SADD testkey redis
(integer) 1
$ SADD testkey mongodb
(integer) 1
$ SADD testkey mysql
(integer) 1
$ SADD testkey mysql
(integer) 0
$ SMEMBERS testkey

1) "mysql"
2) "mongodb"
3) "redis"
```

- 在以上实例中我们通过 **SADD** 命令向名为 **testkey** 的集合插入的三个元素。

## Redis 集合命令

- 下表列出了 Redis 集合基本命令：

| 序号 | 命令及描述                                                   |
| :--- | :----------------------------------------------------------- |
| 1    | [SADD key member1 member2\]  向集合添加一个或多个成员        |
| 2    | SCARD key  获取集合的成员数                                  |
| 3    | [SDIFF key1 key2\]  返回第一个集合与其他集合之间的差异，      |
| 4    | [SDIFFSTORE destination key1 key2\]  返回给定所有集合的差集并存储在 destination 中 |
| 5    | [SINTER key1 key2\]  返回给定所有集合的交集                  |
| 6    | [SINTERSTORE destination key1 key2\]  返回给定所有集合的交集并存储在 destination 中 |
| 7    | SISMEMBER key member  判断 member 元素是否是集合 key 的成员  |
| 8    | SMEMBERS key  返回集合中的所有成员                           |
| 9    | SMOVE source destination member  将 member 元素从 source 集合移动到 destination 集合 |
| 10   | SPOP key  移除并返回集合中的一个随机元素                     |
| 11   | [SRANDMEMBER key count\]  返回集合中一个或多个随机数         |
| 12   | [SREM key member1 member2\]  移除集合中一个或多个成员        |
| 13   | [SUNION key1 key2]  返回所有给定集合的并集                   |
| 14   | [SUNIONSTORE destination key1 key2\]  所有给定集合的并集存储在 destination 集合中 |
| 15   | SSCAN key cursor [MATCH pattern\] [COUNT count]  迭代集合中的元素 |