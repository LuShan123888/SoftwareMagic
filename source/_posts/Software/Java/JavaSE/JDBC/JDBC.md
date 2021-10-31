---
title: JDBC
categories:
- Software
- Java
- JavaSE
- JDBC
---
# JDBC

- 为支持Java程序的数据库操作功能,Java语言采用了专门的Java数据库编程接口JDBC(Java Database Connectivity),JDBC类库中的类依赖于驱动程序管理器,不同的数据库需要不同的驱动程序,驱动程序管理器的作用是通过JDBC驱动程序建立与数据库的连接
- 作为一种有效的数据存储和管理工具,数据库技术得到广泛应用,目前主流的数据库技术是关系数据库,数据以行列的表格形式存储,通常一个数据库中由一组表组成,表中的数据项以及表之间的连接通过关系来组织和约束,根据数据库的大小和性能要求,用户可以选用不同的数据库管理系统,小型数据库常用的有Microsoft Access和MySQL等,而大型数据库产品有IBM DB2,Microsoft SQL Server,Oracle,SYBASE等,所有这些数据库产品都支持SQL结构查询语言,通过统一的查询语言可实现各种数据库的访问处理,常用的SQL命令的使用样例如下表所示

| 命令   | 功能     | 举例                                                     |
| ------ | -------- | -------------------------------------------------------- |
| CREATE | 创建表格 | CREATE TABLE Coffees(Cof_Name VARCHAR(32),Price INTEGER) |
| DROP   | 删除表格 | DROP TABLE Coffees                                       |
| INSERT | 插入数据 | INSERT INTO Coffees VALUES('Clolmbian',101)              |
| SELECT | 查询数据 | SELECT Cof_Name,Price FROM Coffees WHERE Price>7         |
| DELETE | 删除数据 | DELETE FROM Coffees WHERE Cof_Name='Colomabian'          |
| UPDATE | 修改数据 | UPDATE Coffees SET Price = Price+1                       |

## JDBC驱动程序

- JDBC驱动程序有以下4类
    - **JDBC-ODBC桥接(JDBC-ODBC Bridge)驱动程序**:Sun公司在Java2中免费提供了JDBC-ODBC桥接驱动程序,供存取标准的ODBC数据源,然而,Sun公司建议除开发很小的应用程序外,一般不适用这种驱动程序
    - **JDBC结合本地API桥(JDBC-Native API Bridge)驱动程序**:这类驱动程序将JDBC的调用转换成具体数据库系统的本地API调用,Oracle,SYBASE,Informix,DB2等数据库系统均提供了本地API

    - **JDBC结合中间件(JDBC-Middleware)的驱动程序**:这类驱动程序必须在数据库管理系统的服务器上安装中间件,该中间件将JDBC转换为具体数据库系统的本地API调用

    - **纯JDBC驱动程序(Pure JDBC)**:这类驱动程序全由Java写出,所有存取数据库的操作直接由JDBC驱动程序完成,它属于专用的驱动程序,要靠数据库厂商提供支持
- 从性能上考虑,第3类和第4类驱动程序较理想

## JDBC API

- JDBC是对ODBC API进行的一种面向对象的封装和重新设计,Java应用程序通过JDBC API(java.sql)与数据库连接,而实际的动作则由JDBC驱动程序管理器(JDBC Driver Manager)通过JDBC驱动程序与数据库系统进行连接
- Java.sql包提供了多种JDBC API,以下为几个最常用的API
    - Connection接口:代表数据库的连接,通过Connection接口提供的`getMetaData()`方法可获取所连接的数据库的有关描述信息,如表名,表的索引,数据库产品的名称和版本,数据库支持的操作等
    - Statement接口:用来执行SQL语句并返回结果记录集
    - ResultSet:SQL语句执行后的结果记录集,必须逐行访问数据行,但是可以任何顺序访问列

### 使用JDBC连接数据库

