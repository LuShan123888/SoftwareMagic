---
title: Kafka API
categories:
- Software
- BackEnd
- Kafka
---
# Kafka API

## Producer API

### API生产者流程

- Kafka 的 Producer 发送消息采用的是异步发送的方式，在消息发送的过程中，涉及到了两个线程：main 线程和 sender 线程，以及一个线程共享变量： RecordAccumulator
- main 线程将消息发送给 RecordAccumulator
- sender 线程不断从 RecordAccumulator 中拉取消息发送到 Kafka broker

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-07-18-19.png)

- **batch.size**：只有数据积累到 batch.size 之后，sender 才会发送数据。
- **linger.time**：如果数据迟迟未达到 batch.size,sender 等待 linger.time 之后就会发送数据。

### 异步发送

#### 普通生产者

**pom.xml**

```xml
<dependency>
    <groupId>org.apache.kafka</groupId>
    <artifactId>kafka-clients</artifactId>
    <version>0.11.0.0</version>
</dependency>
```

**实例**

- KafkaProducer：需要创建一个生产者对象，用来发送数据。
- ProducerConfig：获取所需的一系列配置参数。
- ProducerRecord：每条数据都要封装成一个 ProducerRecord 对象。

```java
public class CustomProducer {
  public static void main(String[] args) {
    Properties props = new Properties();
    // kafka 集群，broker-list
    props.put("bootstrap.servers", "kafka:9092");
    // 可用ProducerConfig.ACKS_CONFIG 代替 "acks"
    //props.put(ProducerConfig.ACKS_CONFIG, "all");
    props.put("acks", "all");
    // 重试次数。
    props.put("retries", 1);
    // 批次大小。
    props.put("batch.size", 16384);
    // 等待时间。
    props.put("linger.ms", 1);
    // RecordAccumulator 缓冲区大小。
    props.put("buffer.memory", 33554432);
    // 序列化配置。
    props.put("key.serializer", "org.apache.kafka.common.serialization.StringSerializer");
    props.put("value.serializer", "org.apache.kafka.common.serialization.StringSerializer");
    // 基于上述配置创建生产者对象。
    Producer<String, String> producer = new KafkaProducer<>(props);
    for (int i = 0; i < 100; i++) {
      producer.send(new ProducerRecord<>("test-topic", "test-" + i, "test-" + i));
    }
    producer.close();
  }
}
```

#### 带回调函数的生产者

- 回调函数会在 producer 收到 ack 时调用，为异步调用，该方法有两个参数，分别是 RecordMetadata 和 Exception，如果 Exception 为 null，说明消息发送成功，如果Exception 不为 null，说明消息发送失败。
- **注意**：消息发送失败会自动重试，不需要我们在回调函数中手动重试。

```java
public class CallBackProducer {
  public static void main(String[] args) {
    Properties props = new Properties();
    props.put("bootstrap.servers", "kafka:9092");
    props.put("acks", "all");
    props.put("retries", 1);
    props.put("batch.size", 16384);
    props.put("linger.ms", 1);
    props.put("buffer.memory", 33554432);
    props.put("key.serializer","org.apache.kafka.common.serialization.StringSerializer");
    props.put("value.serializer","org.apache.kafka.common.serialization.StringSerializer");
    Producer<String, String> producer = new KafkaProducer<>(props);
    for (int i = 0; i < 100; i++) {
      producer.send(new ProducerRecord<String, String>("test-topic","test-" + i, new Callback() {
        // 回调函数，该方法会在 Producer 收到 ack 时调用，为异步调用。
        @Override
        public void onCompletion(RecordMetadata metadata, Exception exception) {
          if (exception == null) {
            System.out.println(metadata.partition() + " - " + metadata.offset());
          } else {
            exception.printStackTrace();
          }
        }
      });
    }
    producer.close();
  }
}
```

- ProducerRecord类有许多构造函数，其中一个参数partition可指定分区。

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-07-18-20.png)

#### 自定义分区器

```java
public class MyPartitioner implements Partitioner {
  @Override
  public void configure(Map<String, ?> configs) {
    // TODO Auto-generated method stub
  }

  @Override
  public int partition(String topic, Object key, byte[] keyBytes, Object value, byte[] valueBytes, Cluster cluster) {
    // TODO Auto-generated method stub
    return 0;
  }

  @Override
  public void close() {
    // TODO Auto-generated method stub
  }
}
```

- 具体内容填写可参考默认分区器`org.apache.kafka.clients.producer.internals.DefaultPartitioner`
- 然后Producer配置中注册使用。

```java
Properties props = new Properties();
props.put(ProducerConfig.PARTITIONER_CLASS_CONFIG, MyPartitioner.class);
Producer<String, String> producer = new KafkaProducer<>(props);
```

