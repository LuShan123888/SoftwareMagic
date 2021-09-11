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

- Java为数据结构中的映射定义了一个接口java.util.Map,此接口主要有四个常用的实现类,分别是HashMap,Hashtable,LinkedHashMap和TreeMap,类继承关系如下图所示

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-04-22-835.png)

-  **HashMap**:它根据键的hashCode值存储数据,大多数情况下可以直接定位到它的值,因而具有很快的访问速度,但遍历顺序却是不确定的,HashMap最多只允许一条记录的键为null,允许多条记录的值为null,HashMap非线程安全,即任一时刻可以有多个线程同时写HashMap,可能会导致数据的不一致,如果需要满足线程安全,可以用 Collections的synchronizedMap方法使HashMap具有线程安全的能力,或者使用ConcurrentHashMap
-  **Hashtable**:Hashtable是遗留类,很多映射的常用功能与HashMap类似,不同的是它承自Dictionary类,并且是线程安全的,任一时间只有一个线程能写Hashtable,并发性不如ConcurrentHashMap,因为ConcurrentHashMap引入了分段锁,Hashtable不建议在新代码中使用,不需要线程安全的场合可以用HashMap替换,需要线程安全的场合可以用ConcurrentHashMap替换
-  **LinkedHashMap**:LinkedHashMap是HashMap的一个子类,保存了记录的插入顺序,在用Iterator遍历LinkedHashMap时,先得到的记录肯定是先插入的,也可以在构造时带参数,按照访问次序排序
-  **TreeMap**:TreeMap实现SortedMap接口,能够把它保存的记录根据键排序,默认是按键值的升序排序,也可以指定排序的比较器,当用Iterator遍历TreeMap时,得到的记录是排过序的,如果使用排序的映射,建议使用TreeMap,在使用TreeMap时,key必须实现Comparable接口或者在构造TreeMap传入自定义的Comparator,否则会在运行时抛出java.lang.ClassCastException类型的异常
-  **Properties**:Hashtable还有个子类Properties,其关键字和值只能是String类型,经常被用来存储和访问配置信息

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

## HashMap

- HashMap以Hash表数据结构实现,查找对象时通过Hash函数计算其位置,它是为快速查询而设计的,其内部定义了一个 Hash表数组`Entry[] table`,元素会通过Hash函数将元素的Hash值转换成数组中存放的索引,如果有冲突,则使用链表的形式将所有相同Hash值的元素串起来,可以通过查看`HashMap.Entry`的源码它是一个单链表结构
- HashMap 是线程不安全的,不是同步的

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

- LinkedHashMap 是 HashMap 的一个子类,它保留插入的顺序,如果需要输出的顺序和输入时的相同,那么就选用 LinkedHashMap
- **LinkedHashMap 是 Map 接口的Hash表和链接列表实现,具有可预知的迭代顺序,**此实现提供所有可选的映射操作,并允许使用 null 值和 null 键,此类不保证映射的顺序,特别是它不保证该顺序不变
- LinkedHashMap 实现与 HashMap 的不同之处在于,前者维护着一个运行于所有条目的双重链接列表,此链接列表定义了迭代顺序,该迭代顺序可以是插入顺序或者是访问顺序
- 根据链表中元素的顺序可以分为:按插入顺序的链表,和按访问顺序 (调用 get 方法) 的链表,默认是按插入顺序排序,如果是访问顺序,那put和get操作已存在的Entry时,都会把Entry移动到双向链表的表尾(其实是先删除再插入)

> **注意**:
>
> - 此实现不是同步的,如果多个线程同时访问链接的Hash映射,而其中至少一个线程从结构上修改了该映射,则它必须保持外部同步
> - 由于 LinkedHashMap 需要维护元素的插入顺序,因此性能略低于 HashMap 的性能,但在迭代访问 Map 里的全部元素时将有很好的性能,因为它以链表来维护内部顺序

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

**定义**

- LinkedHashMap继承了HashMap,所以它们有很多相似的地方

```java
public class LinkedHashMap<K,V>  extends HashMap<K,V>  implements Map<K,V>{
}
```

**构造方法**

- LinkedHashMap提供了多个构造方法,我们先看空参的构造方法

```java
public LinkedHashMap() {
  // 调用HashMap的构造方法,其实就是初始化Entry[] table
  super();
  // 这里是指是否基于访问排序,默认为false
  accessOrder = false;
}
```

- 首先使用super调用了父类HashMap的构造方法,其实就是根据初始容量,负载因子去初始化Entry[] table
- 然后把accessOrder设置为false,这就跟存储的顺序有关了,LinkedHashMap存储数据是有序的,而且分为两种:插入顺序和访问顺序
- 这里accessOrder设置为false,表示不是访问顺序而是插入顺序存储的,这也是默认值,表示LinkedHashMap中存储的顺序是按照调用put方法插入的顺序进行排序的,LinkedHashMap也提供了可以设置accessOrder的构造方法,我们来看看这种模式下,它的顺序有什么特点？

