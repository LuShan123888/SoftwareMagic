---
title: Hadoop HBase
categories:
- Software
- BackEnd
- Distributed
- Hadoop
---
# Hadoop HBase

## Shell命令

### DML

#### 创建表

```sql
create '<表名>','<列族>','[列族]'...
```

**实例**

- 创建了一个`student`表，属性有：`Sname`,`Ssex`,`Sage`,`Sdept`,`course`
- 因为HBase的表中会有一个系统默认的属性作为行键，无需自行创建，默认为put命令操作中表名后第一个数据。

```sqlite
  create 'student','Sname','Ssex','Sage','Sdept','course'
```

- 创建一个`teacher`表，属性有`username`，指定保存的版本数为5

```sql
  create 'teacher',{NAME=>'username',VERSIONS=>5}
```

#### 查看表的基本信息

```sql
describe '<表名>'
```

**实例**

- 创建完`student`表后，通过describe命令查看`student`表的基本信息。

```
hbase(main):002:0> describe 'student'
Table student is ENABLED
student
COLUMN FAMILIES DESCRIPTION
{NAME => 'Sage', BLOOMFILTER => 'ROW', VERSIONS => '1', IN_MEMORY => 'false', KE
EP_DELETED_CELLS => 'FALSE', DATA_BLOCK_ENCODING => 'NONE', TTL => 'FOREVER', CO
MPRESSION => 'NONE', MIN_VERSIONS => '0', BLOCKCACHE => 'true', BLOCKSIZE => '65
536', REPLICATION_SCOPE => '0'}
{NAME => 'Sdept', BLOOMFILTER => 'ROW', VERSIONS => '1', IN_MEMORY => 'false', K
EEP_DELETED_CELLS => 'FALSE', DATA_BLOCK_ENCODING => 'NONE', TTL => 'FOREVER', C
OMPRESSION => 'NONE', MIN_VERSIONS => '0', BLOCKCACHE => 'true', BLOCKSIZE => '6
5536', REPLICATION_SCOPE => '0'}
{NAME => 'Sname', BLOOMFILTER => 'ROW', VERSIONS => '1', IN_MEMORY => 'false', K
EEP_DELETED_CELLS => 'FALSE', DATA_BLOCK_ENCODING => 'NONE', TTL => 'FOREVER', C
OMPRESSION => 'NONE', MIN_VERSIONS => '0', BLOCKCACHE => 'true', BLOCKSIZE => '6
5536', REPLICATION_SCOPE => '0'}
{NAME => 'Ssex', BLOOMFILTER => 'ROW', VERSIONS => '1', IN_MEMORY => 'false', KE
EP_DELETED_CELLS => 'FALSE', DATA_BLOCK_ENCODING => 'NONE', TTL => 'FOREVER', CO
MPRESSION => 'NONE', MIN_VERSIONS => '0', BLOCKCACHE => 'true', BLOCKSIZE => '65
536', REPLICATION_SCOPE => '0'}
{NAME => 'course', BLOOMFILTER => 'ROW', VERSIONS => '1', IN_MEMORY => 'false',
KEEP_DELETED_CELLS => 'FALSE', DATA_BLOCK_ENCODING => 'NONE', TTL => 'FOREVER',
COMPRESSION => 'NONE', MIN_VERSIONS => '0', BLOCKCACHE => 'true', BLOCKSIZE => '
65536', REPLICATION_SCOPE => '0'}
5 row(s) in 0.1390 seconds
```

#### 删除表

删除表有两步，第一步先让该表不可用，第二步删除表。

```sql
disable '<表名>'
drop '<表名>'
```

**实例**

- 删除student表。

```sql
disable 'student'
drop 'student'
```

### DDL

#### 添加数据

- HBase中用put命令添加数据。
- 在添加数据时，HBase会自动为添加的数据添加一个时间戳，故在需要修改数据时，只需直接添加数据，HBase即会生成一个新的版本，从而完成"改”操作，旧的版本依旧保留，系统会定时回收垃圾数据，只留下最新的几个版本，保存的版本数可以在创建表的时候指定。
- **注意**：一次只能为一个表的一行数据的一个列添加数据，也就是一个单元格添加一个数据，所以直接用shell命令插入数据效率很低，在实际应用中，一般都是利用编程操作数据。