- 与数据库建立连接的标准方法是调用`DriverManager.getConnection()`方法,该方法接收含有某个URL的字符串,JDBC管理器将尝试找到可与给定URL所代表的数据库进行连接的驱动程序,以下代码为几类典型数据库的连接方法,其中,url提供了一种标识数据库的方法,可以使相应的驱动程序能识别该数据库并与之建立连接

```java
Class.forName("com.mysql.jdbc.Driver");
String url="jdbc:mysql://localhost:3306?数据库名";
Connection conn=DriverManager.getConnection(url,数据库用户,密码);
```

**注意**:`Class.forName`方法的作用,就是初始化给定的类,而我们给定的 MySQL 的 Driver 类中,它在静态代码块中通过 JDBC 的 DriverManager 注册了一下驱动,我们也可以直接使用 JDBC 的驱动管理器注册 MySQL 驱动,从而代替使用`Class.forName`

### 创建Statement对象

- 建立了与特定数据库的连接之后,就可用该连接发送SQL语句,Statement对象用Connection类的`createStatement()`方法创建,例如:

```php
Statement stmt = con.createStatement();
```

- 接下来,可以通过Statement对象提供的方法执行SQL查询,例如:

```java
ResultSet rs = stmt.executeQuery("SELECT a,b,c FROM Table2");
```

- Statement接口提供了3种执行SQL语句的方法,即`excuteQuery()`,`executeUpdate()`和`execute()`,使用哪一个方法由SQL语句所产生的内容决定
    - `executeQuery()`方法用于产生单个结果集的语句,例如SELECT语句
    - `executeUpdate()`方法执行INSERT,UPDATE或DELETE语句以及SQL DDL(数据定义语言)语句,例如CREATE TABLE和DROP TABLE,INSERT,UPDATE或DELETE语句的效果是修改数据库表格中若干行的指定数据项内容,`executeUpdate()`的返回值是一个整数,是受影响的行数(即更新计数),对于CREATE TABLE或DROP TABLE等不涉及操作记录的语句,`executeUpdate()`的返回值总为零
    - `execute()`方法用于执行返回多个结果集,多个更新计数或二者组合的语句,Statement对象将由Java垃圾收集程序自动关闭,而作为一种好的编程风格,应在不需要Statement对象时显式地关闭它们,这将立即释放DBMS资源

**[例17-1]**:创建数据表

```java
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class JDBC {
    public static void main(String[] args) throws ClassNotFoundException, SQLException {
        //创建数据表
        String url = "jdbc:mysql://localhost:3306/Classroom_Management";
        String sql = "CREATE TABLE Student" +
            "(name VARCHAR(20)," +
            "sex CHAR(2)," +
            "birthday DATE," +
            "leave BIT," +
            "stnumber INTEGER)";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (java.lang.ClassNotFoundException e) {
        }
        try {
            Connection con = DriverManager.getConnection(url, "账号", "密码");
            Statement stmt = con.createStatement();
            stmt.executeUpdate(sql);
            System.out.println("student table created");
            stmt.close();
            con.close();
        } catch (SQLException ex) {
        }
    }
```

**注意**:运行程序将在所连接的数据库中创建一个数据库表格student,如果数据库中已有该表,则不会覆盖已有表,要创建新表,必须先将原表删除(用drop命令)

### 用PreparedStatement类实现SQL操作

- 从上面的例子可以看出,SQL语句的拼接结果往往比较长,日期数据还需要使用转换函数,容易出错,以下介绍一种新的处理方法,即利用`PreparedStatement(String)`方法可获取一个PreparedStatement接口对象,利用该对象可创建一个表示预编译的SQL语句,然后可以用其提供的方法多次处理语句中的数据,例如:

```java
PreparedStatement ps = con.preparedStatement("INSERT INTO Teacher VALUES(?,?,?,?,?,?)");
```