```dart
// 第三个参数用于指定accessOrder值
Map<String, String> linkedHashMap = new LinkedHashMap<>(16, 0.75f, true);
linkedHashMap.put("name1", "josan1");
linkedHashMap.put("name2", "josan2");
linkedHashMap.put("name3", "josan3");
System.out.println("开始时顺序:");
Set<Entry<String, String>> set = linkedHashMap.entrySet();
Iterator<Entry<String, String>> iterator = set.iterator();
while(iterator.hasNext()) {
  Entry entry = iterator.next();
  String key = (String) entry.getKey();
  String value = (String) entry.getValue();
  System.out.println("key:" + key + ",value:" + value);
}
System.out.println("通过get方法,导致key为name1对应的Entry到表尾");
linkedHashMap.get("name1");
Set<Entry<String, String>> set2 = linkedHashMap.entrySet();
Iterator<Entry<String, String>> iterator2 = set2.iterator();
while(iterator2.hasNext()) {
  Entry entry = iterator2.next();
  String key = (String) entry.getKey();
  String value = (String) entry.getValue();
  System.out.println("key:" + key + ",value:" + value);
}
```

- 因为调用了get("name1")导致了name1对应的Entry移动到了最后,这里只要知道LinkedHashMap有插入顺序和访问顺序两种就可以,后面会详细讲原理
- 还记得,上一篇HashMap解析中提到,在HashMap的构造函数中,调用了init方法,而在HashMap中init方法是空实现,但LinkedHashMap重写了该方法,所以在LinkedHashMap的构造方法里,调用了自身的init方法,init的重写实现如下:

```dart
/**
     * Called by superclass constructors and pseudoconstructors (clone,
     * readObject) before any entries are inserted into the map.  Initializes
     * the chain.
     */
@Override
void init() {
  // 创建了一个hash=-1,key,value,next都为null的Entry
  header = new Entry<>(-1, null, null, null);
  // 让创建的Entry的before和after都指向自身,注意after不是之前提到的next
  // 其实就是创建了一个只有头部节点的双向链表
  header.before = header.after = header;
}
```

- 这好像跟我们上一篇HashMap提到的Entry有些不一样,HashMap中静态内部类Entry是这样定义的:

```dart
static class Entry<K,V> implements Map.Entry<K,V> {
  final K key;
  V value;
  Entry<K,V> next;
  int hash;
}
```

- 没有before和after属性啊!原来,LinkedHashMap有自己的静态内部类Entry,它继承了HashMap.Entry,定义如下:

```cpp
/**
     * LinkedHashMap entry.
     */
private static class Entry<K,V> extends HashMap.Entry<K,V> {
  // These fields comprise the doubly linked list used for iteration.
  Entry<K,V> before, after;

  Entry(int hash, K key, V value, HashMap.Entry<K,V> next) {
    super(hash, key, value, next);
  }
```

- 所以LinkedHashMap构造函数,主要就是调用HashMap构造函数初始化了一个Entry[] table,然后调用自身的init初始化了一个只有头结点的双向链表,完成了如下操作:

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-04-21-image-20210421222855769.png" alt="image-20210421222855769" style="zoom:50%;" />

### put方法

- LinkedHashMap没有重写put方法,所以还是调用HashMap得到put方法,如下:

```csharp
public V put(K key, V value) {
  // 对key为null的处理
  if (key == null)
    return putForNullKey(value);
  // 计算hash
  int hash = hash(key);
  // 得到在table中的index
  int i = indexFor(hash, table.length);
  // 遍历table[index],是否key已经存在,存在则替换,并返回旧值
  for (Entry<K,V> e = table[i]; e != null; e = e.next) {
    Object k;
    if (e.hash == hash && ((k = e.key) == key || key.equals(k))) {
      V oldValue = e.value;
      e.value = value;
      e.recordAccess(this);
      return oldValue;
    }
  }

  modCount++;
  // 如果key之前在table中不存在,则调用addEntry,LinkedHashMap重写了该方法
  addEntry(hash, key, value, i);
  return null;
}
```

- 我们看看LinkedHashMap的addEntry方法:

```csharp
void addEntry(int hash, K key, V value, int bucketIndex) {
  // 调用父类的addEntry,增加一个Entry到HashMap中
  super.addEntry(hash, key, value, bucketIndex);

  // removeEldestEntry方法默认返回false,不用考虑
  Entry<K,V> eldest = header.after;
  if (removeEldestEntry(eldest)) {
    removeEntryForKey(eldest.key);
  }
}
```

- 这里调用了父类HashMap的addEntry方法,如下:

```csharp
void addEntry(int hash, K key, V value, int bucketIndex) {
  // 扩容相关
  if ((size >= threshold) && (null != table[bucketIndex])) {
    resize(2 * table.length);
    hash = (null != key) ? hash(key) : 0;
    bucketIndex = indexFor(hash, table.length);
  }
  // LinkedHashMap进行了重写
  createEntry(hash, key, value, bucketIndex);
}
```

- 前面是扩容相关的代码,在上一篇HashMap解析中已经讲过了,这里主要看createEntry方法,LinkedHashMap进行了重写

