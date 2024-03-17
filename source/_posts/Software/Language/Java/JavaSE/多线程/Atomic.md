---
title: Java Atomic
categories:
  - Software
  - Language
  - Java
  - JavaSE
  - 多线程
---
# Java Atomic

-   使用`java.util.concurrent.atomic`提供的原子操作可以简化多线程编程：
    -   原子操作实现了无锁的线程安全。
    -   适用于计数器，累加器等。
-   Atomic类是通过无锁（lock-free）的方式实现的线程安全（thread-safe）访问，它的主要原理是利用了CAS:Compare and Set
-   以`AtomicInteger`为例，它提供的主要操作有：
    -   增加值并返回新值：`int addAndGet(int delta)`
    -   加1后返回新值：`int incrementAndGet()`
    -   获取当前值：`int get()`
    -   用CAS方式设置：`int compareAndSet(int expect, int update)`
-   如果我们自己通过CAS编写`incrementAndGet()`，它大概长这样：

```java
public int incrementAndGet(AtomicInteger var) {
    int prev, next;
    do {
        prev = var.get();
        next = prev + 1;
    } while ( ! var.compareAndSet(prev, next));
    return next;
}
```

-   通过CAS操作并配合`do ... while`循环，形成了自旋锁，即使其他线程修改了`AtomicInteger`的值，最终的结果也是正确的。
-   我们利用`AtomicLong`可以编写一个多线程安全的全局唯一ID生成器：

```java
class IdGenerator {
    AtomicLong var = new AtomicLong(0);

    public long getNextId() {
        return var.incrementAndGet();
    }
}
```

-   在高度竞争的情况下，还可以使用Java 8提供的`LongAdder`和`LongAccumulator`

## CAS

-  CAS 全称是（Compare and Swap)，即比较并交换，它是一种原子操作，同时 CAS 是一种乐观锁。
-  java.util.concurrent 包很多功能都是建立在 CAS 之上，如 ReenterLock 内部的 AQS，各种原子类，其底层都用 CAS来实现原子操作。
-  在这个机制中有三个核心的参数：
    -  主内存中存放的共享变量的值：V（一般情况下这个V是内存的地址值，通过这个地址可以获得内存中的值）
    -  工作内存中共享变量的副本值，也叫预期值：A
    -  需要将共享变量更新到的最新值：B
-  当且仅当预期值 A 和内存值 V 相同时，将内存值修改为 B 并返回 true，否则什么都不做，并返回 false

### CAS的Java实现

>   CAS是一条CPU的原子指令（cmpxchg指令），不会造成所谓的数据不一致问题，Unsafe提供的CAS方法（如compareAndSwapXXX）底层实现即为CPU指令cmpxchg

-   这里我们可以看一下Java的原子类AtomicLong.getAndIncrement(）的实现，来理解一下CAS这一乐观锁（JDK 1.8)

```java
public class AtomicLong extends Number implements java.io.Serializable {
    private static final long serialVersionUID = 1927816293512124184L;

    // setup to use Unsafe.compareAndSwapLong for updates
    private static final Unsafe unsafe = Unsafe.getUnsafe();
    private static final long valueOffset;

    static {
        try {
            valueOffset = unsafe.objectFieldOffset
                (AtomicLong.class.getDeclaredField("value"));
        } catch (Exception ex) { throw new Error(ex); }
    }

    private volatile long value;
```

-   其中，valueOffset表示该变量在内存偏移地址，alueOffset的值在AtomicInteger初始化时，在静态代码块中通过Unsafe的objectFieldOffset方法获取，在AtomicInteger中提供的线程安全方法中，通过字段valueOffset的值可以定位到AtomicInteger对象中value的内存地址，从而可以根据CAS实现对value字段的原子操作。
-   看一下其中的两个典型的方法：

```java
public final boolean compareAndSet(long expect, long update) {
    return unsafe.compareAndSwapLong(this, valueOffset, expect, update);
}

public final long getAndIncrement() {
   return unsafe.getAndAddLong(this, valueOffset, 1L);
}
```