- 其中,SQL语句中的问号为数据占位符,每个"?"号根据其在语句中出现的次序对应有一个位置编号,可以调用PreparedStatement提供的方法将某个数据插入到占位符的位置,例如,以下语句将字符串'”china”插入到第一个问号处

```java
ps.setString(1,"china");
```

- PreparedStatement提供了如下方法以便将各种类型数据插入到语句中
  - `void setAsciiStream(int parameterIndex,InputStream x,int length)`:从InputStream流(字符数据)读取length个字节数据插入到parameterIndex位置
  - `void setBinaryStream(int parameterIndex,InputStream x,int length)`:从InputStream流(二进制数据)读取length个字节数据插入到parameterIndex位置
  - `void setCharacterStream(int parameterIndex,InputStream x,int length)`:从字符输入流读取length个字节数据插入到parameterIndex位置
  - `void setBoolean(int parameterIndex,boolean x)`:在指定位置插入一个布尔值
  - `void setByte(int parameterIndex,byte x)`:在指定位置插入一个Byte值
  - `void setBytes(int parameterIndex,byte[] x)`:在指定位置插入一个Byte数组
  - `void setDate(int parameterIndex,Date x)`:在指定位置插入一个Date对象
  - `void setDouble(int parameterIndex,double x)`:在指定位置插入一个double值
  - `void setFloat(int parameterIndex,float x)`:在指定位置插入一个float值
  - `void setInt(int parameterIndex,int x)`:在指定位置插入一个int值
  - `void setLong(int parameterIndex,long x)`:在指定位置插入一个long值
  - `void setShort(int parameterIndex,short x)`:在指定位置插入一个short值
  - `void setString(int parameterIndex,String x)`:将一个字符串插入到指定位置
  - `void setNull(int parameterIndex,int sqlType)`:将指定参数设置为SQL NULL
  - `void setObject(int parameterIndex,Object x)`:用给定对象设置指定参数的值

**[例17-5]**:采用PreparedStatement实现数据写入

```java
public class 用PreparedStatement类实现SQL操作{
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/Classroom_Management";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(url, "root", "pwforSQL990511");
            Statement stmt = con.createStatement();
            String sql="INSERT INTO teacher VALUES (?,?,?,?,?,?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1,"10000006");
            ps.setString(2,"李斌");
            ps.setString(3,"男");
            ps.setInt(4,35);
            ps.setString(5,"13010001006");
            ps.setString(6,"00000005");
            ps.executeUpdate();
            System.out.println("add 1 Item");
            stmt.close();
            con.close();
        } catch (SQLException | ClassNotFoundException ex) {
            System.out.println(ex.getMessage());
        }
    }
}
```



> **Statement和PreparedStatement有什么区别?**
>
> - PreparedStatement接口代表预编译的语句,它主要的优势在于可以减少SQL的编译错误并增加SQL的安全性(减少SQL注射攻击的可能性)
> - PreparedStatement中的SQL语句是可以带参数的,避免了用字符串连接拼接SQL语句的麻烦和不安全
> - 当批量处理SQL或频繁执行相同的查询时,PreparedStatement有明显的性能上的优势,由于数据库可以将编译优化后的SQL语句缓存起来,下次执行相同结构的语句时就会很快(不用再次编译和生成执行计划)

> **补充**:为了提供对存储过程的调用,JDBC API中还提供了CallableStatement接口,存储过程(Stored Procedure)是数据库中一组为了完成特定功能的SQL语句的集合,经编译后存储在数据库中,用户通过指定存储过程的名字并给出参数(如果该存储过程带有参数)来执行它,虽然调用存储过程会在网络开销,安全性,性能上获得很多好处,但是存在如果底层数据库发生迁移时就会有很多麻烦,因为每种数据库的存储过程在书写上存在不少的差别

## 数据库查询

### 获取表的列信息

- 通过ResultSetMetaData对象可获取有关ResultSet中列的名称和类型的信息,假如results为结果集,则可以用如下方法获取数据项的个数和每栏数据项的名称