```csharp
void createEntry(int hash, K key, V value, int bucketIndex) {
  HashMap.Entry<K,V> old = table[bucketIndex];
  // e就是新创建了Entry,会加入到table[bucketIndex]的表头
  Entry<K,V> e = new Entry<>(hash, key, value, old);
  table[bucketIndex] = e;
  // 把新创建的Entry,加入到双向链表中
  e.addBefore(header);
  size++;
}
```

- 我们来看看LinkedHashMap.Entry的addBefore方法:

```cpp
        private void addBefore(Entry<K,V> existingEntry) {
            after  = existingEntry;
            before = existingEntry.before;
            before.after = this;
            after.before = this;
        }
```

- 从这里就可以看出,当put元素时,不但要把它加入到HashMap中去,还要加入到双向链表中,所以可以看出LinkedHashMap就是HashMap+双向链表,下面用图来表示逐步往LinkedHashMap中添加数据的过程,红色部分是双向链表,黑色部分是HashMap结构,header是一个Entry类型的双向链表表头,本身不存储数据
- 首先是只加入一个元素Entry1,假设index为0:

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-04-21-image-20210421222936322.png" alt="image-20210421222936322" style="zoom:50%;" />

- 当再加入一个元素Entry2,假设index为15:

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-04-21-image-20210421222956770.png" alt="image-20210421222956770" style="zoom:50%;" />

- 当再加入一个元素Entry3, 假设index也是0:

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-04-21-image-20210421223014204.png" alt="image-20210421223014204" style="zoom:50%;" />

- 以上,就是LinkedHashMap的put的所有过程了,总体来看,跟HashMap的put类似,只不过多了把新增的Entry加入到双向列表中

### 扩容

- 在HashMap的put方法中,如果发现前元素个数超过了扩容阀值时,会调用resize方法,如下:

```java
void resize(int newCapacity) {
  Entry[] oldTable = table;
  int oldCapacity = oldTable.length;
  if (oldCapacity == MAXIMUM_CAPACITY) {
    threshold = Integer.MAX_VALUE;
    return;
  }

  Entry[] newTable = new Entry[newCapacity];
  boolean oldAltHashing = useAltHashing;
  useAltHashing |= sun.misc.VM.isBooted() &&
    (newCapacity >= Holder.ALTERNATIVE_HASHING_THRESHOLD);
  boolean rehash = oldAltHashing ^ useAltHashing;
  // 把旧table的数据迁移到新table
  transfer(newTable, rehash);
  table = newTable;
  threshold = (int)Math.min(newCapacity * loadFactor, MAXIMUM_CAPACITY + 1);
}
```

- LinkedHashMap重写了transfer方法,数据的迁移,它的实现如下:

```java
    void transfer(HashMap.Entry[] newTable, boolean rehash) {
        // 扩容后的容量是之前的2倍
        int newCapacity = newTable.length;
        // 遍历双向链表,把所有双向链表中的Entry,重新计算hash,并加入到新的table中
        for (Entry<K,V> e = header.after; e != header; e = e.after) {
            if (rehash)
                e.hash = (e.key == null) ? 0 : hash(e.key);
            int index = indexFor(e.hash, newCapacity);
            e.next = newTable[index];
            newTable[index] = e;
        }
    }
```

- 可以看出,LinkedHashMap扩容时,数据的再散列和HashMap是不一样的
- HashMap是先遍历旧table,再遍历旧table中每个元素的单向链表,取得Entry以后,重新计算hash值,然后存放到新table的对应位置
- LinkedHashMap是遍历的双向链表,取得每一个Entry,然后重新计算hash值,然后存放到新table的对应位置
- 从遍历的效率来说,遍历双向链表的效率要高于遍历table,因为遍历双向链表是N次(N为元素个数),而遍历table是N+table的空余个数(N为元素个数)

### 双向链表的重排序

- 前面分析的,主要是当前LinkedHashMap中不存在当前key时,新增Entry的情况,当key如果已经存在时,则进行更新Entry的value,就是HashMap的put方法中的如下代码:

```csharp
for (Entry<K,V> e = table[i]; e != null; e = e.next) {
  Object k;
  if (e.hash == hash && ((k = e.key) == key || key.equals(k))) {
    V oldValue = e.value;
    e.value = value;
    // 重排序
    e.recordAccess(this);
    return oldValue;
  }
}
```

- 主要看e.recordAccess(this),这个方法跟访问顺序有关,而HashMap是无序的,所以在HashMap.Entry的recordAccess方法是空实现,但是LinkedHashMap是有序的,LinkedHashMap.Entry对recordAccess方法进行了重写

```csharp
void recordAccess(HashMap<K,V> m) {
  LinkedHashMap<K,V> lm = (LinkedHashMap<K,V>)m;
  // 如果LinkedHashMap的accessOrder为true,则进行重排序
  // 比如前面提到LruCache中使用到的LinkedHashMap的accessOrder属性就为true
  if (lm.accessOrder) {
    lm.modCount++;
    // 把更新的Entry从双向链表中移除
    remove();
    // 再把更新的Entry加入到双向链表的表尾
    addBefore(lm.header);
  }
}
```

