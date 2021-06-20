---
title: Java Thread
categories:
- Software
- Backend
- Java
- JavaSE
- 多线程
---
# Java Thread

用Java编写多线程代码有两种方式:第1种是直接继承Java的线程类Thread,第二种方法是实现Runnable接口,无论采用哪种方法均需要在程序中编写`run()`方法,线程在运行时要完成的任务在该方法中实现

## Thread类简介

Thread类综合了Java程序中一个线程需要拥有的属性和方法,它的构造方法为:

```java
public Thread(ThreadGroup group,Runnable target,String name);
```

- `group`指明该线程所属的线程
- `target`为实际执行线程体的目标对象,它必须实现接口Runnable
- `name`为线程名

- 以下构造方法为缺少某些参数的情形:

```java
public Thread();
public Thread(Runnable target);
public Thread(Runnable target,String name);
public Thread(String name);
public Thread(ThreadGroup group,Runnable target);
public Thread(ThreadGroup group,String name);
```

- 线程组是为了方便访问一组线程引入的,例如,通过执行线程组的`interrupt()`方法,可以中断该组所有线程的执行,但如果当前线程无权修改线程组时将产生异常,实际应用中较少用到线程组
- 下表为Thread类的主要方法简介

| 方法                 | 功能                                            |
| -------------------- | ----------------------------------------------- |
| currentThread()      | 返回当前运行的Thread对象                        |
| start()              | 启动线程                                        |
| run()                | 由调度程序调用,当run()方法返回时,该线程停止     |
| sleep(int n)         | 是线程睡眠n毫秒,n毫秒后,线程可以再次运行        |
| setPriority(int p)   | 设置线程优先级                                  |
| getPriority()        | 返回线程优先级                                  |
| join()               | 其他线程要等待调用该方法的线程结束后,再往下执行 |
| suspend()            | 使线程挂起,JDK已不建议使用的方法                |
| resume()             | 恢复挂起的线程,JDK已不建议使用的方法            |
| yield()              | 将CPU控制权主动移交到下一个可运行的线程         |
| setName(String name) | 赋予线程一个名字                                |
| getName()            | 取得代表线程名字的字符串                        |
| stop()               | 停止线程的执行                                  |

- Thread类封装了线程的行为,继承Thread类须重写`run()`方法实现线程的任务,注意,程序中不要直接调用此方法,而是调用线程对象的`start()`方法启动线程,让其进入可调度状态,线程获得调度时将自动执行`run()`方法

## 创建线程

### 继承Thread类实现多线程

**[例12-1]**直接继承Thread类实现多线程

```java
import java.util.*;
class TimePrinter extends Thread {
  int pauseTime;    //中间休息时间
  String name;      //名称标识

  public TimePrinter(int x, String n) {
    pauseTime = x;
    name = n;
  }

  public void run() {
    while (true) {
      try {
        System.out.println(name + ": " + Calendar.getInstance().getTime());
        Thread.sleep(pauseTime);    //让线程睡眠一段时间
      } catch (InterruptedException e) {
      }
    }
  }

  public static void main(String[] args) {
    TimePrinter tp1 = new TimePrinter(1000, "Fast");
    tp1.start();
    TimePrinter tp2 = new TimePrinter(3000, "Slow");
    tp2.start();
  }
}

Fast: Sun Jan 12 11:50:24 CST 2020
Fast: Sun Jan 12 11:50:25 CST 2020
Fast: Sun Jan 12 11:50:26 CST 2020
Slow: Sun Jan 12 11:50:27 CST 2020
Fast: Sun Jan 12 11:50:27 CST 2020
Fast: Sun Jan 12 11:50:28 CST 2020
Fast: Sun Jan 12 11:50:29 CST 2020
Slow: Sun Jan 12 11:50:30 CST 2020
...
```

- 运行程序,可看到两个线程按两个不同的时间间隔显示当前时间,睡眠时间长的线程运行机会自然少
- **注意**:如果包括主线程,实际上有3个线程在运行,主线程从`mian()`方法开始执行,启动完两个新线程后首先停止,其他两个线程的`run()`方法被设计为无限循环,必须靠按Ctrl+C快捷键强行结束

## 停止线程

- 不推荐使用JDK提供的`stop()`和`destroy()`方法(已废弃)
- 建议在其他线程中对目标线程调用`interrupt()`方法,目标线程需要反复检测自身状态是否是interrupted状态,如果是,就立刻结束运行

```java
public class Main {
    public static void main(String[] args) throws InterruptedException {
        Thread t = new MyThread();
        t.start();
        Thread.sleep(1); // 暂停1毫秒
        t.interrupt(); // 中断t线程
        t.join(); // 等待t线程结束
        System.out.println("end");
    }
}

class MyThread extends Thread {
    public void run() {
        int n = 0;
        while (! isInterrupted()) {
            n ++;
            System.out.println(n + " hello!");
        }
    }
}
```

