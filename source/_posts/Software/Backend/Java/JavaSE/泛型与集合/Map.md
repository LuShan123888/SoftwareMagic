---
title: Java Map
categories:
- Software
- Backend
- Java
- JavaSE
- 泛型与集合
---
# Java Map

- 除了Collection接口表示的这种单一对象数据集合,对于**关键字=值**表示的数据集合在CollectionAPI中提供了Map接口
- 在 Map 中它保证了 key 与 value 之间的一一对应关系。也就是说一个 key 对应一个 value，所以它不能存在相同的 key 值，当然 value 值可以相同
- Map接口及其子接口的实现层次如下图所示,其中,`K`为关键字对象的数据类型,而`V`类映射值对象的数据类型

![](https://www.plantuml.com/plantuml/svg/XPBVIiCm58Vl-nGHBmP5cgxRiCeOqs4PE6MuwNriZsrOcfGafQZu2leGuWDuxVEehs6QJQqRQYy2vvVqEr_-39KcKkUK9pafd1RQeZncPG98Pv23LvGvQwQPreNQnrYIoakfpihBKe6C1TV0jHUB74_AMKPuE-Y4OOWZoa3Xd2WD4ayPuVhyP88RwBxIrmm63XS6VkiWyqr9ab2UehPlonCYKyfHQ8j34YzIAKgUZ0GJ4bKPrM1dnaBI6wD1s06ZAS-D3ehD0D9Edot_aHmaQlTiDA4SbfHjVnHsZoAR6lb4LBQ_S-T88VJfjzeFbo_Fm9Oj2vpLsq6Xvw-tYABERjV_PnDDoz2qTnYGgz_wD-6ZlQWNR202V_r03P98AQeLh-dS_UDGwdIUqNZ1GIaKU3MeZrTNvngjed-ySp5uktzwVNXqN1UDYSe-q_VdbpgQ2QaXsLZgeha4QAuTWdcBo_Vu0G00)

- Map是包括了关键字,值以及它们的映射关系的集合,可分别使用如下方法得到
  - `public Set<K> keySet()`:关键字的集合
  - `public Collection<V> values()`:值的集合
  - `public Set<Map.Entry<K,V>> entrySet()`:
- Map中还定义了对Map数据集合的操作方法,如下所示:
  - `public void clear()`:清空整个数据集合
  - `public V get(K key)`:根据关键字得到对应值
  - `public V put(K key,V value)`:加入新的"关键字-值”,如果该映射关系在map中已存在,则修改映射的值,返回原来的值,如果该映射关系在map中不存在,则返回null
  - `public V remove(Object key)`:删除Map中关键字所对应的映射关系,返回结果同`put()`方法
  - `public boolean equals(Object obj)`:判断Map对象与参数对象是否等价 ,两个 Map相等,当且仅当其`entrySet()`得到的集合是一致的
  - `public boolean containsKey(Object key)`:判断在Map中是否存在与键值匹配的映射关系
  - `public boolean contains Values(Object value)`:判断在Map中是否存在与键值匹配的映射关系

- 实现Map接口的类有很多,其中最常用的有HashMap和Hashtable,两者使用上的最大差别是,Hashtable是线程访问安全的,而HashMap需要提供外同步,Hashtable还有个子类Properties,其关键字和值只能是String类型,经常被用来存储和访问配置信息

## HashMap

- HashMap以哈希表数据结构实现，查找对象时通过哈希函数计算其位置，它是为快速查询而设计的，其内部定义了一个 hash 表数组`Entry[] table`，元素会通过哈希转换函数将元素的哈希地址转换成数组中存放的索引，如果有冲突，则使用散列链表的形式将所有相同哈希地址的元素串起来，可以通过查看`HashMap.Entry`的源码它是一个单链表结构。
- HashMap 是线程不安全的，不是同步的

```java
public class Map接口的使用 {
  public static void main(String[] args) {
    Map<String,String> m = new HashMap<String, String>();
    m.put("张三","2003011");
    m.put("李四","2003012");
    m.put("王五","2003013");
    m.put("张三","2003001");//添加一个已有相同关键字的元素时将修改元素的键值
    Set<String> keys = m.keySet();//通过Map对象的keySet()方法得到关键字的集合
    for (Iterator<String> i = keys.iterator();i.hasNext();){
      System.out.print(i.next()+",");
    }
    System.out.println(m.values());
  }
}

李四,张三,王五
  [2003012, 2003001, 2003013]
```

## 	LinkedHashMap

- LinkedHashMap 是 HashMap 的一个子类，它保留插入的顺序，如果需要输出的顺序和输入时的相同，那么就选用 LinkedHashMap
- **LinkedHashMap 是 Map 接口的哈希表和链接列表实现，具有可预知的迭代顺序。**此实现提供所有可选的映射操作，并允许使用 null 值和 null 键。此类不保证映射的顺序，特别是它不保证该顺序恒久不变。
- LinkedHashMap 实现与 HashMap 的不同之处在于，前者维护着一个运行于所有条目的双重链接列表。此链接列表定义了迭代顺序，该迭代顺序可以是插入顺序或者是访问顺序。
- 根据链表中元素的顺序可以分为：按插入顺序的链表，和按访问顺序 (调用 get 方法) 的链表。默认是按插入顺序排序，如果指定按访问顺序排序，那么调用 get 方法后，会将这次访问的元素移至链表尾部，不断访问可以形成按访问顺序排序的链表。

> **注意**:
>
> - 此实现不是同步的。如果多个线程同时访问链接的哈希映射，而其中至少一个线程从结构上修改了该映射，则它必须保持外部同步。
> - 由于 LinkedHashMap 需要维护元素的插入顺序，因此性能略低于 HashMap 的性能，但在迭代访问 Map 里的全部元素时将有很好的性能，因为它以链表来维护内部顺序。

```java
public class Map接口的使用 {
  public static void main(String[] args) {
    Map<String,String> m = new LinkedHashMap<String, String>();
    m.put("张三","2003011");
    m.put("李四","2003012");
    m.put("王五","2003013");
    Set<String> keys = m.keySet(); 
    for (Iterator<String> i = keys.iterator();i.hasNext();)
      System.out.print(i.next()+",");
    System.out.println(m.values());
  }
}

张三,李四,王五
  [2003012, 2003001, 2003013]
```

## Hashtable

- Hashtable是原始的java.util的一部分， 是一个Dictionary具体的实现 。然而，Java 2 重构的Hashtable实现了Map接口，因此，Hashtable现在集成到了集合框架中。它和HashMap类很相似，但是它支持同步。
- 像HashMap一样，Hashtable在哈希表中存储键/值对。当使用一个哈希表，要指定用作键的对象，以及要链接到该键的值。然后，该键经过哈希处理，所得到的散列码被用作存储在该表中值的索引。但是HashTable 的 key、value 都不可为 null 。

> **Hashtable定义了四个构造方法**
>
> - 默认构造方法
>
> ```java
> Hashtable()
> ```
>
> - 创建指定大小的哈希表
>
> ```java
> Hashtable(int size)
> ```
>
> - 创建一个指定大小的哈希表，并且通过fillRatio指定填充比例
>
> ```java
> Hashtable(int size,float fillRatio)
> ```
>
> - 填充比例必须介于0.0和1.0之间，它决定了哈希表在重新调整大小之前的充满程度
>
> - 创建一个以M中元素为初始化元素的哈希表
>
> ```java
> Hashtable(Map m)
> ```
>
> - 哈希表的容量被设置为M的两倍。

- Hashtable中除了从Map接口中定义的方法外，还定义了以下方法：

| **序号** | **方法描述**                                                 |
| :------- | :----------------------------------------------------------- |
| 1        | **void clear( )**  将此哈希表清空，使其不包含任何键。        |
| 2        | **Object clone( )** 创建此哈希表的浅表副本。                 |
| 3        | **boolean contains(Object value)**  测试此映射表中是否存在与指定值关联的键。 |
| 4        | **boolean containsKey(Object key)** 测试指定对象是否为此哈希表中的键。 |
| 5        | **boolean containsValue(Object value)** 如果此 Hashtable 将一个或多个键映射到此值，则返回 true。 |
| 6        | **Enumeration elements( )** 返回此哈希表中的值的枚举。       |
| 7        | **Object get(Object key)**  返回指定键所映射到的值，如果此映射不包含此键的映射，则返回 null. 更确切地讲，如果此映射包含满足 (key.equals(k)) 的从键 k 到值 v 的映射，则此方法返回 v；否则，返回 null。 |
| 8        | **boolean isEmpty( )** 测试此哈希表是否没有键映射到值。      |
| 9        | **Enumeration keys( )**  返回此哈希表中的键的枚举。          |
| 10       | **Object put(Object key, Object value)** 将指定 key 映射到此哈希表中的指定 value。 |
| 11       | **void rehash( )** 增加此哈希表的容量并在内部对其进行重组，以便更有效地容纳和访问其元素。 |
| 12       | **Object remove(Object key)** 从哈希表中移除该键及其相应的值。 |
| 13       | **int size( )**  返回此哈希表中的键的数量。                  |
| 14       | **String toString( )** 返回此 Hashtable 对象的字符串表示形式，其形式为 ASCII 字符 ", " （逗号加空格）分隔开的、括在括号中的一组条目。 |

**实例**

```java
import java.util.*;

public class HashTableDemo {

  public static void main(String args[]) {
    // Create a hash map
    Hashtable balance = new Hashtable();
    Enumeration names;
    String str;
    double bal;

    balance.put("Zara", new Double(3434.34));
    balance.put("Mahnaz", new Double(123.22));
    balance.put("Ayan", new Double(1378.00));
    balance.put("Daisy", new Double(99.22));
    balance.put("Qadir", new Double(-19.08));

    // Show all balances in hash table.
    names = balance.keys();
    while(names.hasMoreElements()) {
      str = (String) names.nextElement();
      System.out.println(str + ": " +
                         balance.get(str));
    }
    System.out.println();
    // Deposit 1,000 into Zara's account
    bal = ((Double)balance.get("Zara")).doubleValue();
    balance.put("Zara", new Double(bal+1000));
    System.out.println("Zara's new balance: " +
                       balance.get("Zara"));
  }
}
```

- 以上实例编译运行结果如下：

```
Qadir: -19.08
Zara: 3434.34
Mahnaz: 123.22
Daisy: 99.22
Ayan: 1378.0

Zara's new balance: 4434.34
```

## TreeMap

- TreeMap 是一个有序的 key-value 集合，非同步，基于红黑树（Red-Black tree）实现，每一个 key-value 节点作为红黑树的一个节点。
- 放入TreeMap的元素，必须实现`Comparable`接口,如果没有实现`Comparable`接口,则必须在创建 TreeMap 时传入自定义的 `Comparator`对象，TreeMap 会自动对元素的进行排序
- TreeMap 中判断相等的标准是：两个 key 通过`equals()`方法返回为 true，并且通过`compare()`方法比较应该返回为 0。
- 要严格按照`compare()`规范实现比较逻辑，否则，`TreeMap`将不能正常工作。如果使用自定义的类来作为 TreeMap 中的 key 值，且想让 TreeMap 能够良好的工作，则必须重写自定义类中的`equals()`方法

**实例**:定义了`Student`类，并用分数`score`进行排序，高分在前

```java
public class Main {
  public static void main(String[] args) {
    Map<Student, Integer> map = new TreeMap<>(new Comparator<Student>() {
      public int compare(Student p1, Student p2) {
        return p1.score > p2.score ? -1 : 1;
      }
    });
    map.put(new Student("Tom", 77), 1);
    map.put(new Student("Bob", 66), 2);
    map.put(new Student("Lily", 99), 3);
    for (Student key : map.keySet()) {
      System.out.println(key);
    }
    System.out.println(map.get(new Student("Bob", 66))); // null?
  }
}

class Student {
  public String name;
  public int score;
  Student(String name, int score) {
    this.name = name;
    this.score = score;
  }
  public String toString() {
    return String.format("{%s: score=%d}", name, score);
  }
}
```

- 在`for`循环中，我们确实得到了正确的顺序。但是根据相同的Key：`new Student("Bob", 66)`进行查找时，结果为`null`
- 在这个例子中，`TreeMap`出现问题，原因其实出在这个`Comparator`上：

```java
public int compare(Student p1, Student p2) {
    return p1.score > p2.score ? -1 : 1;
}
```

- 在`p1.score`和`p2.score`不相等的时候，它的返回值是正确的，但是，在`p1.score`和`p2.score`相等的时候，它并没有返回`0`,这就是为什么`TreeMap`工作不正常的原因：`TreeMap`在比较两个Key是否相等时，依赖Key的`compareTo()`方法或者`Comparator.compare()`方法。在两个Key相等时，必须返回`0`。因此，修改代码如下：

```java
public int compare(Student p1, Student p2) {
  if (p1.score == p2.score) {
    return 0;
  }
  return p1.score > p2.score ? -1 : 1;
}
```

- 或者直接借助`Integer.compare(int, int)`也可以返回正确的比较结果。

## EnumMap

- 如果Map作为key的对象是`enum`类型，那么，还可以使用Java集合库提供的一种`EnumMap`，它在内部以一个非常紧凑的数组存储value，并且根据`enum`类型的key直接定位到内部数组的索引，并不需要计算`hashCode()`，不但效率最高，而且没有额外的空间浪费。
- 我们以`DayOfWeek`这个枚举类型为例，为它做一个“翻译”功能：

```java
public class Main {
  public static void main(String[] args) {
    Map<DayOfWeek, String> map = new EnumMap<>(DayOfWeek.class);
    map.put(DayOfWeek.MONDAY, "星期一");
    map.put(DayOfWeek.TUESDAY, "星期二");
    map.put(DayOfWeek.WEDNESDAY, "星期三");
    map.put(DayOfWeek.THURSDAY, "星期四");
    map.put(DayOfWeek.FRIDAY, "星期五");
    map.put(DayOfWeek.SATURDAY, "星期六");
    map.put(DayOfWeek.SUNDAY, "星期日");
    System.out.println(map);
    System.out.println(map.get(DayOfWeek.MONDAY));
  }
}

```

- 使用`EnumMap`的时候，总是用`Map`接口来引用它，因此，实际上把`HashMap`和`EnumMap`互换，在客户端看来没有任何区别。

## Properties

- Java集合库提供了一个`Properties`来表示一组“配置”。由于历史遗留原因，`Properties`内部本质上是一个`Hashtable`，但我们只需要用到`Properties`自身关于读写配置的接口。

### 读取配置文件

- 用`Properties`读取配置文件非常简单。Java默认配置文件以`.properties`为扩展名，每行以`key=value`表示，以`#`课开头的是注释。以下是一个典型的配置文件：

```properties
# setting.properties

last_open_file=/data/hello.txt
auto_save_interval=60
```

- 可以从文件系统读取这个`.properties`文件：

```java
String f = "setting.properties";
Properties props = new Properties();
props.load(new java.io.FileInputStream(f));

String filepath = props.getProperty("last_open_file");
String interval = props.getProperty("auto_save_interval", "120");
```

- 可见，用`Properties`读取配置文件，一共有三步：
  - 创建`Properties`实例；
  - 调用`load()`读取文件；
  - 调用`getProperty()`获取配置。
- 调用`getProperty()`获取配置时，如果key不存在，将返回`null`。我们还可以提供一个默认值，这样，当key不存在的时候，就返回默认值。
- 也可以从classpath读取`.properties`文件，因为`load(InputStream)`方法接收一个`InputStream`实例，表示一个字节流，它不一定是文件流，也可以是从jar包中读取的资源流：

```java
Properties props = new Properties();
props.load(getClass().getResourceAsStream("/common/setting.properties"));
```

- 如果有多个`.properties`文件，可以反复调用`load()`读取，后读取的key-value会覆盖已读取的key-value：

```java
Properties props = new Properties();
props.load(getClass().getResourceAsStream("/common/setting.properties"));
props.load(new FileInputStream("C:\\conf\\setting.properties"));
```

- 上面的代码演示了`Properties`的一个常用用法：可以把默认配置文件放到classpath中，然后，根据机器的环境编写另一个配置文件，覆盖某些默认的配置。
- **注意**:`Properties`设计的目的是存储`String`类型的key－value，但`Properties`实际上是从`Hashtable`派生的，它的设计实际上是有问题的，但是为了保持兼容性，现在已经没法修改了。除了`getProperty()`和`setProperty()`方法外，还有从`Hashtable`继承下来的`get()`和`put()`方法，这些方法的参数签名是`Object`，我们在使用`Properties`的时候，不要去调用这些从`Hashtable`继承下来的方法。

### 写入配置文件

- 如果通过`setProperty()`修改了`Properties`实例，可以把配置写入文件，以便下次启动时获得最新配置。写入配置文件使用`store()`方法：

```java
Properties props = new Properties();
props.setProperty("url", "http://www.liaoxuefeng.com");
props.setProperty("language", "Java");
props.store(new FileOutputStream("C:\\conf\\setting.properties"), "这是写入的properties注释");
```

### 编码

- 早期版本的Java规定`.properties`文件编码是ASCII编码（ISO8859-1），如果涉及到中文就必须用`name=\u4e2d\u6587`来表示，从JDK9开始，Java的`.properties`文件可以使用UTF-8编码了。
- 不过，需要注意的是，由于`load(InputStream)`默认总是以ASCII编码读取字节流，所以会导致读到乱码。我们需要用另一个重载方法`load(Reader)`读取：

```java
Properties props = new Properties();
props.load(new FileReader("settings.properties", StandardCharsets.UTF_8));
```

- `InputStream`和`Reader`的区别是一个是字节流，一个是字符流。字符流在内存中已经以`char`类型表示了，不涉及编码问题。

## 重写 equals 和 hashCode

正确使用`Map`必须保证：

1. 作为`key`的对象必须正确覆写`equals()`方法，相等的两个`key`实例调用`equals()`必须返回`true`
2. 作为`key`的对象还必须正确覆写`hashCode()`方法，因为通过`key`计算索引的方式就是调用`key`对象的`hashCode()`方法，它返回一个`int`整数。`HashMap`正是通过这个方法直接定位`key`对应的`value`的索引，继而直接返回`value`,
3. 且`hashCode()`方法要严格遵循以下规范：
   - 如果两个对象相等，则两个对象的`hashCode()`必须相等
   - 如果两个对象不相等，则两个对象的`hashCode()`尽量不要相等。
4. 即对应两个实例`a`和`b`：
   - 如果`a`和`b`相等，那么`a.equals(b)`一定为`true`，则`a.hashCode()`必须等于`b.hashCode()`；
   - 如果`a`和`b`不相等，那么`a.equals(b)`一定为`false`，则`a.hashCode()`和`b.hashCode()`尽量不要相等。

**注意**:

- 上述第一条规范是正确性，必须保证实现，否则`HashMap`不能正常工作。
- 而第二条如果尽量满足，则可以保证查询效率，因为不同的对象，如果返回相同的`hashCode()`，会造成`Map`内部存储冲突，使存取的效率下降。

**实例**:以`Person`类为例：

```java
public class Person {
    String firstName;
    String lastName;
    int age;
}
```

- 把需要比较的字段找出来,然后，引用类型使用`Objects.equals()`比较，基本类型使用`==`比较。
- 在正确实现`equals()`的基础上，我们还需要正确实现`hashCode()`，即上述3个字段分别相同的实例，`hashCode()`返回的`int`必须相同：

```java
public class Person {
  String firstName;
  String lastName;
  int age;

  @Override
  int hashCode() {
    int h = 0;
    h = 31 * h + firstName.hashCode();
    h = 31 * h + lastName.hashCode();
    h = 31 * h + age;
    return h;
  }

  @Override
  public boolean equals(Object obj) {
    if (obj instanceof Person) {
      Person p = (Person) obj;
      return this.firstName == p.firstName && this.lastName == p.lastName && this.age == p.age;
    }
    return false;
  }
}
```

- String类已经正确实现了`hashCode()`方法，我们在计算``Person``的`hashCode()`时，反复使用`31*h`，这样做的目的是为了尽量把不同的Person实例的`hashCode()`均匀分布到整个`int`范围。
- 和实现`equals()`方法遇到的问题类似，如果firstName或lastName为`null`，上述代码工作起来就会抛`NullPointerException`。为了解决这个问题，我们在计算`hashCode()`的时候，经常借助`Objects.hash()`来计算：

```java
int hashCode() {
  return Objects.hash(firstName, lastName, age);
}
```

- 编写`equals()`和`hashCode()`遵循的原则是：`equals()`用到的用于比较的每一个字段，都必须在`hashCode()`中用于计算；`equals()`中没有使用到的字段，绝不可放在`hashCode()`中计算。
- 另外注意，对于放入`HashMap`的`value`对象，没有任何要求。

## HashMap、Hashtable、LinkedHashMap 和 TreeMap 比较

- Hashmap 是一个最常用的 Map，它根据键的 HashCode 值存储数据，根据键可以直接获取它的值，具有很快的访问速度。遍历时，取得数据的顺序是完全随机的。**HashMap 最多只允许一条记录的键为 Null；允许多条记录的值为 Null；HashMap 不支持线程的同步，即任一时刻可以有多个线程同时写 HashMap；可能会导致数据的不一致。**如果需要同步，可以用 Collections 的 synchronizedMap 方法使 HashMap 具有同步的能力。
- Hashtable 与 HashMap 类似，不同的是：**它不允许记录的键或者值为空；它支持线程的同步**，即任一时刻只有一个线程能写 Hashtable，因此也导致了 Hashtale 在写入时会比较慢。
- LinkedHashMap 是 HashMap 的一个子类，如果需要输出的顺序和输入的相同，那么用 LinkedHashMap 可以实现，它还可以按读取顺序来排列，像连接池中可以应用。
  - LinkedHashMap 保存了记录的插入顺序，在用 Iterator 遍历 LinkedHashMap 时，先得到的记录肯定是先插入的，也可以在构造时用带参数，按照应用次数排序。在遍历的时候会比 HashMap 慢，不过有种情况例外，**当 HashMap 容量很大，实际数据较少时，遍历起来可能会比 LinkedHashMap 慢，因为 LinkedHashMap 的遍历速度只和实际数据有关，和容量无关，而 HashMap 的遍历速度和他的容量有关。**
  - **LinkedHashMap 实现与 HashMap 的不同之处在于，后者维护着一个运行于所有条目的双重链表**。此链接列表定义了迭代顺序，该迭代顺序可以是插入顺序或者是访问顺序。对于 LinkedHashMap 而言，它继承与 HashMap、底层使用哈希表与双向链表来保存所有元素。其基本操作与父类 HashMap 相似，它通过重写父类相关的方法，来实现自己的链接列表特性。
- **TreeMap 实现 SortMap 接口，内部实现是红黑树。**能够把它保存的记录根据键排序，默认是按键值的升序排序，也可以指定排序的比较器，当用 Iterator 遍历 TreeMap 时，得到的记录是排过序的。TreeMap 不允许 key 的值为 null。非同步的。
  - TreeMap 取出来的是排序后的键值对。但如果您要按自然顺序或自定义顺序遍历键，那么 TreeMap 会更好。