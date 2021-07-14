---
title: Hadoop WordCount
categories:
- Software
- Backend
- Distributed
- Hadoop
---
# Hadoop WordCount

## Hadoop 2.x 版本中的依赖 jar

Hadoop 2.x 版本中 jar 不再集中在一个 hadoop-core*.jar 中,而是分成多个 jar,如使用 Hadoop 2.6.0 运行 WordCount 实例至少需要如下三个 jar:

- $HADOOP_HOME/share/hadoop/common/hadoop-common-2.6.0.jar
- $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-client-core-2.6.0.jar
- $HADOOP_HOME/share/hadoop/common/lib/commons-cli-1.2.jar

实际上,通过命令 `hadoop classpath` 我们可以得到运行 Hadoop 程序所需的全部 classpath 信息

## 添加环境变量

将 Hadoop 的 classhpath 信息添加到 CLASSPATH 变量中,在`~/.bashrc`中增加如下几行:

```bash
export HADOOP_HOME=/usr/local/hadoop
export CLASSPATH=$($HADOOP_HOME/bin/hadoop classpath):$CLASSPATH
```

## 编译,打包 Hadoop MapReduce 程序

1. 生成`WordCount.java`

```java
vim WordCount.java

import java.io.IOException;
import java.util.Iterator;
import java.util.StringTokenizer;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.util.GenericOptionsParser;

public class WordCount {
    public WordCount() {
    }

    public static void main(String[] args) throws Exception {
        Configuration conf = new Configuration();
        String[] otherArgs = (new GenericOptionsParser(conf, args)).getRemainingArgs();
        if(otherArgs.length < 2) {
            System.err.println("Usage: wordcount <in> [<in>...] <out>");
            System.exit(2);
        }

        Job job = Job.getInstance(conf, "word count");
        job.setJarByClass(WordCount.class);
        job.setMapperClass(WordCount.TokenizerMapper.class);
        job.setCombinerClass(WordCount.IntSumReducer.class);
        job.setReducerClass(WordCount.IntSumReducer.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(IntWritable.class);

        for(int i = 0; i < otherArgs.length - 1; ++i) {
            FileInputFormat.addInputPath(job, new Path(otherArgs[i]));
        }

        FileOutputFormat.setOutputPath(job, new Path(otherArgs[otherArgs.length - 1]));
        System.exit(job.waitForCompletion(true)?0:1);
    }

    public static class IntSumReducer extends Reducer<Text, IntWritable, Text, IntWritable> {
        private IntWritable result = new IntWritable();

        public IntSumReducer() {
        }

        public void reduce(Text key, Iterable<IntWritable> values, Reducer<Text, IntWritable, Text, IntWritable>.Context context) throws IOException, InterruptedException {
            int sum = 0;

            IntWritable val;
            for(Iterator i$ = values.iterator(); i$.hasNext(); sum += val.get()) {
                val = (IntWritable)i$.next();
            }

            this.result.set(sum);
            context.write(key, this.result);
        }
    }

    public static class TokenizerMapper extends Mapper<Object, Text, Text, IntWritable> {
        private static final IntWritable one = new IntWritable(1);
        private Text word = new Text();

        public TokenizerMapper() {
        }

        public void map(Object key, Text value, Mapper<Object, Text, Text, IntWritable>.Context context) throws IOException, InterruptedException {
            StringTokenizer itr = new StringTokenizer(value.toString());

            while(itr.hasMoreTokens()) {
                this.word.set(itr.nextToken());
                context.write(this.word, one);
            }

        }
    }
}
```

2. 编译

```shell
javac WordCount.java
```

- 编译时可能会有警告,可以忽略

3. 打包

```shell
jar -cvf WordCount.jar ./WordCount*.class
```

## 创建上传测试文件

1. 创建测试文件

```shell
mkdir input
echo "echo of the rainbow" > ./input/file0
echo "the waiting game" > ./input/file1
```

2. 把本地文件上传到伪分布式HDFS上

```shell
/usr/local/hadoop/bin/hadoop fs -put ~/wordcount/input /user/hadoop/input
```

## 运行WordCount

```bash
/usr/local/hadoop/bin/hadoop jar WordCount.jar org/apache/hadoop/examples/WordCount input output
```

## 查看结果

```
/usr/local/hadoop/bin/hadoop fs -cat /user/hadoop/output/part-r-00000
```