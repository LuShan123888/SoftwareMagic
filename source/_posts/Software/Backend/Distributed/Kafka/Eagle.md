---
title: Kafka Eagle
categories:
- Software
- Backend
- Distributed
- Kafka
---
# Kafka Eagle

- Kafka Eagle是开源可视化和管理软件,它允许您查询,可视化,提醒和探索您的指标,无论它们存储在哪里,简单地说,它为您提供了将kafka集群数据转换为漂亮的图形和可视化的工具

## Docker

### 启动容器

```shell
$ docker run -d \
-p 8048:8048 \
--net zookeeper \
--name kafka-eagle \
--hostname kafka-eagle \
lushan123888/kafka-eagle:2.0.8
```

### 构建Docker镜像

1. 下载kafka-eagle安装包
2. 准备配置文件`system-config.properties`

```properties
# Multi zookeeper&kafka cluster list -- The client connection address of the Zookeeper cluster is set here
efak.zk.cluster.alias=cluster1
cluster1.zk.list=zookeeper:2181
cluster2.zk.list=xdn1:2181,xdn2:2181,xdn3:2181

# Add zookeeper acl
cluster1.zk.acl.enable=false
cluster1.zk.acl.schema=digest
#cluster1.zk.acl.username=test
#cluster1.zk.acl.password=test123

# Kafka broker nodes online list
cluster1.efak.broker.size=10
cluster2.efak.broker.size=20

# Zkcli limit -- Zookeeper cluster allows the number of clients to connect to
kafka.zk.limit.size=25

# EFAK webui port -- WebConsole port access address
efak.webui.port=8048

# Kafka offset storage -- Offset stored in a Kafka cluster, if stored in the zookeeper, you can not use this option
cluster1.efak.offset.storage=kafka
cluster2.efak.offset.storage=kafka

# Whether the Kafka performance monitoring diagram is enabled
efak.metrics.charts=false

# EFAK keeps data for 30 days by default
efak.metrics.retain=30

# If offset is out of range occurs, enable this property -- Only suitable for kafka sql
efak.sql.fix.error=false
efak.sql.topic.records.max=5000

# Delete kafka topic token -- Set to delete the topic token, so that administrators can have the right to delete
efak.topic.token=keadmin

# Kafka sasl authenticate
cluster1.efak.sasl.enable=false
cluster1.efak.sasl.protocol=SASL_PLAINTEXT
cluster1.efak.sasl.mechanism=SCRAM-SHA-256
cluster1.efak.sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required username="root" password="123456";
# If not set, the value can be empty
cluster1.efak.sasl.client.id=
# Add kafka cluster cgroups
cluster1.efak.sasl.cgroup.enable=false
cluster1.efak.sasl.cgroup.topics=kafka_ads01,kafka_ads02

cluster2.efak.sasl.enable=true
cluster2.efak.sasl.protocol=SASL_PLAINTEXT
cluster2.efak.sasl.mechanism=PLAIN
cluster2.efak.sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username="admin" password="123456";
cluster2.efak.sasl.client.id=
cluster2.efak.sasl.cgroup.enable=false
cluster2.efak.sasl.cgroup.topics=kafka_ads03,kafka_ads04

# Default use sqlite to store data
#efak.driver=org.sqlite.JDBC
# It is important to note that the '/hadoop/kafka-eagle/db' path must be exist.
#efak.url=jdbc:sqlite:/hadoop/kafka-eagle/db/ke.db
#efak.username=root
#efak.password=smartloli

# (Optional) set mysql address
efak.driver=com.mysql.jdbc.Driver
efak.url=jdbc:mysql://mysql:3306/ke?useUnicode=true&characterEncoding=UTF-8&zeroDateTimeBehavior=convertToNull
efak.username=root
efak.password=123456
```

3. 准备DockerFile

```properties
FROM openjdk:8
ARG version
WORKDIR /kafka-eagle
ENV KE_HOME=/kafka-eagle
ENV EAGLE_VERSION=$version
COPY kafka-eagle-bin-$version.tar.gz /opt
RUN tar -xf /opt/kafka-eagle-bin-$version.tar.gz -C /opt \
&& tar -xf /opt/kafka-eagle-bin-$version/efak-web-$version-bin.tar.gz  -C /kafka-eagle --strip-components=1 \
&& rm -rf /opt/* \
&& touch /kafka-eagle/logs/ke_console.out
COPY system-config.properties /kafka-eagle/conf
CMD bash /kafka-eagle/bin/ke.sh start ; sleep 3 ;tail -f /kafka-eagle/logs/ke_console.out
```

4. 进行构建

```shell
$ docker build -t lushan123888/kafka-eagle:2.0.8 --build-arg version=2.0.8 .
```

## 使用

1. 运行kafka server前,需设置JMX_PORT,否则Kafka Eagle 后台提示连接失败,执行命令行`$ export JMX_PORT=9999`设置JMX_PORT
2. 打开浏览器,在地址栏输入`http://localhost:8048/`,然后在登录页面,输入在配置文件设置的账号与密码

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-07-18-22.png)