```sql
put '<表名>','<行键>','<列族>','<值>'
```

**实例**

- 为student表添加了学号为95001，名字为LiYing的一行数据，其行键为95001

```sql
put 'student','95001','Sname','LiYing'
```

- 为95001行下的course列族的math列添加了一个数据。

```sql
put 'student','95001','course:math','80'
```

#### 查看数据

- HBase中有两个用于查看数据的命令。
    - get命令，用于查看表的某一行数据。
    - scan命令用于查看某个表的全部数据。

```sql
get '<表名>','<行键>'
```

```sql
scan '<表名>'
```

**实例**

- 查看student表中的95001行数据。

```sql
get 'student','95001'
```

- 查看student表的全部数据。

```sql
scan 'student'
```

- 查询teacher表的username列族并制定历史版本数为5，默认会查询出最新的数据。

```sql
  get 'teacher','91001',{COLUMN=>'username',VERSIONS=>5}
```

#### 删除数据

- 在HBase中用delete以及deleteall命令进行删除数据操作。
    - delete用于删除一个数据，是put的反向操作。
    - deleteall操作用于删除一行数据。

```sql
delete '<表名>','<行键>','<列族>'
```

```sql
deleteall '<表名>','<行键>'
```

**实例**

- 删除了student表中95001行下的Ssex列的所有数据。

```sql
delete 'student','95001','Ssex'
```

- 删除了student表中的95001行的全部数据。

```sql
deleteall 'student','95001'
```

## Java API

