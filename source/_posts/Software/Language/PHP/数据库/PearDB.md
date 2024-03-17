---
title: PHP PearDB
categories:
- Software
- Language
- PHP
- 数据库
---
# PHP PearDB

- 示例8-1的程序创建了一个关于科幻小说书籍信息的HTML表格，它说明了如何使用PEAR DB库来连接数据库，执行语句，检查错误和查询结果到HTML,请确保在安装PHP时启用了PEAR,这在Unix/Linux和Windows下有一点不同,PEAR DB代码库是面向对象的，带有类方法(`DB::connect()`,`DB::iserror()`)和对象方法(`$db->query()`,`$q->fetchInto()`)

**示例8-1**:显示书籍信息

```php+HTML
<html><head><title>Library Books</title></head>
    <body>
        <table border=1>
            <tr><th>Book</th>Year Published</th><th>Author</th></tr>
    <?php
    //连接
    require_once('DB.php');
    $db = DB::connect("mysql://librarian:password@local/library");
    if(DB::iserror($db)){
        die($db->getMessage());
    }

    //执行查询
    $sql = "SELECT books.title,books.pub_year,authors.name
 		FROM books,authors
 		WHERE books.authorid=authors.authorid
 		ORDER BY books.pub_year ASC";
    $q = $db->query($sql);
    if(DB::iserror($sql){
        die($q->getMessage());
    }
       //生成表格
       while($q->fetchInto($row)){
    ?>
    <tr><td><?= $row[0] ?></td>
        <td><?= $row[1] ?></td>
        <td><?= $row[2] ?></td>
    </tr>
    <?php
       }
    ?>
```

## 数据源名

- DSN(data source name,数据源名)是一个字符串，它指定数据库的位置，数据库的类型，连接数据库时使用的用户名和密码等信息，在PEAR中DSN的各部分被组合成一个类似于URL的字符串:

```php
type(dbsyntax)://username:password@protocol+hostspec/ddatabase
```

- type字段是唯一必须指定的字段，它指定了PHP所使用的数据库类型，下表列出了数据库类型

| Name名称 | Database数据库          |
| -------- | ----------------------- |
| mysql    | MySQL                   |
| mysqli   | MySQL(for MySQL >= 4.1) |
| pgsql    | PostgreSQL              |
| ibase    | InterBase               |
| msql     | Mini SQL                |
| mssql    | MicrosoftSQL Server     |
| oci8     | Oracle 7/8/8i           |
| odbc     | ODBC                    |
| sybase   | Sybase                  |
| ifx      | Informix                |
| fbsql    | FrontBase               |
| dbase    | Dbase                   |
| sqlite   | SQLite                  |

- Prorocol是所用的通信协议，两种常用的值是"tcp"和"unix",对应的Internet和Unix域套接字，不是所有的数据库后台都支持所有的通信协议
- 下面是一些合法的DSN:

```php
mysql:///library
mysql://localhost/library
mysql://librarian@localhost/library
mysql://librarian@tcp+localhost/library
mysql://librarian:password@localhost/library
```

- 在示例8-1中，我们用用户名librarian和密码password连接到Mysql数据库library,在实际开发中一个常见的做法是存放DSN到一个PHP文件中，并在所有需要数据库连接的页面中包含这个文件，想这样做的意义是如果要修改信息，不需要改变所有的页面，在一个更加复杂的配置文件中，甚至可以根据程序正处于开发期或运营期来选择不同的DSN

## 连接

- 一旦有了DSN,就可以使用`connect()`方法来创建数据库连接，该方法返回一个数据库对象，利用它可以进行查询和引用参数:

```php
$db = DB::connect(DSN [,options]);
```

- options的值可以是布尔型的，指定数据库连接是否是持久性的，或者是一个选项设置的数组，下表给出options的值

| Option选项 | Controls控制     |
| ---------- | ---------------- |
| persistent | 在访问间持久连接 |
| optimize   | 要优化的内容     |
| debug      | 显示调试信息     |

- 默认情况下，连接是不持久的并且不显示调试信息,optimize的值可以是'performance'和'portability',默认为'performance',下面的代码展示了如何启用调试功能和对可移植性的优化:

```php
$db = DB::connect($datasource);
if(DB::isError($db)){
    die($db->getMessage());
}
```

如果在数据库对象工作时发生错误,`DB::isError()`方法返回true,如果发生一个错误，通常的做法是停止程序并用`getMessage()`方法显示错误信息，你可以在任何PEAR DB对象上调用`getmessage()`方法