- 在LinkedHashMap中,只有accessOrder为true,即是访问顺序模式,才会put时对更新的Entry进行重新排序,而如果是插入顺序模式时,不会重新排序,这里的排序跟在HashMap中存储没有关系,只是指在双向链表中的顺序
- 举个栗子:开始时,HashMap中有Entry1,Entry2,Entry3,并设置LinkedHashMap为访问顺序,则更新Entry1时,会先把Entry1从双向链表中删除,然后再把Entry1加入到双向链表的表尾,而Entry1在HashMap结构中的存储位置没有变化,对比图如下所示:

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-04-21-image-20210421223149619.png" alt="image-20210421223149619" style="zoom:50%;" />

### get方法

- LinkedHashMap有对get方法进行了重写,如下:

```kotlin
public V get(Object key) {
  // 调用genEntry得到Entry
  Entry<K,V> e = (Entry<K,V>)getEntry(key);
  if (e == null)
  return null;
  // 如果LinkedHashMap是访问顺序的,则get时,也需要重新排序
  e.recordAccess(this);
  return e.value;
}
```

- 先是调用了getEntry方法,通过key得到Entry,而LinkedHashMap并没有重写getEntry方法,所以调用的是HashMap的getEntry方法,在上一篇文章中我们分析过HashMap的getEntry方法:首先通过key算出hash值,然后根据hash值算出在table中存储的index,然后遍历table[index]的单向链表去对比key,如果找到了就返回Entry
- 后面调用了LinkedHashMap.Entry的recordAccess方法,上面分析过put过程中这个方法,其实就是在访问顺序的LinkedHashMap进行了get操作以后,重新排序,把get的Entry移动到双向链表的表尾

### 遍历方式取数据

- 我们先来看看HashMap使用遍历方式取数据的过程:

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-04-21-image-20210421223241731.png" alt="image-20210421223241731" style="zoom:50%;" />

- 很明显,这样取出来的Entry顺序肯定跟插入顺序不同了,既然LinkedHashMap是有序的,那么它是怎么实现的呢？
  先看看LinkedHashMap取遍历方式获取数据的代码:

```dart
Map<String, String> linkedHashMap = new LinkedHashMap<>();
linkedHashMap.put("name1", "josan1");
linkedHashMap.put("name2", "josan2");
linkedHashMap.put("name3", "josan3");
// LinkedHashMap没有重写该方法,调用的HashMap中的entrySet方法
Set<Entry<String, String>> set = linkedHashMap.entrySet();
Iterator<Entry<String, String>> iterator = set.iterator();
while(iterator.hasNext()) {
  Entry entry = iterator.next();
  String key = (String) entry.getKey();
  String value = (String) entry.getValue();
  System.out.println("key:" + key + ",value:" + value);
}
```

- LinkedHashMap没有重写entrySet方法,我们先来看HashMap中的entrySet,如下:

```dart
public Set<Map.Entry<K,V>> entrySet() {
  return entrySet0();
}

private Set<Map.Entry<K,V>> entrySet0() {
  Set<Map.Entry<K,V>> es = entrySet;
  return es != null ? es : (entrySet = new EntrySet());
}

private final class EntrySet extends AbstractSet<Map.Entry<K,V>> {
  public Iterator<Map.Entry<K,V>> iterator() {
    return newEntryIterator();
  }
  // 无关代码
  ......
}
```

- 可以看到,HashMap的entrySet方法,其实就是返回了一个EntrySet对象
- 我们得到EntrySet会调用它的iterator方法去得到迭代器Iterator,从上面的代码也可以看到,iterator方法中直接调用了newEntryIterator方法并返回,而LinkedHashMap重写了该方法

```dart
Iterator<Map.Entry<K,V>> newEntryIterator() {
  return new EntryIterator();
}
```

- 这里直接返回了EntryIterator对象,这个和上一篇HashMap中的newEntryIterator方法中一模一样,都是返回了EntryIterator对象,其实他们返回的是各自的内部类,我们来看看LinkedHashMap中EntryIterator的定义:

```java
private class EntryIterator extends LinkedHashIterator<Map.Entry<K,V>> {
  public Map.Entry<K,V> next() {
    return nextEntry();
  }
}
```

- 该类是继承LinkedHashIterator,并重写了next方法,而HashMap中是继承HashIterator
- 我们再来看看LinkedHashIterator的定义:

```java
private abstract class LinkedHashIterator<T> implements Iterator<T> {
  // 默认下一个返回的Entry为双向链表表头的下一个元素
  Entry<K,V> nextEntry    = header.after;
  Entry<K,V> lastReturned = null;

  public boolean hasNext() {
    return nextEntry != header;
  }

  Entry<K,V> nextEntry() {
    if (modCount != expectedModCount)
      throw new ConcurrentModificationException();
    if (nextEntry == header)
      throw new NoSuchElementException();

    Entry<K,V> e = lastReturned = nextEntry;
    nextEntry = e.after;
    return e;
  }
  // 不相关代码
  ......
}
```

