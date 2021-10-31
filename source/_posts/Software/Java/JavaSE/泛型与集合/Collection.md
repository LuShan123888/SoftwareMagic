---
title:  Java Collection
categories:
- Software
- Java
- JavaSE
- 泛型与集合
---
#  Java Collection

- 接口Collection处于Collection API的最高层,在该接口中定义了所有低层接口或类的公共方法,下图给出了Collection API的实现层次

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-04-22-939.png)

## Collection

- Collection接口的定义如下

```java
public interface Collection<E> extends Iterable<E>
```

- 下表给出了Collection接口的主要方法:

| 方法                                     | 描述                           |
| ---------------------------------------- | ------------------------------ |
| boolean add(E obj)                       | 向收集中插入对象               |
| boolean addAll(Collection<? extends E>c) | 将一个收集的内容插入进来       |
| void clear()                             | 清除收集中的所有元素           |
| boolean contains(Object obj)             | 判断某一个对象是否在收集中存在 |
| boolean containsAll(Collection<?> c)     | 判断一组对象是否在收集中存在   |
| boolean equals(Object obj)               | 判断收集与对象是否相等         |
| int hashCode()                           | 获取集合的Hash值               |
| boolean isEmpty()                        | 收集是否为空                   |
| Iterator<E> iterator()                   | 获取收集的Iterator接口实例     |
| boolean remove(Object obj)               | 删除指定对象                   |
| boolean removeAll(Collection<?> c)       | 删除一组对象                   |
| Int size()                               | 求出收集的大小                 |
| Object[] toArray()                       | 将收集变为对象数组             |
| <T> T[ ] toArray(T[ ] a)                 | 将收集转换为特定类型的对象数组 |

## List

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-03-21-image-20210321213904818.png)

- **List 集合代表一个有序集合,集合中每个元素都有其对应的顺序索引,List 集合允许使用重复元素,可以通过索引来访问指定位置的集合元素,**
- List 接口继承于 Collection 接口,它可以定义一个允许重复的有序集合,因为 List 中的元素是有序的,所以我们可以通过使用索引(元素在 List 中的位置,类似于数组下标)来访问 List 中的元素,这类似于 Java 的数组
- List 接口为 Collection 直接接口,List 所代表的是有序的 Collection,即它用某种特定的插入顺序来维护元素顺序,用户可以对列表中每个元素的插入位置进行精确地控制,同时可以根据元素的整数索引(在列表中的位置)访问元素,并搜索列表中的元素
- 实现 List 接口的集合主要有:`ArrayList,LinkedList,Vector,Stack`

| 方法                                      | 功能                             |
| ----------------------------------------- | -------------------------------- |
| void add(E elem)                          | 在尾部添加元素                   |
| void add(int pos,E elem)                  | 在指定位置添加元素               |
| E get(int pos)                            | 获取指定位置元素                 |
| E set(int pos,E elem)                     | 修改指定位置元素                 |
| E remove(int pos)                         | 删除指定位置元素                 |
| int indexOf(Object obj,int start_pos)     | 从某位置开始往后查找元素位置     |
| int lastindexOf(Object obj,int start_pos) | 从某位置开始由尾往前查找元素位置 |
| ListIterator<E> listIterator()            | 返回列表的ListIterator对象       |

- `elem`:数据对象
- `pos`:操作 位置
- `start_pos`:起始查找位置

#### ArrayList

- ArrayList 是一个动态数组,也是我们最常用的集合,它允许任何符合规则的元素插入甚至包括 null
- 每一个 ArrayList 都有一个初始容量(10),该容量代表了数组的大小,随着容器中的元素不断增加,容器的大小也会随着增加,在每次向容器中增加元素的同时都会进行容量检查,当快溢出时,就会进行扩容操作,所以**如果我们明确所插入元素的多少,最好指定一个初始容量值,避免过多的进行扩容操作而浪费时间,效率,**
- `size()`,`isEmpty()`,`get()`,`set()`,`iterator()`和`listIterator()`操作都以固定时间运行,`add()`操作以分摊的固定时间运行,也就是说,添加 n 个元素需要 O(n) 时间(由于要考虑到扩容,所以这不只是添加元素会带来分摊固定时间开销那样简单)
- **ArrayList 擅长于随机访问,同时 ArrayList 是非同步的,**

**[例14-4]**:ArrayList的使用