## 执行语句

- 在一个数据库对象上调用`query()`方法可向数据库发送SQL:

```php
$result = $db->query(sql);
```

- 操作成功时，一条非查询类的SQL语句(如INSERT,UPDATE,DELETE)返回常量DB_OK来标志操作成功，一条用于查询的SQL语句(如SELECT)返回一个可以用于返回查询结果的对象
- 可以用`DB::isError()`检查操作是否成功:

```php
$q = $db->query($sql);
if(DB::isError($q)){
    die($q->getMessage());
}
```

## 获取查询结果

PEAR DB提供两种从查询结果对象中获取数据的方法，一种是返回对应下一行的数组，另一种是存储行数组到以参数形式传递的变量中

### 返回行

- 在一个查询结果对象上调用`fetchRow()`方法以数组的形式返回结果集中的下一行记录:

```php
$row = $result->fetchRow([mode]);
```

- 如果没有错误，将返回一个数据数组，如果没有数组时则是NULL(当查询结果集为空时),如果有错误发生则返回`DB_ERROR`,mode参数控制返回数组的格式
- `fetchRow()`方法的习惯用法是一次一行的处理查询结果，如下所示:

```php
while($row = $result->fetchRow()){
    if(DB::isError($row)){
        die($row->getMessage());
    }
    //处理行
}
```

### 存储行

- `fetchInto()`方法不只是获取下一行，还把它存放在作为参数传递的数组变量中:

```php
$success = $result->fetchInto(array,[mode]);
```

- 和`fetchRow()`类似，如果没有更多的数据`fetchInto()`返回NULL,或有错误发生时返回`DB_ERROR`
- 习惯像下面这样用`fetchInto()`处理所有结果:

```php
while($result->fetchInto($row)){
 if(DB::isError($success)){
     die($success->getMessage());
 }
 //处理行
}
```

### 行数组的内部

- 将要返回的这些行是什么呢?默认是带索引的数组，在数组中的位置对应返回结果中列的顺序，例如:

```php
$row = $result->fetchRow();
if(DB::isError($row)){
    die($row->getMessage());
}
var_dump($row);
array(3){
    [0]=>string(5) "Foundation",
    [1]=>string(4) "1951",
    [2]=>string(12) "Isaac Asimov"
}
```

- 可以传递一个mode参数给`fetchRow()`或`fetchInto()`来控制行数组的格式，就像上例中那样，默认地是以`DB_FETCHMODE_ORDERED`指定的方式
- 获取模式`DB_FETCHMODE_ASSOC`将创建一个数组，其中元素的键名是列名并且它的值来自于列的值:

```php
$row = $result->fetchRow(DB_FETCHMODE_ASSOC);
if(DB::isError($row)){
    die($row->getMessage());
}
var_dump($row);
array(3){
    ["title"]=>string(5) "Foundation",
    ["pub_year"]=>string(4) "1951",
    ["name"]=>string(12) "Isaac Asimov"
}
```

- 模式`DB_FETCHMODE_OBJECT`把行转换到一个对象，该对象的属性是结果行的每一列:

```php
$row = $result->fetchRow(DB_FETCHMODE_OBJECT);
if(DB::isError($row)){
    die($row->getMessage());
}
var_dump($row);
object (stdClass)(3){
    ["title"]=>string(5) "Foundation",
    ["pub_year"]=>string(4) "1951",
    ["name"]=>string(12) "Isaac Asimov"
}
```

- 要在这个对象中访问数据，可以使用`$object->property`:

```php
echo "{$row->title} was published in {$row->pub_year) and was written by {$row->name}";

Foundation was published in 1951 and was written by Isaac Asimov
```

### 结束查询结果

- 一个查询结果对象通常存放了查询返回的所有行，这将消耗很多内存，要将被查询结果消耗的内存释放归还给操作系统，可以使用`free()`方法:

```php
$result->free();
```

- 我们并不需要严格地这样做，因为当PHP脚本结束时所有的查询会自动调用`free()`

## 关闭连接

- 要强制性地PHP断开数据库连接，可以在这个数据库对象上使用`disconnect()`方法:

```php
$db->disconnect();
```

- 这也不是严格需要的，因为当PHP脚本结束时所有的数据库连接都会被关闭



## 高级数据库技术

- PEAR DB将之前所示的数据库原始操作(primitive)进行改进，它提供了一些简化的函数来取得结果集的一行，还提供了唯一行ID系统，以及互相独立的SQL预处理和执行步骤来提高重复查询的效率