```java
ResultSetMetaData rsmd = results.getMetaData();
rsmd.getColumnCount();	//获取数据项的个数
rsmd.getColumnName(i);	//获取第i栏字段的名称
```

### 遍历访问结果集(定位行)

- ResultSet包含符合SQL语句中条件的所有行,每一行称作一条记录,我们可以按行的顺序逐行访问结果集的内容,在结果集中有一个游标用来指示当前行,初始指向第一行之前的位置,可以使用`next()`方法将游标移到下一行,通过循环使用改方法可实现对结果集中的记录的遍历访问

### 访问当前行的数据项(具体列)

- ResultSet通过一套`get()`方法来访问当前行中的不同数据项,可以多种形式获取ResultSet中的数据内容,这取决于每个列中存储的数据类型,可以按列序号或列名来标识要获取的数据项,注意,列序号从1开始,而不是从0开始,如果结果集对象rs的第二列名为title,并将值存储为字符串,则下列任一代码将获取存储在该列中的值

```java
String s = rs.getString("title");
String s = rs.getString(2);
```

- 可使用ResultSet的如下方法来获取当前记录中的数据
    - `String getString(String name)`:将指定名称的列的内容作为字符串返回
    - `int getInt(String name)`:将指定名称的列的内容作为整数返回
    - `float getFloat(String name)`:将指定名称的列的内容作为浮点数返回
    - `Date getDate(String name)`:将指定名称的列的内容作为日期返回
    - `boolean getBoolean(String name)`:将指定名称的列的内容作为布尔型数返回
    - `Object getObject(String name)`:将指定名称的列的内容返回为Object
- 使用哪个方法获取相应的字段值取决于数据库表格中数据字段的类型

**[例17-2]**:查询老师信息表

```java
import java.sql.*;
public class 数据库查询 {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/Classroom_Management";
        String sql = "SELECT * FROM teacher";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (java.lang.ClassNotFoundException ignored) {
        }
        try {
            Connection con = DriverManager.getConnection(url, "root", "pwforSQL990511");
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(sql);
            while (rs.next()){
                String s0 = rs.getString("Tid");
                String s1 = rs.getString("Tname");
                String s2 = rs.getString("Tsex");
                int s3 = rs.getInt("Tage");
                System.out.println("Tid:"+s0+" Tname:"+s1+" Tsex:"+s2+" Tage"+s3);
            }
            stmt.close();
            con.close();
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
    }
}
```

**说明**:在循环条件中通过结果集的`next()`方法实现对所有行的遍历访问,在第14~18行,针对不同类型字段分别用不同的获取数据方法

#### 创建可滚动结果集

- 由Connection对象提供的,不带参数的`createStatement()`方法创建的Statement对象执行SQL语句所创建的结果集只能向后移动记录指针,实际应用中,有时需要在结果集中前后移动或将游标移动到指定行,这时要使用可滚动记录集

#### 创建滚动记录集

- 必须用如下方法创建Statement对象

```java
Statement createStatement(int resultSetType,int resultSetConcurrency)
```

- 其中,resultSetType代表结果集类型,包括如下情形
  - ResultSet.TYPE_FORWARD_ONLY:结果集的游标只能向后滚动
  - ResultSet.TYPE_SCROLL_INSENSITIVE:结果集的游标可以向前后滚动,但结果集不随数据库内容的改变而变化
  - ResultSet.TYPE_SCROLL_SENSITIVE:结果集的游标可以前后滚动,而且结果集与数据库的内容保持同步
- resultSetConcurrency代表并发类型,取值如下:
  - ResultSet.CONCUR_READ_ONLY:不能用结果集更新数据库表
  - ResultSet.CONCUR_UPDATABLE:结果集会引起数据库表内容的改变
- 具体选择创建什么样的的结果集取决于应用需要,与数据表脱离且滚动方向单一的结果在访问效率上更高

####　游标的移动与检查

