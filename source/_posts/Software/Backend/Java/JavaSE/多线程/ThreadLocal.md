---
title: Java ThreadLocal
categories:
- Software
- Backend
- Java
- JavaSE
- 多线程
---
# Java ThreadLocal

- ThreadLocal的作用是提供线程内的局部变量,这种变量在线程的生命周期内起作用
- **作用**:提供一个线程内公共变量(比如本次请求的用户信息),减少同一个线程内多个函数或者组件之间一些公共变量的传递的复杂度,或者为线程提供一个私有的变量副本,这样每一个线程都可以随意修改自己的变量副本,而不会对其他线程产生影响
- ThreadLoal 变量,线程局部变量,同一个 ThreadLocal 所包含的对象,在不同的 Thread 中有不同的副本,这里有几点需要注意:
  - 因为每个 Thread 内有自己的实例副本,且该副本只能由当前 Thread 使用,这是也是 ThreadLocal 命名的由来
  - 既然每个 Thread 有自己的实例副本,且其它 Thread 不可访问,那就不存在多线程间共享的问题
- ThreadLocal 提供了线程本地的实例,它与普通变量的区别在于,每个使用该变量的线程都会初始化一个完全独立的实例副本
- ThreadLocal 变量通常被private static修饰,当一个线程结束时,它所使用的所有 ThreadLocal 相对的实例副本都可被回收
- 总的来说,ThreadLocal 适用于每个线程需要自己独立的实例且该实例需要在多个方法中被使用,也即变量在线程间隔离而在方法或类间共享的场景

## ThreadLocal实现原理

- 首先 ThreadLocal 是一个泛型类,保证可以接受任何类型的对象
- 因为一个线程内可以存在多个 ThreadLocal 对象,所以其实是 ThreadLocal 内部维护了一个 Map,这个 Map 不是直接使用的 HashMap,而是 ThreadLocal 实现的一个叫做 ThreadLocalMap 的静态内部类,而我们使用的 get(),set() 方法其实都是调用了这个ThreadLocalMap类对应的 get(),set() 方法,例如下面的 set 方法:

```java
public void set(T value) {
  Thread t = Thread.currentThread();
  ThreadLocalMap map = getMap(t);
  if (map != null)
    map.set(this, value);
  else
    createMap(t, value);
}
```

- 从中我们可以发现这个Map的key是ThreadLocal类的实例对象,value为用户的值
- get方法:

```java
public T get() {
  Thread t = Thread.currentThread();
  ThreadLocalMap map = getMap(t);
  if (map != null)
    return (T)map.get(this);

  // Maps are constructed lazily.  if the map for this thread
  // doesn't exist, create it, with this ThreadLocal and its
  // initial value as its only entry.
  T value = initialValue();
  createMap(t, value);
  return value;
}
```

- createMap方法:

```java
void createMap(Thread t, T firstValue) {
  t.threadLocals = new ThreadLocalMap(this, firstValue);
}
```

- Thread类中有一个成员变量属于ThreadLocalMap类(一个定义在ThreadLocal类中的内部类),它是一个Map,他的key是ThreadLocal实例对象
- 初始容量16,负载因子2/3,解决冲突的方法是再hash法

```java
static class ThreadLocalMap {
  ........
}
```

- 最终的变量是放在了当前线程的 `ThreadLocalMap` 中,并不是存在 ThreadLocal 上,ThreadLocal 可以理解为只是ThreadLocalMap的封装,传递了变量值
- 其中ThreadLocalMap类的定义是在ThreadLocal类中,真正的引用却是在Thread类中,同时,ThreadLocalMap中用于存储数据的entry定义:

```java
static class Entry extends WeakReference<ThreadLocal<?>> {
  /** The value associated with this ThreadLocal. */
  Object value;

  Entry(ThreadLocal<?> k, Object v) {
    super(k);
    value = v;
  }
}
```

**如何实现一个线程多个ThreadLocal对象,每一个ThreadLocal对象是如何区分的呢？**

- 查看源码,可以看到:

```java
private final int threadLocalHashCode = nextHashCode();
private static AtomicInteger nextHashCode = new AtomicInteger();
private static final int HASH_INCREMENT = 0x61c88647;
private static int nextHashCode() {
      return nextHashCode.getAndAdd(HASH_INCREMENT);
}
```

- 对于每一个ThreadLocal对象,都有一个final修饰的int型的threadLocalHashCode不可变属性,对于基本数据类型,可以认为它在初始化后就不可以进行修改,所以可以唯一确定一个ThreadLocal对象
- 但是如何保证两个同时实例化的ThreadLocal对象有不同的threadLocalHashCode属性:在ThreadLocal类中,还包含了一个static修饰的AtomicInteger([əˈtɒmɪk]提供原子操作的Integer类)成员变量(即类变量)和一个static final修饰的常量(作为两个相邻nextHashCode的差值),由于nextHashCode是类变量,所以每一次调用ThreadLocal类都可以保证nextHashCode被更新到新的值,并且下一次调用ThreadLocal类这个被更新的值仍然可用,同时AtomicInteger保证了nextHashCode自增的原子性

**为什么不直接用线程id来作为ThreadLocalMap的key？**

- 这一点很容易理解,因为直接用线程id来作为ThreadLocalMap的key,无法区分放入ThreadLocalMap中的多个value,比如我们放入了两个字符串,你如何知道我要取出来的是哪一个字符串呢？
- 而使用ThreadLocal作为key就不一样了,由于每一个ThreadLocal对象都可以由threadLocalHashCode属性唯一区分或者说每一个ThreadLocal对象都可以由这个对象的名字唯一区分(下面的例子),所以可以用不同的ThreadLocal作为key,区分不同的value,方便存取

