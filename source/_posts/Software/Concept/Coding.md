---
title: Coding
categories:
- Software
- Concept
---
# Coding

## JVM

### GC

- 垃圾回收可以有效的防止内存泄露,有效的使用可以使用的内存,垃圾回收器通常是作为一个单独的低优先级的线程运行,不可预知的情况下对内存堆中已经死亡的或者长时间没有使用的对象进行清除和回收,程序员不能实时的调用垃圾回收器对某个对象或所有对象进行垃圾回收

#### 与垃圾回收相关的JVM参数

> -Xms / -Xmx — 堆的初始大小 / 堆的最大大小
>
> -Xmn — 堆中年轻代的大小
> -XX:-DisableExplicitGC — 让System.gc()不产生任何作用
> -XX:+PrintGCDetails — 打印GC的细节
> -XX:+PrintGCDateStamps — 打印GC操作的时间戳
> -XX:NewSize / XX:MaxNewSize — 设置新生代大小/新生代最大大小
> -XX:NewRatio — 可以设置老生代和新生代的比例
> -XX:PrintTenuringDistribution — 设置每次新生代GC后输出幸存者乐园中对象年龄的分布
> -XX:InitialTenuringThreshold / -XX:MaxTenuringThreshold:设置老年代阀值的初始值和最大值
> -XX:TargetSurvivorRatio:设置幸存区的目标使用率

#### 垃圾回收的流程

- 首先有三个代,新生代,老年代,永久代
- 在新生代有三个区域:一个Eden区和两个Survivor区,当一个实例被创建了,首先会被存储Eden 区中
- 具体过程是这样的:
  - 一个对象实例化时,先去看Eden区有没有足够的空间
  - 如果有,不进行垃圾回收,对象直接在Eden区存储
  - 如果Eden区内存已满,会进行一次minor gc
  - 然后再进行判断Eden区中的内存是否足够
  - 如果不足,则去看Survivor区的内存是否足够
  - 如果内存足够,把Eden区部分活跃对象保存在Survivor区,然后把对象保存在Eden区
  - 如果内存不足,查询老年代的内存是否足够
  - 如果老年代内存足够,将部分Survivor区的活跃对象存入老年代,然后把Eden区的活跃对象放入Survivor区,对象依旧保存在Eden区
  - 如果老年代内存不足,会进行一次full gc,之后老年代会再进行判断 内存是否足够,如果足够 还是那些步骤
  - 如果不足,会抛出OutOfMemoryError(内存溢出异常)

#### GC算法

- **标记-清除算法**:遍历 `GC Roots`,然后将所有 `GC Roots` 可达的对象标记,将没有标记的对象全部清除掉
- **复制算法**:它将可用内存按容量划分为大小相等的两块,每次只使用其中的一块,当这一块内存用完,需要进行垃圾收集时,就将存活者的对象复制到另一块上面,然后将第一块内存全部清除
- **标记-整理算法**:遍历 `GC Roots`,然后将存活的对象标记,移动所有存活的对象,且按照内存地址次序依次排列,然后将末端内存地址以后的内存全部回收

#### 垃圾回收器

- CMS 垃圾收集器以获取最短回收停顿时间为目标的收集器(追求低停顿),它在垃圾收集时使得用户线程和 GC 线程并发执行,因此在垃圾收集过程中用户也不会感到明显的卡顿
    - 初始标记:Stop The World,仅使用一条初始标记线程对所有与 GC Roots 直接关联的对象进行标记
    - 并发标记:使用**多条**标记线程,与用户线程并发执行,此过程进行可达性分析,标记出所有废弃对象,速度很慢
    - 重新标记:Stop The World,使用多条标记线程并发执行,将刚才并发标记过程中新出现的废弃对象标记出来
    - 并发清除:只使用一条 GC 线程,与用户线程并发执行,清除刚才标记的对象,这个过程非常耗时
- G1 通用垃圾收集器是一款面向服务端应用的垃圾收集器,它没有新生代和老年代的概念,而是将堆划分为一块块独立的 Region,当要进行垃圾收集时,首先估计每个 Region 中垃圾的数量,每次都从垃圾回收价值最大的 Region 开始回收,因此可以获得最大的回收效率
    - 从整体上看,G1 是基于"标记-整理”算法实现的收集器,从局部(两个 Region 之间)上看是基于"复制”算法实现的,这意味着运行期间不会产生内存空间碎片
    - 可以非常精确控制停顿时间,在不牺牲吞吐量前提下,实现低停顿垃圾回收
    - 如果不计算维护 Remembered Set 的操作,G1 收集器的工作过程分为以下几个步骤:
        - 初始标记:Stop The World,仅使用一条初始标记线程对所有与 GC Roots 直接关联的对象进行标记
        - 并发标记:使用**一条**标记线程与用户线程并发执行,此过程进行可达性分析,速度很慢
        - 最终标记:Stop The World,使用多条标记线程并发执行
        - 筛选回收:回收废弃对象,此时也要 Stop The World,并使用多条筛选回收线程并发执行

#### 可达性分析法

- 所有和 GC Roots 直接或间接关联的对象都是有效对象,和 GC Roots 没有关联的对象就是无效对象
- GC Roots 是指:
    - Java 虚拟机栈(栈帧中的本地变量表)中引用的对象
    - 本地方法栈中引用的对象
    - 方法区中常量引用的对象
    - 方法区中类静态属性引用的对象
- GC Roots 并不包括堆中对象所引用的对象,这样就不会有循环引用的问题

#### 引用类型

- **强引用**:类似`Object obj = new Object()`这类的引用,就是强引用
- **软引用**:软引用是一种相对强引用弱化一些的引用,可以让对象豁免一些垃圾收集,只有当 JVM 认为内存不足时,才会去试图回收软引用指向的对象,JVM 会确保在抛出`OutOfMemoryError`之前,清理软引用指向的对象,软引用通常用来**实现内存敏感的缓存**,如果还有空闲内存,就可以暂时保留缓存,当内存不足时清理掉,这样就保证了使用缓存的同时,不会耗尽内存
- **弱引用**:弱引用的**强度比软引用更弱**一些,当 JVM 进行垃圾回收时,**无论内存是否充足,都会回收**只被弱引用关联的对象
- **虚引用**:虚引用也称幽灵引用或者幻影引用,它是**最弱**的一种引用关系,一个对象是否有虚引用的存在,完全不会对其生存时间构成影响,它仅仅是提供了一种确保对象被 finalize 以后,做某些事情的机制,比如,通常用来做所谓的 Post-Mortem 清理机制

#### 什么时候新生代会转换为老年代

- Eden区满时,进行Minor GC时
- 如果新创建的对象占用内存很大,则直接分配到老年代
- 虚拟机对每个对象定义了一个对象年龄(Age)计数器,当年龄增加到一定的临界值时,就会晋升到老年代中
- 如果在Survivor区中相同年龄的对象的所有大小之和超过Survivor空间的一半,包括比这个年龄大的对象就都可以直接进入老年代

#### 新生代2个Survivor区的好处

解决了内存碎片化问题,整个过程中,永远有一个Survivor区是空的,另一个非空的Survivor区是无碎片的

### 遇到过OOM怎么解决

- 最常见的OOM情况有以下三种：
    1. `java.lang.OutOfMemoryError: Java heap space`:java堆内存溢出，此种情况最常见，一般由于内存泄露或者堆的大小设置不当引起。对于内存泄露，需要通过内存监控软件查找程序中的泄露代码，而堆大小可以通过虚拟机参数`-Xms`,`-Xmx`等修改。
    2. `java.lang.OutOfMemoryError: PermGen space`:java永久代溢出，即方法区溢出了，一般出现于大量Class或者jsp页面，或者采用cglib等反射机制的情况，因为上述情况会产生大量的Class信息存储于方法区。此种情况可以通过更改方法区的大小来解决，使用类似`-XX:PermSize=64m -XX:MaxPermSize=256m`的形式修改。另外，过多的常量尤其是字符串也会导致方法区溢出。
    3. `java.lang.StackOverflowError`:不会抛OOM error，但也是比较常见的Java内存溢出。JAVA虚拟机栈溢出，一般是由于程序中存在死循环或者深度递归调用造成的，栈大小设置太小也会出现此种溢出。可以通过虚拟机参数`-Xss`来设置栈的大小
- **OOM分析--heapdump**:获取dump堆的内存镜像，可以采用如下两种方式：
    1. 设置JVM参数`-XX:+HeapDumpOnOutOfMemoryError`，设定当发生OOM时自动dump出堆信息。不过该方法需要JDK5以上版本。
    2. 使用JDK自带的jmap命令。`jmap -dump:format=b,file=heap.bin <pid>`其中pid可以通过jps获取。
- 得到dump堆内存信息后，需要对dump出的文件进行分析，从而找到OOM的原因。常用的工具有：
    1. **mat: eclipse memory analyzer**, 基于eclipse RCP的内存分析工具
    2. **jhat**：JDK自带的java heap analyze tool，可以将堆中的对象以html的形式显示出来，包括对象的数量，大小等等，并支持对象查询语言OQL，分析相关的应用后，可以通过http://localhost:7000来访问分析结果。不推荐使用，因为在实际的排查过程中，一般是先在生产环境 dump出文件来，然后拉到自己的开发机器上分析，所以，不如采用高级的分析工具比如前面的mat来的高效。

### JVM内存结构

- Java 虚拟机的内存空间分为 5 个部分:
    - **程序计数器**
    - **Java 虚拟机栈**:Java 虚拟机栈会为每一个即将运行的 Java 方法创建一块叫做"栈帧”的区域,用于存放该方法运行过程中的一些信息,如:
        - 局部变量表
            - 存放基本变量类型(会包含这个基本类型的基本数值)
            - 引用对象的变量(会存放这个引用在堆里面的具体地址)
        - 操作数栈
        - 动态链接
        - 方法出口信息
    - **本地方法栈**
    - **堆**
        - 存放new的对象和数组
        - 可以被所有的线程共享,不会存放别的对象引用
    - **方法区**:方法区逻辑上属于堆的一部分,但是为了与堆进行区分,通常又叫"非堆”
        - 已经被虚拟机加载的类信息
        - 常量
        - 静态变量
        - 即时编译器编译后的代码

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-03-14-jvm-memory-structure.jpg" alt="jvm-memory-structure" style="zoom: 67%;" />

**注意**:JDK 1.8 同 JDK 1.7 比,最大的差别就是:元空间(元数据区)取代了永久代,元空间的本质和永久代类似,都是对 JVM 规范中方法区的实现,不过元空间与永久代之间最大的区别在于:元空间并不在虚拟机中,而是使用本地内存

### 类的加载过程

1. 加载:查找和导入Class文件
2. 校验:检查载入Class文件数据的正确性
3. 准备:给类的静态变量分配存储空间
4. 解析:将符号引用转成直接引用
5. 初始化:执行类构造器 `<clinit>()` 方法,对类的静态变量,静态代码块执行初始化操作

> **类初始化的时机**
>
> - **类的主动引用**(一定会发生类的初始化)
>     - 当虚拟机启动,先初始化main方法所在的类
>     - new一个类的对象
>     - 调用类的静态成员(除final常量)和静态方法
>     - 使用`java.lang.reflect`包的方法对类进行反射调用
>     - 当初始化一个类,如果其父类没有被初始化,则会先初始化它的父类
> - **类的被动引用**(不会发生类的初始化)
>     - 当访问一个静态域时,只有真正声明这个域的类才会被初始化,如:当通过子类引用父类的静态变量,不会导致子类初始化
>     - 通过数组定义类引用,不会触发此类的初始化
>     - 引用常量不会触发此类的初始化(常量在链接阶段就存入调用类的常量池中)

#### 加载class文件的原理机制

- 类的加载是由类加载器完成的,类加载器包括:根加载器(BootStrap),扩展加载器(Extension),系统加载器(System)和用户自定义类加载器(java.lang.ClassLoader的子类)
- 类加载过程采取了双亲委托机制,更好的保证了Java平台的安全性,在该机制中,JVM自带的Bootstrap是根加载器,其他的加载器都有且仅有一个父类加载器,类的加载首先请求父类加载器加载,父类加载器无能为力时才由其子类加载器自行加载,JVM不会向Java程序提供对Bootstrap的引用

> **说明**:
>
> Bootstrap:一般用本地代码实现,负责加载JVM基础核心类库(rt.jar)
> Extension:从java.ext.dirs系统属性所指定的目录中加载类库,它的父加载器是Bootstrap
> System:又叫应用类加载器,其父类是Extension,它是应用最广泛的类加载器,它从环境变量classpath或者系统属性java.class.path所指定的目录中记载类,是用户自定义加载器的默认父加载器

#### 类的实例化过程

- **类加载检查**:虚拟机遇到一条new指令时,虚拟机首先会去方法区的类常量池中定位到这个类对象的符号引用,并且检查这个符号引用代表的类是否已被加载,解析和初始化过,如果没有,那必须先执行相应的类加载过程
- **分配内存**:在类加载检查通过后,接下来虚拟机将为新生对象分配内存,对象所需内存的大小在类加载完成后便可以完全确定,为对象分配空间的任务等同于把一块确定大小的内存从java堆中划分出来
- **堆中分配内存的两种方法**:这里需要注重说明一下:java堆的内存分配方式是取决于垃圾回收器是否带有压缩整理功能决定的,在使用Serial,ParNew等带Compact过程的收集器时,系统采用的分配算法是指针碰撞,而使用CMS这种基于Mark-Sweep算法的收集器时,通常采用空闲列表方式
    - **指针碰撞**:假设java堆中内存是完全规整的,所有用过的内存都放到一边,空闲的内存放在另一边,中间放着一个指针作为分界点的指示器,那所分配的内存就是仅仅把那个指针向空闲的空间那边挪动一段与对象大小相同的距离
    - **空闲列表**:假设java堆中的内存不是规整的,已使用的内存和空闲的内存是相互交错的,那就没有办法通过简单的指针碰撞分配内存了,虚拟机就必须维护一个列表,记录上那些内存块是可用的,在分配的时候从列表中找到一块足够大的空间划分给对象实例,并更新列表上的记录

## Java SE

### int和Integer的区别

- int是基本数据类型,Integer是他的包装类
- Integer保存的是对象的引用,int保存的变量值
- Integer默认是null,int默认是0
- Integer变量必须实例化后才能使用,而int变量不需要

### 基本数据类型和大小

- boolean(1) = byte(1) < short(2) = char(2) < int(4) = float(4) < long(8) = double(8)

### 接口和抽象类的区别

1. 接口中所有的方法隐含的都是抽象的,而抽象类则可以同时包含抽象和非抽象的方法
2. 类可以实现很多个接口,但是只能继承一个抽象类
3. Java接口中声明的变量默认都是final的,抽象类可以包含非final的变量
4. Java接口中的成员函数默认是public的,抽象类的成员函数可以是private,protected或者是public
5. 抽象类和接口都不能够实例化,但可以定义抽象类和接口类型的引用
6. 一个类如果继承了某个抽象类或者实现了某个接口都需要对其中的抽象方法全部进行实现,否则该类仍然需要被声明为抽象类
7. 接口比抽象类更加抽象,因为抽象类中可以定义构造器,可以有抽象方法和具体方法,而接口中不能定义构造器而且其中的方法全部都是抽象方法
8. 抽象类中的成员可以是private,默认,protected,public的,而接口中的成员全都是public的,抽象类中可以定义成员变量,而接口中定义的成员变量实际上都是常量,有抽象方法的类必须被声明为抽象类,而抽象类未必要有抽象方法

### 异常

-   Error:程序中无法处理的错误,此类错误一般表示代码运行时JVM出现问题,通常有VirtualMachineError(虚拟机运行错误),OutOfMemoryError等,JVM将终止线程
-   Exception:程序本身可以捕获并且可以处理的异常
    -   运行时异常(非受检异常):RuntimeException类及其子类,表示JVM在运行期间可能出现的错误,编译器不会检查此类异常,并且不要求处理异常,比如用空值对象的引用(NullPointerException),数组下标越界(ArrayIndexOutBoundException),此类异常属于不可查异常,一般是由程序逻辑错误引起的,在程序中可以选择捕获处理,也可以不处理
    -   非运行时异常(受检异常):Exception中除RuntimeException极其子类之外的异常,编译器会检查此类异常,如果程序中出现此类异常,比如说IOException,必须对该异常进行处理,要么使用try-catch捕获,要么使用throws语句抛出,否则编译不通过

### String和StringBuilder,StringBuffer的区别

- String是只读字符串,也就意味着String引用的字符串内容是不能被改变的
- StringBuffer/StringBuilder类表示的字符串对象可以直接进行修改
- StringBuilder和StringBuffer的方法完全相同,区别在于StringBuilder不是线程安全,因为它的所有方面都没有被synchronized修饰,因此它的效率也比StringBuffer要高

### 浅复制和深复制

- 如果在拷贝这个对象的时候,只对基本数据类型进行了拷贝,而对引用数据类型只是进行了引用的传递,而没有真实的创建一个新的对象,则认为是浅拷贝
- 反之,在对引用数据类型进行拷贝的时候,创建了一个新的对象,并且复制其内的成员变量,则认为是深拷贝

### 自动拆箱装箱

**自动装箱与自动拆箱的实现原理**

```java
public static void main(String[]args){
  Integer integer=1; //装箱
  int i=integer; //拆箱
}
```

- 对以上代码进行反编译后可以得到以下代码:

```java
public static void main(String[]args){
  Integer integer=Integer.valueOf(1);
  int i=integer.intValue();
}
```

**哪些地方会自动拆装箱**

1. 将基本数据类型放入集合类
2. 包装类型和基本类型的大小比较:包装类与基本数据类型进行比较运算,是先将包装类进行拆箱成基本数据类型,然后进行比较的
3. 包装类型的运算:两个包装类型之间的运算,会被自动拆箱成基本类型进行
4. 三目运算符的使用:当第二,第三位操作数分别为基本类型和对象时,其中的对象就会拆箱为基本类型进行操作

### Object类的方法

-   **clone()**:创建并返回此对象的一个副本
-   **equals(Object obj)**:指示某个其他对象是否与此对象"相等”
-   **finalize()**:当垃圾回收器确定不存在对该对象的更多引用时,由对象的垃圾回收器调用此方法
-   **getClass()**:返回一个对象的运行时类
-   **hashCode()**:返回该对象的哈希码值
-   **notify()**:唤醒在此对象监视器上等待的单个线程
-   **notifyAll()**:唤醒在此对象监视器上等待的所有线程
-   **toString()**:返回该对象的字符串表示
-   **wait()**:导致当前的线程等待,直到其他线程调用此对象的 notify() 方法或 notifyAll() 方法
-   **wait(long timeout)**:导致当前的线程等待,直到其他线程调用此对象的 notify() 方法或 notifyAll() 方法,或者超过指定的时间量
-   **wait(long timeout, int nanos)**:导致当前的线程等待,直到其他线程调用此对象的 notify() 方法或 notifyAll() 方法,或者其他某个线程中断当前线程,或者已超过某个实际时间量

### String为什么不可变

-   **不可变对象**:指一个对象的状态在对象被创建之后就不再变化,不能改变对象内的成员变量,包括基本数据类型的值不能改变,引用类型的变量不能指向其他的对象,引用类型指向的对象的状态也不能改变
-   String 不可变是因为在 JDK 中 String 类被声明为一个 final 类,且类内部的 value 字节数组也是 final 的
-   只有当字符串是不可变时字符串池才有可能实现,字符串池的实现可以在运行时节约很多 heap 空间,因为不同的字符串变量都指向池中的同一个字符串

### 序列化与反序列化

- Java序列化是将一个对象编码成一个字节流,反序列化将字节流编码转换成一个对象
- 为了实现用户自定义的序列化,相应的类必须实现`Serializable`接口,`Serializable`接口中没有定义任何方法在,实现了 Serializable 接口后, JVM 会在底层帮我们实现序列化和反序列

#### serialVersionUID 的作用

-   在进行反序列化时,JVM会把传来的字节流中的serialVersionUID与本地相应实体(类)的serialVersionUID进行比较,如果相同就认为是一致的,可以进行反序列化,否则就会出现序列化版本不一致的异常
-   如果不显示指定 serialVersionUID, JVM 在序列化时会根据属性自动生成一个 serialVersionUID, 然后与属性一起序列化, 再进行持久化或网络传输. 在反序列化时, JVM 会再根据属性自动生成一个新版 serialVersionUID, 然后将这个新版 serialVersionUID 与序列化时生成的旧版 serialVersionUID 进行比较, 如果相同则反序列化成功, 否则报错
-   当序列化了一个类实例后,希望更改一个字段或添加一个字段,不设置serialVersionUID,所做的任何更改都将导致无法反序化旧有实例,并在反序列化时抛出异常

### Java 值传递与引用传递

-   Java参数传递分为值传递和引用传递,基本类型是值传递,封装的对象时引用传递

### Statement和PreparedStatement的区别

- PreparedStatement接口代表预编译的语句,它主要的优势在于可以减少SQL的编译错误并增加SQL的安全性(减少SQL注射攻击的可能性)
- PreparedStatement中的SQL语句是可以带参数的,避免了用字符串连接拼接SQL语句的麻烦和不安全
- 当批量处理SQL或频繁执行相同的查询时,PreparedStatement有明显的性能上的优势,由于数据库可以将编译优化后的SQL语句缓存起来,下次执行相同结构的语句时就会很快(不用再次编译和生成执行计划)

### JDBC中Class.forName的作用

- `Class.forName`方法的作用,就是初始化给定的类,而我们给定的 MySQL 的 Driver 类中,它在静态代码块中通过 JDBC 的 DriverManager 注册了一下驱动,我们也可以直接使用 JDBC 的驱动管理器注册 mysql 驱动,从而代替使用`Class.forName`

### 锁

## Java EE

### forward与redirect

- **forward**:服务器请求资源,服务器直接访问目标地址的URL,把对应URL的响应内容读取过来,再发送给浏览器,所以URL不变,可以共享request的数据
- **redirect**:服务器发送一个状态码302,告诉浏览器重新去请求指定的地址,不能共享数据,地址栏显示的是新的URL

### Cookie与Session

1. cookie数据存放在客户的浏览器上,session数据放在服务器上
2. cookie不是很安全,别人可以分析存放在本地的cookie并进行cookie欺骗,考虑到安全应当使用session
4. 单个cookie保存的数据不能超过4K,很多浏览器都限制一个站点最多保存20个cookie
5. 可以考虑将登陆信息等重要信息存放为session,其他信息如果需要保留,可以放在cookie中

## 反射

### 获得一个类的类对象

1. 类名.class,例如:String.class
2. 对象.getClass(),例如:"hello".getClass()
3. Class.forName(),例如:Class.forName("java.lang.String")

### 通过反射创建对象

1. 通过类对象调用newInstance()方法,例如:String.class.newInstance()
2. 通过类对象的getConstructor()或getDeclaredConstructor()方法获得构造器(Constructor)对象并调用其newInstance()方法创建对象,例如:String.class.getConstructor(String.class).newInstance("Hello");

### 通过反射获取和设置对象私有字段的值

1. 通过类对象的getDeclaredField()方法字段(Field)对象
2. 再通过字段对象的setAccessible(true)将其设置为可以访问
3. 通过get/set方法来获取/设置字段的值了

### 通过反射调用对象的方法

1. 通过类对象的getMethod()方法获得方法对象
2. 调用方法对象的invoke()方法

## 多线程

### 线程的状态

**线程的状态**

- Java中线程的状态分为6种

  1. 初始(NEW):新创建了一个线程对象,但还没有调用start()方法
  2. 运行(RUNNABLE):Java线程中将就绪(ready)和运行中(running)两种状态笼统的称为"运行”
     线程对象创建后,其他线程(比如main线程)调用了该对象的start()方法,该状态的线程位于可运行线程池中,等待被线程调度选中,获取CPU的使用权,此时处于就绪状态(ready),就绪状态的线程在获得CPU时间片后变为运行中状态(running)
  3. 阻塞(BLOCKED):表示线程阻塞于锁
  4. 等待(WAITING):进入该状态的线程需要等待其他线程做出一些特定动作(通知或中断)
  5. 超时等待(TIMED_WAITING):该状态不同于WAITING,它可以在指定的时间后自行返回
  6. 终止(TERMINATED):表示该线程已经执行完毕
- 这6种状态定义在Thread类的State枚举中,可查看源码进行一一对应

**线程的状态图**

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-04-14-watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3BhbmdlMTk5MQ==,size_16,color_FFFFFF,t_70.jpeg" alt="线程状态图" style="zoom: 50%;" />

