---
title: Servlet 网页重定向
categories:
- Software
- Backend
- Java
- JavaEE
- Servlet
---
# Servlet 网页重定向

当文档移动到新的位置,我们需要向客户端发送这个新位置时,我们需要用到网页重定向,当然,也可能是为了负载均衡,或者只是为了简单的随机,这些情况都有可能用到网页重定向

## setStatus()和setHeader()

该方法把响应连同状态码和新的网页位置发送回浏览器,您也可以通过把 setStatus() 和 setHeader() 方法一起使用来达到同样的效果:

```java
String site = "http://www.test.com" ;
response.setStatus(response.SC_MOVED_TEMPORARILY);
response.setHeader("Location", site);
```

## sendRedirect ()

```java
response.sendRedirect();
```

**说明**:

- 服务器根据逻辑,发送一个状态码302,告诉浏览器重新去请求指定的地址,一般来说,你会把需要的参数放在转发的地址里面
- **注意**:使用request.setAttribute的内容,不能读取了,你可以用session代替,或者用include,forward代替


![img](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-sendRedirect%25E7%259A%2584%25E6%25B5%2581%25E7%25A8%258B.PNG)

## RequestDispatcher

### include()

- **servlet**

```java
request.getRequestDispatcher("jsp2.jsp").include(request,   response);
```

- **jsp**

```jsp
<jsp:include page="include.jsp"/>
```

**说明**

- 页面会同时包含页面1和页面2的内容,地址栏不变
- 使用`request.setAttribute`的内容,可以正常使用


![img](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-include%25E6%25B5%2581%25E7%25A8%258B.PNG)



### forward()

- **servlet**

```java
request.getRequestDispatcher("jsp2.jsp").forward(request,  response);
```

- **jsp**

```jsp
<jsp:forward page="include.jsp"/>
```

**说明**

- 页面会是页面2的内容,地址栏不变
- 使用`request.setAttribute`的内容,可以正常使用


![img](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-forward%25E6%25B5%2581%25E7%25A8%258B.png)



**注意**

- 利用`include()`方法将请求转发给其他的Servlet,被调用的Servlet对该请求作出的响应将并入原先的响应对象中,原先的Servlet还可以继续输出响应信息;而利用`forward()`方法将请求转发给其他的Servlet,将由被调用的Servlet负责队请求做出响应,而原先Servlet的执行则终止

- `include` 和 `sendRediect` 之后,后面的语句会继续执行,而`return;forward`的不会

    会