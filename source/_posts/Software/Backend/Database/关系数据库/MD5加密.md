---
title: SQL MD5
categories:
- Software
- Backend
- Database
- 关系数据库
---
# SQL MD5

## MD5简介

- MD5即Message-Digest Algorithm 5(信息-摘要算法5),用于确保信息传输完整一致,是计算机广泛使用的杂凑算法之一(又译摘要算法,Hash算法),主流编程语言普遍已有MD5实现,将数据(如汉字)运算为另一固定长度值,是杂凑算法的基础原理,MD5的前身有MD2,MD3和MD4

## 实现数据加密

- 新建一个表 testmd5

```mysql
 CREATE TABLE `testmd5` (
  `id` INT(4) NOT NULL,
  `name` VARCHAR(20) NOT NULL,
  `pwd` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id`)
 ) ENGINE=INNODB DEFAULT CHARSET=utf8
```

- 插入一些数据

```mysql
 INSERT INTO testmd5 VALUES(1,'test1','123456'),(2,'test2','456789')
```

- 如果我们要对pwd这一列数据进行加密,语法是:

```mysql
 update testmd5 set pwd = md5(pwd);
```

- 如果单独对某个用户的密码加密:

```mysql
 INSERT INTO testmd5 VALUES(3,'test3','123456')
 update testmd5 set pwd = md5(pwd) where name = 'test3';
```

- 插入新的数据自动加密

```mysql
 INSERT INTO testmd5 VALUES(4,'test4',md5('123456'));
```

- 查询登录用户信息(md5对比使用,查看用户输入加密后的密码进行比对)

```mysql
 SELECT * FROM testmd5 WHERE `name`='test4' AND pwd=MD5('123456');
```