- `main`线程通过调用`t.interrupt()`方法中断`t`线程,但是要注意,`interrupt()`方法仅仅向`t`线程发出了"中断请求”,至于`t`线程是否能立刻响应,要看具体代码,而`t`线程的`while`循环会检测`isInterrupted()`,所以上述代码能正确响应`interrupt()`请求,使得自身立刻结束运行`run()`方法
- 如果线程处于等待状态,例如,`t.join()`会让`main`线程进入等待状态,此时,如果对`main`线程调用`interrupt()`,`join()`方法会立刻抛出`InterruptedException`,因此,目标线程只要捕获到`join()`方法抛出的`InterruptedException`,就说明有其他线程对其调用了`interrupt()`方法,通常情况下该线程应该立刻结束运行

```java
public static void main(String[] args) throws InterruptedException {
  Thread t = new MyThread();
  t.start();
  Thread.sleep(1000);
  t.interrupt(); // 中断t线程
  t.join(); // 等待t线程结束
  System.out.println("end");
}
}

class MyThread extends Thread {
  public void run() {
    Thread hello = new HelloThread();
    hello.start(); // 启动hello线程
    try {
      hello.join(); // 等待hello线程结束
    } catch (InterruptedException e) {
      System.out.println("interrupted!");
    }
    hello.interrupt();
  }
}

class HelloThread extends Thread {
  public void run() {
    int n = 0;
    while (!isInterrupted()) {
      n++;
      System.out.println(n + " hello!");
      try {
        Thread.sleep(100);
      } catch (InterruptedException e) {
        break;
      }
    }
  }
}
```

- `main`线程通过调用`t.interrupt()`从而通知`t`线程中断,而此时`t`线程正位于`hello.join()`的等待中,此方法会立刻结束等待并抛出`InterruptedException`
- 由于我们在`t`线程中捕获了`InterruptedException`,因此,就可以准备结束该线程,在`t`线程结束前,对`hello`线程也进行了`interrupt()`调用通知其中断,如果去掉这一行代码,可以发现`hello`线程仍然会继续运行,且JVM不会退出
- 另一个常用的中断线程的方法是设置标志位,我们通常会用一个`running`标志位来标识线程是否应该继续运行,在外部线程中,通过把`HelloThread.running`置为`false`,就可以让线程结束:

```java
public class Main {
  public static void main(String[] args)  throws InterruptedException {
    HelloThread t = new HelloThread();
    t.start();
    Thread.sleep(1);
    t.running = false; // 标志位置为false
  }
}

class HelloThread extends Thread {
  public volatile boolean running = true;
  public void run() {
    int n = 0;
    while (running) {
      n ++;
      System.out.println(n + " hello!");
    }
    System.out.println("end!");
  }
}
```

- 注意到`HelloThread`的标志位`boolean running`是一个线程间共享的变量,线程间共享变量需要使用`volatile`关键字标记,确保每个线程都能读取到更新后的变量值

## 线程休眠

- 一定是当前线程调用此方法,当前线程进入TIMED_WAITING状态,但不释放对象锁,millis后线程自动苏醒进入就绪状态

```java
class TestSleep implements Runnable {
  int pauseTime;    //中间休息时间
  String name;      //名称标识

  public TestSleep(int x, String n) {
    pauseTime = x;
    name = n;
  }

  public void run() {
    while (true) {
      try {
        Thread.sleep(pauseTime);    //让线程睡眠一段时间
        System.out.println(name + " Sleep" + pauseTime + " ms");
      } catch (InterruptedException e) {
      }
    }
  }

  public static void main(String[] args) {
    Thread tp1 = new Thread(new TestSleep(1000, "Thread 1"));
    tp1.start();
    for (int k = 0; k < 100; k++) {
      try {
        Thread.sleep(3000);//主线程睡眠一段时间
      } catch (InterruptedException e) {
      }
      System.out.println("Main Thread Sleep 3000ms");
    }
  }
}
```

## 线程让步

- 一定是当前线程调用此方法,当前线程放弃获取的CPU时间片,但不释放锁资源,由运行状态变为就绪状态,让OS再次选择线程

```java
class TestYield implements Runnable {

  public void run() {
    System.out.println(Thread.currentThread().getName() + "线程开始执行");
    Thread.yield();//线程让步
    System.out.println(Thread.currentThread().getName() + "线程停止执行");
  }

  public static void main(String[] args) {
    TestYield test = new TestYield();
    new Thread(test, "test1").start();
    new Thread(test, "test2").start();
  }
}
```

## 线程插入

