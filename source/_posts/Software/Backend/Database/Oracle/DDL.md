---
title: Oracle DDL
categories:
- Software
- Backend
- Database
- Oracle
---
# Oracle DDL

## 基于其他表新建表

```sql
create tablename as 查询语句
```

## 修改表结构

### 修改表名

```sql
rename 原表名 to 新表名
```

### 修改列名

```sql
alter table 表名 rename column 列名 to 新列名
```

### 修改字段类型

```sql
alter table 表名 modify(字段, 类型)
```

