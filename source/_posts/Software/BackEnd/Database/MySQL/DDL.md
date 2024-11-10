---
title: DDL
categories:
- Software
- BackEnd
- Database
- MySQL
---
# DDL

在MySQL使用过程中，根据业务的需求对表结构进行变更是个普遍的运维操作，这些称为DDL操作。常见的DDL操作有在表上增加新列或给某个列添加索引。通常有两种方式可执行DDL，包括MySQL原生在线DDL（online DDL）以及一种第三方工具pt-osc。下图是执行方式的性能对比及说明。

| 指标     | online DDL | pt-osc |
| ------ | ---------- | ------ |
| 锁表风险   | 较低         | 极低     |
| 执行时间   | 较长         | 长      |
| 主从延迟   | 较大         | 小      |
| 需外额外空间 | 中          | 大      |
| IO负载   | 中          | 大      |

## Online DDL

### 介绍

MySQL Online DDL 功能从 5.6 版本开始正式引入，发展到现在的 8.0 版本，经历了多次的调整和完善。其实早在 MySQL 5.5 版本中就加入了 INPLACE DDL 方式，但是因为实现的问题，依然会阻塞 INSERT、UPDATE、DELETE 操作，这也是 MySQL 早期版本长期被吐槽的原因之一。

在MySQL 5.6版本以前，最昂贵的数据库操作之一就是执行DDL语句，特别是ALTER语句，因为在修改表时，MySQL会阻塞整个表的读写操作。例如，对表 A 进行 DDL 的具体过程如下：

1. 按照表 A 的定义新建一个表 B
2. 对表 A 加写锁。
3. 在表 B 上执行 DDL 指定的操作。
4. 将 A 中的数据拷贝到 B
5. 释放 A 的写锁。
6. 删除表 A
7. 将表 B 重命名为 A

在以上 2-4 的过程中，如果表 A 数据量比较大，拷贝到表 B 的过程会 s消耗大量时间，并占用额外的存储空间。此外，由于 DDL 操作占用了表 A 的写锁，所以表 A 上的 DDL 和 DML 都将阻塞无法提供服务。

如果遇到巨大的表，可能需要几个小时才能执行完成，势必会影响应用程序，因此需要对这些操作进行良好的规划，以避免在高峰时段执行这些更改。对于那些要提供全天候服务（24*7）或维护时间有限的人来说，在大表上执行DDL无疑是一场真正的噩梦。

因此，MySQL官方不断对DDL语句进行增强，自MySQL 5.6 起，开始支持更多的 ALTER TABLE 类型操作来避免数据拷贝，同时支持了在线上 DDL 的过程中不阻塞 DML 操作，真正意义上的实现了 Online DDL，即在执行 DDL 期间允许在不中断数据库服务的情况下执行DML(insert、update、delete)。然而并不是所有的DDL操作都支持在线操作。到了 MySQL 5.7，在 5.6 的基础上又增加了一些新的特性，比如：增加了重命名索引支持，支持了数值类型长度的增大和减小，支持了 VARCHAR 类型的在线增大等。但是基本的实现逻辑和限制条件相比 5.6 并没有大的变化。

### 用法

```sql
ALTER TABLE tbl_name ADD PRIMARY KEY (column), ALGORITHM=INPLACE, LOCK=NONE;
```



ALTER 语句中可以指定参数 ALGORITHM 和 LOCK 分别指定 DDL 执行的算法模式和 DDL 期间 DML 的锁控制模式。