```java
import java.util.*;
public class ArrayList的使用 {
  public static void main(String[] args) {
    ArrayList<Integer> a = new ArrayList<Integer>();
    a.add(new Integer(12));
    a.add(new Integer(15));
    a.add(23);//会自动包装转换,相当于a.add(new Integer(23))
    output(a);
    ArrayList<Double> b = new ArrayList<Double>();
    b.add(new Double(1.2));
    b.add(new Double(2.45));
    output(b);
  }

  // 用来输出ArrayList的数据项内容,该方法参数限制必须是Number范围内的ArratList数据对象
  static void output(ArrayList<? extends Number> a) {
    Iterator<?> p = a.iterator();
    while (p.hasNext()) {
      System.out.println(p.next() + ",");
    }
    System.out.println();
  }
}

12,
15,
23,

1.2,
2.45,
```

**注意**:给ArrayList加入的数据类型通常要与参数类型一致,但如果能进行转换赋值也可,程序中直接将整数23加入`ArrayList<Integer>`,Java会自动将基本类型数据包装转换为其包装类的对象,也就是将23包装转换为Integer类型的对象

#### LinkedList

- 同样实现 List 接口的 LinkedList 与 ArrayList 不同,**ArrayList 是一个动态数组,而 LinkedList 是一个双向链表**,所以它除了有 ArrayList 的基本操作方法外还额外提供了`get,remove,insert`方法在 LinkedList 的首部或尾部
- 由于实现的方式不同,**LinkedList 不能随机访问**,它所有的操作都是要按照双重链表的需要执行,在列表中索引的操作将从开头或结尾遍历列表(从靠近指定索引的一端),这样做的好处就是可以通过较低的代价在 List 中进行插入和删除操作
- 与 ArrayList 一样,**LinkedList 也是非同步的**,如果多个线程同时访问一个 List,则必须自己实现访问同步,一种解决方法是在创建 List 时构造一个同步的 List:

```java
List list = Collections.synchronizedList(new LinkedList(...));
```

**[例14-5]**:ArrayList和LinkedLink的使用测试

```java
import java.util.*;
public class ArrayList和LinkedList的使用测试 {
  static long timeList(List<Integer> st){
    long start = System.currentTimeMillis();//开始时间
    for (int i =0;i<5000;i++)
      // 使用List对象的add(int Object)方法加入对象到List内指定位置
      st.add(0,new Integer(i));
    return System.currentTimeMillis()-start;//计算花费时间
  }

  public static void main(String[] args) {
    System.out.println("time for ArrayList= "+ timeList(new ArrayList<Integer>()));
    System.out.println("time for LinkedList= "+ timeList(new LinkedList<Integer>()));
  }
}

time for ArrayList= 5
  time for LinkedList= 3
```

**说明**:测试可知,ArrayList所花费时间远高于LinkedList,原因是每次加入一个元素到ArrayList的开头,先前所有已存在的元素要后移,而加入一个元素到LinkedList的开头,只要创建一个新结点,并调整一对链接关系即可,如果将程序中的`add(0,obj)`修改为`add(obj)`则可发现ArrayList执行更快些,因此在选择数据结构时要考虑相应问题的操作特点

### Vertor

- 向量(Vector)是List接口中的另一个子类,Vector非常类似ArrayList,早期的程序中使用较多,现在通常用ArrayList代替,两者一个重要的差异是,Vector是线程同步的,线程在更改向量的过程中将对资源加锁,所以说 **Vector 是线程安全的动态数组**
- Vector也是实现了可变大小的对象数组,在容量不够时会自动增加,以下构造方法规定了向量的初始容量及容量不够时的扩展容量

```java
public Vector<E>(int initCapacity, int capacityIncrement);
```

- 无参构造方法规定的初始容量为10,增量为10
- 用`size()`方法可获取向量的大小,而`capacity()`方法则用来获取向量的容量
- 除了支持List接口中定义的方法外,向量还有从早期JDK保留下来的一些方法,例如:
  - `void addElement(E elem)`:在向量的尾部添加元素
  - `void insertElementAt(E obj,int index)`:在指定位置添加元素
  - `E elementAt(int index)`:获取指定位置元素
  - `void setElementAt(int index)`:设置index处元素为obj
  - `boolean removeElement(E obj)`:删除首个与obj相同元素
  - `void removeElementAt(int index)`:删除index指定位置的元素
  - `void removeAllElements()`:清除向量序列所有元素
  - `void clear()`:清除向量序列所有元素