- 当前线程里调用其它线程t的join方法,当前线程进入`WAITING/TIMED_WAITING`状态,当前线程不会释放已经持有的对象锁,线程t执行完毕或者millis时间到,当前线程一般情况下进入RUNNABLE状态,也有可能进入BLOCKED状态(因为join是基于wait实现的)

```java
class TestJoin implements Runnable {

  public void run() {
    for (int i = 0; i < 10; i++) {
      System.out.println("测试线程: " + i);
    }
  }

  public static void main(String[] args) throws InterruptedException {
    //启动测试线程
    TestJoin test = new TestJoin();
    Thread thread = new Thread(test);
    thread.start();

    //主线程
    for (int i = 0; i < 100; i++) {
      if (i == 20) {
        thread.join();//线程插入
      }
      System.out.println("主线程: " + i);
    }
  }
}
```

## 线程状态

- `Thread.State`为线程状态,线程可以处于以下状态之一
    - `NEW`:尚未启动的线程处于此状态
    - `RUNNABLE`:在Java虚拟机中执行的线程处于此状态
    - `BLOCKED`:被阻塞等待监视器锁定的线程处于此状态
    - `WAITING`:正在等待另一个线程执行特定动作的线程处于此状态
    - `TIMED_WAITING`:正在等待另一个线程执行动作达到指定等待时间的线程处于此状态
    - `TERMINATED`:已退出的线程处于此状态
- 一个线程可以在给定时间点处于一个状态,这些状态是不反映任何操作系统线程状态的虚拟机状态

```java
class TestState implements Runnable {

  public void run() {
    for (int i = 0; i < 10; i++) {
      try {
        Thread.sleep(500);
      } catch (InterruptedException e) {
        e.printStackTrace();
      }
      System.out.println("测试线程: " + i);
    }
  }

  public static void main(String[] args) throws InterruptedException {
    TestState test = new TestState();
    Thread thread = new Thread(test);

    //观察线程状态
    Thread.State state = thread.getState();
    System.out.println(state);

    //启动测试线程
    thread.start();

    //只要线程不终止,就一直输出状态
    while (state != Thread.State.TERMINATED) {
      Thread.sleep(500);
      state = thread.getState();
      System.out.println(state);
    }
  }
}
```

## 线程优先级

- 线程的优先级用数字来表示,范围从1~10,主线程的默认优先级为5,其他线程的优先级与创建它的父线程的优先级相同,为了方便,Thread类提供了如下几个常量来表示优先级:
    - `Thread.MIN_PRIORITY=1`
    - `Thread.MAX_PRIORITY=10`
    - `Thread.NORM_PRIORITY=5`
- `getPriority()`:获取线程优先级
- `setPriority()`:设置线程优先级

```java
class TestPriority implements Runnable {

  public void run() {
    try {
      Thread.sleep(500);
    } catch (InterruptedException e) {
      e.printStackTrace();
    }
    System.out.println(Thread.currentThread().getName() + "-->" + Thread.currentThread().getPriority());
  }

  public static void main(String[] args) {
    TestPriority test = new TestPriority();
    Thread t1 = new Thread(test);
    Thread t2 = new Thread(test);
    Thread t3 = new Thread(test);
    Thread t4 = new Thread(test);
    Thread t5 = new Thread(test);
    //主线程的优先级
    System.out.println(Thread.currentThread().getName() + "-->" + Thread.currentThread().getPriority());

    //设置优先级
    t2.setPriority(1);
    t3.setPriority(Thread.NORM_PRIORITY);
    t4.setPriority(8);
    t5.setPriority(Thread.MAX_PRIORITY);

    t1.start();
    t2.start();
    t3.start();
    t4.start();
    t5.start();

  }
}
```

- 优先级低只是意味着获得调度的概率低,并不是优先级低就不会被调用

## 守护线程

- 守护线程是指为其他线程服务的线程,在JVM中,所有非守护线程都执行完毕后,无论有没有守护线程,虚拟机都会自动退出
- 在守护线程中,编写代码要注意:守护线程不能持有任何需要关闭的资源,例如打开文件等,因为虚拟机退出时,守护线程没有任何机会来关闭文件,这会导致数据丢失

```java
class TestDaemon {

  static class DaemonThread implements Runnable {
    public void run() {
      while (true) {
        System.out.println("守护进程");
      }
    }
  }

  static class UserThread implements Runnable {
    public void run() {
      for (int i = 0; i < 5; i++) {
        System.out.println("用户进程");
      }
    }
  }


  public static void main(String[] args) {
    //创建并启动守护进程
    Thread thread = new Thread(new DaemonThread());
    //默认是false表示是用户进程,设置true改为守护进程
    thread.setDaemon(true);
    thread.start();

    //创建并启动用户进程
    new Thread(new UserThread()).start();
  }
}
```