- ALGORITHM =INPLACE 表示执行DDL的过程中不发生表拷贝，过程中允许并发执行DML（INPLACE不需要像COPY一样占用大量的磁盘I/O和CPU，减少了数据库负载。同时减少了buffer pool的使用，避免 buffer pool 中原有的查询缓存被大量删除而导致的性能问题）。
- 如果设置 ALGORITHM=COPY，DDL 就会按 MySQL 5.6 之前的方式，采用表拷贝的方式进行，过程中会阻塞所有的DML。另外也可以设置 ALGORITHEM=DAFAULT，让 MySQL 以尽量保证 DML 并发操作的原则选择执行方式。
- LOCK=NONE 表示对 DML 操作不加锁，DDL 过程中允许所有的 DML 操作。此外还有 EXCLUSIVE（持有排它锁，阻塞所有的请求，适用于需要尽快完成DDL或者服务库空闲的场景）、SHARED（允许SELECT，但是阻塞INSERT UPDATE DELETE，适用于数据仓库等可以允许数据写入延迟的场景）和 DEFAULT（根据DDL的类型，在保证最大并发的原则下来选择LOCK的取值）。

### 两种算法

#### Copy

1. 按照原表定义创建一个新的临时表；
2. 对原表加写锁（禁止DML，允许select）；
3. 在步骤1 建立的临时表执行 DDL；
4. 将原表中的数据 copy 到临时表；
5. 释放原表的写锁；
6. 将原表删除，并将临时表重命名为原表。
7. 从上可见，采用 copy 方式期间需要锁表，禁止DML，因此是非Online的。比如：删除主键、修改列类型、修改字符集，这些操作会导致行记录格式发生变化（无法通过全量 + 增量实现 Online）。

#### Inplace

在原表上进行更改，不需要生成临时表，不需要进行数据copy的过程。根据是否行记录格式，又可分为两类：

- rebuild：需要重建表（重新组织聚簇索引）。比如 optimize table、添加索引、添加/删除列、修改列 NULL/NOT NULL 属性等；
- no-rebuild：不需要重建表，只需要修改表的元数据，比如删除索引、修改列名、修改列默认值、修改列自增值等。

对于 rebuild 方式实现 Online 是通过缓存 DDL 期间的 DML，待 DDL 完成之后，将 DML 应用到表上来实现的。例如，执行一个 alter table A engine=InnoDB; 重建表的 DDL 其大致流程如下：

1. 建立一个临时文件，扫描表 A 主键的所有数据页；
2. 用数据页中表 A 的记录生成 B+ 树，存储到临时文件中；
3. 生成临时文件的过程中，将所有对 A 的操作记录在一个日志文件（row log）中；
4. 临时文件生成后，将日志文件中的操作应用到临时文件，得到一个逻辑数据上与表 A 相同的数据文件；
5. 用临时文件替换表 A 的数据文件。

说明：

1. 在 copy 数据到新表期间，在原表上是加的 MDL 读锁（允许 DML，禁止 DDL）；
2. 在应用增量期间对原表加 MDL 写锁（禁止 DML 和 DDL）；
3. 根据表 A 重建出来的数据是放在 tmp_file 里的，这个临时文件是 InnoDB 在内部创建出来的，整个 DDL 过程都在 InnoDB 内部完成。对于 server 层来说，没有把数据挪动到临时表，是一个原地操作，这就是”inplace”名称的来源。

#### 总结

-   使用Inplace方式执行的DDL，发生错误或被kill时，需要一定时间的回滚期，执行时间越长，回滚时间越长。
-   使用Copy方式执行的DDL，需要记录过程中的undo和redo日志，同时会消耗buffer pool的资源，效率较低，优点是可以快速停止。
-   不过并不是所有的 DDL 操作都能用 INPLACE 的方式执行，具体的支持情况可以在（在线 DDL 操作）中查看。
-   以下是常见DDL操作：

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/293bb4d1326a4e09a0d8e873a0023388~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp" style="zoom:50%;" />

-   官网支持列表：

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/a44c6f034af7431091af0e8c9dd09588~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp" style="zoom:50%;" />

### 执行过程

Online DDL主要包括3个阶段，prepare阶段，ddl执行阶段，commit阶段。下面将主要介绍ddl执行过程中三个阶段的流程。

