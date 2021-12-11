---
title: MySQL MVVC
categories:
- Software
- Backend
- Database
- MySQL
---
# MySQL MVVC

- MVVC (Multi-Version Concurrency Control) 是一种基于多版本的并发控制协议,只有在InnoDB引擎下存在,与MVCC相对的,是基于锁的并发控制(Lock-Based Concurrency Control)
- MVCC是为了实现事务的隔离性,通过版本号,避免同一数据在不同事务间的竞争,可以把它当成基于多版本号的一种乐观锁
- MVCC的优点:读不加锁,读写不冲突,在读多写少的OLTP应用中,读写不冲突是非常重要的,极大的增加了系统的并发性能
- MVCC只在 READ COMMITTED 和 REPEATABLE READ 两个隔离级别下工作,其他两个隔离级别够和MVCC不兼容,因为 READ UNCOMMITTED 总是读取最新的数据行,而不是符合当前事务版本的数据行,而 SERIALIZABLE 则会对所有读取的行都加锁

## MVVC 实现原理

- InnoDB在每行数据都增加三个隐藏字段
    - `DB_ROW_ID`:包含一个随着新行插入而单调递增的行ID,当由innodb自动产生聚集索引时,聚集索引会包括这个行ID的值,否则这个行ID不会出现在任何索引中
    - `DB_TRX_ID`（创建版本号）:用来标识最近一次对本行记录做修改的事务ID
    - `DB_ROLL_PTR`（删除版本号）:指向写入回滚段(rollback segment)的 undo log record，如果一行记录被更新, 则 undo log record 包含该行记录被更新之前内容

### MVVC 环境下的CRUD

- **SELECT**：读取创建版本号<=当前事务版本号，删除版本号为空，或者是删除版本号大于当前事务版本号的的数据
    - InnoDB 只查找创建版本小于当前事务版本号的数据行，这样可以确保事务读取的行，要么是在事务开始前已经存在的，要么是事务自身插入或者修改过的。
    - 行的删除版本要么未定义，要么大于当前事务版本号，这可以确保事务读取到的行在事务开始之前未被删除。
- **INSERT**：保存当前事务的版本号为创建版本号。
- **UPDATE**：插入一条新的记录，保存当前的版本号为创建版本号，同时当前版本号保存为原来数据的删除版本号。
- **DELETE**：保存当前版本号为删除版本号。

**插入操作**

- 记录的创建版本号就是事务版本号
- 比如插入一条记录, 事务id 假设是1,那么记录如下:也就是说,创建版本号就是事务版本号

| id   | name    | DB_ROW_ID | DB_TRX_ID |
| ---- | ------- | --------- | --------- |
| 1    | xttblog | 1         |           |

**更新操作**

- 采用的是先标记旧的那行记录为已删除,并且删除版本号是事务版本号,然后插入一行新的记录的方式
- 比如,针对上面那行记录,事务Id为2 要把name字段更新

```sql
update table set name= 'xttblog.com' where id=1;
```

| id   | name        | DB_ROW_ID | DB_TRX_ID |
| ---- | ----------- | --------- | --------- |
| 1    | xttblog     | 1         | 2         |
| 1    | xttblog.com | 2         |           |

**删除操作**

- 把事务版本号作为删除版本号

```sql
delete from table where id=1;
```

| id   | name        | DB_ROW_ID | DB_TRX_ID |
| ---- | ----------- | --------- | --------- |
| 1    | xttblog.com | 2         | 3         |

**查询操作**

- 上面的描述可以看到,在查询时要符合以下两个条件的记录才能被事务查询出来
    - 删除版本号大于当前事务版本号,就是说删除操作是在当前事务启动之后做的
    - 创建版本号小于或者等于当前事务版本号,就是说记录创建是在事务中(等于的情况)或者事务启动之前

## 快照读和当前读

- 通过MVCC机制,虽然让数据变得可重复读,但我们读到的数据可能是历史数据,是不及时的数据,不是数据库当前的数据!这在一些对于数据的时效特别敏感的业务中,就很可能出问题
- 对于这种读取历史数据的方式,我们叫它快照读 (snapshot read),而读取数据库当前版本数据的方式,叫当前读 (current read),很显然,在MVCC中:
    - **快照读**:就是select
        - select * from table….;
    - **当前读**:特殊的读操作,插入/更新/删除操作,属于当前读,处理的都是当前的数据,需要加锁
        - `select * from table where ? lock in share mode;`
        - `select * from table where ? for update;`
        - `insert;`
        - `update ;`
        - `delete;`
- 事务的隔离级别实际上都是定义了当前读的级别,MySQL为了减少锁处理(包括等待其它锁)的时间,提升并发能力,引入了快照读的概念,使得select不用加锁,而update,insert这些"当前读”,就需要另外的模块来解决了
