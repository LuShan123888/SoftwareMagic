---
title: Redis Jedis
categories:
- Software
- BackEnd
- Database
- Redis
---
# Redis Jedis

## 连接Redis

### Jedis

```java
Jedis jedis = new Jedis("127.0.0.1", 6379);
// jedis.auth("password"); // 如果服务器需要密码，验证密码。
jedis.select(0); // 选择0号数据库。
jedis.connect(); // 连接。
jedis.disconnect(); // 断开连接。
jedis.flushAll(); // 清空所有的key
```

### JedisPool

- 每次连接需要创建一个连接，执行完后就关闭，非常浪费资源，所以使用jedispool（连接池）连接。

```java
//  创建连接池配置对象。
JedisPoolConfig jedisPoolConfig = new JedisPoolConfig();
jedisPoolConfig.setMaxTotal(8);
jedisPoolConfig.setMaxIdle(8);
// 创建连接池对象。
JedisPool jedisPool = new JedisPool(jedisPoolConfig, "localhost", 6379);
// 从连接池中获取一个Jedis对象。
Jedis jedis = jedisPool.getResource();
// 把连接归还到连接池。
jedis.close();
// 释放连接池对象。
jedisPool.close();
```

### 测试Redis

```java
Jedis jedis = new Jedis("127.0.0.1",6379);
// 查看服务是否运行。
System.out.println("服务正在运行： "+jedis.ping());
// 获取客户端信息。
System.out.println(jedis.getClient());
// 清空Redis数据库，相当于执行FLUSHALL命令。
System.out.println(jedis.flushAll());
// 查看Redis信息，相当于执行INFO命令。
System.out.println(jedis.info());
// 获取数据库中key的数量，相当于执行DBSIZE命令。
System.out.println(jedis.dbSize());
// 获取数据库名字。
System.out.println(jedis.getDB());
// 返回当前Redis服务器的时间，相当于执行TIME命令。
System.out.println(jedis.time());
```

## 数据类型

### key

```java
Jedis jedis = new Jedis("127.0.0.1", 6379);
System.out.println("清空数据："+jedis.flushDB());
System.out.println("判断某个键是否存在："+jedis.exists("username"));
System.out.println("新增<'username','test'>的键值对："+jedis.set("username", "test"));
System.out.println("新增<'password','password'>的键值对："+jedis.set("password", "password"));
System.out.print("系统中所有的键如下：");
Set<String> keys = jedis.keys("*");
System.out.println(keys);
System.out.println("删除键password:"+jedis.del("password"));
System.out.println("判断键password是否存在："+jedis.exists("password"));
System.out.println("查看键username所存储的值的类型："+jedis.type("username"));
System.out.println("随机返回key空间的一个："+jedis.randomKey());
System.out.println("重命名key:"+jedis.rename("username","name"));
System.out.println("取出改后的name:"+jedis.get("name"));
System.out.println("按索引查询："+jedis.select(0));
System.out.println("删除当前选择数据库中的所有key:"+jedis.flushDB());
System.out.println("返回当前数据库中key的数目："+jedis.dbSize());
System.out.println("删除所有数据库中的所有key:"+jedis.flushAll());
```

### String

```java
Jedis jedis = new Jedis("127.0.0.1", 6379);
jedis.flushDB();
System.out.println("===========增加数据===========");
System.out.println(jedis.set("key1","value1"));
System.out.println(jedis.set("key2","value2"));
System.out.println(jedis.set("key3", "value3"));
System.out.println("删除键key2:"+jedis.del("key2"));
System.out.println("获取键key2:"+jedis.get("key2"));
System.out.println("修改key1:"+jedis.set("key1", "value1Changed"));
System.out.println("获取key1的值："+jedis.get("key1"));
System.out.println("在key3后面加入值："+jedis.append("key3", "End"));
System.out.println("key3的值："+jedis.get("key3"));
System.out.println("增加多个键值对："+jedis.mset("key01","value01","key02","value02","key03","value03"));
System.out.println("获取多个键值对："+jedis.mget("key01","key02","key03"));
System.out.println("获取多个键值对："+jedis.mget("key01","key02","key03","key04"));
System.out.println("删除多个键值对："+jedis.del("key01","key02"));
System.out.println("获取多个键值对："+jedis.mget("key01","key02","key03"));

jedis.flushDB();
System.out.println("===========新增键值对防止覆盖原先值==============");
System.out.println(jedis.setnx("key1", "value1"));
System.out.println(jedis.setnx("key2", "value2"));
System.out.println(jedis.setnx("key2", "value2-new"));
System.out.println(jedis.get("key1"));
System.out.println(jedis.get("key2"));

System.out.println("===========新增键值对并设置有效时间=============");
System.out.println(jedis.setex("key3", 2, "value3"));
System.out.println(jedis.get("key3"));
try {
TimeUnit.SECONDS.sleep(3);
} catch (InterruptedException e) {
e.printStackTrace();
}
System.out.println(jedis.get("key3"));

System.out.println("===========获取原值，更新为新值==========");
System.out.println(jedis.getSet("key2", "key2GetSet"));
System.out.println(jedis.get("key2"));

System.out.println("获得key2的值的字串："+jedis.getrange("key2", 2, 4));
```