-   注意下面的图对valueOffset的标记含义，它是用来从baseAddress来检索具体的value的地址的偏移量。

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-06-12-6e8b1fe5d5993d17a4c5b69bb72ac51d89826.png" alt="img" style="zoom:50%;" />

-   看一下 `Unsafe.getAndAddLong()` 的实现：

```java
public final long getAndAddLong(Object var1, long var2, long var4) {
   long var6;
   do {
       var6 = this.getLongVolatile(var1, var2); // 不断读取volatile的值。
   } while(!this.compareAndSwapLong(var1, var2, var6, var6 + var4)); // 不断循环直到满足条件。
   return var6;
}
```

-   可以看到这个是一个非阻塞算法，非阻塞算法通常叫作乐观算法，因为它们继续操作的假设是不会有干扰，如果发现干扰，就会回退并重试。

>   这里需要注意使用了 `volatile` 原语保证了可见性，volatile变量的读操作，会强制使CPU缓存失效，强制从内存读取变量，因为并没有使用锁，只能通过其他机制保证内存的可见性问题。

### ABA问题

-   ABA问题是指在CAS操作时，其他线程将变量值A改为了B，但是又被改回了A，等到本线程使用期望值A与当前变量进行比较时，发现变量A没有变，于是CAS就将A值进行了交换操作，但是实际上该值已经被其他线程改变过，这里就是产生ABA问题的关键，因为获取和比较是两个独立的操作，在获取数据之后和比较之前由于CPU对线程的调度问题，可能会发生很多事情，也就是这里的ABA

>   比如我们常见的两个线程同时执行一个业务逻辑，如果不通过锁加以控制，同时判断某个条件是合理的，然后都去执行某一个操作，可能会对业务有一定的影响，如货物超发或者计数值为负数等，而ABA问题只不过是其中的一个特例，一个线程执行完之后恰好结果和没有变更之前的值是一样的，但是A完成了一次业务逻辑，B在某种情况下需要对这件事情加以感知来控制自身的业务是否仍照旧就执行。

#### 原子引用解决ABA问题

-   既然不能加独占锁，那么只能通过乐观锁的机制来做了，即增加版本号：每次变量更新的时候把变量的版本号加1，那么A-B-A就会变成A(v1)-B(v2)-A(v3)，只要变量被某一线程修改过，该变量对应的版本号就会发生递增变化，从而解决了ABA问题。

>   独占锁的替代就是乐观锁，即通过版本号控制，形成逻辑上的独占效果。

-   在JDK的 `java.util.concurrent.atomic`包中提供了 `AtomicStampedReference` 来解决ABA问题，该类的compareAndSet是该类的核心方法，实现如下：

```java
public boolean compareAndSet(V   expectedReference,
                            V   newReference,
                            int expectedStamp,
                            int newStamp) {
   Pair<V> current = pair;
   return
       expectedReference == current.reference &&
       expectedStamp == current.stamp &&
       ((newReference == current.reference &&
         newStamp == current.stamp) ||
        casPair(current, Pair.of(newReference, newStamp)));
}
```

-   我们可以发现，该类检查了当前引用与当前标志是否与预期相同，如果全部相等，才会以原子方式将该引用和该标志的值设为新的更新值，这样CAS操作中的比较就不依赖于变量的值了。

#### ABA影响业务的例子

-   这个还是比较难的，如果你没理解可能还是会局限于数字变化这种模糊的例子，如果真能结合业务或者实际的场景才算真的理解。
-   假设，现有一个用单向链表实现的堆栈，栈顶为A，这时线程T1已经知道A.next为B，然后希望用CAS将栈顶替换为B:

```java
head.compareAndSet(A,B);
```

-   在T1执行上面这条指令之前，线程T2介入，将A,B出栈，再push D,C,A，而对象B此时处于游离状态。
-   此时轮到线程T1执行CAS操作，检测发现栈顶仍为A，所以CAS成功，栈顶变为B，但实际上B.next为null，所以此时链表处于断裂的状态，即B是游离的，C和D是一起的，但不是栈顶元素，栈顶元素是B，但是B已经是栈里的唯一元素了，所以就造成了数据的丢失!