### 多线程的创建方式

- 继承Thread类
- 实现Runnable接口
- 实现Callable接口

### 线程有关的方法

- `Thread.sleep(long millis)`:一定是当前线程调用此方法,当前线程进入TIMED_WAITING状态,但不释放对象锁,millis后线程自动苏醒进入就绪状态
- `Thread.yield()`:一定是当前线程调用此方法,当前线程放弃获取的CPU时间片,但不释放锁资源,由运行状态变为就绪状态,让OS再次选择线程
- `thread.join()/thread.join(long millis)`:当前线程里调用其它线程t的join方法,当前线程进入`WAITING/TIMED_WAITING`状态,当前线程不会释放已经持有的对象锁,线程t执行完毕或者millis时间到,当前线程一般情况下进入RUNNABLE状态,也有可能进入BLOCKED状态(因为join是基于wait实现的)
- `obj.wait()`:当前线程调用对象的wait()方法,当前线程释放对象锁,进入等待队列,依靠notify()/notifyAll()唤醒或者wait(long timeout) timeout时间到自动唤醒
- `obj.notify()`:唤醒在此对象监视器上等待的单个线程,选择是任意性的
- `notifyAll()`:唤醒在此对象监视器上等待的所有线程

### wait方法的底层原理

- `ObjectSynchronizer::wait`方法通过object的对象中找到ObjectMonitor对象调用方法`void ObjectMonitor::wait(jlong millis, bool interruptible, TRAPS) `
- 通过`ObjectMonitor::AddWaiter`调用把新建立的`ObjectWaiter`对象放入到`_WaitSet`的队列的末尾中然后在`ObjectMonitor::exit`释放锁,接着 `thread_ParkEvent->park`也就是wait

### CAS

-  CAS,是Compare and Swap的简称,在这个机制中有三个核心的参数:
- 主内存中存放的共享变量的值:V(一般情况下这个V是内存的地址值,通过这个地址可以获得内存中的值)
- 工作内存中共享变量的副本值,也叫预期值:A
- 需要将共享变量更新到的最新值:B

### cyclicbarrier与countdownlatch区别

- CountDownLatch一般用于某个线程A等待若干个其他线程执行完任务之后,它才执行
- CyclicBarrier一般用于一组线程互相等待至某个状态,然后这一组线程再同时执行
- CountDownLatch是不能够重用的,而CyclicBarrier是可以重用的

### 多线程回调

所谓回调,就是客户程序C调用服务程序S中的某个方法A,然后S又在某个时候反过来调用C中的某个方法B,对于C来说,这个B方法便叫做回调方法框架

### 公平锁与非公平锁

如果一个锁是公平的,那么锁的获取顺序就应该符合请求的绝对时间顺序FIFO,对于非公平锁,只要CAS设置同步状态成功,则表示当前线程获取了锁,而公平锁还需要判断当前节点是否有前驱节点,如果有,则表示有线程比当前线程更早请求获取锁,因此需要等待前驱线程获取并释放锁之后才能继续获取锁

### AQS

Java中的锁,可以分为Synchronized,AQS这两类

- Synchronized是隐式锁,通过内部对象Monitor(监控器锁)实现,具体是由JVM中C++代码实现,它有一个同步队列,一个等待队列
- AQS是显示锁,通过CAS,LockSurpport,CLH 双向链表实现,是由java代码实现,它有一个同步队列,多个等待队列,当使用Condition的时候,调用condition的await方法,将会使当前线程进入等待队列,等待队列的唤醒是调用condition的signal方法,而AQS可以设置多个Condition,也就有了多个等待队列
- AQS的同步队列和等待队列如下图:

![img](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-06-20-watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpc2hlbmc1MjE4,size_16,color_FFFFFF,t_70.png)

### 原子性,可见性,有序性

- **原子性**:能够保证同一时刻有且只有一个线程在操作共享数据,其他线程必须等该线程处理完数据后才能进行
- **可见性**:当一个线程在修改共享数据时,其他线程能够看到
- **有序性**:在Java中,JVM能够根据处理器特性(CPU多级缓存系统,多核处理器等)适当对机器指令进行重排序,最大限度发挥机器性能,Java中的指令重排序有两次,第一次发生在将字节码编译成机器码的阶段,第二次发生在CPU执行的时候,也会适当对指令进行重排

### JMM

- Java虚拟机规范中定义了一种Java内存模型(Java Memory Model,即JMM)来屏蔽掉各种硬件和操作系统的内存访问差异,以实现让Java程序在各种平台下都能达到一致的并发效果,Java内存模型的主要目标就是**定义程序中各个变量的访问规则,即在虚拟机中将变量存储到内存和从内存中取出变量这样的细节**
- JMM中规定所有的变量都存储在主内存(Main Memory)中,每条线程都有自己的工作内存(Work Memory),线程的工作内存中保存了该线程所使用的变量的从主内存中拷贝的副本,线程对于变量的读,写都必须在工作内存中进行,而不能直接读,写主内存中的变量,同时,本线程的工作内存的变量也无法被其他线程直接访问,必须通过主内存完成
- 关于主内存与工作内存之间的具体交互协议,即一个变量如何从主内存拷贝到工作内存,如何从工作内存同步到主内存之间的实现细节,Java内存模型定义了以下八种操作来完成:
    1. **lock(锁定)**:作用于主内存的变量,把一个变量标识为一条线程独占状态
    2. **unlock(解锁)**:作用于主内存变量,把一个处于锁定状态的变量释放出来,释放后的变量才可以被其他线程锁定
    3. **read(读取)**:作用于主内存变量,把一个变量值从主内存传输到线程的工作内存中,以便随后的load动作使用
    4. **load(载入)**:作用于工作内存的变量,它把read操作从主内存中得到的变量值放入工作内存的变量副本中
    5. **use(使用)**:作用于工作内存的变量,把工作内存中的一个变量值传递给执行引擎,每当虚拟机遇到一个需要使用变量的值的字节码指令时将会执行这个操作
    6. **assign(赋值)**:作用于工作内存的变量,它把一个从执行引擎接收到的值赋值给工作内存的变量,每当虚拟机遇到一个给变量赋值的字节码指令时执行这个操作
    7. **store(存储)**:作用于工作内存的变量,把工作内存中的一个变量的值传送到主内存中,以便随后的write的操作
    8. **write(写入)**:作用于主内存的变量,它把store操作从工作内存中一个变量的值传送到主内存的变量中

### volatile

- volatile关键字是用来保证有序性和可见性的
- **有序性**:`volatile`是通过编译器在生成字节码时,在指令序列中添加**内存屏障**来禁止指令重排序的
- 当对volatile变量执行写操作后,JMM会把工作内存中的最新变量值强制刷新到主内存写操作会导致其他线程中的缓存无效这样,其他线程使用缓存时,发现本地工作内存中此变量无效,便从主内存中获取,这样获取到的变量便是最新的值,实现了线程的可见性

### synchronize

- synchronize是java中的关键字,可以用来修饰实例方法,静态方法,还有代码块,主要有三种作用:可以确保原子性,可见性,有序性
- synchronized的底层原理是跟monitor有关,也就是视图器锁,每个对象都有一个关联的monitor,当Synchronize获得monitor对象的所有权后会进行两个指令:加锁指令跟减锁指令
- monitor里面有个计数器,初始值是从0开始的,如果一个线程想要获取monitor的所有权,就看看它的计数器是不是0,如果是0的话,那么就说明没人获取锁,那么它就可以获取锁了,然后将计数器+1,也就是执行monitorenter加锁指令,monitorexit减锁指令是跟在程序执行结束和异常里的,如果不是0的话,就会陷入一个堵塞等待的过程,直到为0等待结束
- synchronized是同步锁,同步块内的代码相当于同一时刻单线程执行,故不存在原子性和指令重排序的问题

**Lock锁与synchronized的区别**

- Lock 能完成synchronized所实现的所有功能
- Lock可以知道是不是已经获取到锁,而synchronized无法知道
- Lock是显式锁(手动开启和关闭锁),synchronized是隐式锁,出了作用域自动释放
- Lock只有代码块锁,synchronized有代码块和方法锁
- Lock是一个接口,而synchronized是Java中的关键字,synchronized是内置的语言实现,synchronized在发生异常时,会自动释放线程占有的锁,因此不会导致死锁现象发生,而Lock在发生异常时,如果没有主动通过unLock()去释放锁,则很可能造成死锁现象,因此使用Lock时需要在finally块中释放锁

### 线程池

- 线程池顾名思义就是事先创建若干个可执行的线程放入一个池(容器)中,需要的时候从池中获取线程不用自行创建,使用完毕不需要销毁线程而是放回池中,从而减少创建和销毁线程对象的开销
- 使用线程池可以降低资源消耗,提高响应速度,提高线程的可管理性,提供更多更强大的功能

#### 主要参数

- 线程池核心线程数大小
- 最大线程数
    1. CPU 密集型:最大线程数等于本机CPU线程数,可以保持CPU的效率最高`Runtime.getRuntime().availableProcessors()`
    2. IO 密集型:最大线程数大于 > 判断你程序中十分耗IO的线程,应为IO会导致线程阻塞
- 空闲线程存活时长
- 时间单位
- 阻塞队列
- 线程工厂
- 拒绝策略

#### 运行流程

- 当需要任务大于核心线程数时候,就开始把任务往存储任务的队列里,当存储队列满了的话,就开始增加线程池创建的线程数量,如果当线程数量也达到了最大,就开始执行拒绝策略,比如说记录日志,直接丢弃,或者丢弃最老的任务,或者交给提交任务的线程执行
- 当一个线程完成时,它会从队列中取下一个任务来执行,当一个线程无事可做,且超过一定的时间(keepAliveTime)时,如果当前运行的线程数大于核心线程数,那么这个线程会停掉了

#### 线程池种类

- `Executors`:工具类,线程池的工厂类,用于创建并返回不同类型的线程池,本质上是调用ThreadPoolExecutor的构造方法
    - newFixedThreadPool创建一个指定大小的线程池,每当提交一个任务就创建一个线程,如果工作线程数量达到线程池初始的最大数,则将提交的任务存入到等待队列中
    - newCachedThreadPool创建一个可缓存的线程池,这种类型的线程池特点是:
        - 工作线程的创建数量几乎没有限制(其实也有限制的,数目为Interger. MAX_VALUE), 这样可灵活的往线程池中添加线程
        - 如果长时间没有往线程池中提交任务,即如果工作线程空闲了指定的时间(默认为1分钟),则该工作线程将自动终止,终止后,如果你又提交了新的任务,则线程池重新创建一个工作线程
    - newSingleThreadExecutor创建一个单线程的Executor,即只创建唯一的工作者线程来执行任务,如果这个线程异常结束,会有另一个取代它,保证顺序执行
    - newScheduleThreadPool创建一个定长的线程池,而且支持定时的以及周期性的任务执行,类似于Timer

#### 线程池的submit和execute的区别

**execute提交的方式**

execute提交的方式只能提交一个Runnable的对象,且该方法的返回值是void,也即是提交后如果线程运行后,和主线程就脱离了关系了,当然可以设置一些变量来获取到线程的运行结果,并且当线程的执行过程中抛出了异常通常来说主线程也无法获取到异常的信息的,只有通过ThreadFactory主动设置线程的异常处理类才能感知到提交的线程中的异常信息

**submit提交的方式**

- submit提交的方式有如下三种情况

```java
<T> Future<T> submit(Callable<T> task);
```

- 这种提交的方式是提交一个实现了Callable接口的对象,这种提交的方式会返回一个Future对象,这个Future对象代表这线程的执行结果
- 当主线程调用Future的get方法的时候会获取到从线程中返回的结果数据
- 如果在线程的执行过程中发生了异常,get会获取到异常的信息

```java
Future<?> submit(Runnable task);
```

- 也可以提交一个Runable接口的对象,这样当调用get方法的时候,如果线程执行成功会直接返回null,如果线程执行异常会返回异常的信息

```java
<T> Future<T> submit(Runnable task, T result);
```

- 这种方式除了task之外还有一个result对象,当线程正常结束的时候调用Future的get方法会返回result对象,当线程抛出异常的时候会获取到对应的异常的信息

### ThreadLocal

### 多线程按顺序执行

### 如何实现主线程等待子线程执行完后再继续执行？

1. 可以使用join方法,在主线程内部调用子线程.join方法
2. CountDownLatch实现
    - await()方法阻塞当前线程,直到计数器等于0
    - countDown()方法将计数器减一

### 解决死锁

1.  使用`jps -l`定位进程号
2.  使用`jstack`进程号,找到死锁问题并解决

## 集合

### List/Set/Map的区别

- List有序存取元素,可以有重复元素
- Set不能存放重复元素,存入的元素是无序的
- Map保存键值对映射,映射关系可以是一对一或多对一

### HashMap/Hashtable/HashSet/LinkedHashMap/TreeMap 比较

- Hashmap 是一个最常用的 Map,它根据键的 HashCode 值存储数据,HashMap 最多只允许一条记录的键为Null,允许多条记录的值为 Null
- Hashtable 与 HashMap 类似,不同的是:它不允许记录的键或者值为空,是线程安全的,因此也导致了 Hashtale 的效率偏低
- LinkedHashMap 是 HashMap 的一个子类,如果需要输出的顺序和输入的相同,那么用 LinkedHashMap 可以实现
- TreeMap 实现 SortMap 接口,内部实现是红黑树,能够把它保存的记录根据键排序,默认是按键值的升序排序,也可以指定排序的比较器,当用 Iterator 遍历 TreeMap 时,得到的记录是排过序的,TreeMap 不允许 key 的值为 null

### HashSet/LinkedHashSet/TreeSet 比较

- **HashSet**
    - HashSet 是由 HashMap 实现的,不保证元素的顺序
- **LinkedHashSet**
    - LinkedHashSet 集合同样是根据元素的 hashCode 值来决定元素的存储位置,但是它同时使用链表维护元素的次序,这样使得元素看起来像是以插入顺序保存的,也就是说,当遍历该集合时候,LinkedHashSet 将会以元素的添加顺序访问集合的元素
    - **LinkedHashSet 在迭代访问 Set 中的全部元素时,性能比 HashSet 好,但是插入时性能稍微逊色于 HashSet**
- **TreeSet**
    - TreeSet 是 SortedSet 接口的唯一实现类,TreeSet 可以确保集合元素处于排序状态

### ArrayList/LinkedList 比较

- ArrayList内部使用数组存放元素,实现了可变大小的数组,访问元素效率高,当插入元素效率低
- LinkedList内部使用双向链表存储元素,插入元素效率高,但访问元素效率低
- 相对于ArrayList,LinkedList的插入,添加,删除操作速度更快,因为当元素被添加到集合任意位置的时候,不需要像数组那样重新计算大小或者是更新索引
- LinkedList比ArrayList更占内存,因为LinkedList为每一个节点存储了两个引用,一个指向前一个元素,一个指向下一个元素

### Iterator和ListIterator

- Iterator提供了统一遍历操作集合元素的统一接口, Collection接口实现Iterable接口,每个集合都通过实现Iterable接口中iterator()方法返回Iterator接口的实例, 然后对集合的元素进行迭代操作

**Iterator和ListIterator的区别**

- Iterator可用来遍历Set和List集合,但是ListIterator只能用来遍历List
- Iterator对集合只能是前向遍历,ListIterator既可以前向也可以后向
- ListIterator实现了Iterator接口,并包含其他的功能,比如:增加元素,替换元素,获取前一个和后一个元素的索引,等等

### HashMap