1.   Prepare阶段：初始化阶段会根据存储引擎、用户指定的操作、用户指定的 ALGORITHM 和 LOCK 计算 DDL 过程中允许的并发量，这个过程中会获取一个 shared metadata lock，用来保护表的结构定义。
     - 创建新的临时frm文件（与InnoDB无关）。
     - 持有EXCLUSIVE-MDL锁，禁止读写。
     - 根据alter类型，确定执行方式（copy,online-rebuild,online-norebuild)。假如是Add Index，则选择online-norebuild即INPLACE方式。
     - 更新数据字典的内存对象。
     - 分配row_log对象来记录增量（仅rebuild类型需要）。
     - 生成新的临时ibd文件（仅rebuild类型需要） 。
     - 数据字典上提交事务、释放锁。

注：Row log是一种独占结构，它不是redo log。它以Block的方式管理DML记录的存放，一个Block的大小为由参数innodb_sort_buffer_size控制，默认大小为1M，初始化阶段会申请两个Block。

2.   DDL执行阶段：执行期间的 shared metadata lock 保证了不会同时执行其他的 DDL，但 DML 能可以正常执行。
     -   降级EXCLUSIVE-MDL锁，允许读写（copy不可写）。
     -   扫描old_table的聚集索引每一条记录rec。
     -   遍历新表的聚集索引和二级索引，逐一处理。
     -   根据rec构造对应的索引项。
     -   将构造索引项插入sort_buffer块排序。
     -   将sort_buffer块更新到新的索引上。
     -   记录ddl执行过程中产生的增量（仅rebuild类型需要）
     -   重放row_log中的操作到新索引上（no-rebuild数据是在原表上更新的）。
     -   重放row_log间产生dml操作append到row_log最后一个Block。

3.   Commit阶段：将 shared metadata lock 升级为 exclusive metadata lock，禁止DML，然后删除旧的表定义，提交新的表定义。
     -   当前Block为row_log最后一个时，禁止读写，升级到EXCLUSIVE-MDL锁。
     -   重做row_log中最后一部分增量。
     -   更新innodb的数据字典表。
     -   提交事务（刷事务的redo日志）。
     -   修改统计信息。
     -   rename临时idb文件，frm文件。
     -   变更完成。

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/27191c96c5b4403fbbaa3577a9458593~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp)

Online DDL 过程中占用 exclusive MDL 的步骤执行很快，所以几乎不会阻塞 DML 语句。  不过，在 DDL 执行前或执行时，其他事务可以获取 MDL。由于需要用到 exclusive MDL，所以必须要等到其他占有 metadata lock 的事务提交或回滚后才能执行上面两个涉及到 MDL 的地方。

### 踩坑