**[例14-6]**:测试向量的大小及容量变化

```java
import java.util.Vector;
public class 测试向量的大小及容量变化 {
  public static void main(String[] args) {
    Vector<Integer> v = new Vector<Integer>(20,30);
    System.out.println("size="+v.size());
    System.out.println("capacity="+v.capacity());
    for (int i=0;i<24;i++){
      v.add(i);//加入数据自动包装转换为Integer对象
    }
    System.out.println("After added 24 Elements");
    System.out.println("size="+v.size());
    System.out.println("capacity="+v.capacity());
  }
}

size=0
  capacity=20
  After added 24 Elements
  size=24
  capacity=50
```

### Stack

- 栈是Vector的一个子类,它实现了一个标准的后进先出的栈,也就是新进栈的元素总在栈顶,而出栈时总是先取栈顶元素
- 除了由Vector定义的所有方法,Stack也定义了一些方法:
  - `boolean empty()`:测试堆栈是否为空
  - `Object peek( )`:查看堆栈顶部的对象,但不从堆栈中移除它
  - `Object pop( )`:移除堆栈顶部的对象,并作为此函数的值返回该对象
  - `Object push(Object element)`:把项压入堆栈顶部
  - `int search(Object element)`:返回对象在堆栈中的位置,以 1 为基数

**实例**:下面的程序说明这个集合所支持的几种方法

```java
import java.util.*;

public class StackDemo {

  static void showpush(Stack<Integer> st, int a) {
    st.push(new Integer(a));
    System.out.println("push(" + a + ")");
    System.out.println("stack: " + st);
  }

  static void showpop(Stack<Integer> st) {
    System.out.print("pop -> ");
    Integer a = (Integer) st.pop();
    System.out.println(a);
    System.out.println("stack: " + st);
  }

  public static void main(String args[]) {
    Stack<Integer> st = new Stack<Integer>();
    System.out.println("stack: " + st);
    showpush(st, 42);
    showpush(st, 66);
    showpush(st, 99);
    showpop(st);
    showpop(st);
    showpop(st);
    try {
      showpop(st);
    } catch (EmptyStackException e) {
      System.out.println("empty stack");
    }
  }
}
```

- 以上实例编译运行结果如下:

```
stack: [ ]
push(42)
stack: [42]
push(66)
stack: [42, 66]
push(99)
stack: [42, 66, 99]
pop -> 99
stack: [42, 66]
pop -> 66
stack: [42]
pop -> 42
stack: [ ]
pop -> empty stack
```

### 重写 equals 方法

- `List`提供了`boolean contains(Object o)`方法来判断`List`是否包含某个指定元素,此外,`int indexOf(Object o)`方法可以返回某个元素的索引,如果元素不存在,就返回`-1`
- 正确使用`List`的`contains()`,`indexOf()`这些方法,放入的实例必须正确覆写`equals()`方法,否则,放进去的实例,查找不到,我们之所以能正常放入`String`,`Integer`这些对象,是因为Java标准库定义的这些类已经正确实现了`equals()`方法

> **如何正确编写equals()方法**
>
> - `equals()`方法要求我们必须满足以下条件:
>   - **自反性**(Reflexive):对于非`null`的`x`来说,`x.equals(x)`必须返回`true`
>   - **对称性**(Symmetric):对于非`null`的`x`和`y`来说,如果`x.equals(y)`为`true`,则`y.equals(x)`也必须为`true`
>   - **传递性**(Transitive):对于非`null`的`x`,`y`和`z`来说,如果`x.equals(y)`为`true`,`y.equals(z)`也为`true`,那么`x.equals(z)`也必须为`true`
>   - **一致性**(Consistent):对于非`null`的`x`和`y`来说,只要`x`和`y`状态不变,则`x.equals(y)`总是一致地返回`true`或者`false`
>   - **对null的比较**:即`x.equals(null)`永远返回`false`

- 上述规则看上去似乎非常复杂,但其实代码实现`equals()`方法是很简单的,我们以`Person`类为例:

```java
public class Person {
    public String name;
    public int age;
}
```

- 首先,我们要定义"相等”的逻辑含义,对于`Person`类,如果`name`相等,并且`age`相等,我们就认为两个`Person`实例相等
- 因此,编写`equals()`方法如下:

```java
public boolean equals(Object o) {
    if (o instanceof Person) {
        Person p = (Person) o;
        return this.name.equals(p.name) && this.age == p.age;
    }
    return false;
}
```

