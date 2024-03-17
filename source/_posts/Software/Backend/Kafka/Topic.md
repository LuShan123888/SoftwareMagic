---
title: Kafka Topic
categories:
- Software
- BackEnd
- Kafka
---
# Kafka Topic

### 创建Topic

```bash
$ kafka-topics.sh --create --zookeeper zookeeper:2181 --replication-factor 1 --partitions 1 --topic test-replicated-topic
```

- `--topic`:定义 topic 名
- `--replication-factor`:定义副本数，副本数要小于等于broker数
- `--partitions`:定义分区数

> 为了实现扩展性，一个非常大的 topic 可以分布到多个 broker(即服务器)上，一个 topic 可以分为多个 partition,每个 partition 是一个有序的队列

### 查看所有Topic

```bash
$ kafka-topics.sh --list --zookeeper zookeeper:2181
```

### 查看某个Topic的详情

```bash
$ kafka-topics.sh --zookeeper zookeeper:2181 --describe --topic test-topic
```

### 删除Topic

```bash
$ kafka-topics.sh --zookeeper zookeeper:2181 --delete --topic test-topic
```

- 可以在`server.properties`中设置 `delete.topic.enable=true` 否则只是标记删除

### 修改Topic分区数

```bash
$ kafka-topics.sh --zookeeper zookeeper:2181 --alter --topic  test-topic --partitions 3
```

### 发送消息

```bash
$ kafka-console-producer.sh --broker-list kafka:9092 --topic test-topic

>hello, kafka.
>test message
```

### 消费消息

```bash
$ kafka-console-consumer.sh --bootstrap-server kafka:9092 --topic test-topic --from-beginning

hello, kafka.
test message
```

- `--from-beginning`:会把主题中以往所有的数据都读取出来