```java
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.*;
import org.apache.hadoop.hbase.client.*;

public class ExampleForHbase{
    public static Configuration configuration;
    public static Connection connection;
    public static Admin admin;

    // 主函数中的语句请逐句执行，只需删除其前的// 即可，如：执行insertRow时请将其他语句注释。
    public static void main(String[] args)throws IOException{
        // 创建一个表，表名为Score，列族为sname,course
        createTable("Score",new String[]{"sname","course"});

        // 在Score表中插入一条数据，其行键为95001,sname为Mary(因为sname列族下没有子列所以第四个参数为空）
        // 等价命令：put 'Score','95001','sname','Mary'
        //insertRow("Score", "95001", "sname", "", "Mary");
        // 在Score表中插入一条数据，其行键为95001,course:Math为88(course为列族，Math为course下的子列）
        // 等价命令：put 'Score','95001','score:Math','88'
        //insertRow("Score", "95001", "course", "Math", "88");
        // 在Score表中插入一条数据，其行键为95001,course:English为85(course为列族，English为course下的子列）
        // 等价命令：put 'Score','95001','score:English','85'
        //insertRow("Score", "95001", "course", "English", "85");

        //1，删除Score表中指定列数据，其行键为95001，列族为course，列为Math
        // 执行这句代码前请deleteRow方法的定义中，将删除指定列数据的代码取消注释注释，将删除制定列族的代码注释。
        // 等价命令：delete 'Score','95001','score:Math'
        //deleteRow("Score", "95001", "course", "Math");

        //2，删除Score表中指定列族数据，其行键为95001，列族为course(95001的Math和English的值都会被删除）
        // 执行这句代码前请deleteRow方法的定义中，将删除指定列数据的代码注释，将删除制定列族的代码取消注释。
        // 等价命令：delete 'Score','95001','score'
        //deleteRow("Score", "95001", "course", "");

        //3，删除Score表中指定行数据，其行键为95001
        // 执行这句代码前请deleteRow方法的定义中，将删除指定列数据的代码注释，以及将删除制定列族的代码注释。
        // 等价命令：deleteall 'Score','95001'
        //deleteRow("Score", "95001", "", "");

        // 查询Score表中，行键为95001，列族为course，列为Math的值。
        //getData("Score", "95001", "course", "Math");
        // 查询Score表中，行键为95001，列族为sname的值（因为sname列族下没有子列所以第四个参数为空）
        //getData("Score", "95001", "sname", "");

        // 删除Score表。
        //deleteTable("Score");
    }

    // 建立连接。
    public static void init(){
        configuration  = HBaseConfiguration.create();
        configuration.set("hbase.rootdir","hdfs://localhost:9000/hbase");
        try{
            connection = ConnectionFactory.createConnection(configuration);
            admin = connection.getAdmin();
        }catch (IOException e){
            e.printStackTrace();
        }
    }
    // 关闭连接。
    public static void close(){
        try{
            if(admin != null){
                admin.close();
            }
            if(null != connection){
                connection.close();
            }
        }catch (IOException e){
            e.printStackTrace();
        }
    }

    /**
     * 建表，HBase的表中会有一个系统默认的属性作为主键，主键无需自行创建，默认为put命令操作中表名后第一个数据，因此此处无需创建id列。
     * @param myTableName 表名。
     * @param colFamily 列族名。
     * @throws IOException
     */
    public static void createTable(String myTableName,String[] colFamily) throws IOException {

        init();
        TableName tableName = TableName.valueOf(myTableName);

        if(admin.tableExists(tableName)){
            System.out.println("talbe is exists!");
        }else {
            HTableDescriptor hTableDescriptor = new HTableDescriptor(tableName);
            for(String str:colFamily){
                HColumnDescriptor hColumnDescriptor = new HColumnDescriptor(str);
                hTableDescriptor.addFamily(hColumnDescriptor);
            }
            admin.createTable(hTableDescriptor);
            System.out.println("create table success");
        }
        close();
    }
    /**
     * 删除指定表。
     * @param tableName 表名。
     * @throws IOException
     */
    public static void deleteTable(String tableName) throws IOException {
        init();
        TableName tn = TableName.valueOf(tableName);
        if (admin.tableExists(tn)) {
            admin.disableTable(tn);
            admin.deleteTable(tn);
        }
        close();
    }

    /**
     * 查看已有表。
     * @throws IOException
     */
    public static void listTables() throws IOException {
        init();
        HTableDescriptor hTableDescriptors[] = admin.listTables();
        for(HTableDescriptor hTableDescriptor :hTableDescriptors){
            System.out.println(hTableDescriptor.getNameAsString());
        }
        close();
    }
    /**
     * 向某一行的某一列插入数据。
     * @param tableName 表名。
     * @param rowKey 行键。
     * @param colFamily 列族名。
     * @param col 列名（如果其列族下没有子列，此参数可为空）
     * @param val 值。
     * @throws IOException
     */
    public static void insertRow(String tableName,String rowKey,String colFamily,String col,String val) throws IOException {
        init();
        Table table = connection.getTable(TableName.valueOf(tableName));
        Put put = new Put(rowKey.getBytes());
        put.addColumn(colFamily.getBytes(), col.getBytes(), val.getBytes());
        table.put(put);
        table.close();
        close();
    }

    /**
     * 删除数据。
     * @param tableName 表名。
     * @param rowKey 行键。
     * @param colFamily 列族名。
     * @param col 列名。
     * @throws IOException
     */
    public static void deleteRow(String tableName,String rowKey,String colFamily,String col) throws IOException {
        init();
        Table table = connection.getTable(TableName.valueOf(tableName));
        Delete delete = new Delete(rowKey.getBytes());
        // 删除指定列族的所有数据。
        //delete.addFamily(colFamily.getBytes());
        // 删除指定列的数据。
        //delete.addColumn(colFamily.getBytes(), col.getBytes());

        table.delete(delete);
        table.close();
        close();
    }
    /**
     * 根据行键rowkey查找数据。
     * @param tableName 表名。
     * @param rowKey 行键。
     * @param colFamily 列族名。
     * @param col 列名。
     * @throws IOException
     */
    public static void getData(String tableName,String rowKey,String colFamily,String col)throws  IOException{
        init();
        Table table = connection.getTable(TableName.valueOf(tableName));
        Get get = new Get(rowKey.getBytes());
        get.addColumn(colFamily.getBytes(),col.getBytes());
        Result result = table.get(get);
        showCell(result);
        table.close();
        close();
    }
    /**
     * 格式化输出。
     * @param result
     */
    public static void showCell(Result result){
        Cell[] cells = result.rawCells();
        for(Cell cell:cells){
            System.out.println("RowName:"+new String(CellUtil.cloneRow(cell))+" ");
            System.out.println("Timetamp:"+cell.getTimestamp()+" ");
            System.out.println("column Family:"+new String(CellUtil.cloneFamily(cell))+" ");
            System.out.println("row Name:"+new String(CellUtil.cloneQualifier(cell))+" ");
            System.out.println("value:"+new String(CellUtil.cloneValue(cell))+" ");
        }
    }
}
```