- 对于引用字段比较,我们使用`equals()`,对于基本类型字段的比较,我们使用`==`
- 如果`this.name`为`null`,那么`equals()`方法会报错,因此,需要继续改写如下:

```java
public boolean equals(Object o) {
    if (o instanceof Person) {
        Person p = (Person) o;
        boolean nameEquals = false;
        if (this.name == null && p.name == null) {
            nameEquals = true;
        }
        if (this.name != null) {
            nameEquals = this.name.equals(p.name);
        }
        return nameEquals && this.age == p.age;
    }
    return false;
}
```

- 如果`Person`有好几个引用类型的字段,上面的写法就太复杂了,要简化引用类型的比较,我们使用`Objects.equals()`静态方法:

```java
public boolean equals(Object o) {
    if (o instanceof Person) {
        Person p = (Person) o;
        return Objects.equals(this.name, p.name) && this.age == p.age;
    }
    return false;
}
```

- 因此,我们总结一下`equals()`方法的正确编写方法:
  - 先确定实例"相等”的逻辑,即哪些字段相等,就认为实例相等
  - 用`instanceof`判断传入的待比较的`Object`是不是当前类型,如果是,继续比较,否则,返回`false`
  - 对引用类型用`Objects.equals()`比较,对基本类型直接用`==`比较
- 使用`Objects.equals()`比较两个引用类型是否相等的目的是省去了判断`null`的麻烦,两个引用类型都是`null`时它们也是相等的
- 如果不调用`List`的`contains()`,`indexOf()`这些方法,那么放入的元素就不需要实现`equals()`方法

### ArrayList/LinkedList比较

- ArrayList内部使用数组存放元素,实现了可变大小的数组,访问元素效率高,当插入元素效率低
- LinkedList内部使用双向链表存储元素,插入元素效率高,但访问元素效率低
- 相对于ArrayList,LinkedList的插入,添加,删除操作速度更快,因为当元素被添加到集合任意位置的时候,不需要像数组那样重新计算大小或者是更新索引
- LinkedList比ArrayList更占内存,因为LinkedList为每一个节点存储了两个引用,一个指向前一个元素,一个指向下一个元素

## Set

- **Set 是一种不包含重复的元素的无序 Collection,Set 最多有一个 null 元素,**它维持它自己的内部排序,所以随机访问没有任何意义
- Set 接口有三个具体实现类,分别是散列集 HashSet,链式散列集 LinkedHashSet 和树形集 TreeSet
- 需要注意的是:虽然 Set 中元素没有顺序,但是元素在 set 中的位置是由该元素的 HashCode 决定的,其具体位置其实是固定的
- 因为放入Set的元素和Map的key类似,都要正确实现`equals()`和`hashCode()`方法,否则该元素无法正确地放入Set
- Set用于存储不重复的元素集合,它主要提供以下几个方法:
  - 将元素添加进`Set<E>`:`boolean add(E e)`
  - 将元素从`Set<E>`删除:`boolean remove(Object e)`
  - 判断是否包含元素:`boolean contains(Object e)`

**[例14-3]**:Set接口的使用

```java
public class TestSet {

  public static void main(String[] args){

    Set<String> books = new HashSet<String>();
    //添加一个字符串对象
    books.add(new String("Struts2权威指南"));

    //再次添加一个字符串对象
    //因为两个字符串对象通过equals方法比较相等,所以添加失败,返回false
    boolean result = books.add(new String("Struts2权威指南"));

    System.out.println(result);

    //下面输出看到集合只有一个元素
    System.out.println(books);

  }
}
```

- **分析**:程序中,book 集合两次添加的字符串对象明显不是一个对象(程序通过 new 关键字来创建字符串对象),当使用`==`运算符判断返回 false,使用 equals 方法比较返回 true,所以不能添加到 Set 集合中,最后只能输出一个元素

### HashSet