### 同步发送

- 同步发送的意思就是，一条消息发送之后，会阻塞当前线程，直至返回 ack
- 由于 send 方法返回的是一个 Future 对象，根据 Futrue 对象的特点，我们也可以实现同步发送的效果，只需在调用 Future 对象的 get 方法即可。

```java
Producer<String, String> producer = new KafkaProducer<>(props);
for (int i = 0; i < 100; i++) {
  producer.send(new ProducerRecord<String, String>("test",  "test - " + i), new Callback() {
    @Override
    public void onCompletion(RecordMetadata metadata, Exception exception) {
      ...
    }
  }).get();
}
```

## Consumer API

### 普通消费者

- **KafkaConsumer**：需要创建一个消费者对象，用来消费数据。
- **ConsumerConfig**：获取所需的一系列配置参数。
- **ConsuemrRecord**：每条数据都要封装成一个 ConsumerRecord 对象。
- 为了使我们能够专注于自己的业务逻辑，Kafka 提供了自动提交 offset 的功能，自动提交 offset 的相关参数：
    - **enable.auto.commit**：是否开启自动提交 offset 功能。
    - **auto.commit.interval.ms**：自动提交 offset 的时间间隔。

```java
public class CustomConsumer {
  public static void main(String[] args) {
    Properties props = new Properties();
    props.put("bootstrap.servers", "kafka:9092");
    props.put("group.id", "test-group");
    props.put("enable.auto.commit", "true");
    props.put("auto.commit.interval.ms", "1000");
    props.put("key.deserializer", "org.apache.kafka.common.serialization.StringDeserializer");
    props.put("value.deserializer", "org.apache.kafka.common.serialization.StringDeserializer");
    KafkaConsumer<String, String> consumer = new KafkaConsumer<>(props);
    // 订阅主题 test-topic
    consumer.subscribe(Collections.singletonList("test-topic"));
    while (true) {
      ConsumerRecords<String, String> records = consumer.poll(100);
      for (ConsumerRecord<String, String> record : records) {
        System.out.printf("offset = %d, key = %s, value = %s%n", record.offset(), record.key(), record.value());
      }
    }
  }
}
```

### 消费者重置offset

- 由于 consumer 在消费过程中可能会出现断电宕机等故障，consumer 恢复后，需要从故障前的位置的继续消费，所以consumer 需要实时记录自己消费到了哪个 offset，以便故障恢复后继续消费。
- 当消费者切换消费者组或数据过期失效的情况下，offset会找不到，此时可以选择不同的策略重新定位offset

```java
public static final String AUTO_OFFSET_RESET_CONFIG = "auto.offset.reset";
Properties props = new Properties();
props.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "earliest");
KafkaConsumer<String, String> consumer = new KafkaConsumer<>(props);
```

- `props.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "earliest");`与命令行中的`--from-beginning`拥有相同的作用。

> **auto.offset.reset**
>
> What to do when there is no initial offset in Kafka or if the current offset does not exist any more on the server (e.g. because that data has been deleted):
>
> - **earliest**: automatically reset the offset to the earliest offset
> - **latest**: automatically reset the offset to the latest offset
> - **none**: throw exception to the consumer if no previous offset is found for the consumer's group
> - **anything else**: throw exception to the consumer.
>
> **TYPE**:string
>
> **DEFAULT**:latest
>
> **VALID VALUES**:[latest, earliest, none]

### 消费者保存offset

#### 自动提交offset

```java
// 是否自动提交 offset
props.put("enable.auto.commit", "true");
// 自动提交 offset 的时间间隔。
props.put("auto.commit.interval.ms", "1000");
```

#### 手动提交offset

- 虽然自动提交 offset 十分便利，但由于其是基于时间提交的，开发人员难以把握offset 提交的时机，因此 **Kafka 还提供了手动提交 offset 的 API**
- 手动提交 offset 的方法有两种。
    1. commitSync（同步提交）
    2. commitAsync（异步提交）
- **相同点**：都会将本次 poll 的一批数据最高的 offset 提交。
- **不同点**:commitSync 阻塞当前线程，一直到提交成功，并且会自动失败重试（由不可控因素导致，也会出现提交失败），而 commitAsync 则没有失败重试机制，故有可能提交失败。

##### 同步提交offset

- 由于同步提交 offset 有失败重试机制，故更加可靠。

