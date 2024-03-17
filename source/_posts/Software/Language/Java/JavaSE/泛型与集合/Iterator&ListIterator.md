---
title: Java Iterator & ListLterator
categories:
- Software
- Language
- Java
- JavaSE
- 泛型与集合
---
# Java Iterator & ListLterator

## Iterator

- `Iterator`是一种抽象的数据访问模型，使用`Iterator`模式进行迭代的好处有:
  - 对任何集合都采用同一种访问模型
  - 调用者不用了解集合的内部结构
- Java提供了标准的迭代器模型，即集合类实现`java.util.Iterable`接口，返回`java.util.Iterator`实例
- Iterator接口定义的方法介绍如下:
  - `boolean hasNext()`:判断容器中是否存在下一个可访问元素
  - `Object next()`:返回要访问的下一个元素，如果没有下一个元素，则引发`NoSuchElement Exception`异常
  - `void remove()`:是一个可选操作，用于删除迭代子返回的最后一个元素，该方法只能在每次执行`next()`后执行一次

> **注意**
>
> - Iterator 只能单向移动
> - `Iterator.remove()`是唯一安全的方式来在迭代过程中修改集合，如果在迭代过程中以任何其它的方式修改了基本集合将会产生未知的行为，而且每调用一次`next()`方法,`remove()`方法只能被调用一次，如果违反这个规则将抛出一个异常

- Iterator接口典型的用法如下:

```java
public class IteratorExample {
  public static void main(String[] args) {
    ArrayList<String> a = new ArrayList<String>();
    a.add("aaa");
    a.add("bbb");
    a.add("ccc");
    System.out.println("Before iterate : " + a);
    Iterator<String> it = a.iterator();
    while (it.hasNext()) {
      String t = it.next();
      if ("bbb".equals(t)) {
        it.remove();
      }
    }
    System.out.println("After iterate : " + a);
  }
}
```

- 如果我们自己编写了一个集合类，想要使用`for each`循环，只需满足以下条件:
  - 集合类实现`Iterable`接口，该接口要求返回一个`Iterator`对象
  - 用`Iterator`对象迭代集合内部数据
- 这里的关键在于，集合类通过调用`iterator()`方法，返回一个`Iterator`对象，这个对象必须自己知道如何遍历该集合
- 一个简单的`Iterator`示例如下，它总是以倒序遍历集合:

```java
import java.util.*;

public class Main {
  public static void main(String[] args) {
    ReverseList<String> rlist = new ReverseList<>();
    rlist.add("Apple");
    rlist.add("Orange");
    rlist.add("Pear");
    for (String s : rlist) {
      System.out.println(s);
    }
  }
}

class ReverseList<T> implements Iterable<T> {

  private List<T> list = new ArrayList<>();

  public void add(T t) {
    list.add(t);
  }

  @Override
  public Iterator<T> iterator() {
    return new ReverseIterator(list.size());
  }

  class ReverseIterator implements Iterator<T> {
    int index;

    ReverseIterator(int index) {
      this.index = index;
    }

    @Override
    public boolean hasNext() {
      return index > 0;
    }

    @Override
    public T next() {
      index--;
      return ReverseList.this.list.get(index);
    }
  }
}
```

- 虽然`ReverseList`和`ReverseIterator`的实现类稍微比较复杂，但是，注意到这是底层集合库，只需编写一次，而调用方则完全按`for each`循环编写代码，根本不需要知道集合内部的存储逻辑和遍历逻辑
- 在编写`Iterator`的时候，我们通常可以用一个内部类来实现`Iterator`接口，这个内部类可以直接访问对应的外部类的所有字段和方法，例如，上述代码中，内部类`ReverseIterator`可以用`ReverseList.this`获得当前外部类的`this`引用，然后，通过这个`this`引用就可以访问`ReverseList`的所有字段和方法

## ListIterator

- ListIterator 是一个功能更加强大的迭代器, 它继承于 Iterator 接口，只能用于各种 List 类型的访问，可以通过调用`listIterator()`方法产生一个指向 List 开始处的 ListIterator, 还可以调用`listIterator(n)`方法创建一个一开始就指向列表索引为 n 的元素处的 ListIterator
- ListIterator 接口定义如下:

```java
public interface ListIterator<E> extends Iterator<E> {
    boolean hasNext();

    E next();

    boolean hasPrevious();

    E previous();

    int nextIndex();

    int previousIndex();

    void remove();

    void set(E e);

    void add(E e);

}
```

- 由以上定义我们可以推出 ListIterator 可以:
  - 双向移动(向前 / 向后遍历)
  - 产生相对于迭代器在列表中指向的当前位置的前一个和后一个元素的索引
  - 可以使用`set()`方法替换它访问过的最后一个元素
  - 可以使用`add()`方法在`next()`方法返回的元素之前或`previous()`方法返回的元素之后插入一个元素
- 使用示例:

```java
public class ListIteratorExample {

  public static void main(String[] args) {
    ArrayList<String> a = new ArrayList<String>();
    a.add("aaa");
    a.add("bbb");
    a.add("ccc");
    System.out.println("Before iterate : " + a);
    ListIterator<String> it = a.listIterator();
    while (it.hasNext()) {
      System.out.println(it.next() + ", " + it.previousIndex() + ", " + it.nextIndex());
    }
    while (it.hasPrevious()) {
      System.out.print(it.previous() + " ");
    }
    System.out.println();
    it = a.listIterator(1);
    while (it.hasNext()) {
      String t = it.next();
      System.out.println(t);
      if ("ccc".equals(t)) {
        it.set("nnn");
      } else {
        it.add("kkk");
      }
    }
    System.out.println("After iterate : " + a);
  }
}
```

- 输出结果如下:

```
Before iterate : [aaa, bbb, ccc]
aaa, 0, 1
bbb, 1, 2
ccc, 2, 3
ccc bbb aaa
bbb
ccc
After iterate : [aaa, bbb, kkk, nnn]
```

## Iterator 和 ListIterator 区别

- Iterator可用来遍历Set和List集合，但是ListIterator只能用来遍历List
- Iterator对集合只能是前向遍历,ListIterator既可以前向也可以后向
- ListIterator实现了Iterator接口，并包含其他的功能，比如:增加元素，替换元素，获取前一个和后一个元素的索引，等等