- HashMap基于哈希表的Map接口实现,是以key-value存锗形式存在,即主要用来存放键值对,HashMap的实现不是同步的,这意味着它不是线程安全的,它的key,value都可以为null,此外,HashMap中的映射不是有序的
- jdk1.8之前HashMap由数组+链表组成的,数组是HashMap的主体,链表则是主要为了解决哈希冲突(两个对象调用的hashCode方法计算的哈希值一致导致计算的教组索引值相同)而存在的("拉链法”解决冲突)
- jdk1.8以后在解决哈希冲突时有了较大的变化,当链表长度大于阈值(或者红黑树的边界值,默认为8)并且当前数组的长度大于64时,此时此索引位置上的所有数据改为使用红黑树存储
- **补充**:将链表转换成红黑树前会判断,即便阈值大于8,但是数组长度小于64,此时并不会将链表变为红黑树,而是选择逬行数组扩容
- 这样做的目的是因为数组比较小,尽量避开红黑树结构,这种情况下变为红黑树结构,反而会降低效率,因为红黑树需要逬行左旋,右旋,变色这些操作来保持平衡,同时数组长度小于64时,搜索时间相对要快些,所以结上所述为了提高性能和减少搜索时间,底层阈值大于8并且数组长度大于64时,链表才转换为红黑树,具体可以参考 **treeifyBin() 方法,**
- 当然虽然增了红黑树作为底层数据结构,结构变得复杂了,但是阈值大于8并且数组长度大于64时,链表转换为红黑树时,效率也变的更高
- 使用HashMap,如果key是自定义的类,就必须重写hashcode()和equals()
- **HashMap的扩容机制**:HashMap底层是数组,在第一次put的时候会初始化,发生第一次扩容到16,它有一个负载因子是0.75,下一次扩容的时候就是当前数组大小*0.75,扩大容量为原来的2倍

### ConcurrentHashMap

-   Concurrenthashmap是线程安全的

-   JDK1.7

    -   采用Segment + HashEntry的方式进行实现的,Segment 类继承于 ReentrantLock 类,从而使得 Segment 对象能充当锁的角色,每个 Segment 对象用来守护其(成员对象 table 中)包含的若干个桶
    -   size的计算是先采用不加锁的方式,连续计算元素的个数,最多计算3次:
        1.  如果前后两次计算结果相同,则说明计算出来的元素个数是准确的
        2.  如果前后两次计算结果都不同,则给每个Segment进行加锁,再计算一次元素的个数

    -   ConcurrentHashMap 类中包含两个静态内部类 HashEntry 和 Segment,HashEntry 用来封装映射表的键 / 值对,Segment 用来充当锁的角色,每个 Segment 对象守护整个散列映射表的若干个桶,每个桶是由若干个 HashEntry 对象链接起来的链表,一个 ConcurrentHashMap 实例中包含由若干个 Segment 对象组成的数组,HashEntry 用来封装散列映射表中的键值对,在 HashEntry 类中,key,hash 和 next 域都被声明为 final 型,value 域被声明为 volatile 型
    -   在ConcurrentHashMap 中,在散列时如果产生"碰撞”,将采用"分离链接法”来处理"碰撞”:把"碰撞”的 HashEntry 对象链接成一个链表,由于 HashEntry 的 next 域为 final 型,所以新节点只能在链表的表头处插入,由于只能在表头插入,所以链表中节点的顺序和插入的顺序相反

-   JDK1.8

    -   放弃了Segment臃肿的设计,取而代之的是采用Node + CAS + Synchronized来保证并发安全进行实现
    -   使用一个volatile类型的变量baseCount记录元素的个数,当插入新数据或则删除数据时,会通过addCount()方法更新baseCount,通过累加baseCount和CounterCell数组中的数量,即可得到元素的总个数

### poll & offer

|                    | throw Exception | 返回false或null    |
| :----------------- | :-------------- | ------------------ |
| 添加元素到队尾     | add(E e)        | boolean offer(E e) |
| 取队首元素并删除   | E remove()      | E poll()           |
| 取队首元素但不删除 | E element()     | E peek()           |

### 快速失败(fail-fast)和安全失败(fail-safe)的区别

- Iterator的安全失败是基于对底层集合做拷贝,因此,它不受源集合上修改的影响,java.util包下面的所有的集合类都是快速失败的,而java.util.concurrent包下面的所有的类都是安全失败的,快速失败的迭代器会抛出ConcurrentModificationException异常,而安全失败的迭代器永远不会抛出这样的异常

### 红黑树

一种二叉查找树,但在每个节点增加一个存储位表示节点的颜色,可以是红或黑(非红即黑),通过对任何一条从根到叶子的路径上各个节点着色的方式的限制,红黑树确保没有一条路径会比其它路径长出两倍,因此,红黑树是一种弱平衡二叉树(由于是弱平衡,可以看到,在相同的节点情况下,AVL树的高度低于红黑树),相对于要求严格的AVL树来说,它的旋转次数少,所以对于搜索,插入,删除操作较多的情况下,我们就用红黑树


1. 每个节点要么是红色,要么是黑色
2. 根节点永远是黑色的
3. 所有的叶节点都是空节点(即 null),并且是黑色的
4. 每个红色节点的两个子节点都是黑色,(从每个叶子到根的路径上不会有两个连续的红色节点)
5. 从任一节点到其子树中每个叶子节点的路径都包含相同数量的黑色节点

### 重写 equals 和 hashCode

1. 作为`key`的对象必须正确覆写`equals()`方法,相等的两个`key`实例调用`equals()`必须返回`true`
2. 作为`key`的对象还必须正确覆写`hashCode()`方法,因为通过`key`计算索引的方式就是调用`key`对象的`hashCode()`方法,它返回一个`int`整数,`HashMap`正是通过这个方法直接定位`key`对应的`value`的索引,继而直接返回`value`,且`hashCode()`方法要严格遵循以下规范:
    - 如果两个对象相等,则两个对象的`hashCode()`必须相等
    - 如果两个对象不相等,则两个对象的`hashCode()`尽量不要相等
3. 即对应两个实例`a`和`b`:
    - 如果`a`和`b`相等,那么`a.equals(b)`一定为`true`,则`a.hashCode()`必须等于`b.hashCode()`
    - 如果`a`和`b`不相等,那么`a.equals(b)`一定为`false`,则`a.hashCode()`和`b.hashCode()`尽量不要相等

## 设计模式

### DCL

```java
public class Singleton {
  //Singleton对象属性,加上volatile关键字是为了防止指定重排序,要知道singleton = new Singleton()拆分成cpu指令的话,有足足3个步骤
  private volatile static Singleton singleton;

  //对外提供的获取实例的方法
  public static Singleton getInstance() {
    if (singleton == null) {
      synchronized (Singleton.class) {
        if (singleton == null) {
          singleton = new Singleton();
        }
      }
    }
    return singleton;
  }
}
```

从代码里可以看到,做了两重的singleton == null的判断,中间还用了synchronized关键字,第一个singleton == null的判断是为了避免线程串行化,如果为空,就进入synchronized代码块中,获取锁后再操作,如果不为空,直接就返回singleton对象了,无需再进行锁竞争和等待了,而第二个singleton == null的判断是为了防止有多个线程同时跳过第一个singleton == null的判断,比如线程一先获取到锁,进入同步代码块中,发现singleton实例还是null,就会做new操作,然后退出同步代码块并释放锁,这时一起跳过第一层singleton == null的判断的还有线程二,这时线程一释放了锁,线程二就会获取到锁,如果没有第二层的singleton == null这个判断挡着,那就会再创建一个singleton实例,就违反了单例的约束了

**总结**:DCL使用volatile关键字,是为了禁止指令重排序,避免返回还没完成初始化的singleton对象,导致调用报错,也保证了线程的安全

## Spring

### AOP

- AOP指面向切面编程,用于处理系统中分布于各个模块的横切关注点,把那些与业务无关,但是却为业务模块所共同调用的逻辑部分封装起来,从而使得业务逻辑各部分之间的耦合度降低, 提高程序的可重用性, 同时提高了开发的效率
- AOP实现的关键在于AOP框架自动创建的AOP代理,AOP代理主要分为静态代理和动态代理,静态代理的代表为AspectJ,而动态代理则以Spring AOP为代表
    - 通常使用AspectJ的编译时增强实现AOP,AspectJ是静态代理的增强,所谓的静态代理就是AOP框架会在编译阶段生成AOP代理类,因此也称为编译时增强
    - Spring AOP中的动态代理主要有两种方式,JDK动态代理和CGLIB动态代理,JDK动态代理通过反射来接收被代理的类,并且要求被代理的类必须实现一个接口,JDK动态代理的核心是InvocationHandler接口和Proxy类
- 在AOP编程中,我们经常会遇到下面的概念:
    - Joinpoint:连接点,即定义在应用程序流程的何处插入切面的执行
    - Pointcut:切入点,即一组连接点的集合
    - Advice:增强,指特定连接点上执行的动作
    - Introduction:引介,特殊的增强,指为一个已有的Java对象动态地增加新的接口
    - Weaving:织入,将增强添加到目标类具体连接点上的过程
    - Aspect:切面,由切点和增强(引介)组成,包括了对横切关注功能的定义,已包括了对连接点的定义

### IoC

- 控制反转,是把传统上由程序代码直接操控的对象的调用权交给容器,由容器来创建对象并管理对象之间的依赖关系,DI是对IoC更准确的描述,即由容器动态的将某种依赖关系注入到组件之中

- **IoC的原理**

    1. 定义用来描述bean的配置的Java类或配置文件
    2. 解析bean的配置,将bean的配置信息转换为的BeanDefinition对象保存在内存中,spring中采用HashMap进行对象存储,其中会用到一些xml解析技术

    - 遍历存放BeanDefinition的HashMap对象,逐条取出BeanDefinition对象,获取bean的配置信息,利用Java的反射机制实例化对象,将实例化后的对象保存在另外一个Map中

### DI

- 依赖注入的方式有以下几种:
    - @Autowired,@Resource
    - Setter方法注入
    - p命名空间和c命名空间注入
    - 构造器注入
    - 自动装配
    - 工厂模式的方法注入
- @Autowired 和@Resource区别
    - @Autowired注解是按照类型(byType)装配依赖对象,当有且仅有一个匹配的Bean时,Spring将其注入@Autowired标注的变量中,如果我们想使用按照名称(byName)来装配,可以结合@Qualifier注解一起使用
    - @Resource默认按照ByName自动注入,@Resource有两个重要的属性:name和type,而Spring将@Resource注解的name属性解析为bean的名字,而type属性则解析为bean的类型,所以,如果使用name属性,则使用byName的自动注入策略,而使用type属性时则使用byType自动注入策略,如果既不制定name也不制定type属性,这时将通过反射机制使用byName自动注入策略

### Bean作用域

- 在Spring的早期版本中仅有两个作用域:singleton和prototype,前者表示Bean以单例的方式存在,后者表示每次从容器中调用Bean时,都会返回一个新的实例
- Spring2.x中针对WebApplicationContext新增了3个作用域,分别是:request(每次HTTP请求都会创建一个新的Bean), session(同一个HttpSession共享同一个Beaan,不同的HttpSession使用不同的Bean)和globalSession(同一个全局Session共享一个Bean)

### Bean的生命周期

Spring生命周期流程图

![img](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-04-21-308572_1537967995043_4D7CF33471A392D943F00167D1C86C10.png)

### Spring ApplicationContext 容器

- **Application Context** :是BeanFactory的子类,因为古老的BeanFactory无法满足不断更新的spring的需求,于是ApplicationContext就基本上代替了BeanFactory的工作,它可以加载配置文件中定义的 bean,将所有的 bean 集中在一起,当有请求的时候分配 bean
- 最常被使用的 ApplicationContext 接口实现:
    - **FileSystemXmlApplicationContext**:该容器从 XML 文件中加载已被定义的 bean,在这里,你需要提供给构造器 XML 文件的完整路径
    - **ClassPathXmlApplicationContext**:该容器从 XML 文件中加载已被定义的 bean,在这里,你不需要提供 XML 文件的完整路径,只需正确配置 CLASSPATH 环境变量即可,因为,容器会从 CLASSPATH 中搜索 bean 配置文件
    - **WebXmlApplicationContext**:该容器会在一个 web 应用程序的范围内加载在 XML 文件中已被定义的 bean

### Spring 事务

- 事务属性可以理解成事务的一些基本配置,描述了事务策略如何应用到方法上,事务属性包含了5个方面:传播行为,隔离规则,回滚规则,事务超时,是否只读
- 并发状态下可能产生:　脏读,不可重复读,幻读的情况,因此我们需要将事务与事务之间隔离,Spring中定义了五种隔离规则:数据库默认,读未提交,读已提交,可重复读,序列化
- 当事务方法被另一个事务方法调用时,必须指定事务应该如何传播,Spring定义了七种传播行为:默认的事务传播行为是`PROPAGATION_REQUIRED`, 它适合于绝大多数的情况:如果当前没有事务,就新建一个事务,如果已经存在一个事务,则加入到这个事务中,这是最常见的选择

### Spring MVC的执行流程

1. `DispatcherServlet`表示前置控制器,是整个Spring MVC的控制中心,用户发出请求,`DispatcherServlet`接收请求并拦截请求
2. `HandlerMapping`为处理器映射,`DispatcherServlet`调用`HandlerMapping`,`HandlerMapping`根据请求url查找`Handler`
3. `HandlerExecution`表示具体的Handler,其主要作用是根据url查找Controller
4. `HandlerExecution`将解析后的信息传递给`DispatcherServlet`,如解析Controller映射等
5. `HandlerAdapter`表示处理器适配器,其按照特定的规则去执行`Handler`
6. `Handler`让具体的Controller执行
7. Controller将具体的执行信息返回给`HandlerAdapter`,如ModelAndView
8. `HandlerAdapter`将逻辑视图或模型传递给`DispatcherServlet`
9. `DispatcherServlet`调用`ViewResolver`将逻辑视图解析为真实视图对象
10. `ViewResolver`将解析的真实视图对象返回`DispatcherServlet`
11. `DispatcherServlet`利用是土地向对模型数据进行渲染
12. 最终视图呈现给客户端

### Spring MVC的常用注解

- `@Component`:会被spring容器识别,并转为bean
- `@Repository`:对Dao实现类进行注解
- `@Service`:对业务逻辑层进行注解
- `@Controller`:表明这个类是Spring MVC里的Controller,将其声明为Spring的一个Bean,Dispatch Servlet会自动扫描注解了此注解的类,并将Web请求映射到注解了@RequestMapping的方法上
- `@RequestMapping`:用来映射Web请求(访问路径和参数),处理类和方法的,它可以注解在类和方法上,注解在方法上的@RequestMapping路径会继承注解在类上的路径
- `@RequestBody`:可以将整个返回结果以某种格式返回,如json或xml格式
- `@PathVariable`:用来接收路径参数,如/news/001,可接收001作为参数,此注解放置在参数前
- `@RequestParam`:用于获取传入参数的值
- `@RestController`:是一个组合注解,组合了@Controller和@ResponseBody,意味着当只开发一个和页面交互数据的控制的时候,需要使用此注解

### Spring MVC将数据存储到session

一般都是使用Servlet-Api,在处理请求的方法参数列表中,添加一个HTTPSession对象,之后SpringMVC就可以自动注入进来了,在方法体中调用session.setAttribute就可以了

### 过滤器和拦截器的区别

1. 拦截器是基于java的反射机制的,而过滤器是基于函数回调
2. 拦截器不依赖servlet容器,过滤器依赖servlet容器
3. 拦截器只能对action请求起作用,而过滤器则可以对几乎所有的请求起作用
4. 拦截器可以访问action上下文,值栈里的对象,而过滤器不能访问
5. 在action的生命周期中,拦截器可以多次被调用,而过滤器只能在容器初始化时被调用一次
6. 拦截器可以获取IOC容器中的各个bean,而过滤器就不行,这点很重要,在拦截器里注入一个service,可以调用业务逻辑

### Spring拦截器的执行顺序

Springmvc的拦截器实现HandlerInterceptor接口后,会有三个抽象方法需要实现,分别为方法前执行preHandle,方法后postHandle,页面渲染后afterCompletion

1. 当俩个拦截器都实现放行操作时,顺序为preHandle 1,preHandle 2,postHandle 2,postHandle 1,afterCompletion 2,afterCompletion 1
2. 当第一个拦截器preHandle返回false,也就是对其进行拦截时,第二个拦截器是完全不执行的,第一个拦截器只执行preHandle部分
3. 当第一个拦截器preHandle返回true,第二个拦截器preHandle返回false,顺序为preHandle 1,preHandle 2,afterCompletion 1

总结:

```
preHandle 按拦截器定义顺序调用
postHandler 按拦截器定义逆序调用
afterCompletion 按拦截器定义逆序调用
postHandler 在拦截器链内所有拦截器返成功调用
afterCompletion 只有preHandle返回true才调用
```

### SpringBootApplication的加载过程

### Spring Security 原理

**过滤器**

- Spring Security 基本都是通过过滤器来完成配置的身份认证,权限认证以及登出
- Spring Security 在 Servlet 的过滤链(filter chain)中注册了一个过滤器 `FilterChainProxy`,它会把请求代理到 Spring Security 自己维护的多个过滤链,每个过滤链会匹配一些 URL,如果匹配则执行对应的过滤器,过滤链是有顺序的,一个请求只会执行第一条匹配的过滤链,Spring Security 的配置本质上就是新增,删除,修改过滤器
- 默认情况下系统帮我们注入的这 15 个过滤器,分别对应配置不同的需求,接下来我们重点是分析下 `UsernamePasswordAuthenticationFilter` 这个过滤器,他是用来使用用户名和密码登录认证的过滤器,但是很多情况下我们的登录不止是简单的用户名和密码,又可能是用到第三方授权登录,这个时候我们就需要使用自定义过滤器,当然这里不做详细说明,只是说下自定义过滤器怎么注入

```java
@Override
protected void configure(HttpSecurity http) throws Exception {

  http.addFilterAfter(...);
  ...
}
```

**身份认证流程**

在开始身份认证流程之前我们需要了解下几个基本概念

**SecurityContextHolder**

`SecurityContextHolder` 存储 `SecurityContext` 对象,`SecurityContextHolder` 是一个存储代理,有三种存储模式分别是:

- MODE_THREADLOCAL:SecurityContext 存储在线程中
- MODE_INHERITABLETHREADLOCAL:`SecurityContext` 存储在线程中,但子线程可以获取到父线程中的 `SecurityContext`
- MODE_GLOBAL:`SecurityContext` 在所有线程中都相同

`SecurityContextHolder` 默认使用 MODE_THREADLOCAL 模式,`SecurityContext` 存储在当前线程中,调用 `SecurityContextHolder` 时不需要显示的参数传递,在当前线程中可以直接获取到 `SecurityContextHolder` 对象

```java
//获取当前线程里面认证的对象
SecurityContext context = SecurityContextHolder.getContext();
Authentication authentication = context.getAuthentication();

//保存认证对象 (一般用于自定义认证成功保存认证对象)
SecurityContextHolder.getContext().setAuthentication(authResult);

//清空认证对象 (一般用于自定义登出清空认证对象)
SecurityContextHolder.clearContext();
```

**2.Authentication**

`Authentication` 即验证,表明当前用户是谁,什么是验证,比如一组用户名和密码就是验证,当然错误的用户名和密码也是验证,只不过 Spring Security 会校验失败

`Authentication` 接口

```java
public interface Authentication extends Principal, Serializable {
  //获取用户权限,一般情况下获取到的是用户的角色信息
  Collection<? extends GrantedAuthority> getAuthorities();
  //获取证明用户认证的信息,通常情况下获取到的是密码等信息,不过登录成功就会被移除
  Object getCredentials();
  //获取用户的额外信息,比如 IP 地址,经纬度等
  Object getDetails();
  //获取用户身份信息,在未认证的情况下获取到的是用户名,在已认证的情况下获取到的是 UserDetails (暂时理解为,当前应用用户对象的扩展)
  Object getPrincipal();
  //获取当前 Authentication 是否已认证
  boolean isAuthenticated();
  //设置当前 Authentication 是否已认证
  void setAuthenticated(boolean isAuthenticated);
}
```

**3.AuthenticationManager ProviderManager AuthenticationProvider**

其实这三者很好区分,`AuthenticationManager` 主要就是为了完成身份认证流程,`ProviderManager`是 `AuthenticationManager` 接口的具体实现类,`ProviderManager` 里面有个记录 `AuthenticationProvider` 对象的集合属性 `providers`,`AuthenticationProvider` 接口类里有两个方法

```java
public interface AuthenticationProvider {
  //实现具体的身份认证逻辑,认证失败抛出对应的异常
  Authentication authenticate(Authentication authentication)
    throws AuthenticationException;
  //该认证类是否支持该 Authentication 的认证
  boolean supports(Class<?> authentication);
}
```

接下来就是遍历 `ProviderManager` 里面的 `providers` 集合,找到和合适的 `AuthenticationProvider`完成身份认证

**4.UserDetailsService UserDetails**

在 `UserDetailsService` 接口中只有一个简单的方法

```java
public interface UserDetailsService {
  //根据用户名查到对应的 UserDetails 对象
  UserDetails loadUserByUsername(String username) throws UsernameNotFoundException;
}
```

**5.流程**

对于上面概念有什么不明白的地方,在们在接下来的流程中慢慢分析

在运行到 `UsernamePasswordAuthenticationFilter` 过滤器的时候首先是进入其父类 `AbstractAuthenticationProcessingFilter` 的 `doFilter()` 方法中

```java
public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
  throws IOException, ServletException {
  ...
    //首先配对是不是配置的身份认证的URI,是则执行下面的认证,不是则跳过
    if (!requiresAuthentication(request, response)) {
      chain.doFilter(request, response);

      return;
    }
  ...
    Authentication authResult;

  try {
    //关键方法, 实现认证逻辑并返回 Authentication, 由其子类 UsernamePasswordAuthenticationFilter 实现, 由下面 5.3 详解
    authResult = attemptAuthentication(request, response);
    if (authResult == null) {
      // return immediately as subclass has indicated that it hasn't completed
      // authentication
      return;
    }
    sessionStrategy.onAuthentication(authResult, request, response);
  }
  catch (InternalAuthenticationServiceException failed) {
    //认证失败调用...由下面 5.1 详解
    unsuccessfulAuthentication(request, response, failed);

    return;
  }
  catch (AuthenticationException failed) {
    //认证失败调用...由下面 5.1 详解
    unsuccessfulAuthentication(request, response, failed);

    return;
  }

  // Authentication success
  if (continueChainBeforeSuccessfulAuthentication) {
    chain.doFilter(request, response);
  }
  //认证成功调用...由下面 5.2 详解
  successfulAuthentication(request, response, chain, authResult);
}
```

**5.1 认证失败处理逻辑**

```java
protected void unsuccessfulAuthentication(HttpServletRequest request,
                                          HttpServletResponse response, AuthenticationException failed)
  throws IOException, ServletException {
  SecurityContextHolder.clearContext();
  ...
    rememberMeServices.loginFail(request, response);
  //该 handler 处理失败界面跳转和响应逻辑
  failureHandler.onAuthenticationFailure(request, response, failed);
}
```

这里默认配置的失败处理 handler 是 `SimpleUrlAuthenticationFailureHandler`,**可自定义**

```java
public class SimpleUrlAuthenticationFailureHandler implements
        AuthenticationFailureHandler {
    ...

    public void onAuthenticationFailure(HttpServletRequest request,
            HttpServletResponse response, AuthenticationException exception)
            throws IOException, ServletException {
        //没有配置失败跳转的URL则直接响应错误
        if (defaultFailureUrl == null) {
            logger.debug("No failure URL set, sending 401 Unauthorized error");

            response.sendError(HttpStatus.UNAUTHORIZED.value(),
                HttpStatus.UNAUTHORIZED.getReasonPhrase());
        }
        else {
            //否则
            //缓存异常
            saveException(request, exception);
            //根据配置的异常页面是重定向还是转发进行不同方式跳转
            if (forwardToDestination) {
                logger.debug("Forwarding to " + defaultFailureUrl);

                request.getRequestDispatcher(defaultFailureUrl)
                        .forward(request, response);
            }
            else {
                logger.debug("Redirecting to " + defaultFailureUrl);
                redirectStrategy.sendRedirect(request, response, defaultFailureUrl);
            }
        }
    }
    //缓存异常,转发则保存在request里面,重定向则保存在session里面
    protected final void saveException(HttpServletRequest request,
            AuthenticationException exception) {
        if (forwardToDestination) {
            request.setAttribute(WebAttributes.AUTHENTICATION_EXCEPTION, exception);
        }
        else {
            HttpSession session = request.getSession(false);

            if (session != null || allowSessionCreation) {
                request.getSession().setAttribute(WebAttributes.AUTHENTICATION_EXCEPTION,
                        exception);
            }
        }
    }
}
```

**这里做下小拓展:用系统的错误处理handler,指定认证失败跳转的URL,在MVC里面对应的URL方法里面可以通过key从`request`或`session`里面拿到错误信息,反馈给前端**

**5.2 认证成功处理逻辑**

```java
protected void successfulAuthentication(HttpServletRequest request,
                                        HttpServletResponse response, FilterChain chain, Authentication authResult)
  throws IOException, ServletException {
  ...
    //这里要注意很重要,将认证完成返回的 Authentication 保存到线程对应的 `SecurityContext` 中
    SecurityContextHolder.getContext().setAuthentication(authResult);

  rememberMeServices.loginSuccess(request, response, authResult);

  // Fire event
  if (this.eventPublisher != null) {
    eventPublisher.publishEvent(new InteractiveAuthenticationSuccessEvent(
      authResult, this.getClass()));
  }
  //该 handler 就是为了完成页面跳转
  successHandler.onAuthenticationSuccess(request, response, authResult);
}
```

这里默认配置的成功处理 handler 是 `SavedRequestAwareAuthenticationSuccessHandler`,里面的代码就不做具体展开了,反正是跳转到指定的认证成功之后的界面,**可自定义**

**5.3 身份认证详情**

```java
public class UsernamePasswordAuthenticationFilter extends
  AbstractAuthenticationProcessingFilter {
  ...
    public static final String SPRING_SECURITY_FORM_USERNAME_KEY = "username";
  public static final String SPRING_SECURITY_FORM_PASSWORD_KEY = "password";

  private String usernameParameter = SPRING_SECURITY_FORM_USERNAME_KEY;
  private String passwordParameter = SPRING_SECURITY_FORM_PASSWORD_KEY;
  private boolean postOnly = true;

  ...
    //开始身份认证逻辑
    public Authentication attemptAuthentication(HttpServletRequest request,
                                                HttpServletResponse response) throws AuthenticationException {
    if (postOnly && !request.getMethod().equals("POST")) {
      throw new AuthenticationServiceException(
        "Authentication method not supported: " + request.getMethod());
    }

    String username = obtainUsername(request);
    String password = obtainPassword(request);

    if (username == null) {
      username = "";
    }

    if (password == null) {
      password = "";
    }

    username = username.trim();
    //先用前端提交过来的 username 和 password 封装一个简易的 AuthenticationToken
    UsernamePasswordAuthenticationToken authRequest = new UsernamePasswordAuthenticationToken(
      username, password);

    // Allow subclasses to set the "details" property
    setDetails(request, authRequest);
    //具体的认证逻辑还是交给 AuthenticationManager 对象的 authenticate(..) 方法完成,接着往下看
    return this.getAuthenticationManager().authenticate(authRequest);
  }
}
```

由源码断点跟踪得知,最终解析是由 `AuthenticationManager` 接口实现类 `ProviderManager` 来完成

```java
public class ProviderManager implements AuthenticationManager, MessageSourceAware,
InitializingBean {
  ...
    private List<AuthenticationProvider> providers = Collections.emptyList();
  ...

    public Authentication authenticate(Authentication authentication)
    throws AuthenticationException {
    ....
      //遍历所有的 AuthenticationProvider, 找到合适的完成身份验证
      for (AuthenticationProvider provider : getProviders()) {
        if (!provider.supports(toTest)) {
          continue;
        }
        ...
          try {
            //进行具体的身份验证逻辑, 这里使用到的是 DaoAuthenticationProvider, 具体逻辑记着往下看
            result = provider.authenticate(authentication);

            if (result != null) {
              copyDetails(authentication, result);
              break;
            }
          }
        catch
          ...
      }
    ...
      throw lastException;
  }
}
```

`DaoAuthenticationProvider` 继承自 `AbstractUserDetailsAuthenticationProvider` 实现了 `AuthenticationProvider` 接口

```java
public abstract class AbstractUserDetailsAuthenticationProvider implements
  AuthenticationProvider, InitializingBean, MessageSourceAware {
  ...
    private UserDetailsChecker preAuthenticationChecks = new DefaultPreAuthenticationChecks();
  private UserDetailsChecker postAuthenticationChecks = new DefaultPostAuthenticationChecks();
  ...

    public Authentication authenticate(Authentication authentication)
    throws AuthenticationException {
    ...
      // 获得提交过来的用户名
      String username = (authentication.getPrincipal() == null) ? "NONE_PROVIDED"
      : authentication.getName();
    //根据用户名从缓存中查找 UserDetails
    boolean cacheWasUsed = true;
    UserDetails user = this.userCache.getUserFromCache(username);

    if (user == null) {
      cacheWasUsed = false;

      try {
        //缓存中没有则通过 retrieveUser(..) 方法查找 (看下面 DaoAuthenticationProvider 的实现)
        user = retrieveUser(username,
                            (UsernamePasswordAuthenticationToken) authentication);
      }
      catch
        ...
    }

    try {
      //比对前的检查,例如账户以一些状态信息(是否锁定, 过期...)
      preAuthenticationChecks.check(user);
      //子类实现比对规则 (看下面 DaoAuthenticationProvider 的实现)
      additionalAuthenticationChecks(user,
                                     (UsernamePasswordAuthenticationToken) authentication);
    }
    catch (AuthenticationException exception) {
      if (cacheWasUsed) {
        // There was a problem, so try again after checking
        // we're using latest data (i.e. not from the cache)
        cacheWasUsed = false;
        user = retrieveUser(username,
                            (UsernamePasswordAuthenticationToken) authentication);
        preAuthenticationChecks.check(user);
        additionalAuthenticationChecks(user,
                                       (UsernamePasswordAuthenticationToken) authentication);
      }
      else {
        throw exception;
      }
    }

    postAuthenticationChecks.check(user);

    if (!cacheWasUsed) {
      this.userCache.putUserInCache(user);
    }

    Object principalToReturn = user;

    if (forcePrincipalAsString) {
      principalToReturn = user.getUsername();
    }
    //根据最终user的一些信息重新生成具体详细的 Authentication 对象并返回
    return createSuccessAuthentication(principalToReturn, authentication, user);
  }
  //具体生成还是看子类实现
  protected Authentication createSuccessAuthentication(Object principal,
                                                       Authentication authentication, UserDetails user) {
    // Ensure we return the original credentials the user supplied,
    // so subsequent attempts are successful even with encoded passwords.
    // Also ensure we return the original getDetails(), so that future
    // authentication events after cache expiry contain the details
    UsernamePasswordAuthenticationToken result = new UsernamePasswordAuthenticationToken(
      principal, authentication.getCredentials(),
      authoritiesMapper.mapAuthorities(user.getAuthorities()));
    result.setDetails(authentication.getDetails());

    return result;
  }
}
```

接下来我们来看下 `DaoAuthenticationProvider` 里面的三个重要的方法,比对方式,获取需要比对的 `UserDetails` 对象以及生产最终返回 `Authentication` 的方法

```java
public class DaoAuthenticationProvider extends AbstractUserDetailsAuthenticationProvider {
  ...
    //密码比对
    @SuppressWarnings("deprecation")
    protected void additionalAuthenticationChecks(UserDetails userDetails,
                                                  UsernamePasswordAuthenticationToken authentication)
    throws AuthenticationException {
    if (authentication.getCredentials() == null) {
      logger.debug("Authentication failed: no credentials provided");

      throw new BadCredentialsException(messages.getMessage(
        "AbstractUserDetailsAuthenticationProvider.badCredentials",
        "Bad credentials"));
    }

    String presentedPassword = authentication.getCredentials().toString();
    //通过 PasswordEncoder 进行密码比对, 注: 可自定义
    if (!passwordEncoder.matches(presentedPassword, userDetails.getPassword())) {
      logger.debug("Authentication failed: password does not match stored value");

      throw new BadCredentialsException(messages.getMessage(
        "AbstractUserDetailsAuthenticationProvider.badCredentials",
        "Bad credentials"));
    }
  }

  //通过 UserDetailsService 获取 UserDetails
  protected final UserDetails retrieveUser(String username,
                                           UsernamePasswordAuthenticationToken authentication)
    throws AuthenticationException {
    prepareTimingAttackProtection();
    try {
      //通过 UserDetailsService 获取 UserDetails
      UserDetails loadedUser = this.getUserDetailsService().loadUserByUsername(username);
      if (loadedUser == null) {
        throw new InternalAuthenticationServiceException(
          "UserDetailsService returned null, which is an interface contract violation");
      }
      return loadedUser;
    }
    catch (UsernameNotFoundException ex) {
      mitigateAgainstTimingAttack(authentication);
      throw ex;
    }
    catch (InternalAuthenticationServiceException ex) {
      throw ex;
    }
    catch (Exception ex) {
      throw new InternalAuthenticationServiceException(ex.getMessage(), ex);
    }
  }

  //生成身份认证通过后最终返回的 Authentication, 记录认证的身份信息
  @Override
  protected Authentication createSuccessAuthentication(Object principal,
                                                       Authentication authentication, UserDetails user) {
    boolean upgradeEncoding = this.userDetailsPasswordService != null
      && this.passwordEncoder.upgradeEncoding(user.getPassword());
    if (upgradeEncoding) {
      String presentedPassword = authentication.getCredentials().toString();
      String newPassword = this.passwordEncoder.encode(presentedPassword);
      user = this.userDetailsPasswordService.updatePassword(user, newPassword);
    }
    return super.createSuccessAuthentication(principal, authentication, user);
  }
}
```

## Mybatis

### MyBatis核心类

### Mybatis的执行过程

1. 读取MyBatis的核心配置文件
2. 构造SqlSessionFactoryBuilder获取SqlSessionFactory
3. SqlSessionFactory创建会话对象SqlSession
4. 使用SqlSession获得Mapper
5. 调用Mapper接口中的方法

### Mybatis的Mapper只有接口没有实现类却能工作的原因

1. 获取已知的加载过的Mapper中获取出MapperProxyFactory,Mapper代理工厂是通过Class.forName反射生成namespace的对应接口的反射对象并将生成的对象传入MapperProxyFactory的构造函数,最后存入knownMappers集合
2. 代理工厂生成动态代理返回,调用MapperProxyFactory的newInstance方法封装InvocationHandler的实现类MapperProxy,最后并返回代理类

### 命名空间

- 在大型项目中,可能存在大量SQL语句,这时候为每个SQL语句起一个唯一的标识就变得并不容易了,为了解决这个问题,在Mybatis中,可以为每个映射文件起一个唯一的命名空间,这样定义在这个映射文件中的每个SQL语句就成了定义在这个命名空间中的一个ID,只要我们能保证每个命名空间中的这个ID是唯一的,即使在不同的映射文件中的语句ID相同,也不会再产生冲突了

### #{ } 和${ }的区别

- `#{}`:这种方式是使用的预编译的方式,一个#{}就是一个占位符,相当于jdbc的占位符PrepareStatement,设置值的时候会加上引号
- `${}`:这种方式是直接拼接的方式,不对数值做预编译,存在sql注入的现象,设置值的时候不会加上引号

### 二级缓存

- Mybatis中一级缓存是默认开启的,二级缓存默认是不开启的,一级缓存是对于一个sqlSeesion而言,而二级缓存是对于一个nameSpace而言,可以多个SqlSession共享
- 查出的数据都会被默认先放在一级缓存中,只有会话提交或者关闭以后, 一级缓存中的数据才会转到二级缓存中

## MySQL

### 数据库建表三大范式

- 第一范式:原子性,要求属性具有原子性,不可再分解
- 第二范式:唯一性,要求记录有唯一标识,即实体的唯一性,即不存在部分依赖
- 第三范式:消除冗余性,要求任何字段不能由其他字段派生出来,它要求字段没有冗余,即不存在传递依赖

### B 树 与 B+ 树

- B+树的中间节点不保存数据,所以磁盘页能容纳更多节点数据,更矮胖
- B+树查询必须查找到叶子节点,B树查询有可能在非叶子节点结束,因此B+树的查询更稳定
- 对于范围查找来说,B+树只需序遍历叶子节点链表即可,B树却需要重复地中序遍历
- B+树非叶子节点相当于是叶子节点的索引层,叶子节点是 存储关键字数据的数据层,实现了索引与数据的分离

### druid连接池

1. 强大的监控特性,通过Druid提供的监控功能,可以清楚知道连接池和SQL的工作情况
   1.  监控SQL的执行时间,ResultSet持有时间,返回行数,更新行数,错误次数,错误堆栈信息;
   2.  SQL执行的耗时区间分布,什么是耗时区间分布呢？比如说,某个SQL执行了1000次,其中`0~1`毫秒区间50次,`1~10`毫秒800次,`10~100`毫秒100次,`100~1000`毫秒30次,`1~10`秒15次,10秒以上5次,通过耗时区间分布,能够非常清楚知道SQL的执行耗时情况
   3.  监控连接池的物理连接创建和销毁次数,逻辑连接的申请和关闭次数,非空等待次数,PSCache命中率等
2. 其次,方便扩展,Druid提供了Filter-Chain模式的扩展API,可以自己编写Filter拦截JDBC中的任何方法,可以在上面做任何事情,比如说性能监控,SQL审计,用户名密码加密,日志等等
3. Druid集合了开源和商业数据库连接池的优秀特性,并结合阿里巴巴大规模苛刻生产环境的使用经验进行优化

### InnoDB和MyISAM的区别

- InnoDB支持事务,MyISAM不支持
- InnoDB支持行级锁而MyISAM仅仅支持表锁,但是InnoDB可能出现死锁
- InnoDB的关注点在于:并发写,事务,更大资源,而MyISAM的关注点在于:节省资源,消耗少,简单业务
- InnoDB比MyISAM更安全,但是MyISAM的效率要比InnoDB高
- 在MySQL5.7的时候,默认就是InnoDb作为默认的存储引擎了

### EXPLAIN

- 使用EXPLAIN关键字可以模拟优化器执行SQL查询语句,从而知道MySQL是如何处理你的SQL语句的,分析查询语句或是表结构的性能瓶颈

```
Explain + SQL语句
```

- 通过Explain,我们可以获取以下信息:
  - 表的读取顺序
  - 哪些索引可以使用
  - 数据读取操作的操作类型
  - **哪些索引被实际使用**
  - 表之间的引用
  - 每张表有多少行被物理查询

### 索引

### 数据库优化

- 选取最适用的字段属性
- 使用连接查询代替子查询
- 选择表合适存储引擎
- 对查询进行优化,应尽量避免全表扫描,首先应考虑在 WHERE 及 ORDER BY 涉及的列上建立索引
- 避免索引失效

### 索引优化

- 使用复合索引的效果会大于使用单个字段索引
- 查询条件时要按照索引中的定义顺序进行匹配,如果索引了多列,要遵守最左前缀法则,指的是查询从索引的最左前列开始并且不跳过索引中的列
- 不在索引列上做任何操作(计算,函数,(自动or手动)类型转换),会导致索引失效而转向全表扫描
- 存储引擎不能使用索引中范围条件右边的列,范围查询的列在定义索引的时候,应该放在最后面
- mysql 在使用不等于(!= 或者<>)的时候无法使用索引会导致全表扫描
- is not null 也无法使用索引,但是is null是可以使用索引的
- like以通配符开头('%abc...')mysql索引失效会变成全表扫描的操作
- 字符串不加单引号索引失效(类型转换导致索引失效)

### 锁

- 按锁定对象不同可以分为表级锁和行级锁,按并发事务锁定关系可以分为共享锁和独占锁

**独占锁**

- MyISAM支持表锁,InnoDB支持表锁和行锁,默认行锁
    - **表级锁**:开锁小,加锁快,不会出现死锁,锁的粒度大,发生锁冲突的概率最高,并发量最低
    - **行级锁**:开销大,加锁慢,会出现死锁,锁的粒度小,容易发生冲突的概率小,并发度最高,innoDB支持三种行锁定方式
        - 行锁(Record Lock):锁直接加在索引记录上面(无索引项时演变成表锁)
        - 间隙锁(Gap Lock):锁定索引记录间隙,确保索引记录的间隙不变,间隙锁是针对事务隔离级别为可重复读或以上级别的
        - Next-Key Lock:行锁和间隙锁组合起来就是 Next-Key Lock
- **何时使用行锁,何时产生间隙锁**
    - 只使用唯一索引查询,并且只锁定一条记录时,innoDB会使用行锁
    - 只使用唯一索引查询,但是检索条件是范围检索,或者是唯一检索然而检索结果不存在(试图锁住不存在的数据)时,会产生间隙锁
    - 使用普通索引检索时,不管是何种查询,只要加锁,都会产生间隙锁
    - 同时使用唯一索引和普通索引时,由于数据行是优先根据普通索引排序,再根据唯一索引排序,所以也会产生间隙锁

**乐观锁**

- 使用数据版本(Version)记录机制实现,这是乐观锁最常用的一种实现方式
    - 数据版本:即为数据增加一个版本标识,一般是通过为数据库表增加一个数字类型的"version” 字段来实现,当读取数据时,将version字段的值一同读出,数据每更新一次,对此version值加一,当我们提交更新的时候,判断数据库表对应记录的当前版本信息与第一次取出来的version值进行比对,如果数据库表当前版本号与第一次取出来的version值相等,则予以更新,否则认为是过期数据
- 使用时间戳(timestamp),乐观锁定的第二种实现方式和第一种差不多,同样是在需要乐观锁控制的table中增加一个字段,名称无所谓,字段类型使用时间戳(timestamp),和上面的version类似,也是在更新提交的时候检查当前数据库中数据的时间戳和自己更新前取到的时间戳进行对比,如果一致则OK,否则就是版本冲突

### 事务

#### ACID

- 原子性(Atomic):事务中各项操作,要么全做要么全不做,任何一项操作的失败都会导致整个事务的失败
- 一致性(Consistent):事务结束后系统状态是一致的
- 隔离性(Isolated):并发执行的事务彼此无法看到对方的中间状态
- 持久性(Durable):事务完成后所做的改动都会被持久化,即使发生灾难性的失败,通过日志和同步备份可以在故障发生后重建数据

#### 隔离级别

- **并发下遇到的问题**

    - **脏读(Dirty Read)**:A事务读取B事务尚未提交的数据并在此基础上操作,而B事务执行回滚,那么A读取到的数据就是脏数据
    - **不可重复读(Unrepeatable Read)**:事务A重新读取前面读取过的数据,发现该数据已经被另一个已提交的事务B修改过了
    - **幻读(Phantom Read)**:事务A重新执行一个查询,返回一系列符合查询条件的行,发现其中插入了被事务B提交的行
    - **第1类丢失更新**:事务A撤销时,把已经提交的事务B的更新数据覆盖了
    - **第2类丢失更新**:事务A覆盖事务B已经提交的数据,造成事务B所做的操作丢失

- 数据库通常会通过锁机制来解决数据并发访问问题,直接使用锁是非常麻烦的,为此数据库为用户提供了自动锁机制,只要用户指定会话的事务隔离级别,数据库就会通过分析SQL语句然后为事务访问的资源加上合适的锁,此外,数据库还会维护这些锁通过各种手段提高系统的性能,这些对用户来说都是透明的

- **隔离级别**

    - **未提交读(Read Uncommitted)**:允许脏读,也就是可能读取到其他会话中未提交事务修改的数据

    - **提交读(Read Committed)**:只能读取到已经提交的数据
    - **可重复读(Repeated Read)**:可重复读,在同一个事务内的查询都是事务开始时刻一致的,InnoDB默认级别,在SQL标准中,该隔离级别消除了不可重复读,但是还存在幻读,Oracle等多数数据库默认都是该级别 (不重复读)
    - **串行读(Serializable)**:完全串行化的读,每次读都需要获得表级共享锁,读写相互都会阻塞
    - 事务隔离级别和数据访问的并发性是对立的,事务隔离级别越高并发性就越差,所以要根据具体的应用来确定合适的事务隔离级别

- **隔离级别与锁的关系**

    - 未提交读(Read Uncommitted):不加任何锁
    - 提交读(Read Committed):数据的读取都是不加锁的,但是数据的写入,修改和删除是需要加锁的
    - 可重复读(Repeatable Read):以间隙锁的方式对数据行进行加锁,当InnoDB扫描索引记录的时候,会首先对索引记录加上行锁(Record Lock),再对索引记录两边的间隙加上间隙锁(Gap Lock),加上间隙锁之后,其他事务就不能在这个间隙修改或者插入记录

#### 手动事务处理

- Connection提供了事务处理的方法,通过调用setAutoCommit(false)可以设置手动提交事务,当事务完成后用commit()显式提交事务如果在事务处理过程中发生异常则通过rollback()进行事务回滚,除此之外,从JDBC 3.0中还引入了Savepoint(保存点)的概念,允许通过代码设置保存点并让事务回滚到指定的保存点

### 数据库连接池

- 由于创建连接和释放连接都有很大的开销(尤其是数据库服务器不在本地时,为了提升系统访问数据库的性能,可以事先创建若干连接置于连接池中,需要时直接从连接池获取,使用结束时归还连接池而不必关闭连接,从而避免频繁创建和释放连接所造成的开销
- 这是典型的用空间换取时间的策略(浪费了空间存储连接,但节省了创建和释放连接的时间)
- 池化技术在Java开发中是很常见的,在使用线程时创建线程池的道理与此相同,基于Java的开源数据库连接池主要有:C3P0,Hikari ,DBCP,BoneCP,Druid等

### SQL语句执行过程

- 首先来看,在 MySQL 数据库中,一条查询语句是如何执行的,索引出现在哪个环节,起到了什么作用

1. 应用程序发现 SQL 到服务端
    - 当执行 SQL 语句时,应用程序会连接到相应的数据库服务器,然后服务器对 SQL 进行处理
2. 查询缓存
    - 接着数据库服务器会先去查询是否有该 SQL 语句的缓存,key 是查询的语句,value 是查询的结果,如果你的查询能够直接命中,就会直接从缓存中拿出 value 来返回客户端
    - **注:查询不会被解析,不会生成执行计划,不会被执行,**
3. 查询优化处理,生成执行计划
    - 如果没有命中缓存,则开始第三步
    - **解析 SQL**:生成解析树,验证关键字如 select,where,left join 等)是否正确
    - **预处理**:进一步检查解析树是否合法,如 **检查数据表和列是否存在**,验证用户权限等
    - **优化 SQL**:决定使用哪个索引,或者在多个表相关联的时候决定表的连接顺序,紧接着,将 SQL 语句转成执行计划
4. 将查询结果返回客户端
    - 最后,数据库服务器将查询结果返回给客户端,(如果查询可以缓存,MySQL 也会将结果放到查询缓存中)

![img](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-04-23-4383d050326b869fde80b6e5b937a2fe-20210423010306492.png)

### 数据库主键为什么要用递增的序列？UUID为什么不适合做主键？

- 顺序的ID占用的空间比随机ID占用的空间小
- 原因是数据库主键和索引索引使用B+树的数据结构进行存储,顺序ID数据存储在最后一个节点的最后的位置,前面的节点数据都是满的
- 随机ID存储时可能会出现节点分裂,导致节点多了,但是每个节点的数据量少了,存储到文件系统中时,无论节点中数据是不是满的都会占用一页的空间,所以所导致空间占用较大

### 分表策略

- 水平拆分行,行数据拆分到不同表中,垂直拆分列,表数据拆分到不同表中
- **垂直拆分**:单表大数据量依然存在性能瓶颈,垂直拆分就是要把表按模块划分到不同数据库表中,相对于垂直切分更进一步的是服务化改造,说得简单就是要把原来强耦合的系统拆分成多个弱耦合的服务,通过服务间的调用来满足业务需求看,因此表拆出来后要通过服务的形式暴露出去,而不是直接调用不同模块的表
- **水平拆分**:上面谈到垂直切分只是把表按模块划分到不同数据库,但没有解决单表大数据量的问题,而水平切分就是要把一个表按照某种规则把数据划分到不同表或数据库里,例如像计费系统,通过按时间来划分表就比较合适,因为系统都是处理某一时间段的数据,而像SaaS应用,通过按用户维度来划分数据比较合适,因为用户与用户之间的隔离的,一般不存在处理多个用户数据的情况,简单的按user_id范围来水平切分

### 主从同步

### 日志

## Redis

### 什么是中间件

中间件是一类提供系统软件和应用软件之间连接,便于软件各部件之间的沟通的软件,应用软件可以借助中间件在不同的技术架构之间共享信息与资源,中间件位于客户机服务器的操作系统之上,管理着计算资源和网络通信

### 分布式锁

- Redis 锁主要利用 Redis 的 setnx 命令
    - 加锁命令:SETNX key value,当键不存在时,对键进行设置操作并返回成功,否则返回失败,KEY 是锁的唯一标识,一般按业务来决定命名
    - 解锁命令:DEL key,通过删除键值对释放锁,以便其他线程可以通过 SETNX 命令来获取锁
    - 锁超时:EXPIRE key timeout, 设置 key 的超时时间,以保证即使锁没有被显式释放,锁也可以在一定时间后自动释放,避免资源被永远锁住
- **SETNX 和 EXPIRE 非原子性**
    - 如果 SETNX 成功,在设置锁超时时间后,服务器挂掉,重启或网络问题等,导致 EXPIRE 命令没有执行,锁没有设置超时时间变成死锁
    - 有很多开源代码来解决这个问题,比如使用 lua 脚本
- **锁误解除**
    - 如果线程 A 成功获取到了锁,并且设置了过期时间 30 秒,但线程 A 执行时间超过了 30 秒,锁过期自动释放,此时线程 B 获取到了锁,随后 A 执行完成,线程 A 使用 DEL 命令来释放锁,但此时线程 B 加的锁还没有执行完成,线程 A 实际释放的线程 B 加的锁
    - 通过在 value 中设置当前线程加锁的标识,在删除之前验证 key 对应的 value 判断锁是否是当前线程持有,可生成一个 UUID 标识当前线程,使用 lua 脚本做验证标识和解锁操作
- **超时解锁导致并发**
    - 如果线程 A 成功获取锁并设置过期时间 30 秒,但线程 A 执行时间超过了 30 秒,锁过期自动释放,此时线程 B 获取到了锁,线程 A 和线程 B 并发执行
    - A,B 两个线程发生并发显然是不被允许的,一般有两种方式解决该问题:
        - 将过期时间设置足够长,确保代码逻辑在锁释放之前能够执行完成
        - 为获取锁的线程增加守护线程,为将要过期但未释放的锁增加有效时间
- **不可重入**
    - 当线程在持有锁的情况下再次请求加锁,如果一个锁支持一个线程多次加锁,那么这个锁就是可重入的,如果一个不可重入锁被再次加锁,由于该锁已经被持有,再次加锁会失败,Redis 可通过对锁进行重入计数,加锁时加 1,解锁时减 1,当计数归 0 时释放锁
    - ThreadLocal或RedisMap实现计数
- **无法等待锁释放**
    - 上述命令执行都是立即返回的,如果客户端可以等待锁释放就无法使用
        - 可以通过客户端轮询的方式解决该问题,当未获取到锁时,等待一段时间重新获取锁,直到成功获取锁或等待超时,这种方式比较消耗服务器资源,当并发量比较大时,会影响服务器的效率
        - 另一种方式是使用 Redis 的发布订阅功能,当获取锁失败时,订阅锁释放消息,获取锁成功后释放时,发送锁释放消息

### 高并发下的问题

#### 缓存穿透

- 缓存穿透是指用户请求的数据在缓存中不存在即没有命中,同时在数据库中也不存在,导致用户每次请求该数据都要去数据库中查询一遍,如果有恶意攻击者不断请求系统中不存在的数据,会导致短时间大量请求落在数据库上,造成数据库压力过大,甚至导致数据库承受不住而宕机崩溃

**解决方法**

1. **将无效的key存放进Redis中**:当出现Redis查不到数据,数据库也查不到数据的情况,我们就把这个key保存到Redis中,设置value="null",并设置其过期时间极短,后面再出现查询这个key的请求的时候,直接返回null,就不需要再查询数据库了,但这种处理方式是有问题的,假如传进来的这个不存在的Key值每次都是随机的,那存进Redis也没有意义
2. **使用布隆过滤器**:如果布隆过滤器判定某个 key 不存在布隆过滤器中,那么就一定不存在,如果判定某个 key 存在,那么很大可能是存在(存在一定的误判率),于是我们可以在缓存之前再加一个布隆过滤器,将数据库中的所有key都存储在布隆过滤器中,在查询Redis前先去布隆过滤器查询 key 是否存在,如果不存在就直接返回,不让其访问数据库,从而避免了对底层存储系统的查询压力

#### 缓存击穿

- 缓存击穿跟缓存雪崩有点类似,缓存雪崩是大规模的key失效,而缓存击穿是某个热点的key失效,大并发集中对其进行请求,就会造成大量请求读缓存没读到数据,从而导致高并发访问数据库,引起数据库压力剧增,这种现象就叫做缓存击穿

**解决方案**

1. **加互斥锁**:在缓存失效后,通过互斥锁或者队列来控制读数据写缓存的线程数量,比如某个key只允许一个线程查询数据和写缓存,其他线程等待,这种方式会阻塞其他的线程,此时系统的吞吐量会下降
2. **热点数据缓存永远不过期**:永不过期实际包含两层意思:
   - 物理不过期,针对热点key不设置过期时间
   - 逻辑过期,把过期时间存在key对应的value里,如果发现要过期了,通过一个后台的异步线程进行缓存的构建

#### 缓存雪崩

- 如果缓存某一个时刻出现大规模的key失效,那么就会导致大量的请求打在了数据库上面,导致数据库压力巨大,如果在高并发的情况下,可能瞬间就会导致数据库宕机,这时候如果运维马上又重启数据库,马上又会有新的流量把数据库打死,这就是缓存雪崩

**解决方案**

1. 事前
   - 均匀过期:设置不同的过期时间,让缓存失效的时间尽量均匀,避免相同的过期时间导致缓存雪崩,造成大量数据库的访问
   - 分级缓存:第一级缓存失效的基础上,访问二级缓存,每一级缓存的失效时间都不同
   - 热点数据缓存永远不过期
   - 保证Redis缓存的高可用,防止Redis宕机导致缓存雪崩的问题,可以使用 主从+ 哨兵,Redis集群来避免 Redis 全盘崩溃的情况
2. 事中
   - 互斥锁:在缓存失效后,通过互斥锁或者队列来控制读数据写缓存的线程数量,比如某个key只允许一个线程查询数据和写缓存,其他线程等待,这种方式会阻塞其他的线程,此时系统的吞吐量会下降
   - 使用熔断机制,限流降级,当流量达到一定的阈值,直接返回"系统拥挤”之类的提示,防止过多的请求打在数据库上将数据库击垮,至少能保证一部分用户是可以正常使用,其他用户多刷新几次也能得到结果
3. 事后
   - 开启Redis持久化机制,尽快恢复缓存数据,一旦重启,就能从磁盘上自动加载数据恢复内存中的数据

### 数据类型

- **String 字符串**:字符串类型是 Redis 最基础的数据结构,首先键都是字符串类型,而且 其他几种数据结构都是在字符串类型基础上构建的,我们常使用的 set key value 命令就是字符串,常用在缓存,计数,共享Session,限速等
- **Hash 哈希**:在Redis中,哈希类型是指键值本身又是一个键值对结构,哈希可以用来存放用户信息,比如实现购物车
- **List 列表(双向链表)**:列表(list)类型是用来存储多个有序的字符串,可以做简单的消息队列的功能
- **Set 集合**:集合(set)类型也是用来保存多个的字符串元素,但和列表类型不一 样的是,集合中不允许有重复元素,并且集合中的元素是无序的,不能通过索引下标获取元素,利用 Set 的交集,并集,差集等操作,可以计算共同喜好,全部的喜好,自己独有的喜好等功能
- **Sorted Set 有序集合(跳表实现)**:Sorted Set 多了一个权重参数 Score,集合中的元素能够按 Score 进行排列,可以做排行榜应用,取 TOP N 操作

### 持久化技术

- Redis为了保证效率,数据缓存在了内存中,但是会周期性的把更新的数据写入磁盘或者把修改操作写入追加的记录文件中,以保证数据的持久化
- Redis的持久化策略有两种:
  1. **RDB**:快照形式是直接把内存中的数据定时保存到一个dump的文件中

      - 当Redis需要做持久化时,Redis会fork一个子进程,子进程将数据写到磁盘上一个临时RDB文件中,当子进程完成写临时文件后,将原来的RDB替换掉

  2. **AOF**:把所有的对Redis的服务器进行修改的命令都存到一个文件里

      - 使用AOF做持久化,每一个写命令都通过write函数追加到`appendonly.aof`中

      - AOF的默认策略是每秒钟fsync一次,在这种配置下,就算发生故障停机,也最多丢失一秒钟的数据
      - **缺点**:对于相同的数据集来说,AOF的文件体积通常要大于RDB文件的体积,AOF的速度可能会慢于RDB

- Redis默认是快照RDB的持久化方式

### Redis 效率高的原因

1. 纯内存操作,相对于读写磁盘,读写速度提升明显
2. 单线程操作,避免了频繁的上下文切换
3. 采用了I/O多路复用机制

> **文件描述符**
>
> - 在形式上是一个非负整数,实际上,它是一个索引值,指向内核为每一个进程所维护的该进程打开文件的记录表

**I/O多路复用机制**

- 多路指的是多个网络连接,复用指的是复用同一个线程
- IO 多路复用只需要一个进程就能够处理多个套接字,从而解决了上下文切换的问题
- 在 I/O 多路复用模型中,最重要的函数调用就是 `select`,该方法的能够同时监控多个文件描述符的可读可写情况,当其中的某些文件描述符可读或者可写时,`select` 方法就会返回可读以及可写的文件描述符个数

### 事务

- Redis事务可以理解为一个打包的批量执行脚本,但批量指令并非原子化的操作,中间某条指令的失败不会导致前面已做指令的回滚,也不会造成后续的指令不做

###  删除策略

- 不会,有三种不同的删除策略
    1. 立即删除,在设置键的过期时间时,创建一个定时器,当过期时间达到时,立即执行删除操作
    2. 惰性删除,key过期的时候不删除,每次从数据库获取key的时候去检查是否过期,若过期,则删除,返回null
    3. 定时删除,每隔一段时间,对全部的键进行检查,删除里面的过期键

### Redis 和 Mysql 数据库数据如何保持一致性

- **先写数据库再删缓存**
    1. 先更新数据库
    2. 再删除缓存
- **缓存延时双删**
    1. 先删除缓存
    2. 再更新数据库
    3. 休眠一会(读业务逻辑数据的耗时 + 几百毫秒)
    4. 再次删除缓存
- **删除缓存重试机制**
    1. 写请求更新数据库
    2. 缓存因为某些原因,删除失败
    3. 把删除失败的key放到消息队列
    4. 消费消息队列的消息,获取要删除的key
    5. 重试删除缓存操作
- **读取binlog异步删除缓存**
    - 一旦MySQL中产生了新的写入,更新,删除等操作,就可以把binlog相关的消息通过消息队列推送至Redis,Redis再根据binlog中的记录,对Redis进行更新
    - 这种同步机制类似于MySQL的主从备份机制,可以结合使用阿里的canal对MySQL的binlog进行订阅

### Redis的应用场景

- 缓存
- 共享Session
- 消息队列系统
- 分布式锁

### 集群

#### 主从复制

- 主从复制,是指将一台Redis服务器的数据,复制到其他的Redis服务器,前者称为主节点(master/leader) ,后者称为从节点(slave/follower)
- 默认情况下,每台Redis服务器都是主节点,且一个主节点可以有0或多个从节点,但一个从节点只能有一个主节点,数据的复制是单向的,只能由主节点到从节点
- **作用**
    - **数据冗余**:主从复制实现了数据的热备份,是持久化之外的一种数据冗余方式
    - **故障恢复**:当主节点出现问题时,可以由从节点提供服务,实现快速的故障恢复;实际上是一种服务的冗余
    - **读写分离**:在主从复制的基础上,配合读写分离,可以由主节点提供写服务,由从节点提供读服务 ,分担服务器负载;尤其是在写少读多的场景下,通过多个从节点分担读负载,可以大大提高Redis服务器的并发量
    - **高可用基础**:除了上述作用以外,主从复制还是哨兵和集群能够实施的基础,因此说主从复制是Redis高可用的基础
- **原理**:对于主从复制来说,主从刚刚连接的时候,进行全量同步(RDB),全同步结束后,进行增量同步(AOF)
    1. 与master建立连接
    2. 向master发起同步请求(SYNC)
    3. 接受master发来的RDB文件
    4. 载入RDB文件

#### 哨兵

- 哨兵模式能够后台监控主机是否故障,如果故障了则根据投票数**自动将从节点转换为主节点**
- **原理**:
    - 哨兵通过发送命令,等待 Redis服务器响应,从而监控运行的多个 Redis实例,让 Redis服务器返回其运行状态
    - 当哨兵监测到主节点宕机,会自动将从节点切换成主节点,然后通过发布订阅模式通知其他的从节点,修改配置文件,并切换主节点
    - 当主节点恢复连接后,原主节点自动转换为从节点,现主节点不变
- **优点**
    - 哨兵模式是主从模式的升级,手动转换为自动
    - 主从可以切换,故障可以转移,系统的可用性更好
- **缺点**
    - Redis不利于在线扩容的,集群容量一旦到达上限,在线扩容就十分麻烦

#### 分片

- 分片是分割数据到多个Redis实例的处理过程,因此每个实例只保存key的一个子集
- **优点**
    - 通过利用多台计算机内存,可以构造更大的数据库
    - 通过利用多台计算机的多核,允许我们扩展计算能力
    - 通过利用多台计算机的网络适配器,可以扩展网络带宽
- **分片的不足**
    - 涉及多个key的操作通常是不被支持的,例如,当两个set映射到不同的redis实例上时,你就不能对这两个set执行交集操作
    - 涉及多个key的redis事务不能使用
    - 当使用分片时,数据处理较为复杂,比如需要处理多个rdb/aof文件,并且从多个实例和主机备份持久化文件
    - 增加或删除容量也比较复杂,redis集群大多数支持在运行时增加,删除节点的透明数据平衡的能力,但是类似于客户端分片,代理等其他系统则不支持这项特性,然而,一种叫做presharding的技术对此是有帮助的分片是分割数据到多个Redis实例的处理过程,因此每个实例只保存key的一个子集**优点**通过利用多台计算机内存,可以构造更大的数据库通过利用多台计算机的多核,允许我们扩展计算能力通过利用多台计算机的网络适配器,可以扩展网络带宽**分片的不足**涉及多个key的操作通常是不被支持的,例如,当两个set映射到不同的redis实例上时,你就不能对这两个set执行交集操作涉及多个key的redis事务不能使用当使用分片时,数据处理较为复杂,比如需要处理多个rdb/aof文件,并且从多个实例和主机备份持久化文件增加或删除容量也比较复杂,redis集群大多数支持在运行时增加,删除节点的透明数据平衡的能力,但是类似于客户端分片,代理等其他系统则不支持这项特性,然而,一种叫做presharding的技术对此是有帮助的

## Kafka

### 为什么选择使用MQ来实现同步

通过使用消息队列,我们可以异步处理请求,从而缓解系统的压力,同样可以达到解耦的效果

### ISR、OSR、AR

- ISR (InSyncRepli): 速率和leader相差低于10秒的follower的集合
- OSR(OutSyncRepli) : 速率和leader相差大于10秒的follower
- AR(AllRepli) : 所有分区的follower

## HW、LEO

- HW : 又名高水位,根据同一分区中,最低的LEO所决定
- LEO : 每个分区的最高offset

### Kafka的使用场景

- 用户追踪:根据用户在web或者app上的操作,将这些操作消息记录到各个topic中,然后消费者通过订阅这些消息做实时的分析,或者记录到HDFS,用于离线分析或数据挖掘
- 日志收集:通过kafka对各个服务的日志进行收集,再开放给各个consumer
- 消息系统:缓存消息
- 运营指标:记录运营监控数据,收集操作应用数据的集中反馈,如报错和报告

### Kafka中是怎么体现消息顺序性的？

- 每个分区内,每条消息都有offset,所以只能在同一分区内有序,但不同的分区无法做到消息顺序性

5.“消费组中的消费者个数如果超过topic的分区，那么就会有消费者消费不到数据”这句话是否正确?

对的,超过分区数的消费者就不会再接收数据

6. 有哪些情形会造成重复消费？或丢失信息?

先处理后提交offset,会造成重读消费
先提交offset后处理,会造成数据丢失

7.Kafka 分区的目的？

对于kafka集群来说,分区可以做到负载均衡,对于消费者来说,可以提高并发度,提高读取效率

8.Kafka 的高可靠性是怎么实现的?

为了实现高可靠性,kafka使用了订阅的模式,并使用isr和ack应答机制
能进入isr中的follower和leader之间的速率不会相差10秒
当ack=0时,producer不等待broker的ack,不管数据有没有写入成功,都不再重复发该数据
当ack=1时,broker会等到leader写完数据后,就会向producer发送ack,但不会等follower同步数据,如果这时leader挂掉,producer会对新的leader发送新的数据,在old的leader中不同步的数据就会丢失
当ack=-1或者all时,broker会等到leader和isr中的所有follower都同步完数据,再向producer发送ack,有可能造成数据重复

9.topic的分区数可不可以增加？如果可以怎么增加？如果不可以，那又是为什么？

可以增加

bin/kafka-topics.sh --zookeeper localhost:2181/kafka --alter --topic topic-config --partitions 3
1
10.topic的分区数可不可以减少？如果可以怎么减少？如果不可以，那又是为什么？

不可以,先有的分区数据难以处理

11.简述Kafka的日志目录结构？

每一个分区对应一个文件夹,命名为topic-0,topic-1,每个文件夹内有.index和.log文件

12.如何解决消费者速率低的问题?

增加分区数和消费者数

13.Kafka的那些设计让它有如此高的性能？?

1.kafka是分布式的消息队列
2.对log文件进行了segment,并对segment建立了索引
3.(对于单节点)使用了顺序读写,速度可以达到600M/s
4.引用了zero拷贝,在os系统就完成了读写操作

14.kafka启动不起来的原因?

在关闭kafka时,先关了zookeeper,就会导致kafka下一次启动时,会报节点已存在的错误
只要把zookeeper中的zkdata/version-2的文件夹删除即可

15.聊一聊Kafka Controller的作用？

负责kafka集群的上下线工作,所有topic的副本分区分配和选举leader工作

16.Kafka中有那些地方需要选举？这些地方的选举策略又有哪些？

在ISR中需要选择,选择策略为先到先得

17.失效副本是指什么？有那些应对措施？

失效副本为速率比leader相差大于10秒的follower
将失效的follower先提出ISR
等速率接近leader10秒内,再加进ISR

18.Kafka消息是采用Pull模式，还是Push模式？

在producer阶段,是向broker用Push模式
在consumer阶段,是向broker用Pull模式
在Pull模式下,consumer可以根据自身速率选择如何拉取数据,避免了低速率的consumer发生崩溃的问题
但缺点是,consumer要时不时的去询问broker是否有新数据,容易发生死循环,内存溢出

19.Kafka创建Topic时如何将分区放置到不同的Broker中?

首先副本数不能超过broker数
第一分区是随机从Broker中选择一个,然后其他分区相对于0号分区依次向后移
第一个分区是从nextReplicaShift决定的,而这个数也是随机产生的

20.Kafka中的事务是怎么实现的?☆☆☆☆☆

kafka事务有两种
producer事务和consumer事务
producer事务是为了解决kafka跨分区跨会话问题
kafka不能跨分区跨会话的主要问题是每次启动的producer的PID都是系统随机给的
所以为了解决这个问题
我们就要手动给producer一个全局唯一的id,也就是transaction id 简称TID
我们将TID和PID进行绑定,在producer带着TID和PID第一次向broker注册时,broker就会记录TID,并生成一个新的组件__transaction_state用来保存TID的事务状态信息
当producer重启后,就会带着TID和新的PID向broker发起请求,当发现TID一致时
producer就会获取之前的PID,将覆盖掉新的PID,并获取上一次的事务状态信息,从而继续上次工作
consumer事务相对于producer事务就弱一点,需要先确保consumer的消费和提交位置为一致且具有事务功能,才能保证数据的完整,不然会造成数据的丢失或重复

21.Kafka中的分区器、序列化器、拦截器是否了解？它们之间的处理顺序是什么？

拦截器>序列化器>分区器

22.Kafka生产者客户端的整体结构是什么样子的？使用了几个线程来处理？分别是什么？


使用两个线程:
main线程和sender线程
main线程会依次经过拦截器,序列化器,分区器将数据发送到RecourdAccumlator(线程共享变量)
再由sender线程从RecourdAccumlator中拉取数据发送到kafka broker
相关参数：
batch.size：只有数据积累到batch.size之后，sender才会发送数据。
linger.ms：如果数据迟迟未达到batch.size，sender等待linger.time之后就会发送数据。

23.消费者提交消费位移时提交的是当前消费到的最新消息的offset还是offset+1？

offset + 1
图示:

生产者发送数据offset是从0开始的

消费者消费的数据offset是从offset+1开始的


## Elasticsearch

### 高亮你们是怎么做的

- SpringBoot整合Elasticsearch有一个searchSourceBuilder,通过链式调用一个highlighter方法,传入一个HighlightBuilder对象并设置好查询的列和高亮的标签
- 之后调用RestHighLevelClient对象的Search方法之后返回一个SearchResponse对象,之后可以调用response.getHits().getHits();获得击中的结果数组,数组中每一个对象除了包含原始内容还包含了一个高亮结果集,是一个Map集合

## 其他

### Maven 命令

- clean:清理项目生产的临时文件,一般是模块下的target目录
- compile:编译源代码,一般编译模块下的src/main/java目录
- test:测试命令,或执行src/test/java/下junit的测试用例
- package:项目打包工具,会在模块下的target目录生成jar或war等文件
- install:将打包的jar/war文件复制到你的本地仓库中,供其他模块使用
- deploy:将打包的文件发布到远程参考,提供其他人员进行下载依赖
- site:生成项目相关信息的网站
- dependency:打印出项目的整个依赖树

## 数据结构

### 红黑树

- **性质**
    - 根节点是黑色
    - 每个节点都只能是红色或者黑色
    - 每个叶节点(NIL节点,空节点)是黑色的
    - 如果一个节点是红色的,则它两个子节点都是黑色的,也就是说在一条路径上不能出现两个红色的节点
    - 从任一节点到其每个叶子的所有路径都包含相同数目的黑色节点

## 算法

### 查找算法

#### 二分查找

二分查找是一种在有序数组中查找某一特定元素的搜索算法,搜素过程从数组的中间元素开始,如果中间元素正好是要查找的元素,则搜素过程结束,如果某一特定元素大于或者小于中间元素,则在数组大于或小于中间元素的那一半中查找,而且跟开始一样从中间元素开始比较,如果在某一步骤数组已经为空,则表示找不到指定的元素,这种搜索算法每一次比较都使搜索范围缩小一半,其时间复杂度是O(logN)

```java
import java.util.Comparator;

public class MyUtil {

    public static <T extends Comparable<T>> int binarySearch(T[] x, T key) {
        return binarySearch(x, 0, x.length- 1, key);
    }

    // 使用循环实现的二分查找
    public static <T> int binarySearch(T[] x, T key, Comparator<T> comp) {
        int low = 0;
        int high = x.length - 1;
        while (low <= high) {
            int mid = (low + high) >>> 1;
            int cmp = comp.compare(x[mid], key);
            if (cmp < 0) {
                low= mid + 1;
            }
            else if (cmp > 0) {
                high= mid - 1;
            }
            else {
                return mid;
            }
        }
        return -1;
    }

    // 使用递归实现的二分查找
    private static<T extends Comparable<T>> int binarySearch(T[] x, int low, int high, T key) {
        if(low <= high) {
            int mid = low + ((high -low) >> 1);
            if(key.compareTo(x[mid])== 0) {
                return mid;
            }
            else if(key.compareTo(x[mid])< 0) {
                return binarySearch(x,low, mid - 1, key);
            }
            else {
                return binarySearch(x,mid + 1, high, key);
            }
        }
        return -1;
    }
}
```

> **说明**:上面的代码中给出了折半查找的两个版本,一个用递归实现,一个用循环实现,需要注意的是计算中间位置时不应该使用(high+ low) / 2的方式,因为加法运算可能导致整数越界,这里应该使用以下三种方式之一:low + (high - low) / 2或low + (high – low) >> 1或(low + high) >>> 1(>>>是逻辑右移,是不带符号位的右移)

### 排序算法

#### 冒泡排序

- 冒泡排序是一种简单的排序算法,它重复地走访过要排序的数列,一次比较两个元素,如果它们的顺序错误就把它们交换过来,走访数列的工作是重复地进行直到没有再需要交换,也就是说该数列已经排序完成,这个算法的名字由来是因为越小的元素会经由交换慢慢"浮”到数列的顶端
- **算法描述**
    1. 比较相邻的元素,如果第一个比第二个大,就交换它们两个
    2. 对每一对相邻元素作同样的工作,从开始第一对到结尾的最后一对,这样在最后的元素应该会是最大的数
    3. 针对所有的元素重复以上的步骤,除了最后一个
    4. 重复步骤1~3,直到排序完成

![img](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/20210611123345.gif)

```java
public static void bubbleSort(int[] arr) {
    int temp = 0;
    for (int i = arr.length - 1; i > 0; i--) { // 每次需要排序的长度
        for (int j = 0; j < i; j++) { // 从第一个元素到第i个元素
            if (arr[j] > arr[j + 1]) {
                temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }
        }//loop j
    }//loop i
}// method bubbleSort
```

- **稳定性**:在相邻元素相等时,它们并不会交换位置,所以,冒泡排序是稳定排序
- **适用场景**:冒泡排序思路简单,代码也简单,特别适合小数据的排序,但是,由于算法复杂度较高,在数据量大的时候不适合使用
- **代码优化**:在数据完全有序的时候展现出最优时间复杂度,为O(n),其他情况下,几乎总是O( n2 ),因此,算法在数据基本有序的情况下,性能最好
    要使算法在最佳情况下有O(n)复杂度,需要做一些改进,增加一个`swap`的标志,当前一轮没有进行交换时,说明数组已经有序,没有必要再进行下一轮的循环了,直接退出

```java
public static void bubbleSort(int[] arr) {
    int temp = 0;
    boolean swap;
    for (int i = arr.length - 1; i > 0; i--) { // 每次需要排序的长度
        swap=false;
        for (int j = 0; j < i; j++) { // 从第一个元素到第i个元素
            if (arr[j] > arr[j + 1]) {
                temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
                swap=true;
            }
        }//loop j
        if (swap==false){
            break;
        }
    }//loop i
}// method bubbleSort
```

#### 选择排序

- 选择排序是一种简单直观的排序算法,它也是一种交换排序算法,和冒泡排序有一定的相似度,可以认为选择排序是冒泡排序的一种改进
- **算法描述**
    1. 在未排序序列中找到最小(大)元素,存放到排序序列的起始位置
    2. 从剩余未排序元素中继续寻找最小(大)元素,然后放到已排序序列的末尾
    3. 重复第二步,直到所有元素均排序完毕

![img](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/20210611123157.gif)

```java
public static void selectionSort(int[] arr) {
    int temp, min = 0;
    for (int i = 0; i < arr.length - 1; i++) {
        min = i;
        // 循环查找最小值
        for (int j = i + 1; j < arr.length; j++) {
            if (arr[min] > arr[j]) {
                min = j;
            }
        }
        if (min != i) {
            temp = arr[i];
            arr[i] = arr[min];
            arr[min] = temp;
        }
    }
}
```

- **稳定性**:用数组实现的选择排序是不稳定的,用链表实现的选择排序是稳定的,不过,一般提到排序算法时,大家往往会默认是数组实现,所以选择排序是不稳定的
- **适用场景**:选择排序实现也比较简单,并且由于在各种情况下复杂度波动小,因此一般是优于冒泡排序的,在所有的完全交换排序中,选择排序也是比较不错的一种算法,但是,由于固有的O(n2)复杂度,选择排序在海量数据面前显得力不从心,因此,它适用于简单数据排序

#### 插入排序

- 插入排序是一种简单直观的排序算法,它的工作原理是通过构建有序序列,对于未排序数据,在已排序序列中从后向前扫描,找到相应位置并插入
- **算法描述**
    1. 把待排序的数组分成已排序和未排序两部分,初始的时候把第一个元素认为是已排好序的
    2. 从第二个元素
    3. 开始,在已排好序的子数组中寻找到该元素合适的位置并插入该位置
    4. 重复上述过程直到最后一个元素被插入有序子数组中

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/20210611123205.gif" alt="img" style="zoom:50%;" />

```java
public static void insertionSort(int[] arr){
    for (int i=1; i<arr.length; ++i){
        int value = arr[i];
        int position=i;
        while (position>0 && arr[position-1]>value){
            arr[position] = arr[position-1];
            position--;
        }
        arr[position] = value;
    }//loop i
}
```

- **稳定性**:由于只需要找到不大于当前数的位置而并不需要交换,因此,直接插入排序是稳定的排序方法
- **适用场景**:插入排序由于O( n2 )的复杂度,在数组较大的时候不适用,但是,在数据比较少的时候,是一个不错的选择,一般做为快速排序的扩充,例如,在STL的sort算法和stdlib的qsort算法中,都将插入排序作为快速排序的补充,用于少量元素的排序,又如,在JDK 7 java.util.Arrays所用的sort方法的实现中,当待排数组长度小于47时,会使用插入排序

#### 归并排序

- 归并排序是建立在归并操作上的一种有效的排序算法,该算法是采用分治法的一个非常典型的应用,将已有序的子序列合并,得到完全有序的序列,即先使每个子序列有序,再使子序列段间有序,若将两个有序表合并成一个有序表,称为2-路归并
- **算法描述**
    - 递归法(Top-down)
        1. 申请空间,使其大小为两个已经排序序列之和,该空间用来存放合并后的序列
        2. 设定两个指针,最初位置分别为两个已经排序序列的起始位置
        3. 比较两个指针所指向的元素,选择相对小的元素放入到合并空间,并移动指针到下一位置
        4. 重复步骤3直到某一指针到达序列尾
        5. 将另一序列剩下的所有元素直接复制到合并序列尾
    - 迭代法(Bottom-up)
        1. 将序列每相邻两个数字进行归并操作,形成ceil(n/2)个序列,排序后每个序列包含两/一个元素
        2. 若此时序列数不是1个则将上述序列再次归并,形成ceil(n/4)个序列,每个序列包含四/三个元素
        3. 重复步骤2,直到所有元素排序完毕,即序列数为1

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/20210611123213.gif" alt="img" style="zoom:50%;" />

```java
public static void mergeSort(int[] arr){
    int[] temp =new int[arr.length];
    internalMergeSort(arr, temp, 0, arr.length-1);
}
private static void internalMergeSort(int[] arr, int[] temp, int left, int right){
    //当left==right的时,已经不需要再划分了
    if (left<right){
        int middle = (left+right)/2;
        internalMergeSort(arr, temp, left, middle);          //左子数组
        internalMergeSort(arr, temp, middle+1, right);       //右子数组
        mergeSortedArray(arr, temp, left, middle, right);    //合并两个子数组
    }
}
// 合并两个有序子序列
private static void mergeSortedArray(int arr[], int temp[], int left, int middle, int right){
    int i=left;
    int j=middle+1;
    int k=0;
    while (i<=middle && j<=right){
        temp[k++] = arr[i] <= arr[j] ? arr[i++] : arr[j++];
    }
    while (i <=middle){
        temp[k++] = arr[i++];
    }
    while ( j<=right){
        temp[k++] = arr[j++];
    }
    //把数据复制回原数组
    for (i=0; i<k; ++i){
        arr[left+i] = temp[i];
    }
}
```

- **稳定性**:因为我们在遇到相等的数据的时候必然是按顺序"抄写”到辅助数组上的,所以,归并排序同样是稳定算法
- **适用场景**:归并排序在数据量比较大的时候也有较为出色的表现(效率上),但是,其空间复杂度O(n)使得在数据量特别大的时候(例如,1千万数据)几乎不可接受,而且,考虑到有的机器内存本身就比较小,因此,采用归并排序一定要注意

#### 快速排序

- 快速排序是一个知名度极高的排序算法,其对于大数据的优秀排序性能和相同复杂度算法中相对简单的实现使它注定得到比其他算法更多的宠爱
- **算法描述**
    1. 从数列中挑出一个元素,称为"基准"(pivot)
    2. 重新排序数列,所有比基准值小的元素摆放在基准前面,所有比基准值大的元素摆在基准后面(相同的数可以到任何一边),在这个分区结束之后,该基准就处于数列的中间位置,这个称为分区(partition)操作
    3. 递归地(recursively)把小于基准值元素的子数列和大于基准值元素的子数列排序

![v2-c411339b79f92499dcb7b5](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/20210611123302.gif)

```java
public static void quickSort(int[] arr){
    qsort(arr, 0, arr.length-1);
}
private static void qsort(int[] arr, int low, int high){
    if (low >= high)
        return;
    int pivot = partition(arr, low, high);        //将数组分为两部分
    qsort(arr, low, pivot-1);                   //递归排序左子数组
    qsort(arr, pivot+1, high);                  //递归排序右子数组
}
private static int partition(int[] arr, int low, int high){
    int pivot = arr[low];     //基准
    while (low < high){
        while (low < high && arr[high] >= pivot) --high;
        arr[low]=arr[high];             //交换比基准大的记录到左端
        while (low < high && arr[low] <= pivot) ++low;
        arr[high] = arr[low];           //交换比基准小的记录到右端
    }
    //扫描完成,基准到位
    arr[low] = pivot;
    //返回的是基准的位置
    return low;
}
```

- **稳定性**:快速排序并不是稳定的,这是因为我们无法保证相等的数据按顺序被扫描到和按顺序存放
- **适用场景**:快速排序在大多数情况下都是适用的,尤其在数据量大的时候性能优越性更加明显,但是在必要的时候,需要考虑下优化以提高其在最坏情况下的性能

#### 堆排序

堆排序(Heapsort)是指利用堆积树(堆)这种数据结构所设计的一种排序算法,它是选择排序的一种,可以利用数组的特点快速定位指定索引的元素,堆排序就是把最大堆堆顶的最大数取出,将剩余的堆继续调整为最大堆,再次将堆顶的最大数取出,这个过程持续到剩余数只有一个时结束

**堆的概念**

堆是一种特殊的完全二叉树(complete binary tree),完全二叉树的一个"优秀”的性质是,除了最底层之外,每一层都是满的,这使得堆可以利用数组来表示(普通的一般的二叉树通常用链表作为基本容器表示),每一个结点对应数组中的一个元素
如下图,是一个堆和数组的相互关系:

![img](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/20210611123311.jpeg)


对于给定的某个结点的下标 i,可以很容易的计算出这个结点的父结点,孩子结点的下标:

- Parent(i) = floor(i/2),i 的父节点下标
- Left(i) = 2i,i 的左子节点下标
- Right(i) = 2i + 1,i 的右子节点下标

二叉堆一般分为两种:最大堆和最小堆
**最大堆**
最大堆中的最大元素值出现在根结点(堆顶)
堆中每个父节点的元素值都大于等于其孩子结点(如果存在)

![img](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/20210611123316.jpeg)

**最小堆**
最小堆中的最小元素值出现在根结点(堆顶)
堆中每个父节点的元素值都小于等于其孩子结点(如果存在)

![img](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/20210611123319.jpeg)

**堆排序原理**

堆排序就是把最大堆堆顶的最大数取出,将剩余的堆继续调整为最大堆,再次将堆顶的最大数取出,这个过程持续到剩余数只有一个时结束,在堆中定义以下几种操作:

- 最大堆调整(Max-Heapify):将堆的末端子节点作调整,使得子节点永远小于父节点
- 创建最大堆(Build-Max-Heap):将堆所有数据重新排序,使其成为最大堆
- 堆排序(Heap-Sort):移除位在第一个数据的根节点,并做最大堆调整的递归运算 继续进行下面的讨论前,需要注意的一个问题是:数组都是 Zero-Based,这就意味着我们的堆数据结构模型要发生改变

![img](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/20210611123329.jpeg)


相应的,几个计算公式也要作出相应调整:

- Parent(i) = floor((i-1)/2),i 的父节点下标
- Left(i) = 2i + 1,i 的左子节点下标
- Right(i) = 2(i + 1),i 的右子节点下标

**堆的建立和维护**

堆可以支持多种操作,但现在我们关心的只有两个问题:

1. 给定一个无序数组,如何建立为堆？
2. 删除堆顶元素后,如何调整数组成为新堆？

先看第二个问题,假定我们已经有一个现成的大根堆,现在我们删除了根元素,但并没有移动别的元素,想想发生了什么:根元素空了,但其它元素还保持着堆的性质,我们可以把**最后一个元素**(代号A)移动到根元素的位置,如果不是特殊情况,则堆的性质被破坏,但这仅仅是由于A小于其某个子元素,于是,我们可以把A和这个子元素调换位置,如果A大于其所有子元素,则堆调整好了,否则,重复上述过程,A元素在树形结构中不断"下沉”,直到合适的位置,数组重新恢复堆的性质,上述过程一般称为"筛选”,方向显然是自上而下

> 删除后的调整,是把最后一个元素放到堆顶,自上而下比较

删除一个元素是如此,插入一个新元素也是如此,不同的是,我们把新元素放在**末尾**,然后和其父节点做比较,即自下而上筛选

> 插入是把新元素放在末尾,自下而上比较

那么,第一个问题怎么解决呢？

常规方法是从第一个非叶子结点向下筛选,直到根元素筛选完毕,这个方法叫"筛选法”,需要循环筛选n/2个元素

但我们还可以借鉴"插入排序”的思路,我们可以视第一个元素为一个堆,然后不断向其中添加新元素,这个方法叫做"插入法”,需要循环插入(n-1)个元素

由于筛选法和插入法的方式不同,所以,相同的数据,它们建立的堆一般不同,大致了解堆之后,堆排序就是水到渠成的事情了

**动图演示**

![img](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/v2-c66a7e83189427b6a5a5c378f73c17ca_b.gif)

**算法描述**

我们需要一个升序的序列,怎么办呢？我们可以建立一个最小堆,然后每次输出根元素,但是,这个方法需要额外的空间(否则将造成大量的元素移动,其复杂度会飙升到O(n2)),如果我们需要就地排序(即不允许有O(n)空间复杂度),怎么办？

有办法,我们可以建立最大堆,然后我们倒着输出,在最后一个位置输出最大值,次末位置输出次大值……由于每次输出的最大元素会腾出第一个空间,因此,我们恰好可以放置这样的元素而不需要额外空间,很漂亮的想法,是不是？

**算法实现**

```java
public class ArrayHeap {
    private int[] arr;
    public ArrayHeap(int[] arr) {
        this.arr = arr;
    }
    private int getParentIndex(int child) {
        return (child - 1) / 2;
    }
    private int getLeftChildIndex(int parent) {
        return 2 * parent + 1;
    }
    private void swap(int i, int j) {
        int temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
    }
    /**
     * 调整堆
     */
    private void adjustHeap(int i, int len) {
        int left, right, j;
        left = getLeftChildIndex(i);
        while (left <= len) {
            right = left + 1;
            j = left;
            if (j < len && arr[left] < arr[right]) {
                j++;
            }
            if (arr[i] < arr[j]) {
                swap(array, i, j);
                i = j;
                left = getLeftChildIndex(i);
            } else {
                break; // 停止筛选
            }
        }
    }
    /**
     * 堆排序
     * */
    public void sort() {
        int last = arr.length - 1;
        // 初始化最大堆
        for (int i = getParentIndex(last); i >= 0; --i) {
            adjustHeap(i, last);
        }
        // 堆调整
        while (last >= 0) {
            swap(0, last--);
            adjustHeap(0, last);
        }
    }

}
```

- **稳定性**:堆排序存在大量的筛选和移动过程,属于不稳定的排序算法
- **适用场景**:堆排序在建立堆和调整堆的过程中会产生比较大的开销,在元素少的时候并不适用,但是,在元素比较多的情况下,还是不错的一个选择,尤其是在解决诸如"前n大的数”一类问题时,几乎是首选算法

#### 希尔排序

在希尔排序出现之前,计算机界普遍存在"排序算法不可能突破O(n2)”的观点,希尔排序是第一个突破O(n2)的排序算法,它是简单插入排序的改进版,希尔排序的提出,主要基于以下两点:

1. 插入排序算法在数组基本有序的情况下,可以近似达到O(n)复杂度,效率极高
2. 但插入排序每次只能将数据移动一位,在数组较大且基本无序的情况下性能会迅速恶化

**算法描述**

先将整个待排序的记录序列分割成为若干子序列分别进行直接插入排序,具体算法描述:

- 选择一个增量序列t1,t2,…,tk,其中ti>tj,tk=1
- 按增量序列个数k,对序列进行 k 趟排序
- 每趟排序,根据对应的增量ti,将待排序列分割成若干长度为m 的子序列,分别对各子表进行直接插入排序,仅增量因子为1 时,整个序列作为一个表来处理,表长度即为整个序列的长度

**动图演示**

![img](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/20210611123335.gif)

**算法实现**

Donald Shell增量

```java
public static void shellSort(int[] arr){
    int temp;
    for (int delta = arr.length/2; delta>=1; delta/=2){                              //对每个增量进行一次排序
        for (int i=delta; i<arr.length; i++){
            for (int j=i; j>=delta && arr[j]<arr[j-delta]; j-=delta){ //注意每个地方增量和差值都是delta
                temp = arr[j-delta];
                arr[j-delta] = arr[j];
                arr[j] = temp;
            }
        }//loop i
    }//loop delta
}
```

O(n3/2) by Knuth

```java
public static void shellSort2(int[] arr){
    int delta = 1;
    while (delta < arr.length/3){//generate delta
        delta=delta*3+1;    // <O(n^(3/2)) by Knuth,1973>: 1, 4, 13, 40, 121, ...
    }
    int temp;
    for (; delta>=1; delta/=3){
        for (int i=delta; i<arr.length; i++){
            for (int j=i; j>=delta && arr[j]<arr[j-delta]; j-=delta){
                temp = arr[j-delta];
                arr[j-delta] = arr[j];
                arr[j] = temp;
            }
        }//loop i
    }//loop delta
}
```

**希尔排序的增量**

希尔排序的增量数列可以任取,需要的唯一条件是最后一个一定为1(因为要保证按1有序),但是,不同的数列选取会对算法的性能造成极大的影响,上面的代码演示了两种增量
切记:增量序列中每两个元素最好不要出现1以外的公因子!(很显然,按4有序的数列再去按2排序意义并不大)
下面是一些常见的增量序列
\- 第一种增量是最初Donald Shell提出的增量,即折半降低直到1,据研究,使用希尔增量,其时间复杂度还是O(n2)

第二种增量Hibbard:{1, 3, ..., 2k-1},该增量序列的时间复杂度大约是O(n1.5)

第三种增量Sedgewick增量:(1, 5, 19, 41, 109,...),其生成序列或者是9*4i* *- 9*2i + 1或者是4i - 3*2i + 1

**稳定性**

我们都知道插入排序是稳定算法,但是,Shell排序是一个多次插入的过程,在一次插入中我们能确保不移动相同元素的顺序,但在多次的插入中,相同元素完全有可能在不同的插入轮次被移动,最后稳定性被破坏,因此,Shell排序不是一个稳定的算法

**适用场景**

Shell排序虽然快,但是毕竟是插入排序,其数量级并没有后起之秀--快速排序O(n㏒n)快,在大量数据面前,Shell排序不是一个好的算法,但是,中小型规模的数据完全可以使用它

#### **计数排序**

计数排序不是基于比较的排序算法,其核心在于将输入的数据值转化为键存储在额外开辟的数组空间中,作为一种线性时间复杂度的排序,计数排序要求输入的数据必须是有确定范围的整数

**算法描述**

1. 找出待排序的数组中最大和最小的元素
2. 统计数组中每个值为i的元素出现的次数,存入数组C的第i项
3. 对所有的计数累加(从C中的第一个元素开始,每一项和前一项相加)
4. 反向填充目标数组:将每个元素i放在新数组的第C(i)项,每放一个元素就将C(i)减去1

**动图演示**

![img](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/v2-3c7ddb59df2d21b287e42a7b908409cb_b.gif)

**算法实现**

```java
public static void countSort(int[] a, int max, int min) {
     int[] b = new int[a.length];//存储数组
     int[] count = new int[max - min + 1];//计数数组

     for (int num = min; num <= max; num++) {
        //初始化各元素值为0,数组下标从0开始因此减min
        count[num - min] = 0;
     }

     for (int i = 0; i < a.length; i++) {
        int num = a[i];
        count[num - min]++;//每出现一个值,计数数组对应元素的值+1
     }

     for (int num = min + 1; num <= max; num++) {
        //加总数组元素的值为计数数组对应元素及左边所有元素的值的总和
        count[num - min] += sum[num - min - 1]
     }

     for (int i = 0; i < a.length; i++) {
          int num = a[i];//源数组第i位的值
          int index = count[num - min] - 1;//加总数组中对应元素的下标
          b[index] = num;//将该值存入存储数组对应下标中
          count[num - min]--;//加总数组中,该值的总和减少1
     }

     //将存储数组的值一一替换给源数组
     for(int i=0;i<a.length;i++){
         a[i] = b[i];
     }
}
```

**稳定性**

最后给 b 数组赋值是倒着遍历的,而且放进去一个就将C数组对应的值(表示前面有多少元素小于或等于A[i])减去一,如果有相同的数x1,x2,那么相对位置后面那个元素x2放在(比如下标为4的位置),相对位置前面那个元素x1下次进循环就会被放在x2前面的位置3,从而保证了稳定性

**适用场景**

排序目标要能够映射到整数域,其最大值最小值应当容易辨别,例如高中生考试的总分数,显然用0-750就OK啦,又比如一群人的年龄,用个0-150应该就可以了,再不济就用0-200喽,另外,计数排序需要占用大量空间,它比较适用于数据比较集中的情况

#### **桶排序**

桶排序又叫箱排序,是计数排序的升级版,它的工作原理是将数组分到有限数量的桶子里,然后对每个桶子再分别排序(有可能再使用别的排序算法或是以递归方式继续使用桶排序进行排序),最后将各个桶中的数据有序的合并起来

> 计数排序是桶排序的一种特殊情况,可以把计数排序当成每个桶里只有一个元素的情况,网络中很多博文写的桶排序实际上都是计数排序,并非标准的桶排序,要注意辨别

**算法描述**

1. 找出待排序数组中的最大值max,最小值min
2. 我们使用 动态数组ArrayList 作为桶,桶里放的元素也用 ArrayList 存储,桶的数量为(max-min)/arr.length+1
3. 遍历数组 arr,计算每个元素 arr[i] 放的桶
4. 每个桶各自排序
5. 遍历桶数组,把排序好的元素放进输出数组

![img](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/v2-465190477b7fb90d17aef27c2a213368_720w.jpg)

**算法实现**

```java
public static void bucketSort(int[] arr){
    int max = Integer.MIN_VALUE;
    int min = Integer.MAX_VALUE;
    for(int i = 0; i < arr.length; i++){
        max = Math.max(max, arr[i]);
        min = Math.min(min, arr[i]);
    }
    //桶数
    int bucketNum = (max - min) / arr.length + 1;
    ArrayList<ArrayList<Integer>> bucketArr = new ArrayList<>(bucketNum);
    for(int i = 0; i < bucketNum; i++){
        bucketArr.add(new ArrayList<Integer>());
    }
    //将每个元素放入桶
    for(int i = 0; i < arr.length; i++){
        int num = (arr[i] - min) / (arr.length);
        bucketArr.get(num).add(arr[i]);
    }
    //对每个桶进行排序
    for(int i = 0; i < bucketArr.size(); i++){
        Collections.sort(bucketArr.get(i));
    }
    System.out.println(bucketArr.toString());
}
```

**稳定性**

可以看出,在分桶和从桶依次输出的过程是稳定的,但是,由于我们在对每个桶进行排序时使用了其他算法,所以,桶排序的稳定性依赖于这一步,如果我们使用了快排,显然,算法是不稳定的

**适用场景**

桶排序可用于最大最小值相差较大的数据情况,但桶排序要求数据的分布必须均匀,否则可能导致数据都集中到一个桶中,比如[104,150,123,132,20000], 这种数据会导致前4个数都集中到同一个桶中,导致桶排序失效

#### **基数排序**

基数排序(Radix Sort)是桶排序的扩展,它的基本思想是:将整数按位数切割成不同的数字,然后按每个位数分别比较
排序过程:将所有待比较数值(正整数)统一为同样的数位长度,数位较短的数前面补零,然后,从最低位开始,依次进行一次排序,这样从最低位排序一直到最高位排序完成以后, 数列就变成一个有序序列

**算法描述**

1. 取得数组中的最大数,并取得位数
2. arr为原始数组,从最低位开始取每个位组成radix数组
3. 对radix进行计数排序(利用计数排序适用于小范围数的特点)

**动图**

![img](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/v2-3a6f1e5059386523ed941f0d6c3a136e_b.gif)

**算法实现**

```java
public abstract class Sorter {
     public abstract void sort(int[] array);
}

public class RadixSorter extends Sorter {

     private int radix;

     public RadixSorter() {
          radix = 10;
     }

     @Override
     public void sort(int[] array) {
          // 数组的第一维表示可能的余数0-radix,第二维表示array中的等于该余数的元素
          // 如:十进制123的个位为3,则bucket[3][] = {123}
          int[][] bucket = new int[radix][array.length];
          int distance = getDistance(array); // 表示最大的数有多少位
          int temp = 1;
          int round = 1; // 控制键值排序依据在哪一位
          while (round <= distance) {
               // 用来计数:数组counter[i]用来表示该位是i的数的个数
               int[] counter = new int[radix];
               // 将array中元素分布填充到bucket中,并进行计数
               for (int i = 0; i < array.length; i++) {
                    int which = (array[i] / temp) % radix;
                    bucket[which][counter[which]] = array[i];
                    counter[which]++;
               }
               int index = 0;
               // 根据bucket中收集到的array中的元素,根据统计计数,在array中重新排列
               for (int i = 0; i < radix; i++) {
                    if (counter[i] != 0)
                         for (int j = 0; j < counter[i]; j++) {
                              array[index] = bucket[i][j];
                              index++;
                         }
                    counter[i] = 0;
               }
               temp *= radix;
               round++;
          }
     }

     private int getDistance(int[] array) {
          int max = computeMax(array);
          int digits = 0;
          int temp = max / radix;
          while(temp != 0) {
               digits++;
               temp = temp / radix;
          }
          return digits + 1;
     }

     private int computeMax(int[] array) {
          int max = array[0];
          for(int i=1; i<array.length; i++) {
               if(array[i]>max) {
                    max = array[i];
               }
          }
          return max;
     }
}
```

**稳定性**

通过上面的排序过程,我们可以看到,每一轮映射和收集操作,都保持从左到右的顺序进行,如果出现相同的元素,则保持他们在原始数组中的顺序,可见,基数排序是一种稳定的排序

**适用场景**

基数排序要求较高,元素必须是整数,整数时长度10W以上,最大值100W以下效率较好,但是基数排序比其他排序好在可以适用字符串,或者其他需要根据多个条件进行排序的场景,例如日期,先排序日,再排序月,最后排序年,其它排序算法可是做不了的

#### 总结

| 排序算法     | 平均时间复杂度 | 最坏时间复杂度 | 最好时间复杂度 | 空间复杂度 | 稳定性 |
| ------------ | -------------- | -------------- | -------------- | ---------- | ------ |
| 冒泡排序     | O(n²)          | O(n²)          | O(n)           | O(1)       | 稳定   |
| 直接选择排序 | O(n²)          | O(n²)          | O(n)           | O(1)       | 不稳定 |
| 直接插入排序 | O(n²)          | O(n²)          | O(n)           | O(1)       | 稳定   |
| 快速排序     | O(nlogn)       | O(n²)          | O(nlogn)       | O(nlogn)   | 不稳定 |
| 堆排序       | O(nlogn)       | O(nlogn)       | O(nlogn)       | O(1)       | 不稳定 |
| 希尔排序     | O(nlogn)       | O(ns)          | O(n)           | O(1)       | 不稳定 |
| 归并排序     | O(nlogn)       | O(nlogn)       | O(nlogn)       | O(n)       | 稳定   |
| 计数排序     | O(n+k)         | O(n+k)         | O(n+k)         | O(n+k)     | 稳定   |
| 基数排序     | O(N*M)         | O(N*M)         | O(N*M)         | O(M)       | 稳定   |

### 为什么先序中序可以决定一颗树

- 前序和后序在本质上都是将父节点与子结点进行分离,但并没有指明左子树和右子树的能力,因此得到这两个序列只能明确父子关系,而不能确定一个二叉树

### 二叉树遍历

- 前序遍历:根结点 ---> 左子树 ---> 右子树
- 中序遍历:左子树---> 根结点 ---> 右子树
- 后序遍历:左子树 ---> 右子树 ---> 根结点
- 层次遍历:只需按层次遍历即可

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-04-23-image-20210423144633672.png" alt="image-20210423144633672" style="zoom:50%;" />

- 前序遍历:1  2  4  5  7  8  3  6
- 中序遍历:4  2  7  5  8  1  3  6
- 后序遍历:4  7  8  5  2  6  3  1
- 层次遍历:1  2  3  4  5  6  7  8

一,前序遍历

1)根据上文提到的遍历思路:根结点 ---> 左子树 ---> 右子树,很容易写出递归版本:

