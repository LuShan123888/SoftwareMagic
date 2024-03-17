---
title: Java Runnable与Callable
categories:
- Software
- Language
- Java
- JavaSE
- 多线程
---
# Java Runnable与Callable

## 实现Runnable接口编写多线程

- 由于Java的单重继承限制，有些类必须继承其他某个类的同时又要实现线程的特性，这时可通过实现Runnable接口的方式来满足两方面的要求,Runnable接口只有一个方法`run()`,它就是线程运行时要执行的方法，只要将具体代码写入其中即可
- 使用Thread类的构造函数`public Thread(Runnable target)`可以将一个Runnable接口对象传递给线程，线程在调度执行其`run()`方法时将自动调用Runnable接口对象的`run()`方法
- Thread类本身实现了Runnable接口，从其`run()`方法的设计可看出线程调度时会自动执行Runnable接口对象的`run()`方法，以下为Thread类的关键代码:

```java
class Thread implements Runnable{
    private Runnable target;
    public Thread(){...}
    public Thread(Runnable target){...}
    public void run() {
        if (target != null)
            target.run();   //执行实现Runnable接口的target对象的run()方法
    }
    ...
}
```

- 将**例12-1**改用实现Runnable接口的方式实现，利用Thread类的带Runnable接口参数的构造方法创建线程，线程调度运行时，通过执行线程的`run()`方法，将转而调用TimePrinter对象的`run()`方法，不妨让`mian()`方法所在的主线程也循环执行，具体程序代码如下:

```java
class TimePrinter implements Runnable {
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
        Thread tp1 = new Thread(new TimePrinter(1000,"Fast"));
        tp1.start();
        Thread tp2 = new Thread(new TimePrinter(3000,"Slow"));
        tp2.start();
        for (int k=0;k<100;k++){
            System.out.println("主线程循环:  k="+k);
            try {
                Thread.sleep(500);
            }catch (InterruptedException e){
            }
        }
    }
}
```

- 运行程序，会发现有3个线程在轮流执行，其中`main()`方法所在的线程，由于设置的线程睡眠时间更短，因此，得到调度运行的机会更多

**[例12-2]**:一个随机选号程序

有一组号码，让其滚动显示，随机选两个位置在一起的作为中奖号码，本应用让窗体实现Runnable接口，通过多线程的运作方式实现号码的滚动显示，在窗体中通过文本域显示滚动号码，通过一个按钮控制选号过程的开始和停止，线程的停止是通过一个标记变量flag来控制的

```java
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
class Winning extends Frame implements Runnable {
    String[] phoneNumber = {"15031204532", "13014156678", "13870953214",
                            "13943123322", "18114156528"};//用数组存一组号码
    TextArea disp = new TextArea(4, 50);    //用来显示滚动号码
    int pos = 0;    //记录滚动到的索引位置
    boolean flag = false;   //控制线程停止的标记变量
    Button onoff;   //启动停止按钮

    public static void main(String[] args) {
        new Winning();
    }

    public Winning() {
        add("Center", disp);
        onoff = new Button("begin");
        add("South", onoff);
        onoff.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                if (e.getActionCommand().equals("begin")) {
                    flag = true;
                    onoff.setLabel("end"); //更改按钮标签
                    (new Thread(Winning.this)).start(); //启动线程
                } else {
                    flag = false;   //设置线程停止标记
                    onoff.setLabel("begin");
                }
            }
        });
        setSize(200, 100);
        setVisible(true);
    }

    public void run() {
        while (flag) {
            int n = phoneNumber.length;
            pos = (int) (Math.random() * n);   //随机选位置
            String message = phoneNumber[pos] + "\n" +
                phoneNumber[(pos + 1) % n];
            disp.setText(message);     //显示位置连续的两个号码
        }
    }
}
```

- **说明**:第4行定义了Winning类头，表明了该类继承Frame并实现了Runnable接口，第25行创建线程时将Winning窗体自身对象作为实参，并启动线程，线程调度运行时将执行其run()方法

## 实现Callable接口编写多线程

> **步骤**
>
> 1. 创建Callable接口的实现类，并实现call()方法，该call()方法将作为线程执行体，并且有返回值
> 2. 创建Callable实现类的实例，使用FutureTask类来包装Callable对象，该FutureTask对象封装了该Callable对象的call()方法的返回值
> 3. 使用FutureTask对象作为Thread对象的target创建并启动新线程
> 4. 调用FutureTask对象的get()方法来获得子线程执行结束后的返回值

**特点**

- 可以定义返回值
- 可以抛出异常

**实例**

```java
public class CallableTest {
  public static void main(String[] args) throws ExecutionException,
  InterruptedException {
    CallableTest thread = new CallableTest();
    FutureTask futureTask = new FutureTask(thread); // 适配类
    new Thread(futureTask,"A").start();
    new Thread(futureTask,"B").start(); // 结果会被缓存，效率高
    Integer o = (Integer) futureTask.get(); //get 方法可能会产生阻塞
    // 或者使用异步通信来处理!
    System.out.println(o);
  }
}
class CallableTest implements Callable<Integer> {
  @Override
  public Integer call() {
    System.out.println("call()"); // 会打印几个call
    // 耗时的操作
    return 1024;
  }
}
```
