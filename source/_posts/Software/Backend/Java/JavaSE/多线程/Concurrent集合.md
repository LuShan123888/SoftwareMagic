---
title: Java Concurrent集合
categories:
- Software
- Backend
- Java
- JavaSE
- 多线程
---
# Java Concurrent集合

- 使用`java.util.concurrent`包提供的线程安全的并发集合可以大大简化多线程编程
- 尽量使用Java标准库提供的并发集合，避免自己编写同步代码
- 针对`List`、`Map`、`Set`、`Deque`等，`java.util.concurrent`包也提供了对应的并发集合类:

| interface | non-thread-safe         | thread-safe                              |
| :-------- | :---------------------- | :--------------------------------------- |
| List      | ArrayList               | CopyOnWriteArrayList                     |
| Map       | HashMap                 | ConcurrentHashMap                        |
| Set       | HashSet / TreeSet       | CopyOnWriteArraySet                      |
| Queue     | ArrayDeque / LinkedList | ArrayBlockingQueue / LinkedBlockingQueue |
| Deque     | ArrayDeque / LinkedList | LinkedBlockingDeque                      |

- `java.util.Collections`工具类还提供了一些旧的线程安全集合转换器，可以这么用：

```java
Collections.synchronizedMap(new HashMap(););
Collections.synchronizedSet(new HashSet<>());
```

- 但是它实际上是用一个包装类包装了非线程安全的集合，然后对所有读写方法都用`synchronized`加锁，这样获得的线程安全集合的性能比`java.util.concurrent`集合要低很多，所以不推荐使用。

## CopyOnWrite

- CopyOnWrite(写入时复制COW):计算机程序设计领域的一种优化策略,多个线程调用的时候，list，读取的时候，固定的，写入(覆盖),在写入的时候避免覆盖，造成数据问题

```java
package com.kuang.unsafe; import java.util.*;
import java.util.concurrent.CopyOnWriteArrayList;
// java.util.ConcurrentModificationException 并发修改异常! 
public class ListTest {
  public static void main(String[] args) {

    List<String> list = new CopyOnWriteArrayList<>();
    for (int i = 1; i <= 10; i++) {
      new Thread(()->{
        list.add(UUID.randomUUID().toString().substring(0,5));
        System.out.println(list); 
      },String.valueOf(i)).start();
    }
  }
}
```

```java
public class SetTest {
  public static void main(String[] args) {
    Set<String> set = new CopyOnWriteArraySet<>();
    for (int i = 1; i <=30 ; i++) { 
      new Thread(()->{
        set.add(UUID.randomUUID().toString().substring(0,5));
        System.out.println(set); },String.valueOf(i)).start();
    }
  } 
}
```

## ConcurrentHashMap

-   Concurrenthashmap是线程安全的

-   JDK1.7

    -   采用Segment + HashEntry的方式进行实现的，Segment 类继承于 ReentrantLock 类，从而使得 Segment 对象能充当锁的角色。每个 Segment 对象用来守护其（成员对象 table 中）包含的若干个桶。
    -   size的计算是先采用不加锁的方式，连续计算元素的个数，最多计算3次：
        1.  如果前后两次计算结果相同，则说明计算出来的元素个数是准确的
        2.  如果前后两次计算结果都不同，则给每个Segment进行加锁，再计算一次元素的个数；

    -   ConcurrentHashMap 类中包含两个静态内部类 HashEntry 和 Segment。HashEntry 用来封装映射表的键 / 值对；Segment 用来充当锁的角色，每个 Segment 对象守护整个散列映射表的若干个桶。每个桶是由若干个 HashEntry 对象链接起来的链表。一个 ConcurrentHashMap 实例中包含由若干个 Segment 对象组成的数组。HashEntry 用来封装散列映射表中的键值对。在 HashEntry 类中，key，hash 和 next 域都被声明为 final 型，value 域被声明为 volatile 型。
    -   在ConcurrentHashMap 中，在散列时如果产生“碰撞”，将采用“分离链接法”来处理“碰撞”：把“碰撞”的 HashEntry 对象链接成一个链表。由于 HashEntry 的 next 域为 final 型，所以新节点只能在链表的表头处插入。 由于只能在表头插入，所以链表中节点的顺序和插入的顺序相反。

-   JDK1.8

    -   放弃了Segment臃肿的设计，取而代之的是采用Node + CAS + Synchronized来保证并发安全进行实现
    -   使用一个volatile类型的变量baseCount记录元素的个数，当插入新数据或则删除数据时，会通过addCount()方法更新baseCount，通过累加baseCount和CounterCell数组中的数量，即可得到元素的总个数

```java
public class MapTest {
  public static void main(String[] args) {
    for (int i = 1; i <=30; i++) { 
      new Thread(()->{
        map.put(Thread.currentThread().getName(),UUID.randomUUID().toString().substring( 0,5));
        System.out.println(map); },String.valueOf(i)).start();
    }
  }
}
```

## BlockingQueue

### ArrayBlockingQueue / LinkedBlockingQueue

