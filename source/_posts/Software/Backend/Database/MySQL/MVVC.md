---
title: MySQL MVVC
categories:
- Software
- BackEnd
- Database
- MySQL
---
# MySQL MVVC

- MVVC (Multi-Version Concurrency Control) 是一种基于多版本的并发控制协议，只有在 InnoDB 引擎下存在，与 MVCC 相对的，是基于锁的并发控制 (Lock-Based Concurrency Control)
- MVCC 是为了实现事务的隔离性，通过版本号，避免同一数据在不同事务间的竞争，可以把它当成基于多版本号的一种乐观锁。
- MVCC 的优点：读不加锁，读写不冲突，在读多写少的 OLTP 应用中，读写不冲突是非常重要的，极大的增加了系统的并发性能。
- MVCC 只在 READ COMMITTED 和 REPEATABLE READ 两个隔离级别下工作，其他两个隔离级别够和 MVCC 不兼容，因为 READ UNCOMMITTED 总是读取最新的数据行，而不是符合当前事务版本的数据行，而 SERIALIZABLE 则会对所有读取的行都加锁。

## MVVC 实现原理

- InnoDB 在每行数据都增加三个隐藏字段。
    - `DB_ROW_ID`：包含一个随着新行插入而单调递增的行 ID，当由 innodb 自动产生聚集索引时，聚集索引会包括这个行 ID 的值，否则这个行 ID 不会出现在任何索引中。
    - `DB_TRX_ID` (创建版本号)：用来标识最近一次对本行记录做修改的事务 ID
    - `DB_ROLL_PTR` (删除版本号)：指向写入回滚段 (rollback segment) 的 undo log record，如果一行记录被更新，则 undo log record 包含该行记录被更新之前内容。

### MVVC 环境下的 CRUD

- **SELECT**：读取创建版本号<=当前事务版本号，删除版本号为空，或者是删除版本号大于当前事务版本号的的数据。
    - InnoDB 只查找创建版本小于当前事务版本号的数据行，这样可以确保事务读取的行，要么是在事务开始前已经存在的，要么是事务自身插入或者修改过的。
    - 行的删除版本要么未定义，要么大于当前事务版本号，这可以确保事务读取到的行在事务开始之前未被删除。
- **INSERT**：保存当前事务的版本号为创建版本号。
- **UPDATE**：插入一条新的记录，保存当前的版本号为创建版本号，同时当前版本号保存为原来数据的删除版本号。
- **DELETE**：保存当前版本号为删除版本号。

**插入操作**

- 记录的创建版本号就是事务版本号。
- 比如插入一条记录，事务 id 假设是 1，那么记录如下：也就是说，创建版本号就是事务版本号。

| id   | name    | DB_ROW_ID | DB_TRX_ID |
| ---- | ------- | --------- | --------- |
| 1    | xttblog | 1         |           |

**更新操作**

- 采用的是先标记旧的那行记录为已删除，并且删除版本号是事务版本号，然后插入一行新的记录的方式。
- 比如，针对上面那行记录，事务 Id 为 2 要把 name 字段更新。

```sql
update table set name= 'xttblog.com' where id=1;
```

| id   | name        | DB_ROW_ID | DB_TRX_ID |
| ---- | ----------- | --------- | --------- |
| 1    | xttblog     | 1         | 2         |
| 1    | xttblog. com | 2         |           |

**删除操作**

- 把事务版本号作为删除版本号。

```sql
delete from table where id=1;
```

| id   | name        | DB_ROW_ID | DB_TRX_ID |
| ---- | ----------- | --------- | --------- |
| 1    | xttblog. com | 2         | 3         |

**查询操作**

- 上面的描述可以看到，在查询时要符合以下两个条件的记录才能被事务查询出来。
    - 删除版本号大于当前事务版本号，就是说删除操作是在当前事务启动之后做的。
    - 创建版本号小于或者等于当前事务版本号，就是说记录创建是在事务中（等于的情况）或者事务启动之前。