### 占位符(Placeholder)

- 像`printf()`通过把值插入到模板来构建字符串一样,PEAR DB也可以通过把值插入到模板来构建一个查询，传给`query()`函数带`?`的SQL来代替特定值，并且增加由要插入到SQL的数组值组成的第二个参数:

```php
$result = $db->query(SQL,values);
```

- 例如，这段代码插入3条记录到books表中:

```php
$books = array(array('Foundation',1951),
               array('Second Foundation',1953),
               array('Foundation and Empire',1952));
foreach($books as $book){
    $db->query('INSERT INTO books (title,pub_year) VALUES (?,?)',$book);
}
```

- 在SQL查询中你可以使用以下3种占位符:
    - `?`:一个字符串或数字，如果需要的话将带上引号(推荐)
    - `|`:一个字符串或数字，将不会用带上引号
    - `&`:一个文件名，它的内容将被包含在语句中(例如，在一个BLOB字段存储一个图像文件)

### 预处理(预编译)和执行

- 当重复地执行相同语句时，先用`prepare()`编译一次然后使用`execute()`,`executeMultiple()`方法多次执行语句将会使效率更高
- 第一步是在语句上调用`prepare()`:

```php
$compiled = $db->prepare(SQL);
```

- 他将返回一个编译过的查询语句对象(query object),`execute()`方法的参数是包含有任意占位符的查询,`execute()`方法会把该查询发送给RDBMS:

```php
$response = $db->execute(compiled,values);
```

- Values数组包括查询中占位符的值，返回值是一个查询响应对象，如果错误发生则是`DB_ERROR`
- 例如，我们可以像下面这样插入多个值到books表中:

```php
$books = array(array('Foundation',1951),
               array('Second Foundation',1953),
               array('Foundation and Empire',1952));
$compiled = $q->prepare('INSERT INTO books (title,pub_year) VALUES (?,?)');
foreach($books as $book){
    $db->execute($compiled,$book);
}
```

- `executeMultiple()`方法接收二维数组值的插入:

```php
$responses = $db->executeMultiple(compiled,values);
```

- values数组的数字索引必须从0开始，并且包含要插入值得数组，已编译得查询为values中每个值执行一次，查询响应应被收集到`$responses`中
- 往books数据表中插入数据得更好的代码如下:

```php
$books = array(array('Foundation',1951),
               array('Second Foundation',1953),
               array('Foundation and Empire',1952));
$compiled = $q->prepare('INSERT INTO books (title,pub_year) VALUES (?,?)');
$db->insertMultiple($compiled,$books);
```

### 简化操作

PEAR DB提供一些快捷的方法，只需要一个步骤就可以执行一个查询和获取结果集:`getOne()`,`getRow()`,`getCol()`,`getAssoc()`和`getAll()`,这些方法都允许使用占位符

- `getOne()`方法获取SQL查询结果中的第一行的第一列的 内容:

    > ```php
    > $value = $db->getOne(SQL [, values ]);
    > ```

    例如:

    > ```php
    > $when = $db->getOne("SELECT avg(pub_year) FROM books");
    > if(DB::isError($when)){
    > die($when->getMessage());
    > }
    > echo "The  average book in the library was published in $when";
    >
    > The average book in the library was published in 1974
    > ```

- `getRow()`返回SQL查询结果集数据中的第一行的内容:

    > ```php
    > $row = $db ->getRow(SQL,[,values]])
    > ```

    如果你知道只有一行记录将被返回时，这些函数时很有用的，例如:

    > ```php
    > list($titl,$author) = $db->getRow("SELECT books.title,authors.name
    > 								FROM books,authors
    > 								WHERE books.pub_year=1950
    > 								AND books.authorid=authors.authorid");
    > echo ("$title, written by $author)";
    >
    > (I, Robot, written by Isaac Asimov)
    > ```

- ` getCol()`方法返回SQL查询结果集数据中的单个列的内容:

    > ```php
    > $col = $db->getCol(SQL [, column[, values ]]);
    > ```

    Column参数可以是一个数字(默认是0表示第一列),或是一个列名，例如，下面的代码用于获取数据库中所有书名，并以出版年排序:

    > ```php
    > $titles = $db->getAll("SELECT title FROM books ORDER BY pub_year ASC");
    > foreach($titles as $title){
    >  echo "$title\n";
    > }
    >
    > the Hobbit
    > I, Robot
    > ...
    > ```