- 我们先不看整个类的实现,只要知道在LinkedHashMap中,Iterator<Entry<String, String>> iterator = set.iterator(),这段代码会返回一个继承LinkedHashIterator的Iterator,它有着跟HashIterator不一样的遍历规则
- 接着,我们会用while(iterator.hasNext())去循环判断是否有下一个元素,LinkedHashMap中的EntryIterator没有重写该方法,所以还是调用LinkedHashIterator中的hasNext方法,如下:

```java
public boolean hasNext() {
  // 下一个应该返回的Entry是否就是双向链表的头结点
  // 有两种情况:1.LinkedHashMap中没有元素,2.遍历完双向链表回到头部
  return nextEntry != header;
}
```

- nextEntry表示下一个应该返回的Entry,默认值是header.after,即双向链表表头的下一个元素,而上面介绍到,LinkedHashMap在初始化时,会调用init方法去初始化一个before和after都指向自身的Entry,但是put过程会把新增加的Entry加入到双向链表的表尾,所以只要LinkedHashMap中有元素,第一次调用hasNext肯定不会为false
- 然后我们会调用next方法去取出Entry,LinkedHashMap中的EntryIterator重写了该方法,如下:

```csharp
public Map.Entry<K,V> next() {
  return nextEntry();
}
```

- 而它自身又没有重写nextEntry方法,所以还是调用的LinkedHashIterator中的nextEntry方法:

```csharp
Entry<K,V> nextEntry() {
  // 保存应该返回的Entry
  Entry<K,V> e = lastReturned = nextEntry;
  //把当前应该返回的Entry的after作为下一个应该返回的Entry
  nextEntry = e.after;
  // 返回当前应该返回的Entry
  return e;
}
```

- 这里其实遍历的是双向链表,所以不会存在HashMap中需要寻找下一条单向链表的情况,从头结点Entry header的下一个节点开始,只要把当前返回的Entry的after作为下一个应该返回的节点即可,直到到达双向链表的尾部时,after为双向链表的表头节点Entry header,这时候hasNext就会返回false,表示没有下一个元素了,LinkedHashMap的遍历取值如下图所示:

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-04-21-image-20210421223450436.png" alt="image-20210421223450436" style="zoom:50%;" />

- 易知,遍历出来的结果为Entry1,Entry2...Entry6
- 可得,LinkedHashMap是有序的,且是通过双向链表来保证顺序的

### remove方法

LinkedHashMap没有提供remove方法,所以调用的是HashMap的remove方法,实现如下:

```csharp
public V remove(Object key) {
  Entry<K,V> e = removeEntryForKey(key);
  return (e == null ? null : e.value);
}

final Entry<K,V> removeEntryForKey(Object key) {
  int hash = (key == null) ? 0 : hash(key);
  int i = indexFor(hash, table.length);
  Entry<K,V> prev = table[i];
  Entry<K,V> e = prev;

  while (e != null) {
    Entry<K,V> next = e.next;
    Object k;
    if (e.hash == hash &&
        ((k = e.key) == key || (key != null && key.equals(k)))) {
      modCount++;
      size--;
      if (prev == e)
        table[i] = next;
      else
        prev.next = next;
      // LinkedHashMap.Entry重写了该方法
      e.recordRemoval(this);
      return e;
    }
    prev = e;
    e = next;
  }

  return e;
}
```

- 在上一篇HashMap中就分析了remove过程,其实就是断开其他对象对自己的引用,比如被删除Entry是在单向链表的表头,则让它的next放到表头,这样它就没有被引用了,如果不是在表头,它是被别的Entry的next引用着,这时候就让上一个Entry的next指向它自己的next,这样,它也就没被引用了
- 在HashMap.Entry中recordRemoval方法是空实现,但是LinkedHashMap.Entry对其进行了重写,如下:

```csharp
void recordRemoval(HashMap<K,V> m) {
  remove();
}

private void remove() {
  before.after = after;
  after.before = before;
}
```

- 易知,这是要把双向链表中的Entry删除,也就是要断开当前要被删除的Entry被其他对象通过after和before的方式引用
- 所以,LinkedHashMap的remove操作,首先把它从table中删除,即断开table或者其他对象通过next对其引用,然后也要把它从双向链表中删除,断开其他对应通过after和before对其引用

###  HashMap与LinkedHashMap的结构对比

再来看看HashMap和LinkedHashMap的结构图,是不是秒懂了,LinkedHashMap其实就是可以看成HashMap的基础上,多了一个双向链表来维持顺序

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-04-21-image-20210421223642737.png" alt="image-20210421223642737" style="zoom:50%;" />

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-04-21-image-20210421223700724.png" alt="image-20210421223700724" style="zoom:50%;" />

## Hashtable