## 快照读和当前读

- 通过 MVCC 机制，虽然让数据变得可重复读，但我们读到的数据可能是历史数据，是不及时的数据，不是数据库当前的数据! 这在一些对于数据的时效特别敏感的业务中，就很可能出问题。
- 对于这种读取历史数据的方式，我们叫它快照读 (snapshot read)，而读取数据库当前版本数据的方式，叫当前读 (current read)，很显然，在 MVCC 中：
    - **快照读**: `select * from table….;`
    - **当前读**：特殊的读操作，插入/更新/删除操作，属于当前读，处理的都是当前的数据，需要加锁。
        - `select * from table where ? lock in share mode;`
        - `select * from table where ? for update;`
        - `insert;`
        - `update ;`
        - `delete;`
- 事务的隔离级别实际上都是定义了当前读的级别， MySQL 为了减少锁处理（包括等待其它锁）的时间，提升并发能力，引入了快照读的概念，使得 select 不用加锁，而 update, insert 这些"当前读”，就需要另外的模块来解决了。

## 快照

- InnoDB 里面每个事务都有一个唯一的事务 ID，叫作 transaction id。它在事务开始的时候向 InnoDB 的事务系统申请的，是按申请顺序严格递增的。
- 每条记录在更新的时候都会同时记录一条 undo log，这条 log 就会记录上当前事务的 transaction id，记为 row trx_id。记录上的最新值，通过回滚操作，都可以得到前一个状态的值。
- 如下图所示，一行记录被多个事务更新之后，最新值为 k=22。假设事务 A 在 trx_id=15 这个事务**提交后启动**，事务 A 要读取该行时，就通过 undo log，计算出该事务启动瞬间该行的值为 k=10。

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/1728240151ddf24a~tplv-t2oaga2asx-zoom-in-crop-mark:4536:0:0:0.awebp" alt="img" style="zoom:50%;" />

- 在可重复读隔离级别下，一个事务在启动时，InnoDB 会为事务构造一个数组，用来保存这个事务启动瞬间，当前正在”活跃“的所有事务 ID。”活跃“指的是，启动了但还没提交。
- 数组里面事务 ID 为最小值记为低水位，当前系统里面已经创建过的事务 ID 的最大值加 1 记为高水位。
- 这个视图数组和高水位，就组成了当前事务的一致性视图（read-view）。
- 这个视图数组把所有的 row trx_id 分成了几种不同的情况。

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/17282401527b303b~tplv-t2oaga2asx-zoom-in-crop-mark:4536:0:0:0.awebp" alt="img" style="zoom:50%;" />

1. 如果 trx_id 小于低水位，表示这个版本在事务启动前已经提交，可见；
2. 如果 trx_id 大于高水为，表示这个版本在事务启动后生成，不可见；
3. 如果 trx_id 大于低水位，小于高水位，分为两种情况：
   1. 若 trx_id 在数组中，表示这个版本在事务启动时还未提交，不可见；
   2. 若 trx_id 不在数组中，表示这个版本在事务启动时已经提交，可见。

- **InnoDB 就是利用 undo log 和 trx_id 的配合，实现了事务启动瞬间”秒级创建快照“的能力。**

## 示例

```sql
CREATE TABLE `t` (
  `id` int(11) NOT NULL,
  `k` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;
insert into t(id, k) values(1,1),(2,2);
```

- 下表为事务 A, B, C 的执行流程。

| 事务 A                                       | 事务 B                                       | 事务 C                          |
| ------------------------------------------- | ------------------------------------------- | ------------------------------ |
| START TRANSACTION WITH CONSISTENT SNAPSHOT; |                                             |                                |
|                                             | START TRANSACTION WITH CONSISTENT SNAPSHOT; |                                |
|                                             |                                             | UPDATE t SET k=k+1 WHERE id=1; |
|                                             | UPDATE t SET k=k+1 WHERE id=1;              |                                |
|                                             | SELECT k FROM t WHERE id=1;                 |                                |
| SELECT k FROM t WHERE id=1;                 |                                             |                                |
| COMMIT;                                     |                                             |                                |
|                                             | COMMIT;                                     |                                |

