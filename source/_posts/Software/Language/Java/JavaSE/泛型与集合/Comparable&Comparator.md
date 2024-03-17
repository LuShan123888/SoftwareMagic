---
title: Java Comparable & Comparator接口
categories:
- Software
- Language
- Java
- JavaSE
- 泛型与集合
---
# Java Comparable & Comparator接口

Java提供了`Comparable<T>`与`Comparator<T>`两个接口定义对数组或集合中对象进行排序，实现次接口的对象数组或列表可以通过`Arrays.sort`或`Collections.sort`进行自动排序

##  Comparable接口

- `Comparable<T>`接口定义了如下方法:

```java
int compareTo(T obj);
```

- 功能是将当前对象与参数obj进行比较，在当前对象小于，等于或大于指定对象obj时，分别返回负整数，零或正整数
- 一个类实现了Comparable接口，则表明这个类的对象之间是可以互相比较的，这个类对象组成的集合元素就可以直接使用`sort()`方法进行排序

**[l例14-2]**:让User对象按年龄排序

```java
import java.util.Arrays;
public class User implements Comparable<User> {
  private String username;
  private int age;

  public User(String username, int age) {
    this.username = username;
    this.age = age;
  }

  public int getAge() {
    return age;
  }

  public String toString() {
    return username + ":" + age;
  }

  public int compareTo(User obj){
    return this.age-obj.getAge();
  }

  public static void main(String[] args) {
    User[] users = {new User("张三",30),new User("李四",20)};
    Arrays.sort(users);// 用Arrays类的sort()方法对数组排序
    for (int i=0;i<users.length;i++)
      System.out.println(users[i]);
  }
}

李四:20
  张三:30
```

## Comparator接口

- `Comparator<T>`接口中定义了如下方法:

```java
int comparator(T obj1.Tobj2);
```

- 当obj1小于，等于或大于obj2时，分别返回负整数，零或正整数
- Comparator接口可以看成一种对象比较算法的实现，不妨称为"比较算子”,它将算法和数据分离,Comparator接口常用于以下两种环境:
  - 类的设计师没有考虑到比较问题，因而没有实现Comparator接口，可以通过Comparator比较算子来实现排序而不必改变对象本身
  - 对象排序时要用多种排序标准，如升序，降序等，只要执行`sort()`方法时用不同的Comparator比较算子就可适应变化
- 假设User类没有实现Comparator接口，可采用UserComparator比较算子提供的方法实现排序，以下是按年龄(age)进行升序排序的具体实现代码

```java
import java.util.Arrays;
import java.util.Comparator;
public class UserComparator implements Comparator<User> {
  public int compare(User obj1, User obj2) {
    return obj1.getAge() - obj2.getAge();
  }

  public static void main(String[] args) {
    User[] users = {new User("mary", 25), new User("John", 40)};
    Arrays.sort(users, new UserComparator());// 用算子排序
    for (int i = 0; i < users.length; i++)
      System.out.println(users[i]);
  }
}

mary:25
  John:40
```

Ï
