---
title: Node.js MySQL
categories:
- Software
- FrontEnd
- Node.js
---
# Node.js MySQL

##   安装模块

```bash
yarn add  mysql
```

## 连接数据库

**实例**

```js
var mysql      = require('mysql');
var connection = mysql.createConnection({
  host     : 'localhost',
  user     : 'root',
  password : '123456',
  database : 'test'
});

connection.connect();

connection.query('SELECT 1 + 1 AS solution', function (error, results, fields) {
  if (error) throw error;
  console.log('The solution is: ', results[0].solution);
});
```

- 执行以下命令输出结果为：

```bash
node test.js
The solution is: 2
```

### 数据库连接参数说明：

| 参数               | 描述                                                         |
| :----------------- | :----------------------------------------------------------- |
| host               | 主机地址（默认：localhost)|
| user               | 用户名                                                       |
| password           | 密码                                                         |
| port               | 端口号（默认：3306)|
| database           | 数据库名                                                     |
| charset            | 连接字符集（默认：'UTF8_GENERAL_CI'，注意字符集的字母都要大写）|
| localAddress       | 此IP用于TCP连接（可选）|
| socketPath         | 连接到unix域路径，当使用 host 和 port 时会被忽略             |
| timezone           | 时区（默认：'local')|
| connectTimeout     | 连接超时（默认：不限制，单位：毫秒）|
| stringifyObjects   | 是否序列化对象                                               |
| typeCast           | 是否将列值转化为本地JavaScript类型值（默认：true)|
| queryFormat        | 自定义query语句格式化方法                                    |
| supportBigNumbers  | 数据库支持bigint或decimal类型列时，需要设此option为true（默认：false)|
| bigNumberStrings   | supportBigNumbers和bigNumberStrings启用强制bigint或decimal列以JavaScript字符串类型返回（默认：false)|
| dateStrings        | 强制timestamp,datetime,data类型以字符串类型返回，而不是JavaScript Date类型（默认：false)|
| debug              | 开启调试（默认：false)|
| multipleStatements | 是否许一个query中有多个MySQL语句（默认：false)|
| flags              | 用于修改连接标志                                             |
| ssl                | 使用ssl参数（与crypto.createCredenitals参数格式一至）或一个包含ssl配置文件名称的字符串，目前只捆绑Amazon RDS的配置文件 |

- 更多说明可参见：https://github.com/mysqljs/mysql

## 数据库操作（ CURD )

### 查询数据

```js
var mysql  = require('mysql');

var connection = mysql.createConnection({
  host     : 'localhost',
  user     : 'root',
  password : '123456',
  port: '3306',
  database: 'test'
});

connection.connect();

var  sql = 'SELECT * FROM websites';
// 执行查询语句，并返回数据集。
connection.query(sql,function (err, result) {
        if(err){
          console.log('[SELECT ERROR] - ',err.message);
          return;
        }

       console.log('--------------------------SELECT----------------------------');
       console.log(result);
       console.log('------------------------------------------------------------\n\n');
});

connection.end();
```

- 执行以下命令输出结果为：

```bash
node test.js
--------------------------SELECT----------------------------
[ RowDataPacket {
    id: 1,
    name: 'Google',
    url: 'https://www.google.cm/',
    alexa: 1,
    country: 'USA' },
  RowDataPacket {
    id: 2,
    name: '淘宝',
    url: 'https://www.taobao.com/',
    alexa: 13,
    country: 'CN' },
  RowDataPacket {
    id: 4,
    name: '微博',
    url: 'http://weibo.com/',
    alexa: 20,
    country: 'CN' },
  RowDataPacket {
    id: 5,
    name: 'Facebook',
    url: 'https://www.facebook.com/',
    alexa: 3,
    country: 'USA' } ]
------------------------------------------------------------
```

### 插入数据

```js
var mysql  = require('mysql');

var connection = mysql.createConnection({
  host     : 'localhost',
  user     : 'root',
  password : '123456',
  port: '3306',
  database: 'test'
});

connection.connect();

var  addSql = 'INSERT INTO websites(Id,name,url,alexa,country) VALUES(0,?,?,?,?)';
var  addSqlParams = ['百度', 'https://www.baidu.com','23453', 'CN'];
// 执行插入语句。
connection.query(addSql,addSqlParams,function (err, result) {
        if(err){
         console.log('[INSERT ERROR] - ',err.message);
         return;
        }

       console.log('--------------------------INSERT----------------------------');
       //console.log('INSERT ID:',result.insertId);
       console.log('INSERT ID:',result);
       console.log('-----------------------------------------------------------------\n\n');
});

connection.end();
```

- 执行以下命令输出结果为：

```bash
node test.js
--------------------------INSERT----------------------------
INSERT ID: OkPacket {
  fieldCount: 0,
  affectedRows: 1,
  insertId: 6,
  serverStatus: 2,
  warningCount: 0,
  message: '',
  protocol41: true,
  changedRows: 0 }
-----------------------------------------------------------------
```

## 更新数据

```js
var mysql  = require('mysql');

var connection = mysql.createConnection({
  host     : 'localhost',
  user     : 'root',
  password : '123456',
  port: '3306',
  database: 'test'
});

connection.connect();

var modSql = 'UPDATE websites SET name = ?,url = ? WHERE Id = ?';
var modSqlParams = ['腾讯', 'https://qq.com',6];
// 执行更新语句。
connection.query(modSql,modSqlParams,function (err, result) {
   if(err){
         console.log('[UPDATE ERROR] - ',err.message);
         return;
   }
  console.log('--------------------------UPDATE----------------------------');
  console.log('UPDATE affectedRows',result.affectedRows);
  console.log('-----------------------------------------------------------------\n\n');
});

connection.end();
```

- 执行以下命令输出结果为：

```bash
node test.js
--------------------------UPDATE----------------------------
UPDATE affectedRows 1
-----------------------------------------------------------------
```

## 删除数据

```js
var mysql  = require('mysql');

var connection = mysql.createConnection({
  host     : 'localhost',
  user     : 'root',
  password : '123456',
  port: '3306',
  database: 'test'
});

connection.connect();

var delSql = 'DELETE FROM websites where id=6';
// 执行删除语句。
connection.query(delSql,function (err, result) {
        if(err){
          console.log('[DELETE ERROR] - ',err.message);
          return;
        }

       console.log('--------------------------DELETE----------------------------');
       console.log('DELETE affectedRows',result.affectedRows);
       console.log('-----------------------------------------------------------------\n\n');
});

connection.end();
```

- 执行以下命令输出结果为：

```bash
node test.js
--------------------------DELETE----------------------------
DELETE affectedRows 1
-----------------------------------------------------------------
```