```java
public class Son implements Cloneable{
  public static void main(String[] args){
    Thread t = new Thread(new Runnable(){
      public void run(){
        ThreadLocal<Son> threadLocal1 = new ThreadLocal<>();
        threadLocal1.set(new Son());
        System.out.println(threadLocal1.get());
        ThreadLocal<Son> threadLocal2 = new ThreadLocal<>();
        threadLocal2.set(new Son());
        System.out.println(threadLocal2.get());
      }});
    t.start();
  }
}
```

## 内存泄漏问题

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-04-21-1156565-20170724121152430-1111069410.png" alt="img" style="zoom:50%;" />

- 实际上 ThreadLocalMap 中使用的 key 为 ThreadLocal 的弱引用,弱引用的特点是,如果这个对象只存在弱引用,那么在下一次垃圾回收的时候必然会被清理掉

- 所以如果 ThreadLocal 没有被外部强引用的情况下,在垃圾回收的时候会被清理掉的,这样一来 ThreadLocalMap中使用这个 ThreadLocal 的 key 也会被清理掉,但是,value 是强引用,不会被清理,这样一来就会出现 key 为 null 的 value

- ThreadLocalMap实现中已经考虑了这种情况,在调用 set(),get(),remove() 方法的时候,会清理掉 key 为 null 的记录,如果说会出现内存泄漏,那只有在出现了 key 为 null 的记录后,没有手动调用 remove() 方法,并且之后也不再调用 get(),set(),remove() 方法的情况下,ThreadLocalMap的getEntry函数的流程大概为:

  1. 首先从ThreadLocal的直接索引位置(通过ThreadLocal.threadLocalHashCode & (table.length-1)运算得到)获取Entry e,如果e不为null并且key相同则返回e

  2. 如果e为null或者key不一致则向下一个位置查询,如果下一个位置的key和当前需要查询的key相等,则返回对应的Entry,否则,如果key值为null,则擦除该位置的Entry,并继续向下一个位置查询,在这个过程中遇到的key为null的Entry都会被擦除,那么Entry内的value也就没有强引用链,自然会被回收,仔细研究代码可以发现,set操作也有类似的思想,将key为null的这些Entry都删除,防止内存泄露

     但是光这样还是不够的,上面的设计思路依赖一个前提条件:要调用ThreadLocalMap的getEntry函数或者set函数,这当然是不可能任何情况都成立的,所以很多情况下需要使用者手动调用ThreadLocal的remove函数,手动删除不再需要的ThreadLocal,防止内存泄露,所以JDK建议将ThreadLocal变量定义成private static的,这样的话ThreadLocal的生命周期就更长,由于一直存在ThreadLocal的强引用,所以ThreadLocal也就不会被回收,也就能保证任何时候都能根据ThreadLocal的弱引用访问到Entry的value值,然后remove它,防止内存泄露

- 建议回收自定义的ThreadLocal变量,尤其在线程池场景下,线程经常会被复用,如果不清理自定义的 ThreadLocal变量,可能会影响后续业务逻辑和造成内存泄露等问题,尽量在代理中使用try-finally块进行回收:

```java
objectThreadLocal.set(userInfo);
try {
  // ...
}
finally {
  objectThreadLocal.remove();
}
```

## 使用场景

- 如上文所述,ThreadLocal 适用于如下两种场景
  - 每个线程需要有自己单独的实例
  - 实例需要在多个方法中共享,但不希望被多线程共享
- 对于第一点,每个线程拥有自己实例,实现它的方式很多,例如可以在线程内部构建一个单独的实例,ThreadLoca 可以以非常方便的形式满足该需求
- 对于第二点,可以在满足第一点(每个线程有自己的实例)的条件下,通过方法间引用传递的形式实现,ThreadLocal 使得代码耦合度更低,且实现更优雅

**存储用户Session**

- 一个简单的用ThreadLocal来存储Session的例子:

```java
private static final ThreadLocal threadSession = new ThreadLocal();

public static Session getSession() throws InfrastructureException {
  Session s = (Session) threadSession.get();
  try {
    if (s == null) {
      s = getSessionFactory().openSession();
      threadSession.set(s);
    }
  } catch (HibernateException ex) {
    throw new InfrastructureException(ex);
  }
  return s;
}
```

**解决线程安全的问题**

比如Java7中的SimpleDateFormat不是线程安全的,可以用ThreadLocal来解决这个问题:

```java
public class DateUtil {
  private static ThreadLocal<SimpleDateFormat> format1 = new ThreadLocal<SimpleDateFormat>() {
    @Override
    protected SimpleDateFormat initialValue() {
      return new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    }
  };

  public static String formatDate(Date date) {
    return format1.get().format(date);
  }
}
```

- 这里的DateUtil.formatDate()就是线程安全的了,(Java8里的 `java.time.format.DateTimeFormatter`是线程安全的,Joda time里的DateTimeFormat也是线程安全的)

## ThreadLocalRandom

ThreadLocalRandom使用ThreadLocal的原理,让每个线程内持有一个本地的种子变量,该种子变量只有在使用随机数时候才会被初始化,多线程下计算新种子时候是根据自己线程内维护的种子变量进行更新,从而避免了竞争

```java
ThreadLocalRandom.current().nextInt(100)
```

