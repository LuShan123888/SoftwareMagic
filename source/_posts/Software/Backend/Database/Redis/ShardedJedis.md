---
title: Redis ShardedJedis
categories:
- Software
- BackEnd
- Database
- Redis
---
# Redis ShardedJedis

- ShardedJedis是基于一致性哈希算法实现的分布式Redis集群客户端，集群使用一致性 hash 来确保一个 Key 始终被指向相同的 Redis Server,每个 Redis Server 被称为一个 Shard
- 因为每个 Shard 都是一个 Master,因此使用 sharding 机制会产生一些限制：不能在 sharding中直接使用 Jedis 的 transactions,pipelining,pub/sub 这些 API,基本的原则是不能跨越 shard,但 jedis 并没有在 API 的层面上禁止这些行为，但是这些行为会有不确定的结果，一种可能的方式是使用 keytags 来干预 key 的分布，当然，这需要手工的干预
- 另外一个限制是正在使用的 shards 是不能被改变的，因为所有的 sharding 都是预分片的

## ShardedJedis实现分析

- ShardedJedis的设计分为以下几块:
    - 对象池设计:Pool,ShardedJedisPool,ShardedJedisFactory
    - 面向用户的操作封装:BinaryShardedJedis,BinaryShardedJedis
    - 一致性哈希实现:Sharded
- 关于ShardedJedis设计，忽略了Jedis的设计细节，设计类图如下:

![8bd3b170-018d-36a2-b2e5-44cde24caceb.jpg](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/1458475110109071209.jpg)

- 关于ShardedJedis类图设计，省略了对象池，以及Jedis设计的以下细节介绍:

| 类名               | 职责                                                         |
| ------------------ | ------------------------------------------------------------ |
| Sharded            | 抽象了基于一致性哈希算法的划分设计，设计思路基于hash算法划分redis服务器保持每台Redis服务器的Jedis客户端提供基于Key的划分方法，提供了ShardKeyTag实现 |
| BinaryShardedJedis | 同BinaryJedis类似，实现BinaryJedisCommands对外提供基于Byte[]的key,value操作 |
| ShardedJedis       | 同Jedis类似，实现JedisCommands对外提供基于String的key,value操作 |

- shared一致性哈希算法
    1. Redis服务器节点划分：将每台服务器节点采用hash算法划分为160个虚拟节点（可以配置划分权重)
    2. 将划分虚拟节点采用TreeMap存储
    3. 对每个Redis服务器的物理连接采用LinkedHashMap存储
    4. 对Key or KeyTag 采用同样的hash算法，然后从TreeMap获取大于等于键hash值得节点，取最邻近节点存储，当key的hash值大于虚拟节点hash值得最大值时，存入第一个虚拟节点

## 使用方法

### 定义 shards

```java
List<JedisShardInfo> shards = new ArrayList<JedisShardInfo>();
JedisShardInfo si = new JedisShardInfo("localhost", 6379);
si.setPassword("123456");
shards.add(si);
si = new JedisShardInfo("localhost", 6380);
si.setPassword("123456");
shards.add(si);
```

### 使用shards

- 直接使用

```java
ShardedJedis jedis = new ShardedJedis(shards);
jedis.set("a", "foo");
jedis.disconnect;
```

- 使用连接池

```java
ShardedJedisPool pool = new ShardedJedisPool(new Config(), shards);
ShardedJedis jedis = pool.getResource();
jedis.set("a", "foo"); // do your work here
pool.returnResource(jedis); // a few moments later
ShardedJedis jedis2 = pool.getResource();
jedis.set("z", "bar");
pool.returnResource(jedis);
pool.destroy();
```

### 获取当前 shards 信息

```java
ShardInfo si = jedis.getShardInfo(key);
si.getHost/getPort/getPassword/getTimeout/getName
```

### keytags

- 也可以通过 keytags 来确保 key 位于相同的 shard,如:

```java
ShardedJedis jedis = new ShardedJedis(shards,ShardedJedis.DEFAULT_KEY_TAG_PATTERN);
```

- 这样，默认的 keytags 是”{}”,这表示在”{}”内的字符会用于决定使用那个 shard,如:

```java
jedis.set("foo{bar}", "12345");
jedis.set("car{bar}", "877878");
```

- **注意**:如果 key 和 keytag 不匹配，会使用原来的 key 作为选择 shard 的 key