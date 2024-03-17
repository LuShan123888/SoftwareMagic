---
title: Java Thread
categories:
  - Software
  - Language
  - Java
  - JavaSE
  - 多线程
---
# Java Thread

用Java编写多线程代码有两种方式：第1种是直接继承Java的线程类Thread，第二种方法是实现Runnable接口，无论采用哪种方法均需要在程序中编写`run()`方法，线程在运行时要完成的任务在该方法中实现。

## Thread类简介

- Thread类综合了Java程序中一个线程需要拥有的属性和方法，它的构造方法为：

```java
public Thread(ThreadGroup group,Runnable target,String name);
```

- `group`指明该线程所属的线程。
- `target`为实际执行线程体的目标对象，它必须实现接口Runnable
- `name`为线程名。

- 以下构造方法为缺少某些参数的情形：

```java
public Thread();
public Thread(Runnable target);
public Thread(Runnable target,String name);
public Thread(String name);
public Thread(ThreadGroup group,Runnable target);
public Thread(ThreadGroup group,String name);
```

- 线程组是为了方便访问一组线程引入的，例如，通过执行线程组的`interrupt()`方法，可以中断该组所有线程的执行，但如果当前线程无权修改线程组时将产生异常，实际应用中较少用到线程组。
- 下表为Thread类的主要方法简介。

| 方法                 | 功能                                                         |
| -------------------- | ------------------------------------------------------------ |
| currentThread()      | 返回当前运行的Thread对象                                     |
| start()              | 启动线程                                                     |
| run()                | 由调度程序调用，当run()方法返回时，该线程停止                  |
| sleep(int n)         | 是线程睡眠n毫秒，n毫秒后，线程可以再次运行                     |
| setPriority(int p)   | 设置线程优先级                                               |
| getPriority()        | 返回线程优先级                                               |
| join()               | 其他线程要等待调用该方法的线程结束后，再往下执行              |
| suspend()            | 使线程挂起，JDK已不建议使用的方法                             |
| resume()             | 恢复挂起的线程，JDK已不建议使用的方法                         |
| yield()              | 将CPU控制权主动移交到下一个可运行的线程                      |
| setName(String name) | 赋予线程一个名字                                             |
| getName()            | 取得代表线程名字的字符串                                     |
| stop()               | 停止线程的执行                                               |
| interrupt()          | 标记线程为中断状态，不过不会中断正在运行的线程               |
| interrupted()        | 测试当前线程是否已经中断，该方法为静态方法，调用后会返回boolean值，不过调用之后会改变线程的状态，如果是中断状态调用的，调用之后会清除线程的中断状态 |
| isInterrupted()      | 测试线程是否已经中断，该方法由对象调用                       |

- Thread类封装了线程的行为，继承Thread类须重写`run()`方法实现线程的任务，注意，程序中不要直接调用此方法，而是调用线程对象的`start()`方法启动线程，让其进入可调度状态，线程获得调度时将自动执行`run()`方法。

## 创建线程

### 继承Thread类实现多线程

**[例12-1]**：直接继承Thread类实现多线程。

