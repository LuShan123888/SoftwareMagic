---
title: Spring MVC 处理器适配器
categories:
- Software
- BackEnd
- SpringFramework
- SpringMVC
---
# Spring MVC 处理器适配器

- HandlerAdapter调用具体的方法对用户发来的请求来进行处理
- 当HandlerMapping获取到执行请求的controller时,DispatcherServlte会根据controller对应的controller类型来调用相应的HandlerAdapter来进行处

## 源码分析

```java
public class SimpleControllerHandlerAdapter implements HandlerAdapter {

    @Override
    public boolean supports(Object handler) {
        // 判断待执行的类是不是Controller的实现类
        return (handler instanceof Controller);
    }

    @Override
    @Nullable
    public ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object handler)
        throws Exception {

        // 调用Controller实现类的handleRequest方法
        return ((Controller) handler).handleRequest(request, response);
    }

    @Override
    public long getLastModified(HttpServletRequest request, Object handler) {
        if (handler instanceof LastModified) {
            return ((LastModified) handler).getLastModified(request);
        }
        return -1L;
    }

}
```

## 自定义handlerAdaptor

```java
public class MyHandlerAdapter implements HandlerAdapter {

    @Override
    public boolean supports(Object handler) {
        // 判断待执行的类是不是MyController的实现类
        return (handler instanceof MyController);
    }

    @Override
    @Nullable
    public ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object handler)
        throws Exception {
        // 配置编码格式
        request.setCharacterEncoding("UTF-8");
        // 打印
        System.out.println("Enter MyHandlerAdapter!");
        // 调用MyController的实现类的test方法
        return ((MyController) handler).test(request);
    }

    @Override
    public long getLastModified(HttpServletRequest request, Object handler) {
        if (handler instanceof LastModified) {
            return ((LastModified) handler).getLastModified(request);
        }
        return -1L;
    }


```

- MyController接口

```java
public interface MyController {
    ModelAndView test(HttpServletRequest req);
}
```

- MyController实现类

```java
public class DefinedController implements MyController {
    @Override
    public ModelAndView test(HttpServletRequest req) {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("test");
        mv.addObject("msg", "hello");
        return mv;
    }
}
```

- 注入配置文件

```xml
<!--自定义处理适配器-->
<bean class="com.example.MyHandlerAdapter"/>
<!-- 注册Controller -->
<bean name="/mycontroller" class="com.example.DefinedController"/>
```

