---
title: Java Arrays
categories:
- Software
- Language
- Java
- JavaSE
- 泛型与集合
---
# Java Arrays

## Arrays

- Arrays 是JDK提供的操作数组的工具类, array类提供了动态创建和访问 Java 数组的方法

### Arrays.newInstance()

- 创建数组
- 在Java的反射机制中, 通过数组的 class 对象的`getComponentType()`方法可以取得一个数组的Class对象,  通过`Array.newInstance()`可以反射生成数组对象

```java
 T[] b = (T[]) Arrays.newInstance(a.getClass().getComponentType(), a.length);
```

### Arrays.toString()

- 打印数组

```java
int[] intArray = { 1, 2, 3, 4, 5 };
String intArrayString = Arrays.toString(intArray);

// 直接打印，则会打印出引用对象的Hash值
// [I@7150bd4d
System.out.println(intArray);

// [1, 2, 3, 4, 5]
System.out.println(intArrayString);
```

### Arrays.asList()

- 根据数组创建ArrayList

```java
String[] stringArray = { "a", "b", "c", "d", "e" };
ArrayList<String> arrayList = new ArrayList<String>(Arrays.asList(stringArray));
// [a, b, c, d, e]
System.out.println(arrayList);
```

> **注意**
>
> - 该方法适用于对象型数据的数组(String,Integer...)
> - 该方法不建议使用于基本数据类型的数组(byte,short,int,long,float,double,boolean)
> - 该方法将数组与List列表链接起来:当更新其一个时，另一个自动更新
> - 生成的List不支持add(),remove(),clear()等方法
>   - 返回的ArrayList不是java.util包下的，而是java.util.Arrays.ArrayList,它是Arrays类自己定义的一个静态内部类，这个内部类没有实现add(),remove()方法，而是直接使用它的父类AbstractList的相应方法
>

### Arrays.contains()

- 检查数组是否包含某个值

```java
String[] stringArray = { "a", "b", "c", "d", "e" };
boolean b = Arrays.asList(stringArray).contains("a");
// true
System.out.println(b);
```

## ArrayUtils

- Apache Commons Lang 库

### pom.xml

```java
<!-- https://mvnrepository.com/artifact/org.apache.commons/commons-lang3 -->
<dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-lang3</artifactId>
    <version>3.11</version>
</dependency>
```

### ArrayUtils.addAll()

- 合并连接两个数组

```java
int[] intArray = { 1, 2, 3, 4, 5 };
int[] intArray2 = { 6, 7, 8, 9, 10 };
int[] combinedIntArray = ArrayUtils.addAll(intArray, intArray2);
```

### ArrayUtils.reverse()

- 数组元素反转

```java
int[] intArray = { 1, 2, 3, 4, 5 };
ArrayUtils.reverse(intArray);
//[5, 4, 3, 2, 1]
System.out.println(Arrays.toString(intArray));
```

### ArrayUtils.removeElement()

- 移除元素

```java
int[] intArray = { 1, 2, 3, 4, 5 };
int[] removed = ArrayUtils.removeElement(intArray, 3);//创建新的数组
System.out.println(Arrays.toString(removed));
```