- ` getAll()`方法返回查询返回所有行中的内容:

    > ```php
    > $all = $db->getAll(SQL [, values [, fetchmode ]]);
    > ```

    例如，下面的代码是创建一个包括影片名的可选框，被选中电影的ID将被作为参数值提交

    > ```php
    > $result = $db->getAll("SELECT bookid,title
    > 					FROM books
    > 					ORDER BY pub_year ASC");
    > echo "<select name='movie'>\n";
    > foreach ($results as $result){
    >  echo "<option value={$result[0]}>{$result[1]}</option>\n";
    > }
    > echo "</select>";
    > ```

    如果有错误发生，所有的`get*()`方法都会返回DB_ERROR

###  查询响应的细节

- PEAR DB提供了4中方法来获取查询结果对象的信息:`numRows()`,`numCols()`,`affectedRows()`和`tableInfo()`
- 通过调用`numRows()`和`numCols()`方法可以知道SELECT查询结果的行数和列数:

```php
$howmany = $response->numRowas();
$howmany = $response->numRowCols();
```

- 通过调用`affectedRows()`方法可以知道有多少行被INSERT,DELETE或UPDATE操作所影响:

```php
$howmany = $response->affectedRows();
```

- `tableInfo()`方法可以知道有多少行被INSERT,DELETE或UPDATE操作所影响:

```php
$info = $response->tableInfo();
```

- 下面的代码是把一个表的信息放到HTML表格中:

```php
//连接
require_once('DB.php');
$db = DB::connect("mysql://librarian:passw0rd@localhost/librart");
if(DB::iserror($db)){
    die($db->getMessage());
}
$info = $q->tableInfo();
a_to_table($info);

function a_to_table($a){
echo "<html>

<head>
    <title>Table Info</title>
</head>";
echo "<table border=1>\n";
    foreach($a as $key => $value){
    echo "<tr valign=top align=left>
        <td>$key</td>
        <td>";
            if(is_array($value){
            a_to_table($value);
            }else{
            print_r($value);
            }
            echo "</td>
    </tr>\n";
    }
    echo "</table>\n";
}
```

### 序列

- 不是所有的RDBMS都可以指定某行记录的唯一ID,各种数据库有许多不同的方法来返回这一信息,PEAR BD序列(sequence)是一种数据库专用ID分配(例如,MySQL是用`AUTO_INCREMENT`来指定ID的分配)的替代方法
- `nextID()`方法返回给定sequence的下一个ID:

```php
$id = $db->nextID(sequence);
```

- 通常每个需要唯一ID的数据表都会有一个sequence,下面的例子用于插入值到book表中，并给每行记录提供了一个唯一的标识符:

```php
$books = array(array('Foundation',1951),
               array('Second Foundation',1952),
               array('Foundation and Empire',1952));
foreach($books as $book){
    $id = $db->nextID('books');
    splice($book,0,0,$id);
    $db->query('INSERT INTO book (bookid,title,pub_year)
 			VALUES (?,?,?)',$book);
}
```

- Sequence实际上是数据库中的一个表，该表存放了上一次所分配的ID,可以使用`create-Sequence()`和`dropSequence()`方法来显示的创建和销毁sequence:

```php
$res = $db->createSequence(sequence);
$res = $db->dropSequence(sequence);
```

- 上述方法的返回值是创建或销毁操作的结果对象，如果有错误发生的话，则是DB_ERROR

### 元数据

- `getListOf()`然你查询数据库的信息，包括可访问的数据库，用户，视图和函数:

```php
$data = $db->gerListOf(what);
```

- what参数是用于指定要列除的数据库组件的额字符串，大多数的 数据库支持"databases",某些数据库支持"users","views"和"functions"
- 例如，下面的代码是把当前可用的数据库列表存放到`$dbs`中:

```php
$dbs = $db->getListOf("database");
```

### 事务

- 一些RDBMS支持事务(transaction),在事务中，一系列的数据库改变可以被提交(被一次性接受)或回滚(取消对数据库的操作，将不会有任何改变应用于数据库),例如，当银行处例货币转账时，从一个账户取款和存款到另一个账户必须一起发生----不能只发生一个，并且两个动作之间不能有时间间隔,PEAR DB提供了`commit()`和`rollback()`方法来帮助完成事务:

```php
$res = $db->commit();
$res = $db->rollback();
```

- 如果在一个不支持事务的数据库上调用`commit()`或`rollback()`,将会返回`DB_ERROR`