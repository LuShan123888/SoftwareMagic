---
title: MySQL EXPLAIN
categories:
- Software
- BackEnd
- Database
- MySQL
---
# MySQL EXPLAIN

- EXPLAIN可以帮助开发人员分析SQL问题,EXPLAIN显示了MySQL如何使用索引来处理查询语句以及连接表,可以帮助选择更好的索引和写出更优化的查询语句
- MySQL在执行一条查询之前,会对发出的每条SQL进行分析,决定是否使用索引或全表扫描

```sql
Explain + SQL语句
```

-  **id**
    - id值越大优先级越高,越先被执行
    - id如果相同,可以认为是一组,从上往下顺序执行
-  **select_type**:显示查询中每个select子句的类型
    - SIMPLE(简单SELECT,不使用UNION或子查询等)
    - PRIMARY(查询中若包含任何复杂的子部分,最外层的select被标记为PRIMARY)
    - UNION(UNION中的第二个或后面的SELECT语句)
    - DEPENDENT UNION(UNION中的第二个或后面的SELECT语句,取决于外面的查询)
    - UNION RESULT(UNION的结果)
    - SUBQUERY(子查询中的第一个SELECT)
    - DEPENDENT SUBQUERY(子查询中的第一个SELECT,取决于外面的查询)
    - DERIVED(派生表的SELECT, FROM子句的子查询)
    - UNCACHEABLE SUBQUERY(一个子查询的结果不能被缓存,必须重新评估外链接的第一行)
-  **table**:显示这一行的数据是关于哪张表的,有时不是真实的表名字,看到的是derivedx(x是第x步执行的结果)
-  **type**:表示MySQL在表中找到所需行的方式,又称访问类型
    -  **NULL**: MySQL在优化过程中分解语句,执行时甚至不用访问表或索引,例如从一个索引列里选取最小值可以通过单独索引查找完成
    -  **system**:查询系统表,少量数据,往往不需要进行磁盘IO
    -  **const**:连接的是常量,命中主键或唯一索引
    -  **eq_ref**:主键索引或者非空唯一索引等值连接
    -  **ref**:非主键非唯一索引等值连接
    -  **range**:范围扫描
    -  **index**:索引树扫描
    -  **ALL**:全表扫描
-  **possible_keys**:指出MySQL能使用哪个索引在表中找到记录,查询涉及到的字段上若存在索引,则该索引将被列出,但不一定被查询使用
-  **key**:显示MySQL实际决定使用的索引,可以在查询中使用FORCE INDEX,USE INDEX或者IGNORE INDEX指定使用的索引
-  **key_len**:表示索引中使用的字节数,可通过该列计算查询中使用的索引的长度
    -  key_len显示的值为索引字段的最大可能长度,并非实际使用长度,即key_len是根据表定义计算而得,不是通过表内检索出的
-  **ref**:表示上述表的连接匹配条件,即哪些列或常量被用于查找索引列上的值
-  **rows**:表示MySQL根据表统计信息及索引选用情况,估算的找到所需的记录所需要读取的行数
-  **extra**:该列包含MySQL解决查询的详细信息,有以下几种情况
    -  Using where:不用读取表中所有信息,仅通过索引就可以获取所需数据,这发生在对表的全部的请求列都是同一个索引的部分的时候,表示mysql服务器将在存储引擎检索行后再进行过滤
    -  Using temporary:表示MySQL需要使用临时表来存储结果集,常见于排序和分组查询
    -  Using filesort:当Query中包含 order by 操作,而且无法利用索引完成的排序操作称为"文件排序”
    -  Using join buffer:改值强调了在获取连接条件时没有使用索引,并且需要连接缓冲区来存储中间结果,如果出现了这个值,那应该注意,根据查询的具体情况可能需要添加索引来改进能
    -  Impossible where:这个值强调了where语句会导致没有符合条件的行(通过收集统计信息不可能存在结果)
    -  Select tables optimized away:这个值意味着仅通过使用索引,优化器可能仅从聚合函数结果中返回一行
    -  No tables used:Query语句中使用from dual 或不含任何from子句