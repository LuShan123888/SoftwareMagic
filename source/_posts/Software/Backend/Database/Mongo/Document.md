---
title: Mongo Document
categories:
- Software
- Backend
- Database
- Mongo
---
# Mongo Document

文档(document)的数据结构和 JSON 基本一样。所有存储在集合中的数据都是 BSON 格式。

## 创建文档

创建文档时如果集合不存在，则会隐式创建集合

### 单个文档插入

使用insert() 或 save() 方法向集合中插入文档，语法如下:

```sh
db.collection.insert(
    <document or array of documents>, 
    {
    	writeConcern: <document>,
    	ordered: <boolean>
    }
)
```

- `document`:要插入到集合中的文档或文档数组
- `writeConcern`:可选参数。写入安全机制，是一种客户端设置，用于控制写入安全的级别。Write Concern 描述了MongoDB写入到mongod单实例，副本集，以及分片集群时何时应答给客户端。默认情况下，mongoDB文档增删改都会一直等待数据库响应(确认写入是否成功)，然后才会继续执行
    - WriteConcern.NONE:没有异常抛出
    - WriteConcern.NORMAL:仅抛出网络错误异常，没有服务器错误异常
    - WriteConcern.SAFE:抛出网络错误异常、服务器错误异常；并等待服务器完成写操作。
    - WriteConcern.MAJORITY: 抛出网络错误异常、服务器错误异常；并等待一个主服务器完成写操作。
    - WriteConcern.FSYNC_SAFE: 抛出网络错误异常、服务器错误异常；写操作等待服务器将数据刷新到磁盘。
    - WriteConcern.JOURNAL_SAFE:抛出网络错误异常、服务器错误异常；写操作等待服务器提交到磁盘的日志文件。
    - WriteConcern.REPLICAS_SAFE:抛出网络错误异常、服务器错误异常；等待至少2台服务器完成写操作。
- `ordered`:可选参数。在版本2.6+中默认为true
    - 如果为真，则按顺序插入数组中的文档，如果其中一个文档出现错误，MongoDB将返回而不处理数组中的其余文档。
    - 如果为假，则执行无序插入，如果其中一个文档出现错误，则继续处理数组中的其他文档。

**实例**

```shell
db.comment.insert(
	{
		"articleid":"100000",
		"content":"Content Test",
		"userid":"1001",
		"nickname":"Rose",
		"createdatetime":new Date(),
		"likenum":NumberInt(10),
		"state":null
	}
)
```

**注意**

- mongo中的数字，默认情况下是double类型，如果要存整型，必须使用函数NumberInt()
- 插入的数据没有指定 _id ，会自动生成主键值,其类型是ObjectID类型
- MongoDB的文档不能有重复的键

**文档键命名规范**

- 键不能含有\0 (空字符)。这个字符用来表示键的结尾
- .和$有特别的意义，只有在特定环境下才能使用。
- 以下划线"_"开头的键是保留的

### 批量文档插入

```shell
db.collection.insertMany(
	[ <document 1> , <document 2>, ... ], 
	{
		writeConcern: <document>,
		ordered: <boolean> 
	}
)
```

- 插入时指定了 _id ，则主键就是该值。
- 如果某条数据插入失败，将会终止插入，但已经插入成功的数据不会回滚掉。 因为批量插入由于数据较多容易出现失败，因此，可以使用try catch进行异常捕捉处理

```java
try { 
    db.comment.insertMany([
        {"_id":"1","articleid":"100001","content":"Content1","userid":"1002","nickname":"相忘于江湖","createdatetime":new Date("2019-08- 05T22:08:15.522Z"),"likenum":NumberInt(1000),"state":"1"},
        {"_id":"2","articleid":"100001","content":"Content2","userid":"1005","nickname":"伊人憔悴","createdatetime":new Date("2019-08-05T23:58:51.485Z"),"likenum":NumberInt(888),"state":"1"},
        {"_id":"3","articleid":"100001","content":"Content3","userid":"1004","nickname":"杰克船长","createdatetime":new Date("2019-08-06T01:05:06.321Z"),"likenum":NumberInt(666),"state":"1"}
    ]);
} catch (e) { 
    print (e);
}
```

## 查询文档

```shell
 db.collection.find(<query>, [projection])
```

- `query`:可选。使用查询运算符指定选择筛选器。若要返回集合中的所有文档，请省略此参数或传递空文档 ( {} )。
- `projection`:可选。指定要在与查询筛选器匹配的文档中返回的字段(投影)。若要返回匹配文档中的所有字段，请省略此参数。

### 查询所有

查询集合的所有文档

```
db.comment.find() 
// 或 
db.comment.find({})
```

### 条件查询

在find()中添加参数即可，参数也是json格式，如下:

```
db.comment.find({userid:'1003'})
```

如果你需要返回符合条件的第一条数据，可以使用findOne命令来实现，语法和find一样

```
db.comment.findOne({userid:'1003'})
```

### 投影查询

如果要查询结果返回部分字段，则需要使用投影查询(不显示所有字段，只显示指定的字段)。 

```js
db.comment.find({userid:"1003"},{userid:1,nickname:1}) 
```

- 数字1表示显示该字段，0表示不现实该字段，默认为0
- 默认 _id 会显示