- Hashtable是原始的java.util的一部分,是一个Dictionary具体的实现,然而,Java 2 重构的Hashtable实现了Map接口,因此,Hashtable现在集成到了集合框架中,它和HashMap类很相似,但是它支持同步,所有的读写等操作都进行了锁(`synchronized`)保护,在多线程环境下没有安全问题,但是锁保护也是有代价的,会对读写的效率产生较大影响
- 像HashMap一样,Hashtable在Hash表中存储键/值对,当使用一个Hash表,要指定用作键的对象,以及要链接到该键的值,然后,该键经过Hash处理,所得到的Hash值被用作存储在该表中值的索引,但是HashTable 的 key,value 都不可为 null
- HashTable类中,保存实际数据的,依然是`Entry`对象,其数据结构与HashMap是相同的

> **Hashtable定义了四个构造方法**
>
> - 默认构造方法
>
> ```java
> Hashtable()
> ```
>
> - 创建指定大小的Hashtable
>
> ```java
> Hashtable(int size)
> ```
>
> - 创建一个指定大小的Hashtable,并且通过fillRatio指定填充比例
>
> ```java
> Hashtable(int size,float fillRatio)
> ```
>
> - 填充比例必须介于0.0和1.0之间,它决定了Hashtable在重新调整大小之前的充满程度
>
> - 创建一个以M中元素为初始化元素的Hashtable
>
> ```java
> Hashtable(Map m)
> ```
>
> - Hashtable的容量被设置为M的两倍

- Hashtable中除了从Map接口中定义的方法外,还定义了以下方法:

| 序号 | 方法描述                                                     |
| :--- | :----------------------------------------------------------- |
| 1    | **void clear( )**  将此Hashtable清空,使其不包含任何键        |
| 2    | **Object clone( )** 创建此Hashtable的浅表副本                |
| 3    | **boolean contains(Object value)**  测试此Hashtable中是否存在与指定值关联的键 |
| 4    | **boolean containsKey(Object key)** 测试指定对象是否为此Hashtable中的键 |
| 5    | **boolean containsValue(Object value)** 如果此 Hashtable 将一个或多个键映射到此值,则返回 true |
| 6    | **Enumeration elements( )** 返回此Hashtable中的值的枚举      |
| 7    | **Object get(Object key)**  返回指定键所映射到的值,如果此映射不包含此键的映射,则返回 null. 更确切地讲,如果此映射包含满足 (key.equals(k)) 的从键 k 到值 v 的映射,则此方法返回 v,否则,返回 null |
| 8    | **boolean isEmpty( )** 测试此Hashtable是否没有键映射到值     |
| 9    | **Enumeration keys( )**  返回此Hashtable中的键的枚举         |
| 10   | **Object put(Object key, Object value)** 将指定 key 映射到此Hashtable中的指定 value |
| 11   | **void rehash( )** 增加此Hashtable的容量并在内部对其进行重组,以便更有效地容纳和访问其元素 |
| 12   | **Object remove(Object key)** 从Hashtable中移除该键及其相应的值 |
| 13   | **int size( )**  返回此Hashtable中的键的数量                 |
| 14   | **String toString( )** 返回此 Hashtable 对象的字符串表示形式,其形式为 ASCII 字符 ", "(逗号加空格)分隔开的,括在括号中的一组条目 |

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

- 以上实例编译运行结果如下:

```
Qadir: -19.08
Zara: 3434.34
Mahnaz: 123.22
Daisy: 99.22
Ayan: 1378.0

Zara's new balance: 4434.34
```

## TreeMap

- TreeMap 是一个有序的 key-value 集合,非同步,基于红黑树(Red-Black tree)实现,每一个 key-value 节点作为红黑树的一个节点
- 放入TreeMap的元素,必须实现`Comparable`接口,如果没有实现`Comparable`接口,则必须在创建 TreeMap 时传入自定义的 `Comparator`对象,TreeMap 会自动对元素的进行排序
- TreeMap 中判断相等的标准是:两个 key 通过`equals()`方法返回为 true,并且通过`compare()`方法比较应该返回为 0
- 要严格按照`compare()`规范实现比较逻辑,否则,`TreeMap`将不能正常工作,如果使用自定义的类来作为 TreeMap 中的 key 值,且想让 TreeMap 能够良好的工作,则必须重写自定义类中的`equals()`方法

### key排序

- TreeMap默认是升序的,如果我们需要改变排序方式,则需要使用比较器:Comparator,Comparator可以对集合对象或者数组进行排序的比较器接口,实现该接口的public compare(T o1,To2)方法即可实现排序,如下:

```dart
public class TreeMapTest {
    public static void main(String[] args) {
        Map<String, String> map = new TreeMap<String, String>(
            new Comparator<String>() {
                public int compare(String obj1, String obj2) {
                    // 降序排序
                    return obj2.compareTo(obj1);
                }
            });
        map.put("b", "ccccc");
        map.put("d", "aaaaa");
        map.put("c", "bbbbb");
        map.put("a", "ddddd");

        Set<String> keySet = map.keySet();
        Iterator<String> iter = keySet.iterator();
        while (iter.hasNext()) {
            String key = iter.next();
            System.out.println(key + ":" + map.get(key));
        }
    }
}
```

- 运行如下:

```css
d:aaaaa
c:bbbbb
b:ccccc
a:ddddd
```

### value排序

