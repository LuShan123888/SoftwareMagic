---
title: Spring MVC 拦截器
categories:
- Software
- Backend
- Java
- SpringFramework
- SpringMVC
---
# Spring MVC 拦截器

## 概述

- Spring MVC的处理器拦截器类似于Servlet开发中的过滤器Filter,用于对处理器进行预处理和后处理,开发者可以自己定义一些拦截器来实现特定的功能
- **过滤器**
    - servlet规范中的一部分,任何java web工程都可以使用
    - 在url-pattern中配置了`/*`之后,可以对所有要访问的资源进行拦截
- **拦截器**
    - 拦截器是Spring MVC框架自己的,只有使用了Spring MVC框架的工程才能使用
    - 拦截器只会拦截访问的控制器方法, 如果访问的是`jsp/html/css/image/js`是不会进行拦截的
- **过滤器与拦截器的区别**:拦截器是AOP思想的具体应用

## 自定义拦截器

- 自定义拦截器,必须实现 HandlerInterceptor 接口

```java
package com.example.interceptor;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class MyInterceptor implements HandlerInterceptor {

   //在请求处理的方法之前执行
   //如果返回true执行下一个拦截器
   //如果返回false就不执行下一个拦截器
   public boolean preHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o) throws Exception {
       System.out.println("------------处理前------------");
       return true;
  }

   //在请求处理方法执行之后执行
   public void postHandle(HttpServletRequest httpServletRequest, HttpServletResponsehttpServletResponse, Object o, ModelAndView modelAndView) throws Exception {
       System.out.println("------------处理后------------");
  }

   //在dispatcherServlet处理后执行,做清理工作.
   public void afterCompletion(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, Exception e) throws Exception {
       System.out.println("------------清理------------");
  }
}
```

## 配置拦截器

- **Spring**

```xml
<!--关于拦截器的配置-->
<mvc:interceptors>
   <mvc:interceptor>
       <!--/** 包括路径及其子路径-->
       <!--/admin/* 拦截的是/admin/add等等这种 , /admin/add/user不会被拦截-->
       <!--/admin/** 拦截的是/admin/下的所有-->
       <mvc:mapping path="/**"/>
       <!--bean配置的就是拦截器-->
       <bean class="com.example.interceptor.MyInterceptor"/>
   </mvc:interceptor>

    <!--可以通过这种配置方式指定拦截器的映射类, 但是默认拦截所有请求-->
    <bean name="handlerInterceptor1" class="com.briup.web.interceptor.MyInterceptor1"/>
    <bean class="org.springframework.web.servlet.handler.BeanNameUrlHandlerMapping">
        <property name="interceptors">
            <list>
                <ref bean="handlerInterceptor1"/>
            </list>
        </property>
    </bean>	
</mvc:interceptors>
```

**SpringBoot**

```java
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class DemoMvcConfig implements WebMvcConfigurer {
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new DemoLoginHandlerInterceptor()).addPathPatterns("/**").excludePathPatterns("/index.html","/user/login","/css/**","/js/**","/img/**");
    }
}
```

## 实例

- 验证用户是否登录 (认证用户)

**实现思路**

- 有一个登陆页面,需要写一个controller访问页面
- 登陆页面有一提交表单的动作,需要在controller中处理,判断用户名密码是否正确,如果正确,向session中写入用户信息,返回登陆成功
- 拦截用户请求,判断用户是否登陆,如果用户已经登陆,放行, 如果用户未登陆,跳转到登陆页面

**测试**:

1. 编写一个登陆页面  login.jsp

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
   <title>Title</title>
</head>

<h1>登录页面</h1>
<hr>

<body>
<form action="${pageContext.request.contextPath}/user/login">
  用户名:<input type="text" name="username"> <br>
  密码:<input type="password" name="pwd"> <br>
   <input type="submit" value="提交">
</form>
</body>
</html>
```

2. 编写一个登陆成功的页面 success.jsp

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
   <title>Title</title>
</head>
<body>

<h1>登录成功页面</h1>
<hr>

${user}
<a href="${pageContext.request.contextPath}/user/logout">注销</a>
</body>
</html>
```

3. 编写一个Controller处理请求

```java
package com.example.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/user")
public class UserController {

   //跳转到登陆页面
   @RequestMapping("/jumplogin")
   public String jumpLogin() throws Exception {
       return "login";
  }

   //跳转到成功页面
   @RequestMapping("/jumpSuccess")
   public String jumpSuccess() throws Exception {
       return "success";
  }

   //登陆提交
   @RequestMapping("/login")
   public String login(HttpSession session, String username, String pwd) throwsException {
       // 向session记录用户身份信息
       System.out.println("接收前端==="+username);
       session.setAttribute("user", username);
       return "success";
  }

   //退出登陆
   @RequestMapping("logout")
   public String logout(HttpSession session) throws Exception {
       // session 过期
       session.invalidate();
       return "login";
  }
}
```
5. 编写用户登录拦截器

```java
package com.example.interceptor;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class LoginInterceptor implements HandlerInterceptor {

   public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws ServletException, IOException {
       // 如果是登陆页面则放行
       System.out.println("url: " + request.getRequestURI());
       if (request.getRequestURI().contains("login")) {
           return true;
      }

       HttpSession session = request.getSession();

       // 如果用户已登陆也放行
       if(session.getAttribute("user") != null) {
           return true;
      }

       // 用户没有登陆跳转到登陆页面
       request.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(request, response);
       return false;
  }

   public void postHandle(HttpServletRequest httpServletRequest, HttpServletResponsehttpServletResponse, Object o, ModelAndView modelAndView) throws Exception {

  }

   public void afterCompletion(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, Exception e) throws Exception {

  }
}
```

6. 在Spring MVC的配置文件中注册拦截器

```xml
<!--关于拦截器的配置-->
<mvc:interceptors>
   <mvc:interceptor>
       <mvc:mapping path="/**"/>
       <bean id="loginInterceptor" class="com.example.interceptor.LoginInterceptor"/>
   </mvc:interceptor>
</mvc:interceptors>
```

