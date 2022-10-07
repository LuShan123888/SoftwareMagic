---
title: Mongo Collection
categories:
- Software
- BackEnd
- Database
- Mongo
---
# Mongo Collection

集合，类似关系型数据库中的表。可以显示的创建，也可以隐式的创建。

## 创建集合

```shell
$ db.createCollection(name)
```

- `name`:集合名称

集合的命名规范

- 集合名不能是空字符串""
- 集合名不能含有\0字符(空字符)，这个字符表示集合名的结尾
- 集合名不能以"system."开头，这是为系统集合保留的前缀。 
- 用户创建的集合名字不能含有保留字符。有些驱动程序的确支持在集合名里面包含，这是因为某些系统生成的集合中包含该字符。除非你要访问这种系统创建的集合，否则千万不要在名字里出现$

**注意**

- 当向一个集合中插入一个文档的时候，如果集合不存在，则会自动创建集合
- 集合只有在内容插入后才会创建，即创建集合后要再插入一个文档，集合才会真正创建

## 集合的隐式创建

## 查看集合

查看当前库中的集合

```shell
$ show collections
# 或
$ show tables
```

## 删除集合

```shell
$ db.collection.drop()
```

- **返回值**: 如果成功删除选定集合，则 drop() 方法返回 true，否则返回 false