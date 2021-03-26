---
title: Spring Boot 整合 Spring  Security
categories:
- Software
- Backend
- Java
- SpringFramework
- SpringBoot
---
# Spring Boot 整合 Spring  Security

## 简介

- Spring Security 是针对Spring项目的安全框架,也是Spring Boot底层安全模块默认的技术选型,可以实现强大的Web安全控制,对于安全控制,仅需要引入 spring-boot-starter-security 模块,进行少量的配置,即可实现强大的安全管理
- 核心类与注解
    - `WebSecurityConfigurerAdapter`:自定义Security策略
    - `AuthenticationManagerBuilder`:自定义认证策略
    - `@EnableWebSecurity`:开启WebSecurity模式
- Spring Security的两个主要目标
    - 认证(Authentication)
        - 身份验证是关于验证您的凭据,如用户名/用户ID和密码,以验证您的身份
        - 身份验证通常通过用户名和密码完成,有时与身份验证因素结合使用
    - 授权(Authorization)
        - 授权发生在系统成功验证您的身份后,最终会授予您访问资源(如信息,文件,数据库,资金,位置,几乎任何内容)的完全权限
        - 这个概念是通用的,而不是只在Spring Security 中存在

## pom.xml

```xml
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-security</artifactId>
</dependency>
```

## Spring Security 配置

### 基础配置类

- `@EnableWebSecurity`:开启WebSecurity模式

```java
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
importorg.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
importorg.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;

@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {

  @Override
  protected void configure(HttpSecurity http) throws Exception {

  }
}
```

### 开启自动配置的登录功能

- `/login`:请求来到登录页
- `/login?error`:重定向到登录页并表示登录失败

```java
http.formLogin();
```

### 定义认证规则

- 重写`configure(AuthenticationManagerBuilder auth)`方法

```java
@Override
protected void configure(AuthenticationManagerBuilder auth) throws Exception {

  auth.inMemoryAuthentication().passwordEncoder(new BCryptPasswordEncoder())
    .withUser("example").password(new BCryptPasswordEncoder().encode("123456")).roles("vip2","vip3")
    .and()
    .withUser("root").password(new BCryptPasswordEncoder().encode("123456")).roles("vip1","vip2","vip3")
    .and()
    .withUser("guest").password(new BCryptPasswordEncoder().encode("123456")).roles("vip1","vip2");
}
```

### 定制请求的授权规则

```java
@Override
protected void configure(HttpSecurity http) throws Exception {
  http.authorizeRequests().antMatchers("/").permitAll()
    .antMatchers("/level1/**").hasRole("vip1")
    .antMatchers("/level2/**").hasRole("vip2")
    .antMatchers("/level3/**").hasRole("vip3");
}
```

### 注销

- 开启自动配置的注销的功能,删除指定cookies,清空session,并跳转到首页

```java
@Override
protected void configure(HttpSecurity http) throws Exception {
  http.logout().deleteCookies("remember-me").invalidateHttpSession(true).logoutSuccessUrl("/");
}
```

- 前段注销按钮

```html
<a class="item" th:href="@{/logout}">
  <i class="address card icon"></i> 注销
</a>
```

#### csrf配置

- 默认打开防止csrf跨站请求伪造,因为会产生安全问题,可以将请求改为post表单提交,或者在spring security中关闭csrf功能

```java
http.csrf().disable();
```

### 整合Thymeleaf判断登录状态

#### pom.xml

```xml
<!-- https://mvnrepository.com/artifact/org.thymeleaf.extras/thymeleaf-extras-springsecurity4 -->
<dependency>
  <groupId>org.thymeleaf.extras</groupId>
  <artifactId>thymeleaf-extras-springsecurity5</artifactId>
  <version>3.0.4.RELEASE</version>
</dependency>
```

#### 导入命名空间

```
xmlns:sec="http://www.thymeleaf.org/thymeleaf-extras-springsecurity5"
```

#### 导航栏根据登录状态改变

- `sec:authorize="isAuthenticated()"`:判断是否认证登录

```html
<!--登录注销-->
<div class="right menu">

  <!--如果未登录-->
  <div sec:authorize="!isAuthenticated()">
    <a class="item" th:href="@{/login}">
      <i class="address card icon"></i> 登录
    </a>
  </div>

  <!--如果已登录-->
  <div sec:authorize="isAuthenticated()">
    <a class="item">
      <i class="address card icon"></i>
      用户名:<span sec:authentication="principal.username"></span>
      角色:<span sec:authentication="principal.authorities"></span>
    </a>
  </div>

  <div sec:authorize="isAuthenticated()">
    <a class="item" th:href="@{/logout}">
      <i class="address card icon"></i> 注销
    </a>
  </div>
</div>
```

### 记住登录状态

- 开启后发现登录页多了一个Remember me 选项,勾选后登录即可记住登录状态
- 默认生成名为`remember-me`的cookie,保留14天
- 当注销时Spring Security会自动删除`remember-me`

```java
@Override
protected void configure(HttpSecurity http) throws Exception {
  http.rememberMe();
}
```

## 定制登录页

1. 在登录页配置后面指定`loginpage`
    - login.html 配置提交请求及方式,方式必须为post:

```java
http.formLogin().loginPage("/toLogin");
```

2. 配置接收登录的用户名和密码的参数与表单提交的url

- 用户名和密码参数与表单中的input的name属性对应

```java
http.formLogin()
  .usernameParameter("username")
  .passwordParameter("password")
  .loginPage("/toLogin")
  .loginProcessingUrl("/login");
```

3. 定制rememberMe的参数

```java
http.rememberMe().rememberMeParameter("remember");
```

4. 编写前段表单

```html
<form th:action="@{/login}" method="post">
  <div class="field">
    <label>Username</label>
    <div class="ui left icon input">
      <input type="text" placeholder="Username" name="username">
      <i class="user icon"></i>
    </div>
  </div>
  <div class="field">
    <label>Password</label>
    <div class="ui left icon input">
      <input type="password" name="password">
      <i class="lock icon"></i>
    </div>
  </div>
  <input type="submit" class="ui blue submit button"/>
  <input type="checkbox" name="remember"> 记住我
</form>
```