-   试图插元素到一个满的队列会被阻塞，从空队列里面取元素也会被阻塞
-   `void put(E e)`：插入元素，如果队列满则一直等待。插null会抛出NullPointerException，等待的时候被打断会抛出InterruptedException
-   `E take()`：拿出队头的元素，返回该元素，队列空一直等待，和put对应
-   `boolean offer(E e,long timeout,TimeUnit unit)`：插入元素，成功返回true，队列满则等待一定的时间,如果超时返回false。就是说直接放弃了此次操作
-   `E poll(E e,long timeout,TimeUnit unit)`：拿出队头元素，成功返回true，队列满则等待一定的时间,如果超时返回false,和offer对应

```java
public static void test() throws InterruptedException { 
  ArrayBlockingQueue blockingQueue = new ArrayBlockingQueue<>(3);
  blockingQueue.put("a");
  blockingQueue.put("b");
  blockingQueue.put("c");
  blockingQueue.put("d"); // 队列没有位置了，一直阻塞
  System.out.println(blockingQueue.take()); 
  System.out.println(blockingQueue.take()); 
  System.out.println(blockingQueue.take()); 
  System.out.println(blockingQueue.take()); // 队列为空，一直阻塞
}
```

```java
public static void test() throws InterruptedException {
  ArrayBlockingQueue blockingQueue = new ArrayBlockingQueue<>(3);
  blockingQueue.offer("a");
  blockingQueue.offer("b");
  blockingQueue.offer("c");
  blockingQueue.offer("d",2,TimeUnit.SECONDS); // 等待超过2秒就退出
  System.out.println("==============="); 
  System.out.println(blockingQueue.poll()); 
  System.out.println(blockingQueue.poll()); 
  System.out.println(blockingQueue.poll()); 
  blockingQueue.poll(2,TimeUnit.SECONDS); // 等待超过2秒就退出
}
```

### LinkedBlockingDeque

-   LinkedBlockingQueue是一个单向链表实现的阻塞队列。
-   该队列按 FIFO（先进先出）排序元素，新元素插入到队列的尾部，并且队列获取操作会获得位于队列头部的元素。
-   链接队列的吞吐量通常要高于基于数组的队列，但是在大多数并发应用程序中，其可预知的性能要低。
-   此外，LinkedBlockingQueue还是可选容量的(防止过度膨胀)，即可以指定队列的容量。如果不指定，默认容量大小等于Integer.MAX_VALUE。

```java
public class LinkedBlockingQueueDemo1 { 
  private static Queue<String> queue = new LinkedBlockingQueue<String>(); 
  public static void main(String[] args) { 
    // 同时启动两个线程对queue进行操作！ 
    new MyThread("ta").start(); 
    new MyThread("tb").start(); 
  } 

  private static void printAll() { 
    String value; 
    Iterator iter = queue.iterator(); 
    while(iter.hasNext()) { 
      value = (String)iter.next(); 
      System.out.print(value+", "); 
    } 
    System.out.println(); 
  } 

  private static class MyThread extends Thread { 
    MyThread(String name) { 
      super(name); 
    } 

    @Override 
    public void run() { 
      int i = 0; 
      while (i++ < 6) { 
        String val = Thread.currentThread().getName()+i;
        queue.add(val); 
        printAll(); 
      } 
    } 
}
```

### SynchronousQueue

-   SynchronousQueue，实际上它不是一个真正的队列，因为它不会为队列中元素维护存储空间。与其他队列不同的是，它维护一组线程，这些线程在等待着把元素加入或移出队列。
-   因为SynchronousQueue没有存储功能，因此put和take会一直阻塞，直到有另一个线程已经准备好参与到交付过程中。仅当有足够多的消费者，并且总是有一个消费者准备好获取交付的工作时，才适合使用同步队列。

```java
public class SynchronousQueueExample {

  static class SynchronousQueueProducer implements Runnable {
    protected BlockingQueue<String> blockingQueue;
    final Random random = new Random();

    public SynchronousQueueProducer(BlockingQueue<String> queue) {
      this.blockingQueue = queue;
    }

    @Override
    public void run() {
      while (true) {
        try {
          String data = UUID.randomUUID().toString();
          System.out.println("Put: " + data);
          blockingQueue.put(data);
          Thread.sleep(1000);
        } catch (InterruptedException e) {
          e.printStackTrace();
        }
      }
    }

  }

  static class SynchronousQueueConsumer implements Runnable {
    protected BlockingQueue<String> blockingQueue;
    public SynchronousQueueConsumer(BlockingQueue<String> queue) {
      this.blockingQueue = queue;
    }

    @Override
    public void run() {
      while (true) {
        try {
          String data = blockingQueue.take();
          System.out.println(Thread.currentThread().getName()
                             + " take(): " + data);
          Thread.sleep(2000);
        } catch (InterruptedException e) {
          e.printStackTrace();
        }
      }
    }
  }

  public static void main(String[] args) {
    final BlockingQueue<String> synchronousQueue = new SynchronousQueue<String>();
    SynchronousQueueProducer queueProducer = new SynchronousQueueProducer(
      synchronousQueue);
    new Thread(queueProducer).start();
    SynchronousQueueConsumer queueConsumer1 = new SynchronousQueueConsumer(
      synchronousQueue);
    new Thread(queueConsumer1).start();
    SynchronousQueueConsumer queueConsumer2 = new SynchronousQueueConsumer(
      synchronousQueue);
    new Thread(queueConsumer2).start();
  }
}
```