前面提到 Online DDL 执行过程中需要获取 MDL，MDL (metadata lock）是 MySQL 5.5 引入的表级锁，在访问一个表的时候会被自动加上，以保证读写的正确性。当对一个表做 DML 操作的时候，加 MDL 读锁；当做 DDL 操作时候，加 MDL 写锁。

为了在大表执行 DDL 的过程中同时保证 DML 能并发执行，前面使用了 ALGORITHM=INPLACE 的 Online DDL，但这里仍然存在死锁的风险，问题就出在 Online DDL 过程中需要 exclusive MDL 的地方。

例如，Session 1 在事务中执行 SELECT 操作，此时会获取 shared MDL。由于是在事务中执行，所以这个 shared MDL 只有在事务结束后才会被释放。

```shell
# Session 1
> START TRANSACTION;
> SELECT * FROM tbl_name; # 正常执行。
```

这时 Session 2 想要执行 DML 操作也只需要获取 shared MDL，仍然可以正常执行。

```shell
# Session 2
> SELECT * FROM tbl_name; # 正常执行。
```

但如果 Session 3 想执行 DDL 操作就会阻塞，因为此时 Session 1 已经占用了 shared MDL，而 DDL 的执行需要先获取 exclusive MDL，因此无法正常执行。

```shell
# Session 3
> ALTER TABLE tbl_name ADD COLUMN n INT; # 阻塞。
```

通过 show processlist 可以看到 ALTER 操作正在等待 MDL。

```shell
+----+-----------------+------------------+------+---------+------+---------------------------------+-----------------+
| Id | User            | Host             | db   | Command | Time | State                           | Info            |│----+-----------------+------------------+------+---------+------+---------------------------------+-----------------+
| 11 | root            | 172.17.0.1:53048 | demo | Query   |    3 | Waiting for table metadata lock | alter table ... |+----+-----------------+------------------+------+---------+------+---------------------------------+-----------------+
```

由于 exclusive MDL 的获取优先于 shared MDL，后续尝试获取 shared MDL 的操作也将会全部阻塞。

```shell
# Session 4
> SELECT * FROM tbl_name; # 阻塞。
```

到这一步，后续无论是 DML 和 DDL 都将阻塞，直到 Session 1 提交或者回滚，Session 1 占用的 shared MDL 被释放，后面的操作才能继续执行。

上面这个问题主要有两个原因：

1. Session 1 中的事务没有及时提交，因此阻塞了 Session 3 的 DDL
2. Session 3 Online DDL 阻塞了后续的 DML 和 DDL

对于问题 1，有些ORM框架默认将用户语句封装成事务执行，如果客户端程序中断退出，还没来得及提交或者回滚事务，就会出现 Session 1 中的情况。那么此时可以在 infomation_schema.innodb_trx 中找出未完成的事务对应的线程，并强制退出。

```shell
> SELECT * FROM information_schema.innodb_trx\G*************************** 1. row ***************************trx_id: 421564480355704trx_state: RUNNINGtrx_started: 2022-05-01 014:49:41trx_requested_lock_id: NULLtrx_wait_started: NULLtrx_weight: 0trx_mysql_thread_id: 9trx_query: NULLtrx_operation_state: NULLtrx_tables_in_use: 0trx_tables_locked: 0trx_lock_structs: 0trx_lock_memory_bytes: 1136trx_rows_locked: 0trx_rows_modified: 0trx_concurrency_tickets: 0trx_isolation_level: REPEATABLE READtrx_unique_checks: 1trx_foreign_key_checks: 1trx_last_foreign_key_error: NULLtrx_adaptive_hash_latched: 0trx_adaptive_hash_timeout: 0trx_is_read_only: 0trx_autocommit_non_locking: 0trx_schedule_weight: NULL1 row in set (0.0025 sec)
```

可以看到 Session 1 正在执行的事务对应的 trx_mysql_thread_id 为 9，然后执行 KILL 9 即可中断 Session 1 中的事务。  对于问题 2，在查询很多的情况下，会导致阻塞的 session 迅速增多，对于这种情况，可以先中断 DDL 操作，防止对服务造成过大的影响。也可以尝试在从库上修改表结构后进行主从切换或者使用 pt-osc 等第三方工具。

### 限制

- 仅适用于InnoDB（语法上它可以与其他存储引擎一起使用，如MyISAM，但MyISAM只允许algorithm = copy，与传统方法相同）；
- 无论使用何种锁（NONE，共享或排它），在开始和结束时都需要一个短暂的时间来锁表（排它锁）；
- 在添加/删除外键时，应该禁用 foreign_key_checks 以避免表复制；
- 仍然有一些 alter 操作需要 copy 或 lock 表（老方法），有关哪些表更改需要表复制或表锁定，请查看官网；
- 如果在表上有 ON … CASCADE 或 ON … SET NULL 约束，则在 alter table 语句中不允许LOCK = NONE；
- Online DDL会被复制到从库（同主库一样，如果 LOCK = NONE，从库也不会加锁），但复制本身将被阻止，因为 alter 在从库以单线程执行，这将导致主从延迟问题。

## PT-OSC

**pt-online-schema-change** - ALTER tables without locking them.

**pt-online-schema-change** alters a table’s structure without blocking reads or writes. Specify the database and table in the DSN. Do not use this tool before reading its documentation and checking your backups carefully.

**pt-online-schema-change**是Percona公司开发的一个非常好用的DDL工具，称为 pt-online-schema-change，是Percona-Toolkit工具集中的一个组件，很多DBA在使用Percona-Toolkit时第一个使用的工具就是它，同时也是使用最频繁的一个工具。它可以做到在修改表结构的同时（即进行DDL操作）不阻塞数据库表DML的进行，这样降低了对生产环境数据库的影响。在MySQL5.6之前是不支持Online DDL特性的，即使在添加二级索引的时候有FIC特性，但是在修改表字段的时候还是会有锁表并阻止表的DML操作，这样对于DBA来说是非常痛苦的，好在有pt-online-schema-change工具在没有Online DDL时解决了这一问题。

Percona 公司是成立于2006年，总部在美国北卡罗来纳的Raleigh。由 Peter Zaitsev 和 Vadim Tkachenko创立， **这家公司声称他们提供的软件都是免费的，他们的收入主要来与开源社区，企业的支持，以及使用他们软件的公司的支付他们提供support的费用。** 而实际上这家公司"垄断"了业内最流行数据库支持类的软件，并且还开发了一些其他的与数据库相关的东西。

Percona-Toolkit工具集是Percona支持数据库人员用来执行各种MySQL、MongoDB和系统任务的高级命令行工具的集合，这些任务太难或太复杂而无法手动执行。这些工具是私有或“一次性”脚本的理想替代品，因为它们是经过专业开发、正式测试和完整记录的。它们也是完全独立的，因此安装快速简便，无需安装任何库。

Percona Toolkit 源自 Maatkit 和 Aspersa，这两个最著名的 MySQL 服务器管理工​具包。它由 Percona 开发和支持。

### 工作流程

pt-osc 用于修改表时不锁表，简单地说，这个工具创建一个与原始表一样的新的空表，并根据需要更改表结构，然后将原始表中的数据以小块形式复制到新表中，然后删除原始表，然后将新表重命名为原始名称。在复制过程中，对原始表的所有新的更改（insert，delete，update）都将应用于新表，因为在原始表上创建了一个触发器，以确保所有新的更改都将应用于新表。有关 pt-online-schema-change 工具的更多信息，请查阅手册文档 。

**pt-osc大致的工作过程如下**：

1.   创建一个和要执行 alter 操作的表一样的新的空表结构（是alter之前的结构）；
2.   在新表执行alter table 语句（速度应该很快）；
3.   在原表中创建触发器3个触发器分别对应insert,update,delete操作，如果表中已经定义了触发器这个工具就不能工作了；
4.   以一定块大小从原表拷贝数据到临时表，拷贝过程中通过原表上的触发器在原表进行的写操作都会更新到新建的临时表，保证数据不会丢失（会限制每次拷贝数据的行数以保证拷贝不会过多消耗服务器资源，采用 LOCK IN SHARE MODE 来获取要拷贝数据段的最新数据并对数据加共享锁阻止其他会话修改数据，不过每次加S锁的行数不多，很快就会被释放）；
5.   将原表Rename为old表，再把新表Rename为原表（整个过程只在rename表的时间会锁一下表，其他时候不锁表）；
6.   如果有参考该表的外键，根据alter-foreign-keys-method参数的值，检测外键相关的表，做相应设置的处理（根据修改后的数据，修改外键关联的子表），如果被修改表存在外键定义但没有使用  --alter-foreign-keys-method 指定特定的值，该工具不予执行；
7.   默认最后将旧原表删除、触发器删除。﻿

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/c31e551b546d403fa1cc371203924675~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp" style="zoom:50%;" />

### 用法

Percona Toolkit 是成熟的，但是官方还是建议在使用前做到以下几点：

1.   阅读该工具的详细文档。
2.   查看该工具的已知“错误”
3.   在非生产服务器上测试该工具。
4.   备份您的生产数据并验证备份。

下载安装：

从官方网站下载percona-toolkit，然后执行下面的命令进行安装（示例）：

```shell
# 安装依赖包 
yum install perl-TermReadKey.x86_64  
yum install perl-DBI 
yum install perl-DBD-MySQL 
yum install perl-Time-HiRes 
yum install perl-IO-Socket-SSL 
# 安装percona-toolkit 
rpm -ivh percona-toolkit-3.1.0-2.el7.x86_64.rpm
```

执行类似下面的命令修改表结构：

```shell
pt-online-schema-change --alter="add column c1 int;" --execute D=test,t=table,u=user,p=password
```

alter参数指定修改表结构的语句，execute表示立即执行，D、t、u、p分别指定库名、表名、用户名和密码，执行期间不阻塞其它并行的DML语句。pt-online-schema-change还有许多选项，具体用法可以使用pt-online-schema-change --help查看联机帮助。

### 限制

pt-online-schema-change**也存在一些局限性**：

1.   在使用此工具之前，应为表定义PRIMARY KEY或唯一索引，因为它是DELETE触发器所必需的；
2.   如果表已经定义了触发器，则不支持 pt-osc ；（注：不是不能有任何触发器，只是不能有针对insert、update、delete的触发器存在，因为一个表上不能有两个相同类型的触发器）；
3.   如果表具有外键约束，需要使用选项  --alter-foreign-keys-method，如果被修改表存在外键定义但没有使用 --alter-foreign-keys-method 指定特定的值，该工具不予执行；
4.   还是因为外键，对象名称可能会改变（indexes names 等）
5.   在Galera集群环境中，不支持更改MyISAM表，系统变量 wsrep_OSU_method 必须设置为总序隔离（Total Order Isolation，TOI）；
6.   此工具仅适用于 MySQL 5.0.2 及更新版本（因为早期版本不支持触发器）；
7.   需要给执行的账户在 MySQL上授权，才能正确运行。（应在服务器上授予PROCESS、SUPER、REPLICATION SLAVE全局权限以及 SELECT、INSERT、UPDATE、DELETE、CREATE、DROP、ALTER 和 TRIGGER 表权限。Slave 只需要 REPLICATION SLAVE 和 REPLICATION CLIENT 权限。）

### 对比OnLine DDL

下面的表格是国外技术牛人进行的测试数据，是Online DDL和pt-osc对一个包含1,078,880行的表应用一些alter操作的对比结果，仅供参考：

|             | online ddl | pt-osc |       |       |      |       |
| ----------- | ---------- | ------ | ----- | ----- | ---- | ----- |
| 更改操作        | 受影响的行      | 是否锁表   | 时间（秒） | 受影响的行 | 是否锁表 | 时间（秒） |
| 添加索引        | 0          | 否      | 3.76  | 所有行   | 否    | 38.12 |
| 下降指数        | 0          | 否      | 0.34  | 所有行   | 否    | 36.04 |
| 添加列         | 0          | 否      | 27.61 | 所有行   | 否    | 37.21 |
| 重命名列        | 0          | 否      | 0.06  | 所有行   | 否    | 34.16 |
| 重命名列更改其数据类型 | 所有行        | 是      | 30.21 | 所有行   | 否    | 34.23 |
| 删除列         | 0          | 否      | 22.41 | 所有行   | 否    | 31.57 |
| 更改表引擎       | 所有行        | 是      | 25.3  | 所有行   | 否    | 35.54 |

## 总结

虽然pt-osc允许对正在更改的表进行读写操作，但它仍然会在后台将表数据复制到临时表，这会增加MySQL服务器的开销。所以基本上，如果Online DDL不能有效工作，我们应该使用 pt-osc。换句话说，如果Online DDL需要将数据复制到临时表（algorithm=copy）并且该表将被长时间阻塞（lock=exclusive）或者在复制环境中更改大表时，我们应该使用 pt-osc工具。