```java
public void preOrderTraverse1(TreeNode root) {
  if (root != null) {
    System.out.print(root.val+"  ");
    preOrderTraverse1(root.left);
    preOrderTraverse1(root.right);
  }
}
```

2)现在讨论非递归的版本:
根据前序遍历的顺序,优先访问根结点,然后在访问左子树和右子树,所以,对于任意结点node,第一部分即直接访问之,之后在判断左子树是否为空,不为空时即重复上面的步骤,直到其为空,若为空,则需要访问右子树,注意,在访问过左孩子之后,需要反过来访问其右孩子,所以,需要栈这种数据结构的支持,对于任意一个结点node,具体步骤如下:

a)访问之,并把结点node入栈,当前结点置为左孩子

b)判断结点node是否为空,若为空,则取出栈顶结点并出栈,将右孩子置为当前结点,否则重复a)步直到当前结点为空或者栈为空(可以发现栈中的结点就是为了访问右孩子才存储的)

代码如下:

```java
public void preOrderTraverse2(TreeNode root) {
  LinkedList<TreeNode> stack = new LinkedList<>();
  TreeNode pNode = root;
  while (pNode != null || !stack.isEmpty()) {
    if (pNode != null) {
      System.out.print(pNode.val+"  ");
      stack.push(pNode);
      pNode = pNode.left;
    } else { //pNode == null && !stack.isEmpty()
      TreeNode node = stack.pop();
      pNode = node.right;
    }
  }
}
```