- HashSet 是一个没有重复元素的集合,它是由 HashMap 实现的,不保证元素的顺序 (这里所说的没有顺序是指:元素插入的顺序与输出的顺序不一致),而且 HashSet 允许使用 null 元素
- HashSet 是非同步的,如果多个线程同时访问一个HashSet,而其中至少一个线程修改了该 Set,那么它必须保持外部同步
- HashSet 按 Hash 算法来存储集合的元素,因此具有很好的存取和查找性能
- HashSet 的实现方式大致如下,通过一个 HashMap 存储元素,元素是存放在 HashMap 的 Key 中,而 Value 统一使用一个名为PRESENT的 Object 对象
- **HashSet 使用和理解中容易出现的误区**
  - **HashSet 中存放 null 值,**HashSet 中是允许存入 null 值的,但是在 HashSet 中仅仅能够存入一个 null 值
  - **HashSet 中存储元素的位置是固定的,**HashSet 中存储的元素的是无序的,但是由于 HashSet 底层是基于 Hash 算法实现的,使用了 hashcode,所以 HashSet 中相应的元素的位置是固定的
  - **必须小心操作可变对象**(`Mutable Object`),如果一个 Set 中的可变元素改变了自身状态导致`Object.equals(Object)=true`将导致一些问题

```java
public class Main {
  public static void main(String[] args) {
    Set<String> set = new HashSet<>();
    set.add("apple");
    set.add("banana");
    set.add("pear");
    set.add("orange");
    for (String s : set) {
      System.out.println(s);
    }
  }
}
```

**保证唯一性**

- `HashSet`是调用的`HashMap`的`put()`方法,而`put()`方法中有这么一行逻辑,如果`Hash值`和`key`都一样,就会直接拿新值覆盖旧值,而`HashSet`就是利用这个特性来保证唯一性

```java
 if (p.hash == hash && ((k = p.key) == key || (key != null && key.equals(k))))
     e = p;
```

- 所以在存放对象的时候需要重写`hashCode()`和`equals()`方法,因为就是用这两个方法来判断唯一性的,否则就会出现下面这样的情况,创建两个属性一样的对象,放入`HashSet`中会发现重复了,那是因为创建两个对象肯定Hash值是不一样的,所以需要自己重写`hashCode()`和`equals()`

### LinkedHashSet

- LinkedHashSet 继承自 HashSet,其底层是基于 LinkedHashMap 来实现的,有序,非同步
- LinkedHashSet 集合同样是根据元素的 hashCode 值来决定元素的存储位置,但是它同时使用链表维护元素的次序,这样使得元素看起来像是以插入顺序保存的,也就是说,当遍历该集合时候,**LinkedHashSet 将会以元素的添加顺序访问集合的元素,**

```java
public class Main {
  public static void main(String[] args) {
    Set<String> set = new LinkedHashSet<>();
    set.add("apple");
    set.add("banana");
    set.add("pear");
    set.add("orange");
    for (String s : set) {
      System.out.println(s);//输出的顺序与添加的顺序相同
    }
  }
}
```

### TreeSet

- TreeSet 是一个有序集合,其底层是基于 TreeMap 实现的,非线程安全,TreeSet 可以确保集合元素处于排序状态
- TreeSet 支持两种排序方式,自然排序和定制排序,其中自然排序为默认的排序方式
- 放入TreeSet的元素,必须实现`Comparable`接口,如果没有实现`Comparable`接口,则必须在创建 TreeSet 时传入自定义的 `Comparator`对象,TreeSet 会自动对元素的进行排序

> **注意**:TreeSet 集合不是通过 hashcode 和 equals 函数来比较元素的. 它是通过 compare 或者 comparaeTo 函数来判断元素是否相等. compare 函数通过判断两个对象的 id,相同的 id 判断为重复元素,不会被加入到集合中

```java
public class Main {
  public static void main(String[] args) {
    Set<String> set = new TreeSet<>();
    set.add("apple");
    set.add("banana");
    set.add("pear");
    set.add("orange");
    for (String s : set) {
      System.out.println(s); // 按字母顺序排序
    }
  }
}
```

### HashSet/LinkedHashSet/TreeSet 比较

- **HashSet**
    - HashSet 是由 HashMap 实现的,不保证元素的顺序
- **LinkedHashSet**
    - LinkedHashSet 集合同样是根据元素的 hashCode 值来决定元素的存储位置,但是它同时使用链表维护元素的次序,这样使得元素看起来像是以插入顺序保存的,也就是说,当遍历该集合时候,LinkedHashSet 将会以元素的添加顺序访问集合的元素
    - **LinkedHashSet 在迭代访问 Set 中的全部元素时,性能比 HashSet 好,但是插入时性能稍微逊色于 HashSet**
- **TreeSet**
    - TreeSet 是 SortedSet 接口的唯一实现类,TreeSet 可以确保集合元素处于排序状态

## Queue