```java
public class SyncCommitOffset {
  public static void main(String[] args) {
    Properties props = new Properties();
    // 关闭自动提交 offset
    props.put("enable.auto.commit", "false");
    KafkaConsumer<String, String> consumer = new KafkaConsumer<>(props);
    consumer.subscribe(Collections.singletonList("test-topic"));
    while (true) {
      // 消费者拉取数据。
      ConsumerRecords<String, String> records = consumer.poll(100);
      for (ConsumerRecord<String, String> record : records) {
        System.out.printf("offset = %d, key = %s, value= %s%n", record.offset(), record.key(), record.value());
      }
      // 同步提交，当前线程会阻塞直到 offset 提交成功。
      consumer.commitSync();
    }
  }
}
```

##### 异步提交offset

- 虽然同步提交 offset 更可靠一些，但是由于其会阻塞当前线程，直到提交成功，因此吞吐量会收到很大的影响，因此更多的情况下，会选用异步提交 offset 的方式。

```java
public class AsyncCommitOffset {
  public static void main(String[] args) {
    Properties props = new Properties();
    // 关闭自动提交。
    props.put("enable.auto.commit", "false");
    KafkaConsumer<String, String> consumer = new KafkaConsumer<>(props);
    consumer.subscribe(Collections.singletonList("test-topic"));
    while (true) {
      ConsumerRecords<String, String> records = consumer.poll(100);
      for (ConsumerRecord<String, String> record : records) {
        System.out.printf("offset = %d, key = %s, value = %s%n", record.offset(), record.key(), record.value());
      }
      // 异步提交。
      consumer.commitAsync(new OffsetCommitCallback() {
        @Override
        public void onComplete(Map<TopicPartition, OffsetAndMetadata> offsets, Exception exception) {
          if (exception != null) {
            System.err.println("Commit failed for" + offsets);
          }
        }
      });
    }
  }
}
```

#### 数据漏消费和重复消费分析

- 无论是同步提交还是异步提交 offset，都有可能会造成数据的漏消费或者重复消费，先提交 offset 后消费，有可能造成数据的漏消费，而先消费后提交 offset，有可能会造成数据的重复消费。

#### 自定义存储 offset

- Kafka 0.9 版本之前，offset 存储在 zookeeper,0.9 版本及之后，默认将 offset 存储在 Kafka的一个内置的 topic 中，除此之外，Kafka 还可以选择自定义存储 offset
- offset 的维护是相当繁琐的，因为需要考虑到消费者的 Rebalace
    - 当有新的消费者加入消费者组，已有的消费者推出消费者组或者所订阅的主题的分区发生变化，就会触发到分区的重新分配，重新分配的过程叫做 Rebalance
    - 消费者发生 Rebalance 之后，每个消费者消费的分区就会发生变化，因此消费者要首先获取到自己被重新分配到的分区，并且定位到每个分区最近提交的 offset 位置继续消费。
- 要实现自定义存储 offset，需要借助 `ConsumerRebalanceListener`，以下为示例代码，其中提交和获取 offset 的方法，需要根据所选的 offset 存储系统自行实现，（可将offset存入MySQL数据库）

```java
public class CustomSaveOffset {
  private static Map<TopicPartition, Long> currentOffset = new HashMap<>();
  public static void main(String[] args) {
    Properties props = new Properties();
    // 关闭自动提交 offset
    props.put("enable.auto.commit", "false");
    // 创建一个消费者。
    KafkaConsumer<String, String> consumer = new KafkaConsumer<>(props);
    // 消费者订阅主题。
    consumer.subscribe(Arrays.asList("first"),  new ConsumerRebalanceListener() {
      // 该方法会在 Rebalance 之前调用。
      @Override
      public void onPartitionsRevoked(Collection<TopicPartition> partitions) {
        commitOffset(currentOffset);
      }

      // 该方法会在 Rebalance 之后调用。
      @Override
      public void onPartitionsAssigned(Collection<TopicPartition> partitions) {
        currentOffset.clear();
        for (TopicPartition partition : partitions) {
          consumer.seek(partition, getOffset(partition));// 定位到最近提交的 offset 位置继续消费。
        }
      }
    });

    while (true) {
      ConsumerRecords<String, String> records = consumer.poll(100);// 消费者拉取数据。
      for (ConsumerRecord<String, String> record : records) {
        System.out.printf("offset = %d, key = %s, value = %s%n", record.offset(), record.key(), record.value());
        currentOffset.put(new TopicPartition(record.topic(), record.partition()), record.offset());
      }
      commitOffset(currentOffset);// 异步提交。
    }
  }

  // 获取某分区的最新 offset
  private static long getOffset(TopicPartition partition) {
    // TODO
  }

  // 提交该消费者所有分区的 offset
  private static void commitOffset(Map<TopicPartition, Long> currentOffset) {
    // TODO
  }
}
```

## 自定义拦截器

### 拦截器原理

- Producer 拦截器（interceptor）是在 Kafka 0.10 版本被引入的，主要用于实现 clients 端的定制化控制逻辑。

