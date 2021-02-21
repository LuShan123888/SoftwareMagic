---
title: Java Collection
categories:
- Software
- Backend
- Java
- JavaSE
- 泛型与Collections
---
# Java Collection

接口Collection处于Collection API的最高层,在该接口中定义了所有低层接口或类的公共方法,下图给出了Collection API的实现层次,图中省略了AbstractCollection等5个抽象类,省略了Collection接口的子接口Queue

![](https://www.plantuml.com/plantuml/svg/XP91Jjj058RtFiKW5aXUs8u9mgqG2aHO80M46jhzn7xOeundeZVFYcZLAvH3L3q0QyxJzXfzdj340G5UMFh_yVp_DyypSYIH6cNAHYw2FR6ZJA7R4WJLq42qQ1lTTskYXViOnoYNKQMeRcUj0ooi8J0K5RQ99-sqbcQGxcTP5kTAWuiRwGWmljRIqEVBIToBFd9qf-4uC9R3lmM2dsjPbifKOf1uUIcnKaPaNfpAObwXRKqvjjgYMDQAmA-SMrHV6KFg4wqgqp2EAFW5w9S_hVQW0HI30szDb85LocuopePdkNSPlhHBtnzy3z1QkjgWRR6iELClztpWj3kEoABaUKMUxnyEatSEqQVCk3xG86zVw--7Zp_a1-cBY3HvFb2Eb8Xs-PJNPnw-CPJElQbLCJVWd4YZBkWeVlfreRZWASkPXZy_Vls-_nc4eU083GKfQzPUAAP06yNI8a6vRORY1W7O-_lmkFhgNBfwevd4ROMS8CgxpbnlODRvbl65GIp-bznBFFzEZe0l_UhY_mC0)

## Collection接口

Collection接口的定义如下:

```java
public interface Collection<E> extends Iterable<E>
```

下表给出了Collection接口的主要方法:

| 方法                                     | 描述                           |
| ---------------------------------------- | ------------------------------ |
| boolean add(E obj)                       | 向收集中插入对象               |
| boolean addAll(Collection<? extends E>c) | 将一个收集的内容插入进来       |
| void clear()                             | 清除收集中的所有元素           |
| boolean contains(Object obj)             | 判断某一个对象是否在收集中存在 |
| boolean containsAll(Collection<?> c)     | 判断一组对象是否在收集中存在   |
| boolean equals(Object obj)               | 判断收集与对象是否相等         |
| int hashCode()                           | 获取收集的哈希码               |
| boolean isEmpty()                        | 收集是否为空                   |
| Iterator<E> iterator()                   | 获取收集的Iterator接口实例     |
| boolean remove(Object obj)               | 删除指定对象                   |
| boolean removeAll(Collection<?> c)       | 删除一组对象                   |
| Int size()                               | 求出收集的大小                 |
| Object[] toArray()                       | 将收集变为对象数组             |
| <T> T[ ] toArray(T[ ] a)                 | 将收集转换为特定类型的对象数组 |

如何遍历Collection中的每一个元素?不论Collection的实际类型如何,它都支持一个`iterator()`方法,该方法返回一个迭代子,使用该迭代子即可逐一访问Collection中每一个元素,通过Iterator接口定义的`hasNext()`和`next()`方法实现从前往后遍历元素,其子接口ListIterator进一步增加了`hasPrevious()`和`previous()`方法,实现从后向前遍历访问列表元素

Iterator接口定义的方法介绍如下:

- `boolean hasNext()`:判断容器中是否存在下一个可访问元素
- `Object next()`:返回要访问的下一个元素,如果没有下一个元素,则引发NoSuchElement Exception异常
- `void remove()`:是一个可选操作,用于删除迭代子返回的最后一个元素,该方法只能在每次执行`next()`后执行一次

Iterator接口典型的用法如下:

```java
Iterator it = collection.iterator();//获得一个迭代子
while(it.hasNext()){
 Object bj = it.next;	//得到下一个元素
}
```

目前,JDK中并没有提供一个类直接实现Collection接口,而是实现它的两个子接口,一个是Set,另一个是List,当然子接口继承了父接口的方法

## Set接口

Set接口是数学上集合模型的抽象,特点有两个:一是不含重复元素,二是无序,该接口在Collection接口的基础上明确了一些方法的语义,例如`add(Object)`方法不能插入已经在集合中的元素,`allAll(Collection c)`方法将当前 集合与收集c的集合进行并运算

判断集合中重复元素的标准是按对象值比较,即集合中不包括任何两个元素e1和e2,它们之间满足条件e1.equals(e2)

**[例14-3]**Set接口的使用

```java
import java.util.*;
public class Set接口的使用 {
    public static void main(String[] args) {
        Set<String> h = new HashSet<String>();
        h.add("Str1");
        h.add("good");
        h.add("Str1");
        h.add(new String("Str1"));
        System.out.println(h);
    }
}

[Str1, good]
```

**说明**

第5\~8行给集合加入了4个对象,但只有两个成功加入,其他两个因已有相同值的元素不能加入集合

SortedSet接口用于描述按"自然顺序”组织元素的收集,除继承Set接口的方法外,其中定义的新方法体现存放的对象有序的特点,例如,方法`first()`返回SortedSet中的第一个元素,方法`last()`返回SortedSet中的最后一个元素,方法`comparator()`返回集合的比较算子,如果该集合使用自然顺序,则返回null

## List接口

List接口类似于数学上的数列模型,也称序列,其特点是克含重复元素,而且是有序序列,用户可以控制向序列中某位置插入元素,并可按元素的顺序访问它们,元素的顺序从0开始,最后一个元素为`list.size()-1`,下表列出了对`List<E>`接口中定义的常用方法,其中,elem代表数据对象,pos代表操作位置,start_pos为起始查找位置

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

## ArrayList类和LinkList类

类ArrayList是最常用的列表容器类,类ArrayList内部使用数组存放元素,实现了可变大小的数组,访问元素效率高,当插入元素效率低,类LinkedList是另一个常用的列表容器类,其内部使用双向链表存储元素,插入元素效率高,但访问元素效率低,LinkedList的特点是特别区分列表的头位置和尾位置的概念,提供了在头尾增,删和访问元素的方法,例如,方法`addFirst(Object)`在头位置插入元素,如果需要快速插入,删除元素,应该使用LinkedList,如果需要快速随机访问元素,则应该使用ArrayList

**[例14-4]**ArrayList的使用

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

**说明**

第15行定义的`output()`方法用来输出ArrayList的数据项内容,该方法参数限制必须是Number范围内的ArratList数据对象,第4行和第9行分别创建了整数类型和双精度类型的两个ArrayList并进行了测试

**注意**

给ArrayList加入的数据类型通常要与参数类型一致,但如果能进行转换赋值也可,程序中直接将整数23加入ArrayList<Integer>,Java会自动将基本类型数据包装转换为其包装类的对象,也就是将23包装转换为Integer类型的对象

**[例14-5]**ArrayList和LinkedLink的使用测试

```java
import java.util.*;
public class ArrayList和LinkedList的使用测试 {
 static long timeList(List<Integer> st){
     long start = System.currentTimeMillis();//开始时间
     for (int i =0;i<5000;i++)
         st.add(0,new Integer(i));
     return System.currentTimeMillis()-start;//计算花费时间
 }

 public static void main(String[] args) {
     System.out.println("time for ArrayList= "+
                        timeList(new ArrayList<Integer>()));
     System.out.println("time for LinkedList= "+
                        timeList(new LinkedList<Integer>()));
 }
}

time for ArrayList= 5
time for LinkedList= 3
```

**说明**

第6行使用List对象的`add(int Object)`方法加入对象到List内指定位置,测试可知,ArrayList所花费时间远高于LinkedList,原因是每次加入一个元素到ArrayList的开头,先前所有已存在的元素要后移,而加入一个元素到LinkedList的开头,只要创建一个新结点,并调整一对链接关系即可,如果将程序中的`add(0,obj)`修改为`add(obj)`则可发现ArrayList执行更快些,因此在选择数据结构时要考虑相应问题的操作特点

## Vertor类和Stack类

向量(Vector)是List接口中的另一个子类,Vector非常类似ArrayList,早期的程序中使用较多,现在通常用ArrayList代替,两者一个重要的差异是,Vector是线程同步的,线程在更改向量的过程中将对资源加锁,而ArrayList不存在此问题,Vector也是实现了可变大小的对象数组,在容量不够时会自动增加,以下构造方法规定了向量的初始容量及容量不够时的扩展容量

```java
public Vector<E>(int initCapacity, int capacityIncrement);
```

无参构造方法规定的初始容量为10,增量为10

用`size()`方法可获取向量的大小,而`capacity()`方法则用来获取向量的容量

**[例14-6]**测试向量的大小及容量变化

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

除了支持List接口中定义的方法外,向量还有从早期JDK保留下来的一些方法,例如:

- `void addElement(E elem)`:在向量的尾部添加元素
- `void insertElementAt(E obj,int index)`:在指定位置添加元素
- `E elementAt(int index)`:获取指定位置元素
- `void setElementAt(int index)`:设置index处元素为obj
- `boolean removeElement(E obj)`:删除首个与obj相同元素
- `void removeElementAt(int index)`:删除index指定位置的元素
- `void removeAllElements()`:清除向量序列所有元素
- `void clear()`:清除向量序列所有元素

堆栈(Stack)是一种特殊的数据结构,其特点是后进先出,也就是新进栈的元素总在栈顶,而出栈时总是先取栈顶元素,堆栈常用操作是进栈和出栈,使用堆栈对象的`push()`方法可将一个对象压进栈中,而用`pop()`方法将弹出栈顶元素作为返回值,另外还有一个`peek()`方法可获取栈顶元素但不从栈中删除它,`empty()`方法可判断栈是否为空