二,中序遍历
1)根据上文提到的遍历思路:左子树 ---> 根结点 ---> 右子树,很容易写出递归版本:

```java
public void inOrderTraverse1(TreeNode root) {
  if (root != null) {
    inOrderTraverse1(root.left);
    System.out.print(root.val+"  ");
    inOrderTraverse1(root.right);
  }
}
```

2)非递归实现,有了上面前序的解释,中序也就比较简单了,相同的道理,只不过访问的顺序移到出栈时,代码如下:

```java
public void inOrderTraverse2(TreeNode root) {
  LinkedList<TreeNode> stack = new LinkedList<>();
  TreeNode pNode = root;
  while (pNode != null || !stack.isEmpty()) {
    if (pNode != null) {
      stack.push(pNode);
      pNode = pNode.left;
    } else { //pNode == null && !stack.isEmpty()
      TreeNode node = stack.pop();
      System.out.print(node.val+"  ");
      pNode = node.right;
    }
  }
}
```

三,后序遍历

1)根据上文提到的遍历思路:左子树 ---> 右子树 ---> 根结点,很容易写出递归版本:

```java
public void postOrderTraverse1(TreeNode root) {
  if (root != null) {
    postOrderTraverse1(root.left);
    postOrderTraverse1(root.right);
    System.out.print(root.val+"  ");
  }
}
```

