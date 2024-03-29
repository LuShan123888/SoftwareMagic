---
title: JSP JavaBean
categories:
- Software
- Language
- Java
- JavaEE
- JSP
---
# JSP JavaBean

- JavaBean 是特殊的 Java 类，使用 Java 语言书写，并且遵守 JavaBean API 规范。
- 接下来给出的是 JavaBean 与其它 Java 类相比而言独一无二的特征：
    - 提供一个默认的无参构造函数。
    - 需要被序列化并且实现了 Serializable 接口。
    - 可能有一系列可读写属性。
    - 可能有一系列的 **getter** 或 **setter** 方法。

## JavaBean 属性

- 一个 JavaBean 对象的属性应该是可访问的，这个属性可以是任意合法的 Java 数据类型，包括自定义 Java 类。
- 一个 JavaBean 对象的属性可以是可读写，或只读，或只写，JavaBean 对象的属性通过 JavaBean 实现类中提供的两个方法来访问：

| 方法                | 描述                                                         |
| :------------------ | :----------------------------------------------------------- |
| `getPropertyName()` | 举例来说，如果属性的名称为 myName，那么这个方法的名字就要写成 `getMyName()` 来读取这个属性，这个方法也称为访问器， |
| `setPropertyName()` | 举例来说，如果属性的名称为 myName，那么这个方法的名字就要写成 `setMyName()`来写入这个属性，这个方法也称为写入器， |

一个只读的属性只提供 `getPropertyName()` 方法，一个只写的属性只提供 `setPropertyName()` 方法。

## JavaBean 程序示例

- 这是 StudentBean.java 文件：

```java
package com.test;

public class StudentsBean implements java.io.Serializable
{
   private String firstName = null;
   private String lastName = null;
   private int age = 0;

   public StudentsBean() {
   }
   public String getFirstName(){
      return firstName;
   }
   public String getLastName(){
      return lastName;
   }
   public int getAge(){
      return age;
   }

   public void setFirstName(String firstName){
      this.firstName = firstName;
   }
   public void setLastName(String lastName){
      this.lastName = lastName;
   }
   public void setAge(int age) {
      this.age = age;
   }
}
```

## 访问JavaBean

- `<jsp:useBean>` 标签可以在 JSP 中声明一个 JavaBean，然后使用，声明后，JavaBean 对象就成了脚本变量，可以通过脚本元素或其他自定义标签来访问，`<jsp:useBean>` 标签的语法格式如下：

```jsp
<jsp:useBean id="bean 的名字" scope="bean 的作用域" typeSpec/>
```

- 其中，根据具体情况，scope 的值可以是 page,request,session 或 application,id值可任意只要不和同一 JSP 文件中其它 <jsp:useBean> 中 id 值一样就行了。
- 接下来给出的是 `<jsp:useBean>` 标签的一个简单的用法：

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<title>useBean 实例</title>
</head>
<body>

<jsp:useBean id="date" class="java.util.Date" />
<p>日期为：<%= date %>

</body>
</html>
```

- 它将会产生如下结果：

```
日期为：Tue Jun 28 15:22:24 CST 2016
```

## 访问 JavaBean 对象的属性

- 在 `<jsp:useBean>` 标签主体中使用 `<jsp:getProperty/>` 标签来调用 **getter** 方法，使用 `<jsp:setProperty/>` 标签来调用 **setter** 方法，语法格式如下：

```jsp
<jsp:useBean id="id" class="bean 编译的类" scope="bean 作用域">
   <jsp:setProperty name="bean 的 id" property="属性名"
                    value="value"/>
   <jsp:getProperty name="bean 的 id" property="属性名"/>
   ...
</jsp:useBean>
```

- name属性指的是Bean的id属性，property属性指的是想要调用的getter或setter方法。
- 接下来给出使用以上语法进行属性访问的一个简单例子：

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<title>get 和 set 属性实例</title>
</head>
<body>

<jsp:useBean id="students"
                    class="com.test.StudentsBean">
   <jsp:setProperty name="students" property="firstName"
                    value="小强"/>
   <jsp:setProperty name="students" property="lastName"
                    value="王"/>
   <jsp:setProperty name="students" property="age"
                    value="10"/>
</jsp:useBean>

<p>学生名字：
   <jsp:getProperty name="students" property="firstName"/>
</p>
<p>学生姓氏：
   <jsp:getProperty name="students" property="lastName"/>
</p>
<p>学生年龄：
   <jsp:getProperty name="students" property="age"/>
</p>

</body>
</html>
```

- 访问以上 JSP，运行结果如下：

```
学生名字：小强。

学生姓氏：王。

学生年龄： 10
```