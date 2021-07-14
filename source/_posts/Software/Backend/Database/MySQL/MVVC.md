---
title: MySQL MVVC
categories:
- Software
- Backend
- Database
- MySQL
---
# MySQL MVVC

- MVVC (Multi-Version Concurrency Control) 是一种基于多版本的并发控制协议,只有在InnoDB引擎下存在,与MVCC相对的,是基于锁的并发控制(Lock-Based Concurrency Control
- MVCC是为了实现事务的隔离性,通过版本号,避免同一数据在不同事务间的竞争,可以把它当成基于多版本号的一种乐观锁
- MVCC的优点:读不加锁,读写不冲突,在读多写少的OLTP应用中,读写不冲突是非常重要的,极大的增加了系统的并发性能
- MVCC只在 READ COMMITTED 和 REPEATABLE READ 两个隔离级别下工作,其他两个隔离级别够和MVCC不兼容,因为 READ UNCOMMITTED 总是读取最新的数据行,而不是符合当前事务版本的数据行,而 SERIALIZABLE 则会对所有读取的行都加锁

## MVVC 实现原理

- InnoDB在每行数据都增加三个隐藏字段
    - `事务ID(DB_TRX_ID)`:用来标识最近一次对本行记录做修改(insert|update)的事务的标识符,即最后一次修改(insert|update)本行记录的事务id,至于delete操作,在innodb看来也不过是一次update操作,更新行中的一个特殊位将行表示为deleted,并非真正删除
    - `DB_ROW_ID`:包含一个随着新行插入而单调递增的行ID,当由innodb自动产生聚集索引时,聚集索引会包括这个行ID的值,否则这个行ID不会出现在任何索引中
    - `回滚指针(DB_ROLL_PTR)`:指写入回滚段(rollback segment)的 undo log record (撤销日志记录记录),如果一行记录被更新, 则 undo log record 包含 ‘重建该行记录被更新之前内容’ 所必须的信息

### MVVC环境下的CRUD

- **SELECT**:读取创建版本小于或等于当前事务版本号,并且删除版本为空或大于当前事务版本号的记录,这样可以保证在读取之前记录是存在的
- **INSERT**:将当前事务的版本号保存至行的创建版本号
- **UPDATE**:新插入一行,并以当前事务的版本号作为新行的创建版本号,同时将原记录行的删除版本号设置为当前事务版本号
- **DELETE**:将当前事务的版本号保存至行的删除版本号

**插入操作**

- 记录的创建版本号就是事务版本号
- 比如我插入一条记录, 事务id 假设是1,那么记录如下:也就是说,创建版本号就是事务版本号

| id   | name    | DB_ROW_ID | DB_ROLL_PTR |
| ---- | ------- | --------- | ----------- |
| 1    | xttblog | 1         |             |

**更新操作**

- 采用的是先标记旧的那行记录为已删除,并且删除版本号是事务版本号,然后插入一行新的记录的方式
- 比如,针对上面那行记录,事务Id为2 要把name字段更新

```sql
update table set name= 'new_value' where id=1;
```

| id   | name        | DB_ROW_ID | DB_ROLL_PTR |
| ---- | ----------- | --------- | ----------- |
| 1    | xttblog     | 1         | 2           |
| 1    | xttblog.com | 2         |             |

**删除操作**

- 把事务版本号作为删除版本号

```sql
delete from table where id=1;
```

| id   | name        | DB_ROW_ID | DB_ROLL_PTR |
| ---- | ----------- | --------- | ----------- |
| 1    | xttblog.com | 2         | 3           |

**查询操作**

- 上面的描述可以看到,在查询时要符合以下两个条件的记录才能被事务查询出来
    - 删除版本号大于当前事务版本号,就是说删除操作是在当前事务启动之后做的
    - 创建版本号小于或者等于当前事务版本号,就是说记录创建是在事务中(等于的情况)或者事务启动之前

## 快照读和当前读

- **快照读**:读取的是快照版本,也就是历史版本
- **当前读**:读取的是最新版本
- 普通的SELECT就是快照读,而UPDATE,DELETE,INSERT,SELECT…LOCK IN SHARE MODE,SELECT…FOR UPDATE是当前读

## 锁定读

- 在一个事务中,标准的SELECT语句是不会加锁,但是有两种情况例外

1. 给记录假设共享锁,这样一来的话,其它事务只能读不能修改,直到当前事务提交

```sql
SELECT ... LOCK IN SHARE MODE
```

2. 给索引记录加锁,这种情况下跟UPDATE的加锁情况是一样的

```sql
SELECT ... FOR UPDATE
```

## 一致性非锁定读

- Consistent Read(一致性读),InnoDB用多版本来提供查询数据库在某个时间点的快照
    - 如果隔离级别是REPEATABLE READ,那么在同一个事务中的所有一致性读都读的是事务中第一个这样的读而读到的快照
    - 如果是READ COMMITTED,那么一个事务中的每一个一致性读都会读到它自己刷新的快照版本
- Consistent read(一致性读)是READ COMMITTED和REPEATABLE READ隔离级别下普通SELECT语句默认的模式,一致性读不会给它所访问的表加任何形式的锁,因此其它事务可以同时并发的修改它们
