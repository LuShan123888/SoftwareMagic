---
title: Spring AOP
categories:
- Software
- BackEnd
- SpringFramework
- Spring
---
# Spring AOP

## AOP 概述

- AOP(Aspect Oriented Programming)面向切面编程, 通过预编译方式和运行期动态代理实现程序功能的统一维护的一种技术,AOP是OOP的延续, 是软件开发中的一个热点, 也是Spring框架中的一个重要内容, 是函数式编程的一种衍生范型,利用AOP可以对业务逻辑的各个部分进行隔离, 从而使得业务逻辑各部分之间的耦合度降低, 提高程序的可重用性, 同时提高了开发的效率

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-2020-10-31-640-20201031204745305.png)

## AOP 概念

- AOP实现的关键在于AOP框架自动创建的AOP代理,AOP代理主要分为静态代理和动态代理,静态代理的代表为AspectJ,而动态代理则以Spring AOP为代表
  - AspectJ是静态代理的增强,所谓的静态代理就是AOP框架会在编译阶段生成AOP代理类,因此也称为编译时增强
  - Spring AOP 基于动态代理,主要有两种方式
      - JDK动态代理:通过反射来接收被代理的类,并且要求被代理的类必须实现InvocationHandler接口,JDK动态代理的核心是
          InvocationHandler接口和Proxy类
      - CGLIB (Code Generation Library),是一个代码生成的类库,可以在运行时动态的生成某个类的子类,注意,CGLIB是通过继承
          的方式做的动态代理,因此如果某个类被标记为final,那么它是无法使用CGLIB做动态代理的,诸如private的方法也是不可以作为切面的
- 在AOP编程中,我们经常会遇到下面的概念:
  - Joinpoint:连接点,即定义在应用程序流程的何处插入切面的执行
  - Pointcut:切入点,即一组连接点的集合
  - Advice:增强,指特定连接点上执行的动作
  - Introduction:引介,特殊的增强,指为一个已有的Java对象动态地增加新的接口
  - Weaving:织入,将增强添加到目标类具体连接点上的过程
  - Aspect:切面,由切点和增强(引介)组成,包括了对横切关注功能的定义,已包括了对连接点的定义

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-2020-11-06-640-4157569.png)

- Spring AOP 提供了 Advice 接口多个子接口来支持增强:
  - 接口 MethodBeforeAdvice:在目标方法调用之前调用的Advice
  - 接口 AfterReturningAdvice:在目标方法调用并返回之后调用的Advice
  - 接口 MethodInterceptor:在目标方法的整个执行前后有效,并且有能力控制目标方法的执行
  - 接口 ThrowsAdvice:在目标方法抛出异常时调用的Advice
- 对应的注解如下
  - 前置通知(@Before):在目标方法调用之前调用通知
  - 后置通知(@After):在目标方法完成之后调用通知
  - 环绕通知(@Around):在被通知的方法调用之前和调用之后执行自定义的方法
  - 返回通知(@AfterReturning):在目标方法成功执行之后调用通知
  - 异常通知(@AfterThrowing):在目标方法抛出异常之后调用通知

## Spring

### pom.xml

```xml
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-aop</artifactId>
    <version>${spring.version}</version>
</dependency>
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-aspects</artifactId>
    <version>${spring.version}</version>
</dependency>
```

- 上述依赖会自动引入AspectJ,使用AspectJ实现AOP比较方便,因为它的定义比较简单

### 通过 Spring API 实现AOP

- 首先编写业务接口和实现类

```java
public interface UserService {

    public void add();
    public void delete();
    public void update();
    public void search();

}
@Service
public class UserServiceImpl implements UserService{

    @Override
    public void add() {
        System.out.println("增加用户");
    }

    @Override
    public void delete() {
        System.out.println("删除用户");
    }

    @Override
    public void update() {
        System.out.println("更新用户");
    }

    @Override
    public void search() {
        System.out.println("查询用户");
    }
}
```

- 编写增强类 ,一个为前置增强, 另一个为后置增强

```java
@Component
public class BeforeLog implements MethodBeforeAdvice {

    //method : 要执行的目标对象的方法
    //objects : 被调用的方法的参数
    //Object : 目标对象
    @Override
    public void before(Method method, Object[] objects, Object o) throws Throwable {
        System.out.println( o.getClass().getName() + "的" + method.getName() + "方法被执行了");
    }
}
@Component
public class AfterLog implements AfterReturningAdvice {
    //returnValue 返回值
    //method被调用的方法
    //args 被调用的方法的对象的参数
    //target 被调用的目标对象
    @Override
    public void afterReturning(Object returnValue, Method method, Object[] args, Object target) throws Throwable {
        System.out.println("执行了" + target.getClass().getName() +"的"+method.getName()+"方法," +"返回值:"+returnValue);
    }
}
```

- 在Spring的配置文件中注册 , 并实现aop切入实现 , 注意导入约束

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
                           http://www.springframework.org/schema/beans/spring-beans.xsd
                           http://www.springframework.org/schema/aop
                           http://www.springframework.org/schema/aop/spring-aop.xsd">
    <!--aop的配置-->
    <aop:config>
        <!--切入点 expression:表达式匹配要执行的方法-->
        <aop:pointcut id="pointcut" expression="execution(* com.example.service.UserServiceImpl.*(..))"/>
        <!--执行环绕; advice-ref执行方法 . pointcut-ref切入点-->
        <aop:advisor advice-ref="beforeLog" pointcut-ref="pointcut"/>
        <aop:advisor advice-ref="afterLog" pointcut-ref="pointcut"/>
    </aop:config>