2)非递归的代码,暂且不写

```java

    public static void postTraverse(TreeNode node) {
        if (node == null)
            return;
        Deque<TreeNode> s = new LinkedList<>();

        TreeNode curNode; //当前访问的结点
        TreeNode lastVisitNode; //上次访问的结点
        curNode = node;
        lastVisitNode = null;

        //把currentNode移到左子树的最下边
        while (curNode != null) {
            s.push(curNode);
            curNode = curNode.left;
        }
        while (!s.isEmpty()) {
            curNode = s.pop();  //弹出栈顶元素
            //一个根节点被访问的前提是:无右子树或右子树已被访问过
            if (curNode.right != null && curNode.right != lastVisitNode) {
                //根节点再次入栈
                s.push(curNode);
                //进入右子树,且可肯定右子树一定不为空
                curNode = curNode.right;
                while (curNode != null) {
                    //再走到右子树的最左边
                    s.push(curNode);
                    curNode = curNode.left;
                }
            } else {
                //访问
                System.out.print(curNode.val + "  ");
                //修改最近被访问的节点
                lastVisitNode = curNode;
            }
        } //while
```

四,层次遍历

层次遍历的代码比较简单,只需要一个队列即可,先在队列中加入根结点,之后对于任意一个结点来说,在其出队列的时候,访问之,同时如果左孩子和右孩子有不为空的,入队列,代码如下:

```java
public void levelTraverse(TreeNode root) {
  if (root == null) {
    return;
  }
  LinkedList<TreeNode> queue = new LinkedList<>();
  queue.offer(root);
  while (!queue.isEmpty()) {
    TreeNode node = queue.poll();
    System.out.print(node.val+"  ");
    if (node.left != null) {
      queue.offer(node.left);
    }
    if (node.right != null) {
      queue.offer(node.right);
    }
  }
}
```

