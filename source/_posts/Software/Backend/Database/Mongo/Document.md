---
title: Mongo Document
categories:
- Software
- BackEnd
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

### 分页查询

- 使用`limit()`方法来读取指定数量的数据，使用`skip()`方法来跳过指定数量的数据

```
db.COLLECTION_NAME.find().limit(NUMBER).skip(NUMBER)
```

**实例**:每页2个，第二页开始:跳过前两条数据，接着值显示3和4条数据

```
//第一页 
db.comment.find().skip(0).limit(2) 
//第二页 
db.comment.find().skip(2).limit(2) 
//第三页 
db.comment.find().skip(4).limit(2)
```

### 排序查询

`sort()`方法对数据进行排序，`sort()`方法可以通过参数指定排序的字段，并使用 1 和 -1 来指定排序的方式，其中 1 为升序排列，而 -1 是用于降序排列。

```
db.集合名称.find().sort(排序方式) 

db.COLLECTION_NAME.find().sort({KEY:1})
```

**实例**：对userid降序排列，并对访问量进行升序排列

```
db.comment.find().sort({userid:-1,likenum:1})
```

**注意**：`skip()`,`limilt()`,`sort()`执行的顺序是先`sort()`, 然后是`skip()`,最后是显示的`limit()`，和命令编写顺序无关。

### 正则查询

MongoDB的模糊查询是通过正则表达式的方式实现的。格式为:

```
db.collection.find({field:/正则表达式/})
```

**实例**：如果要查询评论的内容中以“专家”开头的，代码如下:

```
db.comment.find({content:/^专家/})
```

### 比较查询

```
db.集合名称.find({ "field" : { $gt: value }}) // 大于: field > value 
db.集合名称.find({ "field" : { $lt: value }}) // 小于: field < value 
db.集合名称.find({ "field" : { $gte: value }}) // 大于等于: field >= value 
db.集合名称.find({ "field" : { $lte: value }}) // 小于等于: field <= value 
db.集合名称.find({ "field" : { $ne: value }}) // 不等于: field != value
```

**实例**:查询评论点赞数量大于700的记录

```
db.comment.find({likenum:{$gt:NumberInt(700)}})
```

### 包含查询

包含使用$in操作符。 示例:查询评论的集合中userid字段包含1003或1004的文档

```
db.comment.find({userid:{$in:["1003","1004"]}})
```

不包含使用$nin操作符。 示例:查询评论集合中userid字段不包含1003和1004的文档

```
db.comment.find({userid:{$nin:["1003","1004"]}})
```

### 条件连接查询

如果需要查询同时满足两个以上条件，需要使用`$and`操作符将条件进行关联

```
$and:[{ },{ },{}]
```

**实例**:查询评论集合中likenum大于等于700 并且小于2000的文档

```
db.comment.find(
	{
		$and:[
			{likenum:{$gte:NumberInt(700)}},
			{likenum:{$lt:NumberInt(2000)}}
		]
	}
)
```

如果两个以上条件之间是或者的关系，我们使用`$or`操作符进行关联

```
$or:[{},{},{ }]
```

**实例**：查询评论集合中userid为1003，或者点赞数小于1000的文档记录

```
db.comment.find(
	{
		$or:[
        	{userid:"1003"},
        	{likenum:{$lt:1000}}
		]
	}
)
```

## 更新文档

```
db.collection.update(
    <query>, 
    <update>, 
    {
        upsert: <boolean>,
        multi: <boolean>,
        writeConcern: <document>,
        collation: <document>,
        arrayFilters: [ <filterdocument1>, ... ],
        hint: <document|string> // Available starting in MongoDB 4.2
	}
)
```

- **query**: 更新的选择条件。可以使用与find()方法中相同的查询选择器。在3.0版中进行了更改:当使用upsert:true执行update()时，如果查询使用点表示法在_id字段上指定条件，则MongoDB将拒绝插入新文档。
- **update**:要应用的修改。该值可以是:包含更新运算符表达式的文档，或仅包含:对的替换文档，或在MongoDB 4.2中启动聚合管道。
- **upsert**:可选参数。如果设置为true，则在没有与查询条件匹配的文档时创建新文档。默认值为false，如果找不到匹配项，则不会插入新文档。
- **multi**:可选参数。如果设置为true，则更新符合查询条件的多个文档。如果设置为false，则更新一个文档。默认值为false。
- **writeConcern**:可选参数。写入安全机制，是一种客户端设置，用于控制写入安全的级别。Write Concern 描述了MongoDB写入到mongod单实例，副本集，以及分片集群时何时应答给客户端。默认情况下，mongoDB文档增删改都会一直等待数据库响应(确认写入是否成功)，然后才会继续执行
- **collation**:可选参数。 指定要用于操作的校对规则。 校对规则允许用户为字符串比较指定特定于语言的规则， 如果未指定校对规则，但集合具有默认校对规则(请参见db.createCollection())，则该操作将使用为集合指定的校对规则。 如果没有为集合或操作指定校对规则，MongoDB将使用以前版本中使用的简单二进制比较进行字符串比较。不能为一个操作指定多个校对规则。例如，不能为每个字段指定不同的校对规则，或者如果使用排序执行查找，则不能将一个校对规则用于查找，另一个校对规则用于排序。
- arrayFilters：可选参数。一个筛选文档数组，用于确定要为数组字段上的更新操作修改哪些数组元素。
- hint：可选参数。指定用于支持查询谓词的索引的文档或字符串。该选项可以采用索引规范文档或索引名称字符串。如果指定的索引不存在，则说明操作错误。

### 覆盖修改

```
 db.comment.update({_id:"1"},{likenum:NumberInt(1001)})
```

- 执行后，这条文档除了likenum字段其它字段的值都被删除

### 局部修改

```
 db.comment.update({_id:"2"},{$set:{likenum:NumberInt(889)}})
```

- 执行后，只会修改`likenum`字段的值

### 批量修改

```
//默认只修改第一条数据 
db.comment.update({userid:"1003"},{$set:{nickname:"Jack"}}) 
//修改所有符合条件的数据 
db.comment.update({userid:"1003"},{$set:{nickname:"Jack"}},{multi:true})
```

### 列值增长的修改

如果我们想实现对某列值在原有值的基础上进行增加或减少，可以使用 $inc 运算符来实现

```
db.comment.update({_id:"3"},{$inc:{likenum:NumberInt(1)}})
```

## 删除文档

```
db.集合名称.remove(条件)
```

### 删除所有文档

```
db.comment.remove({})
```

### 根据条件删除文档

```
db.comment.remove({_id:"1"})
```

## 计数文档

```
db.collection.count(query, options)
```

- `query`:查询选择条件
- `options`:可选。用于修改计数的额外选项。

### 统计所有记录数

```
db.comment.count()
```

### 按条件统计记录数

```
db.comment.count({userid:"1003"})
```

