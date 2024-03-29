---
title: Java this&super
categories:
  - Software
  - Language
  - Java
  - JavaSE
  - 类与对象
---
# Java this&super

## this

- this 是自身的一个对象，代表对象本身，可以理解为**指向对象本身的一个指针**
- this 的用法在 Java 中大体可以分为3种：

### 普通的直接引用

- this 相当于是指向当前对象本身。

### 形参与成员名字重名，用 this 来区分

```java
class Person {
    private int age = 10;
    public Person(){
        System.out.println("初始化年龄："+age);
    }
    public int GetAge(int age){
        this.age = age;
        return this.age;
    }
}

public class test1 {
    public static void main(String[] args) {
        Person Harry = new Person();
        System.out.println("Harry's age is "+Harry.GetAge(12));
    }
}
```

- 运行结果：

```
初始化年龄：10
Harry's age is 12
```

- 可以看到，这里 age 是 GetAge 成员方法的形参，this.age 是 Person 类的成员变量。

### 引用构造函数

- **this（参数）**：调用本类中另一种形式的构造函数（应该为构造函数中的第一条语句）

## super

- super 可以理解为是指向自己超（父）类对象的一个指针，而这个超类指的是离自己最近的一个父类。
- super 也有三种用法：

### 普通的直接引用

- 与 this 类似，super 相当于是指向当前对象的父类，这样就可以用 **super.xxx** 来引用父类的成员。

### 子类中的成员变量或方法与父类中的成员变量或方法同名

```java
class Country {
    String name;
    void value() {
        name = "China";
    }
}

class City extends Country {
    String name;
    void value() {
        name = "Shanghai";
        super.value();      // 调用父类的方法。
        System.out.println(name);
        System.out.println(super.name);
    }

    public static void main(String[] args) {
        City c=new City();
        c.value();
    }
}
```

```
Shanghai
China
```

- 可以看到，这里既调用了父类的方法，也调用了父类的变量，若不调用父类方法 value()，只调用父类变量 name 的话，则父类 name 值为默认值 null

### 引用构造函数

- **super（参数）**：调用父类中的某一个构造函数（应该为构造函数中的第一条语句）

```java
class Person {
  public static void prt(String s) {
    System.out.println(s);
  }

  Person() {
    prt("父类无参数构造方法："+"A Person.");
  }// 构造方法（1)

  Person(String name) {
    prt("父类含一个参数的构造方法："+"A person's name is " + name);
  }// 构造方法（2)
}

public class Chinese extends Person {
  Chinese() {
    super(); // 调用父类构造方法（1)
    prt("子类调用父类"无参数构造方法":"+"A chinese coder.");
  }

  Chinese(String name) {
    super(name);// 调用父类具有相同形参的构造方法（2)
    prt("子类调用父类"含一个参数的构造方法":"+"his name is " + name);
  }

  Chinese(String name, int age) {
    this(name);// 调用具有相同形参的构造方法（3)
    prt("子类：调用子类具有相同形参的构造方法：his age is " + age);
  }

  public static void main(String[] args) {
    Chinese cn = new Chinese();
    cn = new Chinese("codersai");
    cn = new Chinese("codersai", 18);
  }
}
```

```
父类无参数构造方法：A Person
子类调用父类”无参数构造方法":A chinese coder
父类含一个参数的构造方法：A person's name is codersai
子类调用父类”含一个参数的构造方法":his name is codersai
父类含一个参数的构造方法：A person's name is codersai
子类调用父类”含一个参数的构造方法":his name is codersai
子类：调用子类具有相同形参的构造方法：his age is 18
```

- 从本例可以看到，可以用 super 和 this 分别调用父类的构造方法和本类中其他形式的构造方法。
- 例子中 Chinese 类第三种构造方法调用的是本类中第二种构造方法，而第二种构造方法是调用父类的，因此也要先调用父类的构造方法，再调用本类中第二种，最后是重写第三种构造方法。

## super 和 this的异同

- super（参数）：调用父类中的某一个构造函数（应该为构造函数中的第一条语句），每个子类构造方法的第一条语句，都是隐含地调用 super()，如果父类没有这种形式的构造函数，那么在编译的时候就会报错。
- this（参数）：调用本类中另一种形成的构造函数（应该为构造函数中的第一条语句）
- this 和 super 不能同时出现在一个构造函数里面，因为this必然会调用其它的构造函数，其它的构造函数必然也会有 super 语句的存在，所以在同一个构造函数里面有相同的语句，就失去了语句的意义，编译器也不会通过。
- this(）和 super(）都指的是对象，所以，均不可以在 static 环境中使用，包括：static 变量，static 方法，static 语句块。