- 队列(`Queue`)是一种经常使用的集合,`Queue`实际上是实现了一个先进先出(FIFO:First In First Out)的有序表,它和`List`的区别在于,`List`可以在任意位置添加和删除元素,而`Queue`只有两个操作:
  - 把元素添加到队列末尾
  - 从队列头部取出元素
- 在Java的标准库中,队列接口`Queue`定义了以下几个方法:
  - `int size()`:获取队列长度
  - `boolean add(E)`/`boolean offer(E)`:添加元素到队尾
  - `E remove()`/`E poll()`:获取队首元素并从队列中删除
  - `E element()`/`E peek()`:获取队首元素但并不从队列中删除
- 对于具体的实现类,有的Queue有最大队列长度限制,有的Queue没有,注意到添加,删除和获取队列元素总是有两个方法,这是因为在添加或获取元素失败时,这两个方法的行为是不同的

|                    | throw Exception | 返回false或null    |
| :----------------- | :-------------- | ------------------ |
| 添加元素到队尾     | add(E e)        | boolean offer(E e) |
| 取队首元素并删除   | E remove()      | E poll()           |
| 取队首元素但不删除 | E element()     | E peek()           |

- 假设我们有一个队列,对它做一个添加操作,如果调用`add()`方法,当添加失败时(可能超过了队列的容量),它会抛出异常:

```java
Queue<String> q = ...
try {
    q.add("Apple");
    System.out.println("添加成功");
} catch(IllegalStateException e) {
    System.out.println("添加失败");
}
```

- 如果我们调用`offer()`方法来添加元素,当添加失败时,它不会抛异常,而是返回`false`:

```java
Queue<String> q = ...
if (q.offer("Apple")) {
    System.out.println("添加成功");
} else {
    System.out.println("添加失败");
}
```

- 当我们需要从`Queue`中取出队首元素时,如果当前`Queue`是一个空队列,调用`remove()`方法,它会抛出异常:

```java
Queue<String> q = ...
try {
    String s = q.remove();
    System.out.println("获取成功");
} catch(IllegalStateException e) {
    System.out.println("获取失败");
}
```

- 如果我们调用`poll()`方法来取出队首元素,当获取失败时,它不会抛异常,而是返回`null`:

```java
Queue<String> q = ...
String s = q.poll();
if (s != null) {
    System.out.println("获取成功");
} else {
    System.out.println("获取失败");
}
```

- 因此,两套方法可以根据需要来选择使用
- **注意**:不要把`null`添加到队列中,否则`poll()`方法返回`null`时,很难确定是取到了`null`元素还是队列为空
- 对于`Queue`来说,每次调用`poll()`,都会获取队首元素,并且获取到的元素已经从队列中被删除了:

```java
public class Main {
    public static void main(String[] args) {
        Queue<String> q = new LinkedList<>();
        // 添加3个元素到队列:
        q.offer("apple");
        q.offer("pear");
        q.offer("banana");
        // 从队列取出元素:
        System.out.println(q.poll()); // apple
        System.out.println(q.poll()); // pear
        System.out.println(q.poll()); // banana
        System.out.println(q.poll()); // null,因为队列是空的
    }
}
```

- 如果用`peek()`,因为获取队首元素时,并不会从队列中删除这个元素,所以可以反复获取:

```java
public class Main {
    public static void main(String[] args) {
        Queue<String> q = new LinkedList<>();
        // 添加3个元素到队列:
        q.offer("apple");
        q.offer("pear");
        q.offer("banana");
        // 队首永远都是apple,因为peek()不会删除它:
        System.out.println(q.peek()); // apple
        System.out.println(q.peek()); // apple
        System.out.println(q.peek()); // apple
    }
}
```

- 从上面的代码中,我们还可以发现,`LinkedList`即实现了`List`接口,又实现了`Queue`接口,但是,在使用的时候,如果我们把它当作List,就获取List的引用,如果我们把它当作Queue,就获取Queue的引用:

```java
// 这是一个List:
List<String> list = new LinkedList<>();
// 这是一个Queue:
Queue<String> queue = new LinkedList<>();
```

- 始终按照面向抽象编程的原则编写代码,可以大大提高代码的质量

### PriorityQueue

- PriorityQueue和Queue的区别在于,它的出队顺序与元素的优先级有关,对PriorityQueue调用`remove()`或`poll()`方法,返回的总是优先级最高的元素
- 放入PriorityQueue的元素,必须实现`Comparable`接口,如果没有实现`Comparable`接口,则必须在创建 TreeMap 时传入自定义的 `Comparator`对象,PriorityQueue会根据元素的排序顺序决定出队的优先级

