---
title: Oracle rownum&rowid
categories:
- Software
- BackEnd
- Database
- Oracle
---
# Oracle rownum&rowid

- 分页的核心就是计算每页多少记录和总页数以及第几页,每一页的数据则只需计算起始的记录和结束记录即可

## rownum

- rownum 不是一个真实存在的列, 它是用于从查询返回的行的编号, 返回的第一行分配的是 1, 第二行是 2, 依此类推, 这个伪字段可以用于限制查询返回的总行数

```sql
select * from emp where rownum <= 5
```

- 不能对rownum用`>`, 下列查询是失败的

```sql
select * from emp where rownum > 5
```

- 查询出未匹配的行已经被丢弃, 之后查出来的rownum仍然是1,这样永远也不会成功
- 同样道理, rownum如果单独用`=`,也只有在`rownum=1`时才成功

### 实现分页

- 虽然 ronum 不能直接查询大于 1 的记录, 但是我们可以自己添加伪列, 将查询的结果集中的 rownum 作为查询的来源, 则此时来源中的 rownum 变成了普通字段, 再通过这个 rownum 来进行某段记录的选取即可

```sql
select ename,sal,deptno,rw,rownum from (select ename,sal,deptno,rownum rw from emp)
where rw>5 and rw<=10;
```

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-image-20201019112139977.png" alt="image-20201019112139977" style="zoom:50%;" />

**实例**

- 查询员工的信息, 姓名, 工资, 部门编号, 按照工资降序排序, 实现分页
- 每一页显示3条记录, 查询第一页的数据

```sql
select ename,sal,deptno,rownum r1 from emp order by sal desc
```

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-image-20201019113234148.png" alt="image-20201019113234148" style="zoom: 67%;" />

- 此时结果`r1`发生了乱序, 是因为这个查询存在按照其他的列进行排序
- 再次对该结果集取`rownum`使`rownum`按升序排列

```sql
select ename,sal,deptno,r1,rownum r2 from(
	select ename,sal,deptno,rownum r1 from emp order by sal desc)
```

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-2020-11-06-image-20201019113330065.png" alt="image-20201019113330065" style="zoom:50%;" />

- 此时`r2`为最初查询结果集的升序`rowndum`
- 查询当前`rownum`中小于等于3的记录

```sql
select ename,sal,deptno,r2 from(
	select ename,sal,deptno,r1,rownum r2 from(
		select ename,sal,deptno,rownum r1
		from emp order by sal desc
	)
)where r2<=3;
```

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-2020-11-06-image-20201019113411210.png" alt="image-20201019113411210" style="zoom:50%;" />

## rowid

- `rowid` 是 ORACLE 中的一个重要的概念,用于定位数据库中一条记录的一个相对唯一地址值
- 通常情况下, 该值在该行数据插入到数据库表时即被确定且唯一,`rowid` 它是一个伪列, 它并不实际存在于表中
- `rowid`是 ORACLE 在读取表中数据行时, 根据每一行数据的物理地址信息编码而成的一个伪列,所以根据一行数据的`rowid` 能找到一行数据的物理地址信息,从而快速地定位到数据行,数据库的大多数操作都是通过 `rowid` 来完成的, 而且使用 `rowid` 来进行单记录定位速度是最快的

## 实现去重

- oracle 中如果要查询某张表中多个字段, 又只对某个字段去重的时候用 distinct 或者 group by 都不行
- distinct 和 group by 会对要查询的字段一起进行去重, 也就是当查询的所有字段都相同, oracle 才认为是重复的,这时用 rowid 是个不错的选择

**实例**

- 查询rowid

```sql
select deptno,dname,loc,rowid from tempcp;
```

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-image-20201019132935238.png" alt="image-20201019132935238" style="zoom:50%;" />

- 插入重复数据, 查看结果

```sql
insert into tempcp select * from dept;
```

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-image-20201019133113356.png" alt="image-20201019133113356" style="zoom:50%;" />

- 将数据进行分组, 按照重复信息进行分组

```sql
select * from tempcp group by deptno,dname,loc;
```

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-image-20201019133351902.png" alt="image-20201019133351902" style="zoom:50%;" />

- 查找出rowid最小的记录(可以保证只有一条 )

```sql
select min(rowid) from tempcp group by deptno,dname,loc;
```

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-image-20201019133505973.png" alt="image-20201019133505973" style="zoom:50%;" />

- 查找rowid不在这些之内的记录

```sql
select * from tempcp where rowid not in(
    	select min(rowid) from tempcp group by deptno,dname,loc
);
```

删除这些记录,  即完成列去重

```sql
delete from tempcp where rowid not in(
	select min(rowid) from tempcp group by deptno,dname,loc
);
```

