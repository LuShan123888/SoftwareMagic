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

- 控制反转,是把传统上由程序代码直接操控的对象的调用权交给容器,由容器来创建对象并管理对象之间的依赖关系,DI是对IoC更准确的描述,即由容器动态的将某种依赖关系注入到组件之中

- **IoC的原理**

    1. 定义用来描述bean的配置的Java类或配置文件
    2. 解析bean的配置,将bean的配置信息转换为的BeanDefinition对象保存在内存中,spring中采用HashMap进行对象存储,其中会用到一些xml解析技术

    - 遍历存放BeanDefinition的HashMap对象,逐条取出BeanDefinition对象,获取bean的配置信息,利用Java的反射机制实例化对象,将实例化后的对象保存在另外一个Map中

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

