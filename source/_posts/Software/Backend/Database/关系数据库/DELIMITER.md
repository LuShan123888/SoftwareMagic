---
title: SQL DELIMITER
categories:
- Software
- Backend
- Database
- 关系数据库
---
# SQL DELIMITER

- DELIMITER命令指定了MySQL解释器命令行的结束符,默认为`;`
- 但一般在存储过程中会有多个分号,我们并不希望一遇到分号就执行命令,因此可以用delimiter命令指定其他结束符来代替`;`
- 这个结束符可以自己定义,常用的是`//` 和 `$$`

```mysql
mysql> delimiter //        --将结束符指定为"//”

mysql> CREATE PROCEDURE simpleproc (OUT param1 INT)
-> BEGIN
-> SELECT COUNT(*) INTO param1 FROM t;
-> END;
-> //                   --遇到//符号结束并执行上面的命令
Query OK, 0 rows affected (0.00 sec)

mysql> delimiter ;        --将结束符改回默认值";”

mysql> CALL simpleproc(@a);
Query OK, 0 rows affected (0.00 sec)

mysql> SELECT @a;
+------+
| @a |
+------+
| 3 |
+------+
1 row in set (0.00 sec)

```

 **注意**:在定义结束符时:`delimiter //` 命令后不能加上`;`  出于习惯或者是把delimiter命令误以为必须加`;`才能执行而在后面加上了分号,那么在执行存储过程时会报错,因为当`mysql> delimiter // ;`这样定义时,此时的结束符不是`//`,而是`// ;`