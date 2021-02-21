---
title: Java Map
categories:
- Software
- Backend
- Java
- JavaSE
- 泛型与Collections
---
# Java Map

除了Collection接口表示的这种单一对象数据集合,对于"关键字=值”表示的数据集合在CollectionAPI中提供了Map接口,Map接口及其子接口的实现层次如下图所示,其中,K为关键字对象的数据类型,而V类映射值对象的数据类型

![](https://www.plantuml.com/plantuml/svg/XPBVIiCm58Vl-nGHBmP5cgxRiCeOqs4PE6MuwNriZsrOcfGafQZu2leGuWDuxVEehs6QJQqRQYy2vvVqEr_-39KcKkUK9pafd1RQeZncPG98Pv23LvGvQwQPreNQnrYIoakfpihBKe6C1TV0jHUB74_AMKPuE-Y4OOWZoa3Xd2WD4ayPuVhyP88RwBxIrmm63XS6VkiWyqr9ab2UehPlonCYKyfHQ8j34YzIAKgUZ0GJ4bKPrM1dnaBI6wD1s06ZAS-D3ehD0D9Edot_aHmaQlTiDA4SbfHjVnHsZoAR6lb4LBQ_S-T88VJfjzeFbo_Fm9Oj2vpLsq6Xvw-tYABERjV_PnDDoz2qTnYGgz_wD-6ZlQWNR202V_r03P98AQeLh-dS_UDGwdIUqNZ1GIaKU3MeZrTNvngjed-ySp5uktzwVNXqN1UDYSe-q_VdbpgQ2QaXsLZgeha4QAuTWdcBo_Vu0G00)

Map是包括了关键字,值以及它们的映射关系的集合,可分别使用如下方法得到

- `public Set<K> keySet()`:关键字的集合
- `public Collection<V> values()`:值的集合
- `public Set<Map.Entry<K,V>> entrySet()`:

Map中还定义了对Map数据集合的操作方法,如下所示:

- `public void clear()`:清空整个数据集合
- `public V get(K key)`:根据关键字得到对应值
- `public V put(K key,V value)`:加入新的"关键字-值”,如果该映射关系在map中已存在,则修改映射的值,返回原来的值,如果该映射关系在map中不存在,则返回null
- `public V remove(Object key)`:删除Map中关键字所对应的映射关系,返回结果同`put()`方法
- `public boolean equals(Object obj)`:判断Map对象与参数对象是否等价 ,两个 Map相等,当且仅当其`entrySet()`得到的集合是一致的
- `public boolean containsKey(Object key)`:判断在Map中是否存在与键值匹配的映射关系
- `public boolean contains Values(Object value)`:判断在Map中是否存在与键值匹配的映射关系

实现Map接口的类有很多,其中最常用的有HashMap和Hashtable,两者使用上的最大差别是,Hashtable是线程访问安全的,而HashMap需要提供外同步,Hashtable还有个子类Properties,其关键字和值只能是String类型,经常被用来存储和访问配置信息

**[例14-8]**Map接口的使用

```java
import java.util.*;
public class Map接口的使用 {
    public static void main(String[] args) {
        Map<String,String> m = new HashMap<String, String>();
        m.put("张三","2003011");
        m.put("李四","2003012");
        m.put("王五","2003013");
        m.put("张三","2003001");
        Set<String> keys = m.keySet();
        for (Iterator<String> i = keys.iterator();i.hasNext();)
            System.out.print(i.next()+",");
        System.out.println(m.get("李四"));
        System.out.println(m.values());
    }
}

李四,张三,王五,2003012
[2003012, 2003001, 2003013]
```

**说明**:8行添加一个已有相同关键字的元素时将修改元素的键值,从第13行的输出结果可以看出其变化,第9行通过Map对象的`keySet()`方法得到关键字的集合,第10,~11行用for循环输出该集合所有元素,第12行输出Map中关键词"李四”对应的键值