- 上面例子是对根据TreeMap的key值来进行排序的,但是有时我们需要根据TreeMap的value来进行排序,对value排序我们就需要借助于Collections的`sort(List<T> list, Comparator<? super T> c)`方法,该方法根据指定比较器产生的顺序对指定列表进行排序,但是有一个前提条件,那就是所有的元素都必须能够根据所提供的比较器来进行比较,如下:

```dart
public class TreeMapTest {
    public static void main(String[] args) {
        Map<String, String> map = new TreeMap<String, String>();
        map.put("a", "ddddd");
        map.put("c", "bbbbb");
        map.put("d", "aaaaa");
        map.put("b", "ccccc");

        //这里将map.entrySet()转换成list
        List<Map.Entry<String,String>> list = new ArrayList<Map.Entry<String,String>>(map.entrySet());
        //然后通过比较器来实现排序
        Collections.sort(list,new Comparator<Map.Entry<String,String>>() {
            //升序排序
            public int compare(Entry<String, String> o1,
                               Entry<String, String> o2) {
                return o1.getValue().compareTo(o2.getValue());
            }

        });

        for(Map.Entry<String,String> mapping:list){
            System.out.println(mapping.getKey()+":"+mapping.getValue());
        }
    }
}
```

- 运行结果如下:

```css
d:aaaaa
c:bbbbb
b:ccccc
a:ddddd
```

## EnumMap

- 如果Map作为key的对象是`enum`类型,那么,还可以使用Java集合库提供的一种`EnumMap`,它在内部以一个非常紧凑的数组存储value,并且根据`enum`类型的key直接定位到内部数组的索引,并不需要计算`hashCode()`,不但效率最高,而且没有额外的空间浪费
- 我们以`DayOfWeek`这个枚举类型为例,为它做一个"翻译”功能:

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

- 使用`EnumMap`的时候,总是用`Map`接口来引用它,因此,实际上把`HashMap`和`EnumMap`互换,在客户端看来没有任何区别

## Properties

- Java集合库提供了一个`Properties`来表示一组"配置”,由于历史遗留原因,`Properties`内部本质上是一个`Hashtable`,但我们只需要用到`Properties`自身关于读写配置的接口

### 读取配置文件

- 用`Properties`读取配置文件非常简单,Java默认配置文件以`.properties`为扩展名,每行以`key=value`表示,以`#`课开头的是注释,以下是一个典型的配置文件:

```properties
# setting.properties

last_open_file=/data/hello.txt
auto_save_interval=60
```

- 可以从文件系统读取这个`.properties`文件:

```java
String f = "setting.properties";
Properties props = new Properties();
props.load(new java.io.FileInputStream(f));

String filepath = props.getProperty("last_open_file");
String interval = props.getProperty("auto_save_interval", "120");
```

- 可见,用`Properties`读取配置文件,一共有三步:
  - 创建`Properties`实例
  - 调用`load()`读取文件
  - 调用`getProperty()`获取配置
- 调用`getProperty()`获取配置时,如果key不存在,将返回`null`,我们还可以提供一个默认值,这样,当key不存在的时候,就返回默认值
- 也可以从classpath读取`.properties`文件,因为`load(InputStream)`方法接收一个`InputStream`实例,表示一个字节流,它不一定是文件流,也可以是从jar包中读取的资源流:

```java
Properties props = new Properties();
props.load(getClass().getResourceAsStream("/common/setting.properties"));
```

- 如果有多个`.properties`文件,可以反复调用`load()`读取,后读取的key-value会覆盖已读取的key-value:

```java
Properties props = new Properties();
props.load(getClass().getResourceAsStream("/common/setting.properties"));
props.load(new FileInputStream("C:\\conf\\setting.properties"));
```

- 上面的代码演示了`Properties`的一个常用用法:可以把默认配置文件放到classpath中,然后,根据机器的环境编写另一个配置文件,覆盖某些默认的配置
- **注意**:`Properties`设计的目的是存储`String`类型的key－value,但`Properties`实际上是从`Hashtable`派生的,它的设计实际上是有问题的,但是为了保持兼容性,现在已经没法修改了,除了`getProperty()`和`setProperty()`方法外,还有从`Hashtable`继承下来的`get()`和`put()`方法,这些方法的参数签名是`Object`,我们在使用`Properties`的时候,不要去调用这些从`Hashtable`继承下来的方法

### 写入配置文件

- 如果通过`setProperty()`修改了`Properties`实例,可以把配置写入文件,以便下次启动时获得最新配置,写入配置文件使用`store()`方法:

```java
Properties props = new Properties();
props.setProperty("url", "http://www.liaoxuefeng.com");
props.setProperty("language", "Java");
props.store(new FileOutputStream("C:\\conf\\setting.properties"), "这是写入的properties注释");
```

### 编码

- 早期版本的Java规定`.properties`文件编码是ASCII编码(ISO8859-1),如果涉及到中文就必须用`name=\u4e2d\u6587`来表示,从JDK9开始,Java的`.properties`文件可以使用UTF-8编码了
- 不过,需要注意的是,由于`load(InputStream)`默认总是以ASCII编码读取字节流,所以会导致读到乱码,我们需要用另一个重载方法`load(Reader)`读取:

