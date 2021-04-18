---
title: Java Object类
categories:
- Software
- Backend
- Java
- JavaSE
- 继承与多态
---
# Java Object类

Object类是所有Java类的最终祖先,如果类定义时不包含关键字extends,则编译将自动认为该类直接继承Object类,Object是一个具体类,它可以创建对象,Object类包含了所有Java类的公共属性和方法,以下给出了几个常用方法:

- `public boolean equals(Object obj)`:该方法本意用于两个对象的"深度"比较,也就是比较两对象封装的数据是否相等,而比较运算符”=”在比较两对象变量时,只有当两个对象引用指向同一对象时才为真值,但在Object类中,`equals()`方法采用"="运算进行比较,其他类如果没有定义`equals()`方法,则继承Object类的`equals()`方法,因此,在类设计时,需要进行对象的数据比较,一般要重写`equals()`方法
- `public String toString()`:该方法返回对象的字符串描述,在Object类中它被设计为返回对象名后跟一个Hash码,其他类通常将该方法进行重写,以提供关于对象的更有用的描述信息
- `public final Class getClass()`:返回对象的所属类,而且利用Class类提供的`getName()`方法可获取对象的类名称
- `protected void finalize()`:该方法在Java垃圾回收程序删除对象前自动执行,一个对象没有任何一个引用变量指向它时,Java垃圾回收程序将自动释放对象空间

**[例6-5]**给Point类添加`equals()`方法

```java
public class Point {
    private int x, y;

    public Point(int x, int y) {
        this.x = x;
        this.y = y;
    }

    public boolean equals(Point p) {
        return (x == p.x && y == p.y);
    }

    public String toString() {
        return "点:" + x + "," + y;
    }

    public static void main(String arg[]) {
        Point1 x = new Point(4, 3);
        System.out.println("x=" + x);
        System.out.println(x.equals(new Point(4, 3)));
    }
}

x=点:4,3
true
```

**说明**:第9~11行定义了Point类的`equals()`方法,只有当前对象的x,y坐标与参数中指定Point的x,y坐标均相等时方法返回true,第20行给出就了该方法的调用测试

### 类的方法

| 序号 |                         方法 & 描述                          |
| :--- | :----------------------------------------------------------: |
| 1    | [protected Object clone()](https://www.runoob.com/java/java-object-clone.html)创建并返回一个对象的拷贝 |
| 2    | [boolean equals(Object obj)](https://www.runoob.com/java/java-object-equals.html)比较两个对象是否相等 |
| 3    | [protected void finalize()](https://www.runoob.com/java/java-object-finalize.html)当 GC (垃圾回收器)确定不存在对该对象的有更多引用时，由对象的垃圾回收器调用此方法。 |
| 4    | [Class getClass()](https://www.runoob.com/java/java-object-getclass.html)获取对象的运行时对象的类 |
| 5    | [int hashCode()](https://www.runoob.com/java/java-object-hashcode.html)获取对象的 hash 值 |
| 6    | [void notify()](https://www.runoob.com/java/java-object-notify.html)唤醒在该对象上等待的某个线程 |
| 7    | [void notifyAll()](https://www.runoob.com/java/java-object-notifyall.html)唤醒在该对象上等待的所有线程 |
| 8    | [String toString()](https://www.runoob.com/java/java-object-tostring.html)返回对象的字符串表示形式 |
| 9    | [void wait()](https://www.runoob.com/java/java-object-wait.html)让当前线程进入等待状态。直到其他线程调用此对象的 notify() 方法或 notifyAll() 方法。 |
| 10   | [void wait(long timeout)](https://www.runoob.com/java/java-object-wait-timeout.html)让当前线程处于等待(阻塞)状态，直到其他线程调用此对象的 notify() 方法或 notifyAll() 方法，或者超过参数设置的timeout超时时间。 |
| 11   | [void wait(long timeout, int nanos)](https://www.runoob.com/java/java-object-wait-nanos.html)与 wait(long timeout) 方法类似，多了一个 nanos 参数，这个参数表示额外时间（以纳秒为单位，范围是 0-999999）。 所以超时的时间还需要加上 nanos 纳秒。。 |