- 可以使用如下方法来移动游标以实现对结果集的遍历访问
    - `void afterLast()`:移到最后一条记录的后面
    - `void beforeFirst()`:移到第一条记录的前面
    - `void first()`:移到第一条记录
    - `void last()`:移到最后一条记录
    - `void previous()`移到前一条记录处
    - `void next()`:移到下一条记录
    - `boolean isFirst()`:是否游标在第一个记录
    - `Boolean isLast()`:是否游标在最后一个记录
    - `Boolean isBeforeFirst()`:是否游标在最后一个记录之前
    - `Boolean isAfterLast()`:是否游标在最后一个记录之后
    - `int getRow()`:返回当前游标所处行号,行号从1开始编号,如果结果集没有行,返回为空
    - `boolean absolute(int row)`:将游标段到参数row指定的行,如果row为负数,表示倒数行号,例如,`absolute(-1)`表示最后一行,`absolute(1)`和`first()`效果相同

**[例17-3]**:游标的移动

```java
import java.sql.*;
import java.util.*;
public class 数据库查询{
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/Classroom_Management";
        String sql = "SELECT * FROM teacher";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(url, "root", "pwforSQL990511");
            Statement stmt = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = stmt.executeQuery(sql);
            rs.last();
            int num= rs.getRow();
            System.out.println("共有老师数量:"+num);
            rs.beforeFirst();
            while (rs.next()){
                String s0 = rs.getString("Tid");
                String s1 = rs.getString("Tname");
                String s2 = rs.getString("Tsex");
                int s3 = rs.getInt("Tage");
                System.out.println("Tid:"+s0+" Tname:"+s1+" Tsex:"+s2+" Tage"+s3);
            }
            stmt.close();
            con.close();
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
    }
}

```

**说明**:第10行创建的Statement对象可实现记录集的前后滚动,在数据查询应用中经常使用该形式,第12,13行给出了获取数据库表格中记录数的办法,就是先将游标一道最后一行,然后用`getRow()`方法得到记录的行号,第15到22行遍历访问记录的办法是,首先将游标移动到首条记录之前,然后用循环执行记录集的`next()`方法移动到后续记录

## 数据库的更新

###  数据插入

- 将数据插入数据表格中要使用INSERT语句,以下例子按数据表的字段顺序及数据格式拼接出SQL字符串,使用Statement对象的`executeUpdate()`方法执行SQL语句实现数据写入

**[例17-4]**:执行INSERT语句实现数据写入

```java
import java.sql.*;
public class 数据库的更新{
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/Classroom_Management";
        String sql = "INSERT INTO teacher "+
            "VALUES('10000006','李斌','男',35,'13010001006','00000005');";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (java.lang.ClassNotFoundException ignored) {
        }
        try {
            Connection con = DriverManager.getConnection(url, "root", "pwforSQL990511");
            Statement stmt = con.createStatement();
            stmt.executeUpdate(sql);
            System.out.println("1 Item have been inserted");
            stmt.close();
            con.close();
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
    }
}
```

- **说明**:运行该程序,打开数据库将发现在数据表中新加入了一条记录,在SQL语句中提供的数据要与数据库中的字段一致
- **注意**:插入日期新数据要使用SQL中的DataValue转换函数将字符型表示转为日期数据,如果写'78/12/03'是表示字符串,写78/12/03则为整数表达式

###　数据修改和数据删除

- 要实现数据修改只要将SQL语句改用UPDATE语句即可,而删除则使用DELETE语句,例如,以下SQL语句将张三的性别改为'女'

```java
sql = "UPDATE Teacher SET Tsex='女' WHERE Tname='张三'";
```

- 实际编程中经常需要从变量获取要拼接的数据,Java的字符串连接运算符可以方便地将各种类型数据与字符串拼接,如以下SQL语句删除姓名为'张三'的记录

```java
String x = "张三";
sql = "DELETE FROM Teacher WHERE Tname='"+x+'"";
```