- 我们假设事务 A, B, C 的 trx_id 分别为 100, 101, 102。事务 A 开始前活跃的事务 ID 只有 99，并且 id=1 这一行数据的 trx_id=90。
- 根据假设，我们得出事务启动瞬间的视图数组：事务 A：[99, 100]，事务 B：[99, 100, 101]，事务 C：[99, 100, 101, 102]。

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/1728240162340a11~tplv-t2oaga2asx-zoom-in-crop-mark:4536:0:0:0.awebp" alt="img" style="zoom:50%;" />

1. 事务 C 通过更新语句，把 k 更新为 2，此时 trx_id=102；
2. 事务 B 通过更新语句，把 k 更新为 3，此时 trx_id=101；
3. 事务 B 通过查询语句，查询到最新一条记录为 3，trx_id=101，满足隔离条件，返回 k=3；
4. 事务 A 通过查询语句：
   1. 查询到最新一条记录为 3，trx_id=101，比高水位大，不可见；
   2. 通过 undo log，找到上一个历史版本，trx_id=102，比高水位大，不可见；
   3. 继续找上一个历史版本，trx_id=90，比低水位小，可见。

### 提出问题：为啥事务 B 更新的时候能看到事务 C 的修改？

- 我们假设事务 B 在更新的看不到事务 C 的修改，是什么个情况？
  1. 事务 B 查询到最新一条记录为 2，trx_id=102，比高水位大，不可见；
  2. 通过 undo log，找到上一个版本，trx_id=90，比低水位小，可见；
  3. 返回记录 k=1，执行 k=k+1，把 k 更新为 2，此时 trx_id=101。
- 如果是这种情况。事务 B 覆盖了事务 C 的更新。所以，InnoDB 在更新时运用一条规则：**更新数据都是先读后写的，而这个读，只能读当前的值，称为“当前读“ （current read）。**
- 因此，事务 B 在更新时要拿到最新的数据，在此基础上做更新。紧接着，事务 B 在读取的时候，查询到最新的记录为 3， trx_id=101 为当前事务 ID，可见。
- 我们再假设另一种情况：事务 B 在更新之后，事务 C 紧接着更新，事务 B 回滚了，事务 C 成功提交。

| 事务 B                                       | 事务 C                                       |
| ------------------------------------------- | ------------------------------------------- |
| START TRANSACTION WITH CONSISTENT SNAPSHOT; |                                             |
|                                             | START TRANSACTION WITH CONSISTENT SNAPSHOT; |
| UPDATE t SET k=k+1 WHERE id=1;              |                                             |
|                                             | UPDATE t SET k=k+1 WHERE id=1;              |
|                                             | SELECT k FROM t WHERE id=1;                 |
| ROLLBACK;                                   |                                             |
|                                             | COMMIT;                                     |

- 如果按照当前读的定义，会发生以下事故，假设当前 K=1：
  1. 事务 B 把 k 更新为 2；
  2. 事务 C 读取到当前最新值，k=2，更新为 3；
  3. 事务 B 回滚；
  4. 事务 C 提交。
- 这时候，事务 C 发现自己想要执行的是 +1 操作，结果变成了 ”+2“ 操作。InnoDB 肯定不允许这种情况的发生，事务 B 在执行更新语句时，会给该行加上行锁，直到事务 B 结束，才会释放这个锁。

![img](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/1728240153bb5d4e~tplv-t2oaga2asx-zoom-in-crop-mark:4536:0:0:0.awebp)

## 小结

1. InnoDB 的行数据有多个版本，每个版本都有 row trx_id。
2. 事务根据 undo log 和 trx_id 构建出满足当前隔离级别的一致性视图。
3. 可重复读的核心是一致性读，而事务更新数据的时候，只能使用当前读，如果当前记录的行锁被其他事务占用，就需要进入锁等待。
