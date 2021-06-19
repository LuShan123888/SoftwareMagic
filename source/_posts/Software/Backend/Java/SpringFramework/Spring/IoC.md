---
title: Spring IoC 控制反转
categories:
- Software
- Backend
- Java
- SpringFramework
- Spring
---
# Spring IoC 控制反转

## IoC本质

- 控制反转是一种通过描述(XML或注解)并通过第三方去生产或获取特定对象的方式,在Spring中实现控制反转的是IoC容器,其实现方法是依赖注入(Dependency Injection,DI)
- 没有IoC的程序中 , 我们使用面向对象编程 , 对象的创建与对象间的依赖关系完全硬编码在程序中,对象的创建由程序自己控制,控制反转后将对象的创建转移给第三方

![img](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-640-20201016203359477.png)

- IoC是Spring框架的核心内容,使用多种方式完美的实现了IoC,可以使用XML配置,也可以使用注解,新版本的Spring也可以零配置实现IoC
- Spring容器在初始化时先读取配置文件,根据配置文件或元数据创建与组织对象存入容器中,程序使用时再从Ioc容器中取出需要的对象

![img](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-640-20201016203359479.png)

- 采用XML方式配置Bean的时候,Beanw的定义信息是和实现分离的,而采用注解的方式可以把两者合为一体,Bean的定义信息直接以注解的形式定义在实现类中,从而达到了零配置的目的

## IoC实例

- UserDao接口

```java
public interface UserDao {
   public void getUser();
}
```

- Dao的实现类

```java
public class UserDaoMySqlImpl implements UserDao {
   @Override
   public void getUser() {
       System.out.println("MySql获取用户数据");
  }
}
```

- UserService接口

```java
public interface UserService {
   public void getUser();
}
```

- Service的实现类

```java
public class UserServiceImpl implements UserService {
   private UserDao userDao = new UserDaoMySqlImpl();

   @Override
   public void getUser() {
       userDao.getUser();
  }
}
```

- 测试

```java
@Test
public void test(){
   UserService service = new UserServiceImpl();
   service.getUser();
}
```

- 这是原来的方式 , 现在修改一下
- 把Userdao的实现类增加一个

```java
public class UserDaoOracleImpl implements UserDao {
   @Override
   public void getUser() {
       System.out.println("Oracle获取用户数据");
  }
}
```

- 紧接着我们要去使用MySql的话 , 我们就需要去service实现类里面修改对应的实现

```java
public class UserServiceImpl implements UserService {
   private UserDao userDao = new UserDaoOracleImpl();

   @Override
   public void getUser() {
       userDao.getUser();
  }
}
```

- 那么要使用其他的Dao , 又需要去service实现类里面修改对应的实现
- 这种设计的耦合性太高了, 牵一发而动全身

**解决方法**

- 可以在需要用到的地方 , 不去实现它 , 而是留出一个接口 , 利用set方法注入

```java
public class UserServiceImpl implements UserService {
   private UserDao userDao;
    // 利用set实现注入不同的Dao
   public void setUserDao(UserDao userDao) {
       this.userDao = userDao;
  }

   @Override
   public void getUser() {
       userDao.getUser();
  }
}
```

- 测试

```java
@Test
public void test(){
   UserService service = new UserServiceImpl();
   //用Mysql实现
    service.setUserDao( new UserDaoMySqlImpl() );
    service.getUser();
   //用Oracle实现
   service.setUserDao( new UserDaoOracleImpl() );
   service.getUser();
}
```

- 以前所有对象都是由程序去进行控制创建 , 而现在是由我们自行控制创建对象 , 把主动权交给了调用者
- 这种思想 , 从本质上解决了问题 , 程序员不再去管理对象的创建了 , 更多的去关注业务的实现 . 耦合性大大降低 . 这也就是IOC的原型
- 使用Spring , 只需要在xml配置文件中进行修改

```java
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans.xsd">

   <bean id="MysqlImpl" class="com.example.dao.impl.UserDaoMySqlImpl"/>
   <bean id="OracleImpl" class="com.example.dao.impl.UserDaoOracleImpl"/>

   <bean id="ServiceImpl" class="com.example.service.impl.UserServiceImpl">
       <!--注意: 这里的name并不是属性 , 而是set方法后面的那部分 , 首字母小写-->
       <!--引用另外一个bean , 不是用value 而是用 ref-->
       <property name="userDao" ref="OracleImpl"/>
   </bean>
</beans>
```

- 测试

```java
@Test
public void test2(){
   ApplicationContext context = new ClassPathXmlApplicationContext("beans.xml");
   UserService service = (UserServiceImpl) context.getBean("ServiceImpl");
   service.getUser();
}
```

