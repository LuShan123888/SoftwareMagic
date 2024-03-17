---
title: Java Class类
categories:
- Software
- Language
- Java
- JavaSE
- 注解与反射
---
# Java Class类

Java运行环境中提供了反射机制，这种机制允许在程序中动态获取类的信息以及动态调用对象的方法，其相关的类主要有Class类,Field类,Method类,Constructor类,Array类，它们分别代表类，类的属性，类的方法，类的构造方法以及动态创建数组

## 获取Class类型的对象

Class类封装一个对象和接口运行时的状态，当装载类时,Class类型的对象自动创建，有三种方法可以获取Class的对象:

- 调用Object类的`getClasss()`方法
- 使用Class类的`forName()`方法
- 如果T是一个Java类型，那么T.class就代表了于该类型匹配的Class对象，例如,String.class代表字符串类型,int.class代表整数类型

## Class类的常用方法

以下列出了Class类的几个常用方法:

- `static Class<?>forName(String className)`:返回给定串名相应的Class对象，若给定一个类或接口的完整路径名，那么此方法将试图定位，转载和连接该类，若成功，返回该类对象，否则，抛出ClassNotFoundException异常
- `T newInstance()`:创建类的一个实例,`newInstance()`方法调用默认构造器（无参数构造器）初始化新建对象
- `String getName()`:返回Class对象表示的类型（类，接口，数组或父类型）的完整路径名字符串
- `Method[]getMethods()`:返回当前Class对象表示的类或接口的所有公有成员方法对象的数组，包括自身定义的和从父类继承的方法，而且，利用Method类提供的`invoke()`方法可实现相应类的成员方法的调用，例如:

```java
Object invoke(Object obj,Object[]args);
```

其中obj代表调用该方法的类实例对象,args代表存放方法参数的对象数组

- `Method getMethods(String name,Class...parameterType)`:返回指定方法名和参数类型的方法对象
- `Field[] getFields()`:返回当前Class对象表示的类或接口的所有可访问的公有域对象的数组
- `getComponentType()`:可以取得一个数组的Class对象，通过`Array.newInstance()`可以反射生成数组对象

**[例6-6]**:反射机制简单测试举例

```java
import java.lang.reflect.*;
class Test {
    public int add(int x, int y) {
        return x + y;
    }

    public int minus(int x, int y) {
        return x - y;
    }
}

public class Ex6_6 {
    public static void main(String[] args) throws Exception {
        Class<?> myclass = Class.forName("Test");
        System.out.println(myclass.getName());
        Object x = myclass.newInstance();//获取Test类的一个对象
        Method[ ] m = myclass.getMethods();//获取Test类的所有方法
        Object[ ] Args = new Object[ ]{1, 2};
        for (int i = 0; i < 2; i++)
            System.out.println(m[i].toString());
        System.out.println(m[1].invoke(x, Args));//调用对象的第二个方法
        Method addm = myclass.getMethod("add", int.class, int.class);
        System.out.println(addm.invoke(x, Args));//调用add方法
    }
}

Test
    public int Test.minus(int,int)
    public int Test.add(int,int)
    -1
    3
```

**说明**:在该例中有程序注释的4步反映了用反射机制动态调用一个类的方法的过程，首先在第14行利用Class类的forName方法由类名Test创建相应的Class类型的对象，然后通过执行该对象的`newInstance()`方法得到了Test对象实例，并通过`getMethods()`方法得到Test类的所有方法，最后通过Method类的`invoke()`方法实现对象的方法调用，该机制为Java方法的动态调用提供了方便，在分布式编程中应用广泛，值得一提的是，用`getMethod()`方法定义Method对象由于不能确定方法参数的类型是否正确，所以编译时会给出警告，运行时是否出现异常，取决于其给定的方法参数类型是否于实际方法的参数类型一致