</beans>
```

- 测试

```java
public class MyTest {
    @Test
    void test(){
        ApplicationContext context = new ClassPathXmlApplicationContext("beans.xml");
        UserService userService = (UserService) context.getBean("userService");
        userService.search();
    }
}
```

- Spring的Aop就是将公共的业务 (日志 , 安全等) 和领域业务结合起来
- 当执行领域业务时,将会把公共业务加进来,实现公共业务的重复利用,领域业务更纯粹,其本质还是动态代理

### 自定义类来实现AOP

- 目标业务类不变依旧是userServiceImpl
- 编写自定义切入类

```java
@Component
public class DiyPointcut {

    public void before(){
        System.out.println("---------方法执行前---------");
    }
    public void after(){
        System.out.println("---------方法执行后---------");
    }

}
```

- 在Spring配置文件中配置

```xml
<!--aop的配置-->
<aop:config>
    <aop:aspect ref="diy">
        <aop:pointcut id="diyPonitcut" expression="execution(* com.example.service.UserServiceImpl.*(..))"/>
        <aop:before pointcut-ref="diyPonitcut" method="before"/>
        <aop:after pointcut-ref="diyPonitcut" method="after"/>
    </aop:aspect>
</aop:config>
```

- 测试

```java
public class MyTest {
    @Test
    void test(){
        ApplicationContext context = new ClassPathXmlApplicationContext("beans.xml");
        UserService userService = (UserService) context.getBean("userService");
        userService.add();
    }
}
```

### 使用注解实现AOP

- 编写一个注解实现的增强类

```java
@Aspect
@Component
public class AnnotationPointcut {
    @Before("execution(* com.example.service.UserServiceImpl.*(..))")
    public void before(){
        System.out.println("---------方法执行前---------");
    }

    @After("execution(* com.example.service.UserServiceImpl.*(..))")
    public void after(){
        System.out.println("---------方法执行后---------");
    }

    @Around("execution(* com.example.service.UserServiceImpl.*(..))")
    public void around(ProceedingJoinPoint jp) throws Throwable {
        System.out.println("环绕前");
        System.out.println("签名:"+jp.getSignature());
        //执行目标方法proceed
        Object proceed = jp.proceed();
        System.out.println("环绕后");
        System.out.println(proceed);
    }
}
```

- 在Spring配置文件中增加支持注解的配置,或者在主启动类上添加一个@EnableAspectJAutoProxy注解,有了这个配置才能支持@Aspect等相关的一系列AOP注解的功能

```xml
<aop:aspectj-autoproxy/>
```

- **aspectj-autoproxy**
    - 通过aop命名空间的`<aop:aspectj-autoproxy />`声明自动为Spring容器中那些配置`@aspect`切面的bean创建代理, 织入切面
    - Spring 在内部依旧采用`AnnotationAwareAspectJAutoProxyCreator`进行自动代理的创建工作, 但具体实现的细节已经被`<aop:aspectj-autoproxy />`隐藏起来了
    - `<aop:aspectj-autoproxy />`有一个`proxy-target-class`属性, 默认为false, 表示使用JDK动态代理织入增强, 当配为`<aop:aspectj-autoproxy  poxy-target-class="true"/>`时, 表示使用CGLib动态代理技术织入增强,不过即使`proxy-target-class`设置为false, 如果目标类没有声明接口, 则Spring将自动使用CGLib动态代理

## Spring Boot

### pom.xml

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-aop</artifactId>
</dependency>
```

### 表达式绑定方法

```java
@Aspect
@Component
public class LoggingAspect {
    // 在执行UserService的每个方法前执行:
    @Before("execution(public * com.itranswarp.learnjava.service.UserService.*(..))")
    public void doAccessCheck() {
        System.err.println("[Before] do access check...");
    }

    // 在执行MailService的每个方法前后执行:
    @Around("execution(public * com.itranswarp.learnjava.service.MailService.*(..))")
    public Object doLogging(ProceedingJoinPoint pjp) throws Throwable {
        System.err.println("[Around] start " + pjp.getSignature());
        Object retVal = pjp.proceed();
        System.err.println("[Around] done " + pjp.getSignature());
        return retVal;
    }
}
```

### 注解绑定方法

- 我们以一个实际例子演示如何使用注解实现AOP装配,为了监控应用程序的性能,我们定义一个性能监控的注解

```java
@Target(METHOD)
@Retention(RUNTIME)
public @interface MetricTime {
    String value();
}
```

- 在需要被监控的关键方法上标注该注解

```java
@Component
public class UserService {
    // 监控register()方法性能:
    @MetricTime("register")
    public User register(String email, String password, String name) {
        ...
    }
    ...
}
```

- 然后,我们定义`MetricAspect`

```java
@Aspect
@Component
public class MetricAspect {

    @Pointcut("@annotation(com.example.annotation.metricTime)")
    private void pointcut() {
    }


    @Around("pointcut() && @annotation(metricTime)")
    public Object metric(ProceedingJoinPoint joinPoint, MetricTime metricTime) throws Throwable {
        String name = metricTime.value();
        long start = System.currentTimeMillis();
        try {
            return joinPoint.proceed();
        } finally {
            long t = System.currentTimeMillis() - start;
            // 写入日志或发送至JMX:
            System.err.println("[Metrics] " + name + ": " + t + "ms");
        }
    }
}
```

- 注意`metric()`方法标注了`@Around("@annotation(metricTime)")`,它的意思是,符合条件的目标方法是带有`@MetricTime`注解的方法,因为`metric()`方法参数类型是`MetricTime`(注意参数名是`metricTime`不是`MetricTime`),我们通过它获取性能监控的名称
- 有了`@MetricTime`注解,再配合`MetricAspect`,任何Bean,只要方法标注了`@MetricTime`注解,就可以自动实现性能监控,运行代码,输出结果如下:

```
Welcome, Bob!
[Metrics] register: 16ms
```