五,深度优先遍历
其实深度遍历就是上面的前序,中序和后序,但是为了保证与广度优先遍历相照应,也写在这,代码也比较好理解,其实就是前序遍历,代码如下:

```java
public void depthOrderTraverse(TreeNode root) {
  if (root == null) {
    return;
  }
  LinkedList<TreeNode> stack = new LinkedList<>();
  stack.push(root);
  while (!stack.isEmpty()) {
    TreeNode node = stack.pop();
    System.out.print(node.val+"  ");
    if (node.right != null) {
      stack.push(node.right);
    }
    if (node.left != null) {
      stack.push(node.left);
    }
  }
}
```

## 操作系统

### 进程与线程

- 进程是资源分配的基本单位,是程序关于某个数据集合上的一次运行活动
- 线程是进程的一个实体,是独立运行和独立调度的基本单位,线程自己基本上不拥有系统资源,只拥有一点在运行中必不可少的资源(如程序计数器,一组寄存器和栈),但是它可与同属一个进程的其他的线程共享进程所拥有的全部资源
- 程序之间的切换会有较大的开销而线程之间切换的开销小
    - 每当切换进程时,必须要考虑保存当前进程的状态,状态包括存放在内存中的程序的代码和数据,它的栈,通用目的寄存器的内容,程序计数器,环境变量以及打开的文件描述符的集合,这个状态叫做上下文(Context)
    - 同样线程有自己的上下文,包括唯一的整数线程ID,栈,栈指针,程序计数器,通用目的寄存器和条件码,可以理解为线程上下文是进程上下文的子集

#### 上下文切换

- 对于单核单线程CPU而言,在某一时刻只能执行一条CPU指令,上下文切换(Context Switch)是一种将CPU资源从一个进程分配给另一个进程的机制
- 在切换的过程中,操作系统需要先存储当前进程的状态(包括内存空间的指针,当前执行完的指令等等),再读入下一个进程的状态,然后执行此进程
- 从用户角度看,计算机能够并行运行多个进程,这恰恰是操作系统通过快速上下文切换造成的结果

#### 线程同步

- **互斥量**:采用互斥对象机制,只有拥有互斥对象的线程才有访问公共资源的权限,因为互斥对象只有一个,所以可以保证公共资源不会被多个线程同时访问
- **信号量**:它允许同一时刻多个线程访问同一资源,但是需要控制同一时刻访问此资源的最大线程数量
- **事件(信号)**:通过通知操作的方式来保持多线程同步,还可以方便的实现多线程优先级的比较操作

#### 进程同步

- 进程间同步的主要方法有原子操作,信号量机制,自旋锁,管程,会合,分布式系统等

#### 线程间的通信方式

- **锁机制**:包括互斥锁,条件变量,读写锁
    - 互斥锁提供了以排他方式防止数据结构被并发修改的方法
    - 读写锁允许多个线程同时读共享数据,而对写操作是互斥的
    - 条件变量可以以原子的方式阻塞进程,直到某个特定条件为真为止,对条件的试是在互斥锁的保护下进行的,条件变量始终与互斥锁一起使用
- **信号量机制(Semaphore)**:包括无名线程信号量和命名线程信号量
- **信号机制(Signal)**:类似进程间的信号处理

#### 进程间的通信方式

- **管道( pipe )**:管道是一种半双工的通信方式,数据只能单向流动,而且只能在具有亲缘关系的进程间使用,进程的亲缘关系通常是指父子进程关系
-  **有名管道 (namedpipe)** :有名管道也是半双工的通信方式,但是它允许无亲缘关系进程间的通信
-  **信号量(semophore )**:信号量是一个计数器,可以用来控制多个进程对共享资源的访问,它常作为一种锁机制,防止某进程正在访问共享资源时,其他进程也访问该资源,因此,主要作为进程间以及同一进程内不同线程之间的同步手段
-  **消息队列( messagequeue )** :消息队列是由消息的链表,存放在内核中并由消息队列标识符标识,消息队列克服了信号传递信息少,管道只能承载无格式字节流以及缓冲区大小受限等缺点
-  **信号 (sinal )** :信号是一种比较复杂的通信方式,用于通知接收进程某个事件已经发生
-  **共享内存(shared memory )** :共享内存就是映射一段能被其他进程所访问的内存,这段共享内存由一个进程创建,但多个进程都可以访问,共享内存是最快的 IPC 方式,它是针对其他进程间通信方式运行效率低而专门设计的,它往往与其他通信机制,如信号量,配合使用,来实现进程间的同步和通信
-  **套接字(socket )** :套接口也是一种进程间通信机制,与其他通信机制不同的是,它可用于不同及其间的进程通信

#### 进程的状态

- **就绪状态**:进程已获得除处理机以外的所需资源,等待分配处理机资源
- **运行状态**:占用处理机资源运行,处于此状态的进程数小于等于CPU数
- **阻塞状态**:进程等待某种条件(例如IO操作),在条件满足之前无法执行

#### 调度算法

- 调度本质上就是一种资源分配,饥饿指某个进程一直在等待,得不到处理
- 调度算法的分类
    - **抢占式**(当前进程可以被抢):可以暂停某个正在执行的进程,将处理及重新分配给其他进程
    - **非抢占式**(当前进程不能被抢走):一旦处理及分配给了某个进程,他就一直运行下去,直到结束
- **高级调度**(作业调度/长程调度)(频率低):将外存作业调入内存
- **低级调度**(进程调度/短程调度)(频率高):决定就绪队列中哪个进程获得处理机并执行

**进程调度**

1. 先来先服务(FCFS):按照到达顺序,非抢占式,不会饥饿
2. 短作业/进程优先(SJF):抢占/非抢占,会饥饿
3. 高响应比优先(HRRN):综合考虑等待时间和要求服务时间计算一个优先权,非抢占,不会饥饿
4. 时间片轮转(RR):轮流为每个进程服务,抢占式,不会饥饿
5. 优先级:根据优先级,抢占/非抢占,会饥饿
6. 多级反馈队列:
    - 设置多个就绪队列,每个队列的进程按照先来先服务排队,然后按照时间片轮转分配时间片
    - 若时间片用完还没有完成,则进入下一级队尾,只有当前队列为空时,才会为下一级队列分配时间片
    - 抢占式,可能会饥饿

**作业调度**

- 先来先服务调度算法
- 短作业优先调度算法
- 优先级调度算法

#### 死锁

-  两个或多个进程被**无限期地阻塞,相互等待**的一种状态
    -   **互斥条件**:一个资源每次只能被一个进程使用
    -   **请求与保持**:一个进程因请求资源而阻塞时,对已获得的资源保持不放
    -   **不剥夺条件**:进程已获得的资源,在末使用完之前,不能强行剥夺
    -   **循环等待条件**:若干进程之间形成一种头尾相接的循环等待资源关系
-  这四个条件是死锁的必要条件,只要系统发生死锁,这些条件必然成立,而只要上述条件之一不成立,则死锁解除
-  **预防死锁**:执行获取锁的顺序,并强制要求线程按照指定的顺序获取锁

#### 并发与并行

-   并行是指两个或者多个事件在同一时刻发生,而并发是指两个或多个事件在同一时间间隔发生
-   **并发**:一个处理器同时处理多个任务
-   **并行**:多个处理器或者是多核的处理器同时处理多个不同的任务

#### 同步和异步

-   同步和异步关注的是消息通信机制,所谓同步,就是在发出一个调用时,在没有得到结果之前,该调用就不返回,但是一旦调用返回,就得到返回值了,换句话说,就是由调用者主动等待这个调用的结果
-   而异步则是相反,调用在发出之后,这个调用就直接返回了,所以没有返回结果,换句话说,当一个异步过程调用发出后,调用者不会立刻得到结果,而是在调用发出后,被调用者通过状态,通知机制来通知调用者,或通过回调函数处理这个调用

#### 阻塞与非阻塞

-   阻塞与非阻塞关注的是程序在等待调用结果(消息,返回值)时的状态
-   阻塞调用时指调用结果返回之前,当前线程被挂起,调用线程只有在得到结果之后才会返回
-   非阻塞调用时指在不能立刻得到结果之前,该调用不会阻塞当前线程

### 用户态和内核态

- 由于需要限制不同的程序之间的访问能力, 防止他们获取别的程序的内存数据, 或者获取外围设备的数据, 并发送到网络, CPU划分出两个权限等级 :**用户态** 和 **内核态**
- **内核态**:CPU可以访问内存所有数据, 包括外围设备, 例如硬盘, 网卡. CPU也可以将自己从一个程序切换到另一个程序
- **用户态**:只能受限的访问内存, 且不允许访问外围设备,占用CPU的能力被剥夺, CPU资源可以被其他程序获取
- **用户态与内核态的切换**:所有用户程序都是运行在用户态的, 但是有时候程序确实需要做一些内核态的事情, 例如从硬盘读取数据, 或者从键盘获取输入等,这是需要切换至内核态
- **系统调用**:这是处于用户态的进程主动请求切换到内核态的一种方式,用户态的进程通过系统调用申请使用操作系统提供的系统调用服务例程来处理任务,在CPU中的实现称之为**陷阱指令**(Trap Instruction)
    1. 用户态程序将一些数据值放在寄存器中, 或者使用参数创建一个堆栈(stack frame), 以此表明需要操作系统提供的服务
    2. 用户态程序执行陷阱指令
    3. CPU切换到内核态, 并跳到位于内存指定位置的指令, 这些指令是操作系统的一部分, 他们具有内存保护, 不可被用户态程序访问
    4. 这些指令称之为陷阱(trap)或者系统调用处理器(system call handler). 他们会读取程序放入内存的数据参数, 并执行程序请求的服务
    5. 系统调用完成后, 操作系统会重置CPU为用户态并返回系统调用的结果

### 中断和轮询

- 对I/O设备的程序轮询的方式,是早期的计算机系统对I/O设备的一种管理方式,它定时对各种设备轮流询问一遍有无处理要求,轮流询问之后,有要求的,则加以处理,在处理I/O设备的要求之后,处理机返回继续工作,尽管轮询需要时间,但轮询要比I/O设备的速度要快得多,所以一般不会发生不能及时处理的问题,当然,再快的处理机,能处理的输入输出设备的数量也是有一定限度的,而且,程序轮询毕竟占据了CPU相当一部分处理时间,因此,程序**轮询**是一种**效率较低**的方式,在现代计算机系统中已很少应用
- 中断是指在计算机执行期间,系统内发生任何非寻常的或非预期的急需处理事件,使得CPU**暂时中断**当前正在执行的程序而转去执行相应的事件处理程序,待**处理完毕后又返回**原来被中断处继续执行或调度新的进程执行的过程
- **轮询**:效率低,等待时间很长,CPU利用率不高
- **中断**:容易遗漏一些问题,CPU利用率高

### 通道

- 通道是一个独立于 CPU的I/O处理机,它控制I/O设备与内存直接进行数据交换,通道有自己的通道指令,这些通道指令由CPU启动,并在操作结束时向CPU发中断信号
- CPU把数据传输功能下放给通道,这样,通道与CPU分时使用内存(资源),就可以实现CPU与I/O设备的并行工作
- 用通道指令编制通道程序,存入存储器
    - 当需要进行I/O操作时,CPU只需启动通道,然后可以继续执行自身程序
    - 通道则执行通道程序,管理与实现I/O操作
- 整个系统分为二级管理
    - 一级是CPU对通道的管理
    - 二级是通道对设备控制的管理

### 虚拟设备

- 虚拟设备是通过SPOOLing技术把独占设备变成能为若干用户共享的设备

### 缓冲

- 缓冲技术是用在外部设备与其他硬件部件之间的一种数据暂存技术,它利用存储器件在外部设备中设置了数据的一个存储区域,称为缓冲区
- 采用缓冲技术的原因是,CPU处理数据速度与设备传输数据速度不相匹配,需要用缓冲区缓解其间的速度矛盾
- 缓冲技术一般有两种用途,一种是用在外部设备与外部设备之间的通信上的,还有一种是用在外部设备和处理器之间的

### 缓冲区溢出

- 缓冲区溢出是指当计算机向缓冲区内填充数据时**超过了缓冲区本身的容量**,溢出的数据覆盖在合法数据上,造成缓冲区溢出的主原因是程序中**没有仔细检查用户输入的参数**
- 危害有以下两点
    - **程序崩溃**,导致拒绝服务
    - 跳转并且**执行一段恶意代码**

### 临界区

- 每个进程中访问临界资源的那段程序称为临界区,每次只准许一个进程进入临界区,进入后不允许其他进程进入
- 任何时候,**处于临界区内的进程不可多于一个**,如已有进程进入自己的临界区,则其它所有试图进入临界区的进程必须等待
- 进入临界区的进程要在**有限时间内退出**,以便其它进程能及时进入自己的临界区
- 如果进程不能进入自己的临界区,则应**让出CPU**,避免进程出现“忙等”现象

### 虚拟内存

- 每个进程拥有独立的地址空间,这个空间被分为大小相等的多个块,称为页(Page),每个页都是一段连续的地址,这些页**被映射到物理内存**,但并不是所有的页都必须在内存中才能运行程序
- 对于进程而言,逻辑上似乎有很大的内存空间,实际上其中一部分对应物理内存上的一块(称为帧,通常页和帧大小相等),还有一些没加载在内存中的对应在硬盘上,注意,请求分页系统,请求分段系统和请求段页式系统都是针对虚拟内存的,通过请求实现内存与外存的信息置换　　　　　　　　
- 页表实际上存储在 CPU 的**内存管理单元**(MMU)中,于是 CPU 就可以直接通过 MMU,找出要实际要访问的物理内存地址,而当进程访问的虚拟地址在页表中查不到时,系统会产生一个**缺页异常**,进入系统内核空间分配物理内存,更新进程页表,最后再返回用户空间,恢复进程的运行

### 页面置换算法

- 如果内存空间不够,操作系统会把其他正在运行的进程中的「最近没被使用」的内存页面给释放掉,也就是暂时写在硬盘上,称为**换出**(Swap Out),一旦需要的时候,再加载进来,称为**换入**(Swap In),所以,一次性写入磁盘的也只有少数的一个页或者几个页,不会花太多时间,**内存交换的效率就相对比较高,**
- **FIFO先进先出算法**:将先进入的页面置换出去
- **LRU(Least recently use)最近最少使用算法**:选择未使用时间最长的页面置换出去
- **LFU(Least frequently use)最少使用次数算法**:将一段时间内使用次数最少页面置换出去
- **OPT(Optimal replacement)最优置换算法**:理论的最优,将实际内存中最晚使用的页面置换出去

### 内存碎片

- 内部碎片:给一个进程分配一块空间,这块空间没有用完的部分叫做内部碎片
- 外部碎片:给每个进程分配空间以后,内存中会存在一些区域由于太小而无法利用的空间,叫做外部碎片

### 内存管理

#### 连续内存分配方式

- 概念:连续分配为用户分配一个连续的内存空间,比如某个作业需要100mb的内存空间,就为这个作业在内存中划分一个100mb的内存空间

##### 单一连续分配

- 分配方法:将内存去划分为系统区域用户区,系统区为操作系统使用,剩下的用户区给**一个进程或作业**使用
- 特点:操作简单,没有外部碎片,适合单道处理系统,但是会有大量的内部碎片浪费资源,存储效率低

##### 分区式存储管理

###### 固定分区分配

- 分配方法:将内存划分成若干个固定大小的块,分区大小可以相等也可不相等(划分之后不再改变),根据程序的大小,分配当前空闲的,适当大小的分区
- 特点:固定分区分配虽然没有外部碎片,但是会造成大量的内部碎片,分区大小相等缺乏灵活性,大的进程可能放不进去,分区大小不等可能会造成大量的内部碎片,利用率极低

###### 动态分区分配

- 分配方法:不会先划分内存区域,当进程进入内存的时候才会根据进程大小动态的为其建立分区,使分区大小刚好适合进程的需要
- 特点:随着进程的消亡,会出现很多成段的内存空间,时间越来越长就会导致很多不可利用的外部碎片,降低内存的利用率,这时需要分配算法来解决

**分配算法**

- **首次适应算法**:进程进入内存之后从头开始查找第一个适合自己大小的分区,空间分区就是按照地址递增的顺序排列,算法开销小,回收后放到原位置就好,综合看这个算法性能最好
- **最佳适应算法**:将分区从从小到大排列(容量递增),找到最适合自己的分区,这样会有更大的分区被保留下来,满足别的进程需要,但是算法开销大,每次进程消亡产生新的区域后要重新排序,并且当使用多次后会产生很多外部碎片
- **最坏适应算法**:将分区从从大到小排列(容量递减),进程每次都找最大的区域来使用,可以减少难以利用的外部碎片,但是大分区很快就被用完了,大的进程可能会有饥饿的现象,算法开销也比较大
- **邻近适应算法**:空间分区按照地址递增的顺序进行排列,是由首次适应演变而来,进程每次寻找空间,从上一次查找的地址以后开始查找(不同于首次适应,首次适应每次从开头查找),算法开销小,大的分区也会很快被用完

##### 可重定位分区分配

- 分区式存储管理常采用的一项技术就是内存紧缩(compaction):将各个占用分区向内存一端移动,然后将各个空闲分区合并成为一个空闲分区,这种技术在提供了某种程 度上的灵活性的同时,也存在着一些弊端,例如:对占用分区进行内存数据搬移占用CPU时间,如果对占用分区中的程序进行“浮动”,则其重定位需要硬件支持
- 由于若干次内存分配与回收之后,各个空闲的内存块不连续了,通过“重定位”将已经分配的内存“紧凑”在一块,从而空出一大块空闲的内存,“紧凑”是需要开销的,比如需要重新计算地址
- 而离散分配方式—>不管是分页还是分段,都是直接将程序放到各个离散的页中,从而就不存在“紧凑”一说

#### 非连续分配方式

##### 分段管理

- 段式存储管理是一种符合用户视角的内存分配管理方案,在段式存储管理中,将程序的地址空间划分为若干段(segment),如代码段,数据段,堆栈段
- 这样每个进程有一个**二维地址空间**,相互独立,互不干扰
- 段式管理的优点是:**没有内碎片**(因为段大小可变,改变段大小来消除内碎片),但**段换入换出时,会产生外碎片**

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/qU5b1kzBolR9Vvy.png" alt="1229382-20200706184122714-1327445390" style="zoom:50%;" />

##### 分页管理

- 在页式存储管理中,将程序的**逻辑地址划分为固定大小的页(page)**,而**物理内存**划分为同样大小的**帧**,程序加载时,可以将任意一页放入内存中任意一个帧,这些帧不必连续,从而实现了离散分离
- 页式存储管理的优点是:**没有外碎片**(因为页的大小固定),但**会产生内碎片**(一个页可能填充不满)

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/1229382-20200706184202119-510553889.png" alt="1229382-20200706184202119-510553889" style="zoom:50%;" />

##### 多级页表

- 如果使用了二级分页,一级页表就可以覆盖整个 4GB 虚拟地址空间,但**如果某个一级页表的页表项没有被用到,也就不需要创建这个页表项对应的二级页表了,即可以在需要时才创建二级页表**,做个简单的计算,假设只有 20% 的一级页表项被用到了,那么页表占用的内存空间就只有 4KB(一级页表)+ 20% * 4MB(二级页表)= `0.804MB`,这对比单级页表的 `4MB` 是一个巨大的节约

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/1229382-20200706184216560-1820925289.png" alt="1229382-20200706184216560-1820925289" style="zoom:50%;" />

##### 段页式管理

- 先将程序划分为多个有逻辑意义的段,也就是前面提到的分段机制,接着再把每个段划分为多个页,也就是对分段划分出来的连续空间,再划分固定大小的页
- 这样,地址结构就由**段号,段内页号和页内位移**三部分组成
- 用于段页式地址变换的数据结构是每一个程序一张段表,每个段又建立一张页表,段表中的地址是页表的起始地址,而页表中的地址则为某页的物理页号
- **段页式地址变换中要得到物理地址须经过三次内存访问**
    1. 第一次访问段表,得到页表起始地址
    2. 第二次访问页表,得到物理页号
    3. 第三次将物理页号与页内位移组合,得到物理地址

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/1229382-20200706184248663-2120430485.png" alt="1229382-20200706184248663-2120430485" style="zoom:50%;" />

- **快表**:把最常访问的几个页表项存储到访问速度更快的硬件,在 CPU 芯片中,加入了一个专门存放程序最常访问的页表项的 Cache,这个 Cache 就是 TLB(*Translation Lookaside Buffer*),通常称为页表缓存,转址旁路缓存,快表等

### 重定位

- 对程序进行重定位的技术按重定位的时机可分为两种:静态重定位和动态重定位
- **静态重定位**:是在目标程序装入内存时,由装入程序对目标程序中的指令和数据的地址进行修改,即把程序的逻辑地址都改成实际的地址,对每个程序来说,这种地址变换只是在装入时一次完成,在程序运行期间不再进行重定位
    - **优点**:是无需增加硬件地址转换机构,便于实现程序的静态连接,在早期计算机系统中大多采用这种方案
        **缺点**
        - 程序的存储空间只能是连续的一片区域,而且在重定位之后就不能再移动,这不利于内存空间的有效使用
        - 各个用户进程很难共享内存中的同一程序的副本
- **动态重定位**:是在程序执行期间每次访问内存之前进行重定位,这种变换是靠硬件地址变换机构实现的,通常采用一个重定位寄存器,其中放有当前正在执行的程序在内存空间中的起始地址,而地址空间中的代码在装入过程中不发生变化,现在一般计算机系统中都采用动态重定位方法
    - **优点**
        - 程序占用的内存空间动态可变,不必连续存放在一处
        - 比较容易实现几个进程对同一程序副本的共享使用
    - **缺点**:是需要附加的硬件支持,增加了机器成本,而且实现存储管理的软件算法比较复杂

### inode

- 储存文件元信息的区域就叫做inode,也称为**索引节点**
- 每个inode都有一个编号,操作系统用inode编号来识别不同的文件
    - Unix/Linux系统内部不使用文件名,而使用inode号码来识别文件,对于系统来说,文件名只是inode号码便于识别的别称或者绰号
    - 表面上,用户通过文件名,打开文件,实际上,系统内部这个过程分成三步:首先,系统找到这个文件名对应的inode号码,其次,通过inode号码,获取inode信息,最后,根据inode信息,找到文件数据所在的block,读出数据
- inode包含文件的元信息,具体来说有以下内容
    - 文件的字节数
    - 文件拥有者的User ID
    - 文件的Group ID
    - 文件的读,写,执行权限
    - 文件的时间戳,共有三个:
        - ctime指inode上一次变动的时间
        - mtime指文件内容上一次变动的时间
        - atime指文件上一次打开的时间
    - 链接数,即有多少文件名指向这个inode
    - 文件数据block的位置
- **superblock**:记录此 filesystem 的整体信息,包括inode/block的总量,使用量,剩余量,以及文件系统的格式与相关信息等

### 文件空间分配

- **连续分配**:为文件分配连续的磁盘块
    - 目录项:起始块号,文件长度
    - 优点:顺序存取速度快,支持随机访问
    - 缺点:会产生碎片,不利于文件扩展
- **链接分配**
    - **隐式链接**:除文件的最后一个盘块之外,每个盘块中都存在有指向下一个盘块的指针
        - 目录项:起始块号,结束块号
        - 优点:可解决碎片问题,外存利用率高,文件扩展实现方便
        - 缺点:只能顺序访问,不能随机访问
    - **显示链接**:建立一张常驻内存的文件分配表(FAT),显示记录盘块的先后关系
        - 目录项:起始块号
        - 优点:除了隐式连接的优点外,还支持随机访问
        - 缺点:FAT需要专用一定的存储空间
- **索引分配**:为文件数据块建立索引表,若文件太大,可采用链接方案,多层索引,混合索引
    - 目录项:链接方案记录的是第一个索引块的块号,多层,混合索引记录的是顶级索引块的块
    - 优点:支持随机访问,易于实现文件的扩展
    - 缺点:索引表需要占用一定的存储空间,访问数块前需要先读入索引块,若采用链接方案,查找索引块时可能需要很多次读磁盘操作
- **显示链接与索引分配的区别**
    - 显示链接分配只是将指针信息按照先后顺序记录在FAT中,解决的隐式链接无法随机访问的问题,但是在逻辑上还是顺序的记录磁盘块的信息
    - 索引分配在逻辑上更像是包含关系,因为索引块记录的是顶层索引块,顶层索引块中记录的是一级索引块,而一级索引块中又记录的是(若有)二级索引块

### 磁盘模型