```java
import java.util.*;
class TimePrinter extends Thread {
  int pauseTime;    // 中间休息时间。
  String name;      // 名称标识。

  public TimePrinter(int x, String n) {
    pauseTime = x;
    name = n;
  }

  public void run() {
    while (true) {
      try {
        System.out.println(name + ": " + Calendar.getInstance().getTime());
        Thread.sleep(pauseTime);    // 让线程睡眠一段时间。
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

- 运行程序，可看到两个线程按两个不同的时间间隔显示当前时间，睡眠时间长的线程运行机会自然少。
- **注意**：如果包括主线程，实际上有3个线程在运行，主线程从`mian()`方法开始执行，启动完两个新线程后首先停止，其他两个线程的`run()`方法被设计为无限循环，必须靠按Ctrl+C快捷键强行结束。

## 停止线程

### stop()停止

-    线程调用stop()方法会被暴力停止，方法已弃用，该方法会有不好的后果：
    1. 强制让线程停止有可能使一些清理性的工作得不到完成。
    2. 对锁定的对象进行了**解锁**，导致数据得不到同步的处理，出现数据不一致的问题（比如一个方法加上了synchronized，并在其中进行了一个长时间的处理，而在处理结束之前该线程进行了`stop()`，则未完成的数据将没有进行到同步的处理）

### 异常法停止

-  线程调用interrupt()方法后，在线程的run方法中判断当前对象的interrupted状态，如果是中断状态则抛出异常，达到中断线程的效果。

```java
public class MyThread extends Thread {
    public void run(){
        super.run();
        try {
            for(int i=0; i<500000; i++){
                if(this.interrupted()) {
                    System.out.println("线程已经终止，for循环不再执行");
                        throw new InterruptedException();
                }
                System.out.println("i="+(i+1));
            }

            System.out.println("这是for循环外面的语句，也会被执行");
        } catch (InterruptedException e) {
            System.out.println("进入MyThread.java类中的catch了，,,");
            e.printStackTrace();
        }
    }
}
public class Run {
    public static void main(String args[]){
        Thread thread = new MyThread();
        thread.start();
        try {
            Thread.sleep(2000);
            thread.interrupt();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}
```

### 在沉睡中停止

- 先将线程sleep，然后调用interrupt标记中断状态，interrupt会将阻塞状态的线程中断，会抛出中断异常，达到停止线程的效果。

```java
public class MyThread extends Thread {
    @Override
    public void run() {
        try {
            System.out.println("run-----------start");
            Thread.sleep(5000);
            System.out.println("run-----------end");
        } catch (InterruptedException e) {
            System.out.println("在沉睡中被停止!进入catch，线程的是否处于停止状态：" + this.isInterrupted());
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        try {
            MyThread myThread = new MyThread();
            myThread.start();
            Thread.sleep(2000);
            System.out.println("状态："+MyThread.interrupted());
            myThread.interrupt();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}
```

- 线程先调用interrupt标记中断状态，然后线程再睡眠，会抛出中断异常，达到停止线程的效果。

```java
public class MyThread1 extends Thread {
    @Override
    public void run() {
        try {
            for (int i = 0; i < 100000; i++) {
                System.out.println("i = " + (i+1));
            }
            System.out.println("run begin");
            //interrupt是做一个中断标记，当时不会去中断正在运行的线程，当该线程处于阻塞状态时就会进行中断。
            // 因此，先进行interrupt后，再遇到sleep阻塞时，才会进行中断。
            Thread.sleep(200000);
            System.out.println("run end");
        } catch (InterruptedException e) {
            System.out.println("先停止，再遇到了sleep!进入catch!");
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        MyThread1 myThread1 = new MyThread1();
        myThread1.start();
        myThread1.interrupt();
        System.out.println("end!");
    }
}
```

## 线程休眠

- **sleep()**：一定是当前线程调用此方法，当前线程进入TIMED_WAITING状态，但不释放对象锁，millis后线程自动苏醒进入就绪状态。

```java
class TestSleep implements Runnable {
  int pauseTime;    // 中间休息时间。
  String name;      // 名称标识。

  public TestSleep(int x, String n) {
    pauseTime = x;
    name = n;
  }

  public void run() {
    while (true) {
      try {
        Thread.sleep(pauseTime);    // 让线程睡眠一段时间。
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
        Thread.sleep(3000);// 主线程睡眠一段时间。
      } catch (InterruptedException e) {
      }
      System.out.println("Main Thread Sleep 3000ms");
    }
  }
}
```

## 线程让步

- **yield()**：一定是当前线程调用此方法，当前线程放弃获取的CPU时间片，但不释放锁资源，由运行状态变为就绪状态，让OS再次选择线程。

```java
class TestYield implements Runnable {

  public void run() {
    System.out.println(Thread.currentThread().getName() + "线程开始执行");
    Thread.yield();// 线程让步。
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

- **join()**：当前线程里调用其它线程t的join方法，当前线程进入`WAITING/TIMED_WAITING`状态，当前线程不会释放已经持有的对象锁，线程t执行完毕或者millis时间到，当前线程一般情况下进入RUNNABLE状态，也有可能进入BLOCKED状态（因为join是基于wait实现的）

```java
class TestJoin implements Runnable {

  public void run() {
    for (int i = 0; i < 10; i++) {
      System.out.println("测试线程： " + i);
    }
  }

  public static void main(String[] args) throws InterruptedException {
    // 启动测试线程。
    TestJoin test = new TestJoin();
    Thread thread = new Thread(test);
    thread.start();

    // 主线程。
    for (int i = 0; i < 100; i++) {
      if (i == 20) {
        thread.join();// 线程插入。
      }
      System.out.println("主线程： " + i);
    }
  }
}
```

## 线程状态

- `Thread.State`为线程状态，线程可以处于以下状态之一。
    - `NEW`：尚未启动的线程处于此状态。
    - `RUNNABLE`：在Java虚拟机中执行的线程处于此状态。
    - `BLOCKED`：被阻塞等待监视器锁定的线程处于此状态。
    - `WAITING`：正在等待另一个线程执行特定动作的线程处于此状态。
    - `TIMED_WAITING`：正在等待另一个线程执行动作达到指定等待时间的线程处于此状态。
    - `TERMINATED`：已退出的线程处于此状态。
- 一个线程可以在给定时间点处于一个状态，这些状态是不反映任何操作系统线程状态的虚拟机状态。

```java
class TestState implements Runnable {

  public void run() {
    for (int i = 0; i < 10; i++) {
      try {
        Thread.sleep(500);
      } catch (InterruptedException e) {
        e.printStackTrace();
      }
      System.out.println("测试线程： " + i);
    }
  }

  public static void main(String[] args) throws InterruptedException {
    TestState test = new TestState();
    Thread thread = new Thread(test);

    // 观察线程状态。
    Thread.State state = thread.getState();
    System.out.println(state);

    // 启动测试线程。
    thread.start();

    // 只要线程不终止，就一直输出状态。
    while (state != Thread.State.TERMINATED) {
      Thread.sleep(500);
      state = thread.getState();
      System.out.println(state);
    }
  }
}
```

## 线程优先级

- 线程的优先级用数字来表示，范围从1~10，主线程的默认优先级为5，其他线程的优先级与创建它的父线程的优先级相同，为了方便，Thread类提供了如下几个常量来表示优先级：
    - `Thread.MIN_PRIORITY=1`
    - `Thread.MAX_PRIORITY=10`
    - `Thread.NORM_PRIORITY=5`
- `getPriority()`：获取线程优先级。
- `setPriority()`：设置线程优先级。

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
    // 主线程的优先级。
    System.out.println(Thread.currentThread().getName() + "-->" + Thread.currentThread().getPriority());

    // 设置优先级。
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

- 优先级低只是意味着获得调度的概率低，并不是优先级低就不会被调用。

## 守护线程

- 守护线程是指为其他线程服务的线程，在JVM中，所有非守护线程都执行完毕后，无论有没有守护线程，虚拟机都会自动退出。
- 在守护线程中，编写代码要注意：守护线程不能持有任何需要关闭的资源，例如打开文件等，因为虚拟机退出时，守护线程没有任何机会来关闭文件，这会导致数据丢失。

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
    // 创建并启动守护进程。
    Thread thread = new Thread(new DaemonThread());
    // 默认是false表示是用户进程，设置true改为守护进程。
    thread.setDaemon(true);
    thread.start();

    // 创建并启动用户进程。
    new Thread(new UserThread()).start();
  }
}
```

