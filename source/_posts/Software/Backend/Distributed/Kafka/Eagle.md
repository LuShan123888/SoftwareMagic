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

## 初始化

### 下载

- 地址:https://www.oschina.net/action/GoToLink?url=http%3A%2F%2Fdownload.kafka-eagle.org%2F

### 解压并配置环境变量

```bash
$ tar -zxvf kafka-eagle-xxx-bin.tar.gz
$ export KE_HOME=/data/soft/new/kafka-eagle
$ export PATH=$PATH:$KE_HOME/bin
```

### 修改配置文件

- `%KE_HOME%\conf\system-config.properties`

```properties
######################################
# multi zookeeper&kafka cluster list
######################################<---设置ZooKeeper的IP地址
kafka.eagle.zk.cluster.alias=cluster1
cluster1.zk.list=localhost:2181

######################################
# zk client thread limit
######################################
kafka.zk.limit.size=25

######################################
# kafka eagle webui port
######################################
kafka.eagle.webui.port=8048

######################################
# kafka offset storage
######################################
cluster1.kafka.eagle.offset.storage=kafka
#cluster2.kafka.eagle.offset.storage=zk

######################################
# enable kafka metrics
######################################<---metrics.charts从false改成true
kafka.eagle.metrics.charts=true
kafka.eagle.sql.fix.error=false

######################################
# kafka sql topic records max
######################################
kafka.eagle.sql.topic.records.max=5000

######################################
# alarm email configure
######################################
kafka.eagle.mail.enable=false
kafka.eagle.mail.sa=alert_sa@163.com
kafka.eagle.mail.username=alert_sa@163.com
kafka.eagle.mail.password=mqslimczkdqabbbh
kafka.eagle.mail.server.host=smtp.163.com
kafka.eagle.mail.server.port=25

######################################
# alarm im configure
######################################
#kafka.eagle.im.dingding.enable=true
#kafka.eagle.im.dingding.url=https://oapi.dingtalk.com/robot/send?access_token=

#kafka.eagle.im.wechat.enable=true
#kafka.eagle.im.wechat.token=https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=xxx&corpsecret=xxx
#kafka.eagle.im.wechat.url=https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=
#kafka.eagle.im.wechat.touser=
#kafka.eagle.im.wechat.toparty=
#kafka.eagle.im.wechat.totag=
#kafka.eagle.im.wechat.agentid=

######################################
# delete kafka topic token
######################################
kafka.eagle.topic.token=keadmin

######################################
# kafka sasl authenticate
######################################
cluster1.kafka.eagle.sasl.enable=false
cluster1.kafka.eagle.sasl.protocol=SASL_PLAINTEXT
cluster1.kafka.eagle.sasl.mechanism=PLAIN
cluster1.kafka.eagle.sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username="admin" password="kafka-eagle";

#cluster2 在此没有用到,将其注释掉
#cluster2.kafka.eagle.sasl.enable=false
#cluster2.kafka.eagle.sasl.protocol=SASL_PLAINTEXT
#cluster2.kafka.eagle.sasl.mechanism=PLAIN
#cluster2.kafka.eagle.sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username="admin" password="kafka-eagle";

######################################
# kafka jdbc driver address
######################################
kafka.eagle.driver=com.mysql.jdbc.Driver
kafka.eagle.url=jdbc:mysql://localhost:3306/test?useSSL=false&useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai
#进入系统需要用到的账号与密码
kafka.eagle.username=root
kafka.eagle.password=123456
```

## 运行

1. 运行ZooKeeper
2. 运行Kafka集群,另外运行kafka server前,需设置JMX_PORT,否则Kafka Eagle 后台提示连接失败,执行命令行`$ set JMX_PORT=9999 & kafka-server-start.bat config\server.properties start`设置JMX_PORT且运行Kafkaserver
3. `$ %KE_HOME%\bin\ke.sh`,运行Kafka Eagle
4. 打开浏览器,在地址栏输入`http://localhost:8048/ke/`,然后在登录页面,输入在配置文件`%KE_HOME%\conf\system-config.properties`设置的账号与密码
5. 登录成功,便可进入Kafka Eagle

![img](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-07-18-22.png)