### List

```java
Jedis jedis = new Jedis("127.0.0.1", 6379);
jedis.flushDB();
System.out.println("===========添加一个list===========");
jedis.lpush("collections", "ArrayList", "Vector", "Stack", "HashMap", "WeakHashMap", "LinkedHashMap");
jedis.lpush("collections", "HashSet");
jedis.lpush("collections", "TreeSet");
jedis.lpush("collections", "TreeMap");
System.out.println("collections的内容："+jedis.lrange("collections", 0, -1));//-1代表倒数第一个元素，-2代表倒数第二个元素，end为-1表示查询全部。
System.out.println("collections区间0-3的元素："+jedis.lrange("collections",0,3));
System.out.println("===============================");
// 删除列表指定的值，第二个参数为删除的个数（有重复时），后add进去的值先被删，类似于出栈。
System.out.println("删除指定元素个数："+jedis.lrem("collections", 2, "HashMap"));
System.out.println("collections的内容："+jedis.lrange("collections", 0, -1));
System.out.println("删除下表0-3区间之外的元素："+jedis.ltrim("collections", 0, 3));
System.out.println("collections的内容："+jedis.lrange("collections", 0, -1));
System.out.println("collections列表出栈（左端）:"+jedis.lpop("collections"));
System.out.println("collections的内容："+jedis.lrange("collections", 0, -1));
System.out.println("collections添加元素，从列表右端，与lpush相对应："+jedis.rpush("collections", "EnumMap"));
System.out.println("collections的内容："+jedis.lrange("collections", 0, -1));
System.out.println("collections列表出栈（右端）:"+jedis.rpop("collections"));
System.out.println("collections的内容："+jedis.lrange("collections", 0, -1));
System.out.println("修改collections指定下标1的内容："+jedis.lset("collections", 1, "LinkedArrayList"));
System.out.println("collections的内容："+jedis.lrange("collections", 0, -1));
System.out.println("===============================");
System.out.println("collections的长度："+jedis.llen("collections"));
System.out.println("获取collections下标为2的元素："+jedis.lindex("collections", 2));
System.out.println("===============================");
jedis.lpush("sortedList", "3","6","2","0","7","4");
System.out.println("sortedList排序前："+jedis.lrange("sortedList", 0, -1));
System.out.println(jedis.sort("sortedList"));
System.out.println("sortedList排序后："+jedis.lrange("sortedList", 0, -1));
```

### Set

```java
Jedis jedis = new Jedis("127.0.0.1", 6379);
jedis.flushDB();
System.out.println("============向集合中添加元素（不重复）============");
System.out.println(jedis.sadd("eleSet", "e1","e2","e4","e3","e0","e8","e7","e5"));
System.out.println(jedis.sadd("eleSet", "e6"));
System.out.println(jedis.sadd("eleSet", "e6"));
System.out.println("eleSet的所有元素为："+jedis.smembers("eleSet"));
System.out.println("删除一个元素e0:"+jedis.srem("eleSet", "e0"));
System.out.println("eleSet的所有元素为："+jedis.smembers("eleSet"));
System.out.println("删除两个元素e7和e6:"+jedis.srem("eleSet", "e7","e6"));
System.out.println("eleSet的所有元素为："+jedis.smembers("eleSet"));
System.out.println("随机的移除集合中的一个元素："+jedis.spop("eleSet"));
System.out.println("随机的移除集合中的一个元素："+jedis.spop("eleSet"));
System.out.println("eleSet的所有元素为："+jedis.smembers("eleSet"));
System.out.println("eleSet中包含元素的个数："+jedis.scard("eleSet"));
System.out.println("e3是否在eleSet中："+jedis.sismember("eleSet", "e3"));
System.out.println("e1是否在eleSet中："+jedis.sismember("eleSet", "e1"));
System.out.println("e1是否在eleSet中："+jedis.sismember("eleSet", "e5"));
System.out.println("=================================");
System.out.println(jedis.sadd("eleSet1", "e1","e2","e4","e3","e0","e8","e7","e5"));
System.out.println(jedis.sadd("eleSet2", "e1","e2","e4","e3","e0","e8"));
System.out.println("将eleSet1中删除e1并存入eleSet3中："+jedis.smove("eleSet1", "eleSet3", "e1"));// 移到集合元素。
System.out.println("将eleSet1中删除e2并存入eleSet3中："+jedis.smove("eleSet1", "eleSet3", "e2"));
System.out.println("eleSet1中的元素："+jedis.smembers("eleSet1"));
System.out.println("eleSet3中的元素："+jedis.smembers("eleSet3"));
System.out.println("============集合运算=================");
System.out.println("eleSet1中的元素："+jedis.smembers("eleSet1"));
System.out.println("eleSet2中的元素："+jedis.smembers("eleSet2"));
System.out.println("eleSet1和eleSet2的交集："+jedis.sinter("eleSet1","eleSet2"));
System.out.println("eleSet1和eleSet2的并集："+jedis.sunion("eleSet1","eleSet2"));
System.out.println("eleSet1和eleSet2的差集："+jedis.sdiff("eleSet1","eleSet2"));//eleSet1中有，eleSet2中没有。
jedis.sinterstore("eleSet4","eleSet1","eleSet2");// 求交集并将交集保存到dstkey的集合。
System.out.println("eleSet4中的元素："+jedis.smembers("eleSet4"));
```

