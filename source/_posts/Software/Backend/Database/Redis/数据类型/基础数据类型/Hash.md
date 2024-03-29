---
title: Redis Hash
categories:
  - Software
  - BackEnd
  - Database
  - Redis
  - 数据类型
  - 基础数据类型
---
# Redis Hash

- Redis Hash是一个 String类型的 field（字段）和 value（值）的映射表，类似于Map,Hash特别适合用于存储对象。
- Redis 中每个 Hash可以存储 232 - 1 键值对（40多亿）

```
127.0.0.1:6379>  HMSET testKey name "redis tutorial" description "redis basic commands for caching" likes 20 visitors 23000
OK
127.0.0.1:6379>  HGETALL testKey
1) "name"
2) "redis tutorial"
3) "description"
4) "redis basic commands for caching"
5) "likes"
6) "20"
7) "visitors"
8) "23000"
```

- 在以上实例中，我们设置了 Redis 的一些描述信息（name, description, likes, visitors）到Hash表的 **testKey** 中。

## Redis Hash命令

- 下表列出了 Redis Hash基本的相关命令：

| 序号 | 命令及描述                                                   |
| :--- | :----------------------------------------------------------- |
| 1    | [HDEL key field1 field2\]  删除一个或多个Hash表字段          |
| 2    | HEXISTS key field  查看Hash表 key 中，指定的字段是否存在，     |
| 3    | HGET key field  获取存储在Hash表中指定字段的值，              |
| 4    | HGETALL key  获取在Hash表中指定 key 的所有字段和值           |
| 5    | HINCRBY key field increment  为Hash表 key 中的指定字段的整数值加上增量 increment , |
| 6    | HINCRBYFLOAT key field increment  为Hash表 key 中的指定字段的浮点数值加上增量 increment , |
| 7    | HKEYS key  获取所有Hash表中的字段                            |
| 8    | HLEN key  获取Hash表中字段的数量                             |
| 9    | [HMGET key field1 field2\]  获取所有给定字段的值             |
| 10   | [HMSET key field1 value1 field2 value2 \]  同时将多个 field-value （域-值）对设置到Hash表 key 中， |
| 11   | HSET key field value  将Hash表 key 中的字段 field 的值设为 value , |
| 12   | HSETNX key field value  只有在字段 field 不存在时，设置Hash表字段的值， |
| 13   | HVALS key  获取Hash表中所有值，                               |
| 14   | HSCAN key cursor [MATCH pattern\] [COUNT count]  迭代Hash表中的键值对， |