```java
Properties props = new Properties();
props.load(new FileReader("settings.properties", StandardCharsets.UTF_8));
```

- `InputStream`和`Reader`的区别是一个是字节流,一个是字符流,字符流在内存中已经以`char`类型表示了,不涉及编码问题

## 重写 equals 和 hashCode

- 正确使用`Map`必须保证
    1. 作为`key`的对象必须正确覆写`equals()`方法,相等的两个`key`实例调用`equals()`必须返回`true`
    2. 作为`key`的对象还必须正确覆写`hashCode()`方法,因为通过`key`计算索引的方式就是调用`key`对象的`hashCode()`方法,它返回一个`int`整数,`HashMap`正是通过这个方法直接定位`key`对应的`value`的索引,继而直接返回`value`,且`hashCode()`方法要严格遵循以下规范
        - 如果两个对象相等,则两个对象的`hashCode()`必须相等
        - 如果两个对象不相等,则两个对象的`hashCode()`尽量不要相等
- 即对应两个实例`a`和`b`
    1. 如果`a`和`b`相等,那么`a.equals(b)`一定为`true`,则`a.hashCode()`必须等于`b.hashCode()`
    2. 如果`a`和`b`不相等,那么`a.equals(b)`一定为`false`,则`a.hashCode()`和`b.hashCode()`尽量不要相等

**注意**:

- 上述第一条规范是正确性,必须保证实现,否则`HashMap`不能正常工作
- 而第二条如果尽量满足,则可以保证查询效率,因为不同的对象,如果返回相同的`hashCode()`,会造成`Map`内部存储冲突,使存取的效率下降

**实例**:以`Person`类为例:

```java
public class Person {
    String firstName;
    String lastName;
    int age;
}
```

- 把需要比较的字段找出来,然后,引用类型使用`Objects.equals()`比较,基本类型使用`==`比较
- 在正确实现`equals()`的基础上,我们还需要正确实现`hashCode()`,即上述3个字段分别相同的实例,`hashCode()`返回的`int`必须相同:

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

- String类已经正确实现了`hashCode()`方法,我们在计算``Person``的`hashCode()`时,反复使用`31*h`,这样做的目的是为了尽量把不同的Person实例的`hashCode()`均匀分布到整个`int`范围
- 和实现`equals()`方法遇到的问题类似,如果firstName或lastName为`null`,上述代码工作起来就会抛`NullPointerException`,为了解决这个问题,我们在计算`hashCode()`的时候,经常借助`Objects.hash()`来计算:

```java
int hashCode() {
  return Objects.hash(firstName, lastName, age);
}
```

- 编写`equals()`和`hashCode()`遵循的原则是:`equals()`用到的用于比较的每一个字段,都必须在`hashCode()`中用于计算,`equals()`中没有使用到的字段,绝不可放在`hashCode()`中计算
- 另外注意,对于放入`HashMap`的`value`对象,没有任何要求

> **补充**:关于equals和hashCode方法,很多Java程序都知道,但很多人也就是仅仅知道而已,在Joshua Bloch的大作《Effective Java》(很多软件公司,《Effective Java》,《Java编程思想》以及《重构:改善既有代码质量》)中是这样介绍equals方法的:
>
> - 首先equals方法必须满足自反性(x.equals(x)必须返回true),对称性(x.equals(y)返回true时,y.equals(x)也必须返回true),传递性(x.equals(y)和y.equals(z)都返回true时,x.equals(z)也必须返回true)和一致性(当x和y引用的对象信息没有被修改时,多次调用x.equals(y)应该得到同样的返回值),而且对于任何非null值的引用x,x.equals(null)必须返回false
> - 实现高质量的equals方法的诀窍包括:
>   1. 使用==操作符检查"参数是否为这个对象的引用"
>   2. 使用instanceof操作符检查"参数是否为正确的类型"
>   3. 对于类中的关键属性,检查参数传入对象的属性是否与之相匹配
>   4. 编写完equals方法后,问自己它是否满足对称性,传递性,一致性
>   5. 重写equals时总是要重写hashCode
>   6. 不要将equals方法参数中的Object对象替换为其他的类型,在重写时不要忘掉@Override注解

## HashMap/Hashtable/HashSet/LinkedHashMap/TreeMap 比较

- Hashmap 是一个最常用的 Map,它根据键的 HashCode 值存储数据,HashMap 最多只允许一条记录的键为Null,允许多条记录的值为 Null
- Hashtable 与 HashMap 类似,不同的是:它不允许记录的键或者值为空,是线程安全的,因此也导致了 Hashtale 的效率偏低
- LinkedHashMap 是 HashMap 的一个子类,如果需要输出的顺序和输入的相同,那么用 LinkedHashMap 可以实现
- TreeMap 实现 SortMap 接口,内部实现是红黑树,能够把它保存的记录根据键排序,默认是按键值的升序排序,也可以指定排序的比较器,当用 Iterator 遍历 TreeMap 时,得到的记录是排过序的,TreeMap 不允许 key 的值为 null