- 对于 producer 而言，interceptor 使得用户在消息发送前以及 producer 回调逻辑前有机会对消息做一些定制化需求，比如`修改消息`等，同时，producer 允许用户指定多个 interceptor按序作用于同一条消息从而形成一个拦截链（interceptor chain)

- Intercetpor 的实现接口是`org.apache.kafka.clients.producer.ProducerInterceptor`，其定义的方法包括。

    - `configure(configs)`：获取配置信息和初始化数据时调用。
    - `onSend(ProducerRecord)`：该方法封装进 KafkaProducer.send 方法中，即它运行在用户主线程中，Producer 确保**在消息被序列化以及计算分区前**调用该方法，用户可以在该方法中对消息做任何操作，但最好保证不要修改消息所属的 topic 和分区，否则会影响目标分区的计算。
    - `onAcknowledgement(RecordMetadata, Exception)`：该方法会在消息从 RecordAccumulator 成功发送到 Kafka Broker 之后，或者在发送过程中失败时调用，并且通常都是在 producer 回调逻辑触发之前，onAcknowledgement 运行在producer 的 IO 线程中，因此不要在该方法中放入很重的逻辑，否则会拖慢 producer 的消息发送效率。
    - `close()`：关闭 interceptor，主要用于执行一些**资源清理**工作。

    - 如前所述，interceptor 可能被运行在多个线程中，因此在具体实现时用户需要自行确保线程安全，另外**倘若指定了多个 interceptor，则 producer 将按照指定顺序调用它们**，并仅仅是捕获每个 interceptor 可能抛出的异常记录到错误日志中而非在向上传递，这在使用过程中要特别留意。

### 实例

- 实现一个简单的双 interceptor 组成的拦截链。
- 第一个 interceptor 会在消息发送前将时间戳信息加到消息 value 的最前部。
- 第二个 interceptor 会在消息发送后更新成功发送消息数或失败发送消息数。

#### 增加时间戳拦截器

```java
public class TimeInterceptor implements ProducerInterceptor<String, String> {
  @Override
  public void configure(Map<String, ?> configs) {
  }

  @Override
  public ProducerRecord<String, String> onSend(ProducerRecord<String, String> record) {
    // 创建一个新的 record，把时间戳写入消息体的最前部。
    return new ProducerRecord(record.topic(), record.partition(), record.timestamp(), record.key(), "TimeInterceptor: " + System.currentTimeMillis() + "," + record.value().toString());
  }

  @Override
  public void close() {
  }

  @Override
  public void onAcknowledgement(RecordMetadata metadata, Exception exception) {
    // TODO Auto-generated method stub
  }
}
```

#### 增加消息统计拦截器

- 统计发送消息成功和发送失败消息数，并在 producer 关闭时打印这两个计数器。

```java
public class CounterInterceptor implements ProducerInterceptor<String, String>{

  private int errorCounter = 0;
  private int successCounter = 0;

  @Override
  public void configure(Map<String, ?> configs) {
    // TODO Auto-generated method stub
  }

  @Override
  public ProducerRecord<String, String> onSend(ProducerRecord<String, String> record) {
    return record;
  }

  @Override
  public void onAcknowledgement(RecordMetadata metadata, Exception exception) {
    // 统计成功和失败的次数。
    if (exception == null) {
      successCounter++;
    } else {
      errorCounter++;
    }
  }

  @Override
  public void close() {
    // 保存结果。
    System.out.println("Successful sent: " + successCounter);
    System.out.println("Failed sent: " + errorCounter);
  }
}
```

#### producer 主程序

```java
public class InterceptorProducer {
  public static void main(String[] args) {
    Properties props = new Properties();
    props.put("bootstrap.servers", "kafka:9092");
    props.put("acks", "all");
    props.put("retries", 3);
    props.put("batch.size", 16384);
    props.put("linger.ms", 1);
    props.put("buffer.memory", 33554432);
    props.put("key.serializer", "org.apache.kafka.common.serialization.StringSerializer");
    props.put("value.serializer", "org.apache.kafka.common.serialization.StringSerializer");
    // 构建拦截链。
    List<String> interceptors = new ArrayList<>();
    interceptors.add("com.lun.kafka.interceptor.TimeInterceptor");
    interceptors.add("com.lun.kafka.interceptor.CounterInterceptor");
    props.put(ProducerConfig.INTERCEPTOR_CLASSES_CONFIG, interceptors);

    Producer<String, String> producer = new KafkaProducer<>(props);
    for (int i = 0; i < 10; i++) {
      ProducerRecord<String, String> record = new ProducerRecord<>("test-topic", "message" + i);
      producer.send(record);
    }
    producer.close();
  }
}
```

**测试**

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-07-18-21.png)
