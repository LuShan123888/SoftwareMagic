---
title: Hadoop HDFS
categories:
- Software
- Backend
- Hadoop
---
# Hadoop HDFS

## Shell 命令

### 目录操作

#### 创建目录

```bash
hdfs dfs -mkdir <path>
```

- `–mkdir`:是创建目录的操作

**实例**

```bash
./bin/hdfs dfs -mkdir -p /user/hadoop
```

- 该命令中表示在HDFS中创建一个`/user/hadoop`目录
- `-p`:表示如果是多级目录,则父目录和子目录一起创建

#### 查看目录

```bash
hdfs dfs -ls <path>
```

- `-ls`:表示列出HDFS某个目录下的所有内容

**实例**

```bash
./bin/hdfs dfs –ls ~
```

- `~`:表示HDFS中的当前用户目录也就是`/user/hadoop`目录,因此,上面的命令和下面的命令是等价的:

```bash
./bin/hdfs dfs –ls /home/hadoop
```

#### 删除目录

```
hdfs dfs -rm -r <path>
```

- `-rm`:表示删除目录或文件
- `-r`:表示递归删除,即删除文件夹

**实例**

```
./bin/hdfs dfs -rm -r /user
```

- 删除根目录下的user文件夹

### 文件操作

#### 上传文件

```bash
hdfs dfs -put <path>
```

**实例**

- 把本地文件系统的`/home/hadoop/myLocalFile.txt`上传到HDFS中的当前用户目录的input目录下,也就是上传到HDFS的`/user/hadoop/input/`目录下

```bash
./bin/hdfs dfs -put /home/hadoop/myLocalFile.txt  input
```

#### 下载文件

```
hdfs dfs -get <path>
```

**实例**

- 把HDFS中的`myLocalFile.txt`文件下载到本地文件系统中的`/home/hadoop/下载/`目录下

```
./bin/hdfs dfs -get input/myLocalFile.txt  /home/hadoop/下载
```

#### 查看文件

```
hdfs dfs -cat <path>
```

**实例**

- 查看HDFS中的`myLocalFile.txt`文件的内容

```bash
./bin/hdfs dfs –cat input/myLocalFile.txt
```

##### 复制文件

```
hdfs dfs -cp <originPath> <destinationPath>
```

**实例**

- 把HDFS的`/user/hadoop/input/myLocalFile.txt`文件,拷贝到HDFS的另外一个目录`/input`中

```
./bin/hdfs dfs -cp input/myLocalFile.txt  /input
```

##### 移动文件

```
hdfs dfs -mv <originPath> <destinationPath>
```

**实例**

- 把HDFS的`/user/hadoop/input/myLocalFile.txt`文件,移动到HDFS的另外一个目录`/input`中,并且将文件名修改为`test.txt`

```
./bin/hdfs dfs -cp input/myLocalFile.txt  /input/test.txt
```

## Java API

### 写入文件

```java
 import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.FSDataOutputStream;
import org.apache.hadoop.fs.Path;

public class Test {
    public static void main(String[] args) {
        try {
            Configuration conf = new Configuration();
            conf.set("fs.defaultFS","hdfs://localhost:9000");
            conf.set("fs.hdfs.impl","org.apache.hadoop.hdfs.DistributedFileSystem");
            FileSystem fs = FileSystem.get(conf);
            byte[] buff = "Hello world".getBytes(); // 要写入的内容
            String filename = "test"; //要写入的文件名
            FSDataOutputStream os = fs.create(new Path(filename));
            os.write(buff,0,buff.length);
            System.out.println("Create:"+ filename);
            os.close();
            fs.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

### 判断文件是否存在

```java
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;

public class Test {
    public static void main(String[] args) {
        try {
            String filename = "test";

            Configuration conf = new Configuration();
            conf.set("fs.defaultFS","hdfs://localhost:9000");
            conf.set("fs.hdfs.impl","org.apache.hadoop.hdfs.DistributedFileSystem");
            FileSystem fs = FileSystem.get(conf);
            if(fs.exists(new Path(filename))){
                System.out.println("文件存在");
            }else{
                System.out.println("文件不存在");
            }
            fs.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

### 读取文件

```java
import java.io.BufferedReader;
import java.io.InputStreamReader;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.fs.FSDataInputStream;

public class Test {
    public static void main(String[] args) {
        try {
            Configuration conf = new Configuration();
            conf.set("fs.defaultFS","hdfs://localhost:9000");
            conf.set("fs.hdfs.impl","org.apache.hadoop.hdfs.DistributedFileSystem");
            FileSystem fs = FileSystem.get(conf);
            Path file = new Path("test");
            FSDataInputStream getIt = fs.open(file);
            BufferedReader d = new BufferedReader(new InputStreamReader(getIt));
            String content = d.readLine(); //读取文件一行
            System.out.println(content);
            d.close(); //关闭文件
            fs.close(); //关闭hdfs
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