### Hash

```java
Jedis jedis = new Jedis("127.0.0.1", 6379);
jedis.flushDB();
Map<String,String> map = new HashMap<String,String>();
map.put("key1","value1");
map.put("key2","value2");
map.put("key3","value3");
map.put("key4","value4");
// 添加名称为hash(key）的hash元素。
jedis.hmset("hash",map);
// 向名称为hash的hash中添加key为key5,value为value5元素。
jedis.hset("hash", "key5", "value5");
System.out.println("散列hash的所有键值对为："+jedis.hgetAll("hash"));//return Map<String,String>
System.out.println("散列hash的所有键为："+jedis.hkeys("hash"));//return Set<String>
System.out.println("散列hash的所有值为："+jedis.hvals("hash"));//return List<String>
System.out.println("将key6保存的值加上一个整数，如果key6不存在则添加key6:"+jedis.hincrBy("hash", "key6", 6));
System.out.println("散列hash的所有键值对为："+jedis.hgetAll("hash"));
System.out.println("将key6保存的值加上一个整数，如果key6不存在则添加key6:"+jedis.hincrBy("hash", "key6", 3));
System.out.println("散列hash的所有键值对为："+jedis.hgetAll("hash"));
System.out.println("删除一个或者多个键值对："+jedis.hdel("hash", "key2"));
System.out.println("散列hash的所有键值对为："+jedis.hgetAll("hash"));
System.out.println("散列hash中键值对的个数："+jedis.hlen("hash"));
System.out.println("判断hash中是否存在key2:"+jedis.hexists("hash","key2"));
System.out.println("判断hash中是否存在key3:"+jedis.hexists("hash","key3"));
System.out.println("获取hash中的值："+jedis.hmget("hash","key3"));
System.out.println("获取hash中的值："+jedis.hmget("hash","key3","key4"));
```

## 事务

```java
// 创建客户端连接服务端，Redis服务端需要被开启。
Jedis jedis = new Jedis("127.0.0.1", 6379);
jedis.flushDB();

JSONObject jsonObject = new JSONObject();
jsonObject.put("hello", "world");
jsonObject.put("name", "java");
// 开启事务。
Transaction multi = jedis.multi();
String result = jsonObject.toJSONString();
try{
    // 向Redis存入一条数据。
    multi.set("json", result);
    // 再存入一条数据。
    multi.set("json2", result);
    // 这里引发了异常，用0作为被除数。
    int i = 100/0;
    // 如果没有引发异常，执行进入队列的命令。
    multi.exec();
    }catch(Exception e){
        e.printStackTrace();
        // 如果出现异常，回滚。
        multi.discard();
    }finally{
        System.out.println(jedis.get("json"));
        System.out.println(jedis.get("json2"));
        // 最终关闭客户端。
        jedis.close();
}

```

## jedisCluster

- jedisCluster专门用来连接Redis Cluster集群。

### 连接Cluster集群

```java
// 创建jedisCluster对象，有一个参数 nodes是Set类型，Set包含若干个HostAndPort对象。
Set<HostAndPort> nodes = new HashSet<>();
nodes.add(new HostAndPort("127.0.0.1",7001));
nodes.add(new HostAndPort("127.0.0.1",7002));
nodes.add(new HostAndPort("127.0.0.1",7003));
nodes.add(new HostAndPort("127.0.0.1",7004));
nodes.add(new HostAndPort("127.0.0.1",7005));
nodes.add(new HostAndPort("127.0.0.1",7006));
JedisCluster jedisCluster = new JedisCluster(nodes);
```

### 获取指定分片

```java
// 使用jedisCluster获取集群节点集合。
Map<String, JedisPool> clusterNodes = jedisCluster.getClusterNodes();
// 获取某个集群节点的连接池。
JedisPool jedisPool = clusterNodes.get(k);
// 获取Jedis实例。
Jedis connection = jedisPool.getResource();
// 操作对于分片。
String str = connection.get("test");
System.out.println(str);
// 关闭连接池。
jedisCluster.close();
```