- **磁头**磁头是硬盘中对盘片进行读写工作的工具
- **盘片**:硬盘中一般会有多个盘片组成,每个盘片包含两个面,每个盘面都对应地有一个读/写磁头
- **磁道**:当磁盘旋转时,磁头若保持在一个位置上,则每个磁头都会在磁盘表面划出一个圆形轨迹,这些圆形轨迹就叫做磁道
- **扇区**:磁盘上的每个磁道被等分为若干个弧段,这些弧段便是磁盘的扇区
- **柱面**:硬盘通常由重叠的一组盘片构成,每个盘面都被划分为数目相等的磁道,并从外缘的`0`开始编号,具有相同编号的磁道形成一个圆柱,称之为磁盘的柱面
- **容量**:存储容量=磁头数 × 磁道(柱面)数 × 每道扇区数 × 每扇区字节数
- **块/簇**:块是操作系统中最小的逻辑存储单位,操作系统与磁盘打交道的最小单位是磁盘块
    - 在Windows下如NTFS等文件系统中叫做簇
    - 在Linux下如Ext4等文件系统中叫做块(block)
    - 每个簇或者块可以包括2,4,8,16,32,64…2的n次方个扇区

### 磁盘寻道算法

- **先来先服务算法(FCFS)**:根据进程请求访问磁盘的先后次序进行调度
- **最短寻道时间优先算法(SSTF)**:访问的磁道与当前磁头所在的磁道距离最近,以使每次的寻道时间最短,该算法可以得到比较好的吞吐量,但却不能保证平均寻道时间最短
- **扫描算法(SCAN)电梯调度**:扫描算法不仅考虑到欲访问的磁道与当前磁道的距离,更优先考虑的是磁头的当前移动方向
- **循环扫描算法(CSCAN)**:循环扫描算法是对扫描算法的改进,如果对磁道的访问请求是均匀分布的,当磁头到达磁盘的一端,并反向运动时落在磁头之后的访问请求相对较少,这是由于这些磁道刚被处理,而磁盘另一端的请求密度相当高,且这些访问请求等待的时间较长,为了解决这种情况,循环扫描算法规定磁头单向移动,例如,只自里向外移动,当磁头移到最外的被访问磁道时,磁头立即返回到最里的欲访磁道,即将最小磁道号紧接着最大磁道号构成循环,进行扫描

## 计算机网络

### OSI七层模型和协议

![img](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-04-21-v2-2d62ba265be486cb94ab531912aa3b9c_720w.jpg)

### TCP协议

#### TCP的可靠性传输

- TCP主要提供了检验和、序列号/确认应答、超时重传、最大消息长度、滑动窗口控制等方法实现了可靠性传输
- **检验和**:通过检验和的方式，接收端可以检测出来数据是否有差错和异常，假如有差错就会直接丢弃TCP段，重新发送。TCP在计算检验和时，会在TCP首部加上一个12字节的伪首部。检验和总共计算3部分：TCP首部、TCP数据、TCP伪首部
- **序列号/确认应答**:发送端发送信息给接收端，接收端会回应一个包，这个包就是应答包。只要发送端有一个包传输，接收端没有回应确认包（ACK包），都会重发。或者接收端的应答包，发送端没有收到也会重发数据。这就可以保证数据的完整性。
- **超时重传**:超时重传是指发送出去的数据包到接收到确认包之间的时间，如果超过了这个时间会被认为是丢包了，需要重传
    - 超时重传时间设置要比数据报往返时间（往返时间，简称RTT）长一点
    - 一来一回的时间总是差不多的，都会有一个类似于平均值的概念。比如发送一个包到接收端收到这个包一共是0.5s，然后接收端回发一个确认包给发送端也要0.5s，这样的两个时间就是RTT（往返时间）。然后可能由于网络原因的问题，时间会有偏差，称为抖动（方差）
- **最大消息长度**:在建立TCP连接的时候，双方约定一个最大的长度（MSS）作为发送的单位，重传的时候也是以这个单位来进行重传。理想的情况下是该长度的数据刚好不被网络层分块

#### TCP报文首部格式

![img](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/20210707143947.png)

#### 三次握手四次挥手的过程

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-03-12-v2-e8aaab48ff996e5cd8a5b39dc450bd6a_1440w.jpg" alt="img" style="zoom: 33%;" />

- **TCP连接建立过程**:首先Client端发送连接请求报文SYN进入SYN-SEND状态,Server端接受连接后回复ACK报文进入SYN-RCVD状态,Client端接收到ACK报文后也向Server端发送ACK报文进入ESTABLISED状态,Server端收到ACK报文也进入ESTABLISED状态,这样TCP连接就建立了
- **TCP连接断开过程**:Client端发起发送FIN报文中断连接请求进入FIN-WAIT-1状态,Server端接到FIN报文后,如果服务端还有数据没有发送完成,则不必急着关闭Socket,可以继续发送数据,所以服务端先发送ACK报文进入CLOSE-WAIT状态,这个时候Client端收到ACK报文就进入FIN_WAIT-2状态,继续等待Server端的FIN报文,当Server端确定数据已发送完成,则向Client端发送FIN报文进入LAST-ACK状态,Client端收到FIN报文后发送ACK后进入TIME_WAIT状态,如果Server端没有收到ACK则可以重传,Server端收到ACK后进入CLOSED状态,Client端等待了2MSL后依然没有收到回复,则证明Server端已正常关闭,Client进入CLOSED状态
- **为什么要三次握手？**
    - 在只有两次"握手"的情形下,假设Client想跟Server建立连接,但是却因为中途连接请求的数据报丢失了,故Client端不得不重新发送一遍,这个时候Server端仅收到一个连接请求,因此可以正常的建立连接,但是,有时候Client端重新发送请求不是因为数据报丢失了,而是有可能数据传输过程因为网络并发量很大在某结点被阻塞了,这种情形下Server端将先后收到2次请求,并持续等待两个Client请求向他发送数据Cient端实际上只有一次请求,而Server端却有2个响应,极端的情况可能由于Client端多次重新发送请求数据而导致Server端最后建立了N多个响应在等待,因而造成极大的资源浪费
- **为什么要四次挥手？**
    - 假如现在Client想断开跟Server的所有连接,第一步,Client先停止向Server端发送数据,并等待Server的回复,虽然Client不往Server发送数据了,但是因为之前已经建立好平等的连接,所以此时Server也有主动权向Client发送数据,故Server端还得终止主动向Client发送数据,并等待Client的确认
- **为什么建立连接是三次握手,而关闭连接却是四次挥手呢？**
    - 这是因为服务端在LISTEN状态下,收到建立连接请求的SYN报文后,把ACK和SYN放在一个报文里发送给客户端,而关闭连接时,当收到对方的FIN报文时,仅仅表示对方不再发送数据了但是还能接收数据,己方是否现在关闭发送数据通道,需要上层应用来决定,因此,己方ACK和FIN一般都会分开发送
- **为什么客户端最后还要等待2MSL？**
    - MSL(Maximum Segment Lifetime),TCP允许不同的实现可以设置不同的MSL值
    - 第一,保证客户端发送的最后一个ACK报文能够到达服务器,因为这个ACK报文可能丢失,站在服务器的角度看来,我已经发送了FIN+ACK报文请求断开了,客户端还没有给我回应,应该是我发送的请求断开报文它没有收到,于是服务器又会重新发送一次,而客户端就能在这个2MSL时间段内收到这个重传的报文,接着给出回应报文,并且会重启2MSL计时器
    - 第二,防止类似与“三次握手”中提到了的“已经失效的连接请求报文段”出现在本连接中,客户端发送完最后一个确认报文后,在这个2MSL时间中,就可以使本连接持续的时间内所产生的所有报文段都从网络中消失,这样新的连接中不会出现旧连接的请求报文

#### 流量控制

- 如果发送者发送数据过快,接收者来不及接收,那么就会有分组丢失,为了避免分组丢失,控制发送者的发送速度,使得接收者来得及接收,这就是流量控制,流量控制根本目的是防止分组丢失,它是构成TCP可靠性的一方面
- **如何实现流量控制**
    - 由滑动窗口协议(连续ARQ协议)实现,滑动窗口协议既保证了分组无差错,有序接收,也实现了流量控制,主要的方式就是接收方返回的 ACK 中会包含自己的接收窗口的大小,并且利用大小来控制发送方的数据发送
- **怎么避免流量控制引发的死锁**
    - 当发送者收到了一个窗口为0的应答,发送者便停止发送,等待接收者的下一个应答,但是如果这个窗口不为0的应答在传输过程丢失,发送者一直等待下去,而接收者以为发送者已经收到该应答,等待接收新数据,这样双方就相互等待,从而产生死锁
    - 为了避免流量控制引发的死锁,TCP使用了持续计时器,每当发送者收到一个零窗口的应答后就启动该计时器,时间一到便主动发送报文询问接收者的窗口大小,若接收者仍然返回零窗口,则重置该计时器继续等待,若窗口不为0,则表示应答报文丢失了,此时重置发送窗口后开始发送,这样就避免了死锁的产生

#### 拥塞控制

**慢开始算法**

- 发送方维持一个叫做拥塞窗口cwnd(congestion window)的状态变量,拥塞窗口的大小取决于网络的拥塞程度,并且动态地在变化,发送方让自己的发送窗口等于拥塞窗口,另外考虑到接受方的接收能力,发送窗口可能小于拥塞窗口
- 慢开始算法的思路就是,不要一开始就发送大量的数据,先探测一下网络的拥塞程度,也就是说由小到大逐渐增加拥塞窗口的大小

![img](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/20210611123119.jpeg)

- 从上图可以看到,一个传输轮次所经历的时间其实就是往返时间RTT,而且每经过一个传输轮次(transmission round),拥塞窗口cwnd就加倍
- 为了防止cwnd增长过大引起网络拥塞,还需设置一个慢开始门限ssthresh状态变量,ssthresh的用法如下
    - 当cwnd<ssthresh时,使用慢开始算法
    - 当cwnd>ssthresh时,改用拥塞避免算法
    - 当cwnd=ssthresh时,慢开始与拥塞避免算法任意
- **注意**,这里的"慢”并不是指cwnd的增长速率慢,而是指在TCP开始发送报文段时先设置cwnd=1,然后逐渐增大,这当然比按照大的cwnd一下子把许多报文段突然注入到网络中要"慢得多”

**拥塞避免算法**

- 拥塞避免算法让拥塞窗口缓慢增长,即每经过一个往返时间RTT就把发送方的拥塞窗口cwnd加1,而不是加倍,这样拥塞窗口按线性规律缓慢增长
- 无论是在慢开始阶段还是在拥塞避免阶段,只要发送方判断网络出现拥塞,就把慢开始门限ssthresh设置为出现拥塞时的发送窗口大小的一半(但不能小于2),然后把拥塞窗口cwnd重新设置为1,执行慢开始算法,这样做的目的就是要迅速减少主机发送到网络中的分组数,使得发生拥塞的路由器有足够时间把队列中积压的分组处理完毕

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/20210611123131.jpeg" alt="img" style="zoom:50%;" />

- 乘法减小(Multiplicative Decrease)和加法增大(Additive Increase)
    - **乘法减小**:指的是无论是在慢开始阶段还是在拥塞避免阶段,只要发送方判断网络出现拥塞,就把慢开始门限ssthresh设置为出现拥塞时的发送窗口大小的一半,并执行慢开始算法,所以当网络频繁出现拥塞时,ssthresh下降的很快,以大大减少注入到网络中的分组数
    - **加法增大**:是指执行拥塞避免算法后,使拥塞窗口缓慢增大,以防止过早出现拥塞,常合起来成为AIMD算法
- **注意**:"拥塞避免”并非完全能够避免了阻塞,而是使网络比较不容易出现拥塞

**快重传算法**

- 快重传要求接收方在收到一个失序的报文段后就立即发出重复确认,使发送方及早知道有报文段没有到达对方,而不要等到自己发送数据时捎带确认,快重传算法规定,发送方只要一连收到三个重复确认就应当立即重传对方尚未收到的报文段,而不必继续等待设置的重传计时器时间到期

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/20210611123139.jpeg" alt="img" style="zoom: 67%;" />

**快恢复算法**

- 快重传配合使用的还有快恢复算法:当发送方连续收到三个重复确认时,就执行"乘法减小”算法,把ssthresh门限减半(为了预防网络发生拥塞),考虑到如果网络出现拥塞的话就不会收到好几个重复的确认,所以发送方现在认为网络可能没有出现拥塞,所以此时不执行慢开始算法,而是将cwnd设置为ssthresh减半后的值,然后执行拥塞避免算法,使cwnd缓慢增大

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/20210611123148.jpeg" alt="img" style="zoom: 50%;" />

- **注意**:在采用快恢复算法时,慢开始算法只是在TCP连接建立时和网络出现超时时才使用

**拥塞控制和流量控制的区别**

- **拥塞控制**:拥塞控制是作用于网络的,它是防止过多的数据注入到网络中,避免出现网络负载过大的情况,常用的方法
    - 慢开始,拥塞避免
    - 快重传,快恢复
- **流量控制**:流量控制是作用于接收者的,它是控制发送者的发送速度从而使接收者来得及接收,防止分组丢失的

### UDP协议

- UDP用户数据报协议,是面向无连接的通讯协议,由于通讯不需要连接,所以可以实现广播发送
- UDP通讯时不需要接收方确认,属于不可靠的传输,可能会出现丢包现象
- 每个UDP报文分UDP报头和UDP数据区两部分,报头由四个16位长(2字节)字段组成,分别说明该报文的源端口,目的端口,报文长度以及校验值,UDP报头由4个域组成,其中每个域各占用2个字节
- 使用UDP协议包括:TFTP(简单文件传输协议),SNMP(简单网络管理协议),DNS(域名解析协议),NFS,BOOTP
- **TCP 与 UDP 的区别**:TCP是面向连接的,可靠的字节流服务,UDP是面向无连接的,不可靠的数据报服务

### HTTP协议

#### HTTP与HTTPS的区别

- HTTPS协议需要到CA申请证书,一般免费证书较少,因而需要一定费用
- HTTP是超文本传输协议,信息是明文传输,HTTPS则是具有安全性的SSL加密传输协议
- HTTP和HTTPS使用的是完全不同的连接方式,用的端口也不一样,前者是80,后者是443

**HTTPS的工作原理**

1. 客户端使用HTTPS的URL访问Web服务器,要求与Web服务器建立SSL连接
2. Web服务器收到客户端请求后,会将网站的证书信息(证书中包含公钥)传送一份给客户端
3. 客户端的浏览器与Web服务器开始协商SSL连接的安全等级,也就是信息加密的等级,客户端的浏览器根据双方同意的安全等级,建立会话密钥,然后利用网站的公钥将会话密钥加密,并传送给服务器
5. Web服务器利用自己的私钥解密出会话密钥,Web服务器利用会话密钥加密与客户端之间的通信

**SSL四次握手**

1. 客户端请求建立SSL链接,并向服务端发送一个随机数–Client random和客户端支持的加密方法,比如RSA公钥加密,此时是明文传输
2. 服务端回复一种客户端支持的加密方法,一个随机数–Server random,授信的服务器证书和非对称加密的公钥
3. 客户端收到服务端的回复后利用服务端的公钥,加上新的随机数–Premaster secret 通过服务端下发的公钥及加密方法进行加密,发送给服务器
4. 服务端收到客户端的回复,利用已知的加解密方式进行解密,同时利用Client random,Server random和Premaster secret通过一定的算法生成HTTP链接数据传输的对称加密key – session key

- 此后的HTTP链接数据传输即通过对称加密方式进行加密传输

**对称加密与非对称加密**

- **对称加密**:指的就是加,解密使用的同是一串密钥,所以被称做对称加密,对称加密只有一个密钥作为私钥,常见的对称加密算法:DES,AES等
- **非对称加密**:指的是加,解密使用不同的密钥,一把作为公开的公钥,另一把作为私钥,公钥加密的信息,只有私钥才能解密,反之,私钥加密的信息,只有公钥才能解密

#### HTTP长连接短连接

- Connection:keep-alive
- **短连接**
    - 建立连接——数据传输——关闭连接...建立连接——数据传输——关闭连接
    - 多用于WEB网站的http服务,因为长连接对于服务端来说会耗费一定的资源,而像WEB网站这么频繁的成千上万甚至上亿客户端的连接用短连接会更省一些资源,如果用长连接,而且同时有成千上万的用户,如果每个用户都占用一个连接的话,那可想而知吧,所以并发量大,但每个用户无需频繁操作情况下需用短连好
- **长连接**的操作步骤是:
    - 建立连接——数据传输...(保持连接)...数据传输——关闭连接
    - 多用于操作频繁,点对点的通讯,而且连接数不能太多情况,,每个TCP连接都需要三步握手,这需要时间,如果每个操作都是先连接,再操作的话那么处理速度会降低很多,所以每个操作完后都不断开,次处理时直接发送数据包就OK了,不用建立TCP连接,例如:数据库的连接用长连接,如果用短连接频繁的通信会造成socket错误,而且频繁的socket 创建也是对资源的浪费

#### 常见状态码

| 状态码 | 原因短语                               |
| :----- | :------------------------------------- |
| 200    | OK (成功)                              |
| 301    | Moved Permanently (永久移动)           |
| 302    | Found (临时移动)                       |
| 304    | Not Modified (未修改)                  |
| 400    | Bad Request (错误请求)                 |
| 401    | Unauthorized (未授权)                  |
| 403    | Forbidden (禁止访问)                   |
| 404    | Not Found (未找到)                     |
| 500    | Internal Server Error (内部服务器错误) |
| 502    | Bad Gateway (网关错误)                 |
| 503    | Service Unavailable (服务不可用)       |

#### POST 与 GET 的区别

- **请求参数**:GET请求参数是通过URL传递的,多个参数以&连接,POST请求放在request body中
- **请求缓存**:GET请求会被缓存,而POST请求不会,除非手动设置
- **安全性**:POST比GET安全,GET请求在浏览器回退时是无害的,而POST会再次请求
- **历史记录**:GET请求参数会被完整保留在浏览历史记录里,而POST中的参数不会被保留
- **编码方式**:GET请求只能进行url编码,而POST支持多种编码方式
- **对参数的数据类型**:GET只接受ASCII字符,而POST没有限制

### ARP协议

- 地址解析协议,即ARP(Address Resolution Protocol),是根据IP地址获取物理地址的一个TCP/IP协议
- 主机发送信息时将包含目标IP地址的ARP请求广播到网络上的所有主机,并接收返回消息,以此确定目标的物理地址
- 收到返回消息后将该IP地址和物理地址存入本机ARP缓存中并保留一定时间,下次请求时直接查询ARP缓存以节约资源

### RARP协议

- 逆地址解析协议,即RARP,功能和ARP协议相对,其将局域网中某个主机的物理地址转换为IP地址
- 比如局域网中有一台主机只知道物理地址而不知道IP地址,那么可以通过RARP协议发出征求自身IP地址的广播请求,然后由RARP服务器负责回答

### ICMP协议

- Ping 的原理是 ICMP 协议:确认IP包是否成功送达目标地址以及通知在发送过程当中IP包被废弃的具体原因
- 差错报文,例如:差错报文,时间超过报文
- 询问报文:回送请求,应答报文,时间戳报文

### IP协议

#### IP数据报的格式

![BB15B9C613CE668AC5CCA95F6A967E9A](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-UCtIPhfpVnv7DuF.png)

#### 分类的IP地址

![image-20200520145853702](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-G9oiYI8saleWEfn.png)

![image-20200520145902844](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-la9Hrsd8OPA1Jk6.png)

### 路由转发算法

1. 先看是不是路由器就在目标网络里,如果在直接发给目的主机
2. 若路由表中有这个主机的地址,就直接发送给这个主机
3. 如果路由表有这个网络的路由地址,就发送到目标网络路由中去
4. 再没有就发送到默认路由
5. 都没有就直接ICMP差错报文

### 路由选择协议

#### RIP路由协议

- 它选择路由的度量标准(metric)是跳数,最大跳数是15跳,如果大于15跳,它就会丢弃数据包
- 每30s都都广播一次RIP路由更新信息,把跳数最少的路径更新

#### OSPF协议

- Open Shortest Path First开放式最短路径优先,底层是迪杰斯特拉算法,是链路状态路由选择协议,它选择路由的度量标准是带宽,延迟
- 直接广播,利用Dijkstra算法构造最优的路由表

### DNS协议

- DNS就是进行域名解析的服务器,可以简单地理解为将URL转换为IP地址

1. 浏览器将会检查缓存中有没有这个域名对应的解析过的IP地址,如果有该解析过程将会结束
2. 如果用户的浏览器中缓存中没有,操作系统会先检查自己本地的hosts文件是否有这个网址映射关系,如果有,就先调用这个IP地址映射关系,完成域名解析
3. 如果hosts里没有这个域名的映射,则查找本地DNS解析器缓存,是否有这个网址映射关系或缓存信息,如果有,直接返回给浏览器,完成域名解析
4. 如果hosts与本地DNS解析器缓存都没有相应的网址映射关系,则会首先找本地DNS服务器,一般是公司内部的DNS服务器,此服务器收到查询,如果此本地DNS服务器查询到相对应的IP地址映射或者缓存信息,则返回解析结果给客户机,完成域名解析,此解析具有权威性
5. 如果本地DNS服务器无法查询到,则根据本地DNS服务器设置的转发器进行查询
    - **未用转发模式**:本地DNS就把请求发至根DNS进行(迭代)查询,根DNS服务器收到请求后会判断这个域名(.com)是谁来授权管理,并会返回一个负责该顶级域名服务器的一个IP,本地DNS服务器收 到IP信息后,将会联系负责.com域的这台服务器,这台负责.com域的服务器收到请求后,如果自己无法解析,它就会找一个管理.com域的下一级 DNS服务器地址给本地DNS服务器,当本地DNS服务器收到这个地址后,就会找域名域服务器,重复上面的动作,进行查询,直至找到域名对应的主机
    - **使用转发模式**:此DNS服务器就会把请求转发至上一级DNS服务器,由上一级服务器进行解析,上一级服务器如果不能解析,或找根DNS或把转请求转至上上级,以此循环,不管是本地DNS服务器用是是转发,还是根提示,最后都是把结果返回给本地DNS服务器,由此DNS服务器再返回给客户机

### 网络地址转换

- NAT的实现方式有三种,即静态转换Static Nat,动态转换Dynamic Nat 和 端口多路复用OverLoad
- **静态转换**(Static Nat):是指将内部网络的私有IP地址转换为公有IP地址,IP地址对是一对一的,是一成不变的,某个私有IP地址只转换为某个公有IP地址,借助于静态转换,可以实现外部网络对内部网络中某些特定设备(如服务器)的访问
- **动态转换**(Dynamic Nat):是指将内部网络的私有IP地址转换为公用IP地址时,IP地址对是不确定的,而是随机的,所有被授权访问上Internet的私有IP地址可随机转换为任何指定的合法IP地址,也就是说,只要指定哪些内部地址可以进行转换,以及用哪些合法地址作为外部地址时,就可以进行动态转换,动态转换可以使用多个合法外部地址集,当ISP提供的合法IP地址略少于网络内部的计算机数量时,可以采用动态转换的方式
- **端口多路复用**(OverLoad):是指改变外出数据包的源端口并进行端口转换,即端口地址转换(PAT,Port Address Translation).采用端口多路复用方式,内部网络的所有主机均可共享一个合法外部IP地址实现对Internet的访问,从而可以最大限度地节约IP地址资源,同时,又可隐藏网络内部的所有主机,有效避免来自internet的攻击,因此,目前网络中应用最多的就是端口多路复用方式

### DHCP协议

- DHCP协议采用UDP作为传输协议,主机发送请求消息到DHCP服务器的67号端口,DHCP服务器回应应答消息给主机的68号端口
- 服务器控制一段IP地址范围,客户机登录服务器时就可以自动获得服务器分配的IP地址和子网掩码

### 网络连接过程

1. DNS解析,找到IP地址
2. 根据IP地址,找到对应的服务器
3. 建立TCP连接( 三次握手)
4. 连接建立后,发出HTTP请求
5. 服务器根据请求作出HTTP响应
6. 浏览器得到响应内容,进行解析与渲染,并显示
7. 断开连接(四次挥手)

## JS

### 什么是闭包

- 闭包就是能够读取其他函数内部变量的函数
- 由于在Javascript语言中,只有函数内部的子函数才能读取局部变量,因此可以把闭包简单理解成"定义在一个函数内部的函数"
- 所以,在本质上,闭包就是将函数内部和函数外部连接起来的一座桥梁
