---
title: Redis 哈希(Hash)
categories:
- Software
- Backend
- Database
- Redis
- Value
- 基础数据类型
---
# Redis 哈希(Hash)

- Redis hash 是一个 string 类型的 field(字段) 和 value(值) 的映射表,类似于Map,hash 特别适合用于存储对象
- Redis 中每个 hash 可以存储 232 - 1 键值对(40多亿)

**实例**

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

- 在以上实例中,我们设置了 redis 的一些描述信息(name, description, likes, visitors) 到哈希表的 **testKey** 中

## Redis hash 命令

- 下表列出了 redis hash 基本的相关命令:

| 序号 | 命令及描述                                                   |
| :--- | :----------------------------------------------------------- |
| 1    | [HDEL key field1 field2\]  删除一个或多个哈希表字段          |
| 2    | HEXISTS key field  查看哈希表 key 中,指定的字段是否存在,     |
| 3    | HGET key field  获取存储在哈希表中指定字段的值,              |
| 4    | HGETALL key  获取在哈希表中指定 key 的所有字段和值           |
| 5    | HINCRBY key field increment  为哈希表 key 中的指定字段的整数值加上增量 increment , |
| 6    | HINCRBYFLOAT key field increment  为哈希表 key 中的指定字段的浮点数值加上增量 increment , |
| 7    | HKEYS key  获取所有哈希表中的字段                            |
| 8    | HLEN key  获取哈希表中字段的数量                             |
| 9    | [HMGET key field1 field2\]  获取所有给定字段的值             |
| 10   | [HMSET key field1 value1 field2 value2 \]  同时将多个 field-value (域-值)对设置到哈希表 key 中, |
| 11   | HSET key field value  将哈希表 key 中的字段 field 的值设为 value , |
| 12   | HSETNX key field value  只有在字段 field 不存在时,设置哈希表字段的值, |
| 13   | HVALS key  获取哈希表中所有值,                               |
| 14   | HSCAN key cursor [MATCH pattern\] [COUNT count]  迭代哈希表中的键值对, |