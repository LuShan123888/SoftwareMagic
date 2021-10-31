---
title: Java  Collections
categories:
- Software
- Java
- JavaSE
- 泛型与集合
---
# Java  Collections

Java还提供了一个包装类java.util.Collections,它包含有针对Collection(收集)操作的众多静态方法,下面列出常用的若干方法

- `addAll(Collection<? super T> c, T... elements)`:将指定元素添加到指定集合中
- `sort(List<T> list)`:根据元素的自然顺序对指定列表按升序进行排序
- `sort(List<T> list,Comparator<? super T> c)`:根据指定比较器产生的顺序对指定列表进行排序
- `max(Collection<? Extends T> coll)`:根据元素的自然排序,返回给定收集的最大元素
- `max(Collection<? extends T> coll,Comparator<? super T> comp)`:根据指定比较器产生的顺序,返回给定收集的最大元素
- `min(Collection<? extends T>coll)`:根据元素的自然排序,返回给定收集的最小元素
- `min(Collection<? extends T> coll,Comparator<? super T> comp)`:根据指定比较器产生的顺序,返回给定收集的最小元素
- `indexOfSubList(List<?> course,List<?> target)`:返回指定源列表中第一次出现指定目标列表的起始位置,如果没有出现这样的列表,则返回-1
- `lastindexOfSubList(List<?> course,List<?> target)`:返回指定源列表中最后一次出现指定目标列表的起始位置,如果没有出现这样的列表,则返回-1
- `replaceAll(List<T> list,T oldVal,T newVal)`:使用newVal值替换列表中出现的所有oldVal值
- `reverse(List<?> list)`:反转指定列表中元素的顺序
- `fill(List<? super T> list,T obj)`:使用指定元素替换指定列表中的所有元素
- `frequency(Collection<?> c,Object o)`:返回指定收集中等于指定对象的元素数
- `disjoint(Collection<?> c1,Collection<?> c2)`:如果两个指定收集中没有相同的元素,则返回true,否则返回false

**[例14-7]**:列表元素的排序测试

```java
import java.util.*;
public class 列表元素的排序测试 {
    public static void main(String[] args) {
        List<String> mylist = new ArrayList<String>();
        for (char i ='a';i<'g';i++){
            mylist.add(String.valueOf(i));
        }
        Collections.addAll(mylist,"S","12");
        Collections.sort(mylist);
        output(mylist);
        Collections.sort(mylist,new Comparator1());
        output(mylist);
    }

    public static void output(Collection<String> c){
        Iterator<String> it  = c.iterator();
        while (it.hasNext()){
            System.out.print(it.next()+",");
        }
        System.out.println();
    }
}

class Comparator1 implements Comparator<String>{
    public int compare(String s1,String s2){
        s1 = s1.toLowerCase();//字符串全部字符换小写
        s2 = s2.toLowerCase();
        return s1.compareTo(s2);
    }
}

12,S,a,b,c,d,e,f,
12,a,b,c,d,e,f,S,
```

**说明**:第8行调用Collection类的`addAll()`方法给列表mylist添加两个元素,第9行调用Collections类的`sort()`方法对列表进行自然排序,第11行调用Collections类的`sort()`方法按指定比较算子对列表排序,从运行结果可观察到排序结果的变化