```java
class Test {

  public static void main(String[] args) {
    Queue<User> q = new PriorityQueue<>(new UserComparator());
    // 添加3个元素到队列:
    q.offer(new User("Bob", "A10"));
    q.offer(new User("Alice", "A232"));
    q.offer(new User("Boss", "V1"));
    System.out.println(q.poll()); // Boss/V1
    System.out.println(q.poll()); // Bob/A1
    System.out.println(q.poll()); // Alice/A2
    System.out.println(q.poll()); // null,因为队列为空
  }
}

class UserComparator implements Comparator<User> {
  public int compare(User u1, User u2) {
    if (u1.number.charAt(0) == u2.number.charAt(0)) {
      // 如果两人的号都是A开头或者都是V开头,比较号的大小:
      return u1.number.substring(1).compareTo(u2.number.substring(1));
    }
    if (u1.number.charAt(0) == 'V') {
      // u1的号码是V开头,优先级高:
      return -1;
    } else {
      return 1;
    }
  }
}

class User {
  public final String name;
  public final String number;

  public User(String name, String number) {
    this.name = name;
    this.number = number;
  }

  public String toString() {
    return name + "/" + number;
  }
}

```

- 实现`PriorityQueue`的关键在于提供的`UserComparator`对象,它负责比较两个元素的大小(较小的在前),`UserComparator`总是把`V`开头的号码优先返回,只有在开头相同的时候,才比较号码大小

### Deque

- Java集合提供了接口Deque来实现一个双端队列,它的功能是:
  - 既可以添加到队尾,也可以添加到队首
  - 既可以从队首获取,又可以从队尾获取
- 我们来比较一下Queue和Deque出队和入队的方法:

|                    | Queue                  | Deque                           |
| :----------------- | :--------------------- | :------------------------------ |
| 添加元素到队尾     | add(E e) / offer(E e)  | addLast(E e) / offerLast(E e)   |
| 取队首元素并删除   | E remove() / E poll()  | E removeFirst() / E pollFirst() |
| 取队首元素但不删除 | E element() / E peek() | E getFirst() / E peekFirst()    |
| 添加元素到队首     | 无                     | addFirst(E e) / offerFirst(E e) |
| 取队尾元素并删除   | 无                     | E removeLast() / E pollLast()   |
| 取队尾元素但不删除 | 无                     | E getLast() / E peekLast()      |

- 对于添加元素到队尾的操作,Queue提供了`add()`/`offer()`方法,而Deque提供了`addLast()`/`offerLast()`方法,添加元素到对首,取队尾元素的操作在Queue中不存在,在Deque中由`addFirst()`/`removeLast()`等方法提供
- 注意到Deque接口实际上扩展自Queue:

```java
public interface Deque<E> extends Queue<E> {
    ...
}
```

- 总是调用`xxxFirst()`/`xxxLast()`以便与`Queue`的方法区分开

```java
public class Main {
  public static void main(String[] args) {
    Deque<String> deque = new LinkedList<>();
    deque.offerLast("A"); // A
    deque.offerLast("B"); // A <- B
    deque.offerFirst("C"); // C <- A <- B
    System.out.println(deque.pollFirst()); // C, 剩下A <- B
    System.out.println(deque.pollLast()); // B, 剩下A
    System.out.println(deque.pollFirst()); // A
    System.out.println(deque.pollFirst()); // null
  }
}
```

- `Deque`是一个接口,它的实现类有`ArrayDeque`和`LinkedList`
- 我们发现`LinkedList`真是一个全能选手,它即是`List`,又是`Queue`,还是`Deque`,但是我们在使用的时候,总是用特定的接口来引用它,这是因为持有接口说明代码的抽象层次更高,而且接口本身定义的方法代表了特定的用途

```java
// 不推荐的写法:
LinkedList<String> d1 = new LinkedList<>();
d1.offerLast("z");
// 推荐的写法:
Deque<String> d2 = new LinkedList<>();
d2.offerLast("z");
```

- **注意**:避免把`null`添加到队列

## List/Set/Map的区别

- List有序存取元素,可以有重复元素
- Set不能存放重复元素,存入的元素是无序的
- Map保存键值对映射,映射关系可以是一对一或多对一
