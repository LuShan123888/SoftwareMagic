---
title: Spring 依赖注入
categories:
- Software
- Backend
- Java
- SpringFramework
- Spring
---
# Spring 依赖注入

##  @Autowired

- 自动装配,用于替代基于XML配置的自动装配
- @Autowired是按类型自动转配的,不支持id匹配

### required

- @Autowired默认是根据参数类型进行自动装配,且必须有一个Bean候选者注入默认`required=true`,如果允许出现0个Bean候选者需要设置属性`required=false`
- `required`属性含义和`@Required`一样,只是`@Required`只适用于基于XML配置的setter注入方式,只能打在setting方法上

### 构造器注入

- 通过将@Autowired注解放在构造器上来完成构造器注入,默认构造器参数通过类型自动装配,如下所示:

```java
package cn.javass.spring.chapter12;  
import org.springframework.beans.factory.annotation.Autowired;  
public class TestBean11 {  
    private String message;  
    @Autowired //构造器注入  
    private TestBean11(String message) {  
        this.message = message;  
    }  
    //省略message的getter和setter  
}  
```

- 在Spring配置文件添加如下Bean配置:

```html
<bean id="testBean" class="cn.javass.spring.chapter12.TestBean11"/>
```

- 测试

```java
@Test  
public void testAutowiredForConstructor() {  
    TestBean11 testBean11 = ctx.getBean("testBean11", TestBean11.class);  
    Assert.assertEquals("hello", testBean11.getMessage());  
}  
```

- 在Spring配置文件中没有对"testBean”进行构造器注入和setter注入配置,而是通过在构造器上添加@ Autowired来完成根据参数类型完成构造器注入

### 字段注入

- 字段注入在基于XML配置中无相应概念,字段注入不支持静态类型字段的注入
- 通过将@Autowired注解放在字段上来完成字段注入
- 使用字段自动注入可以省略setter方法

```java
package cn.javass.spring.chapter12;  
import org.springframework.beans.factory.annotation.Autowired;  
public class TestBean12 {  
    @Autowired //字段注入  
    private String message;  
    //省略getter和setter  
} 
```

- 在Spring配置文件添加如下Bean配置:

```html
<bean id="testBean12" class="cn.javass.spring.chapter12.TestBean12"/>
```

- 测试

```java
@Test  
public void testAutowiredForField() {  
    TestBean12 testBean12 = ctx.getBean("testBean12", TestBean12.class);  
    Assert.assertEquals("hello", testBean12.getMessage());  
}  
```

### 方法参数注入

- 通过将@Autowired注解放在方法上来完成方法参数注入
-  方法参数注入除了支持setter方法注入,还支持1个或多个参数的普通方法注入
- 在基于XML配置中不支持1个或多个参数的普通方法注入
- 方法注入不支持静态类型方法的注入

```java
package cn.javass.spring.chapter12;  
import org.springframework.beans.factory.annotation.Autowired;  
public class TestBean13 {  
    private String message;  
    @Autowired //setter方法注入  
    public void setMessage(String message) {  
        this.message = message;  
    }  
    public String getMessage() {  
        return message;  
    }  
}  
```

```java
package cn.javass.spring.chapter12;  
//省略import  
public class TestBean14 {  
    private String message;  
    private List<String> list;  
    @Autowired(required = true) //任意一个或多个参数方法注入  
    private void initMessage(String message, ArrayList<String> list) {  
        this.message = message;  
        this.list = list;  
    }  
    //省略getter和setter  
}  
```

- 在Spring配置文件添加如下Bean配置:

```html
<bean id="testBean13" class="cn.javass.spring.chapter12.TestBean13"/>  
<bean id="testBean14" class="cn.javass.spring.chapter12.TestBean14"/>  
<bean id="list" class="java.util.ArrayList">  
    <constructor-arg index="0">  
        <list>  
            <ref bean="message"/>  
            <ref bean="message"/>  
        </list>  
   </constructor-arg>          
</bean>  
```

- 测试

```java
@Test  
public void testAutowiredForMethod() {  
    TestBean13 testBean13 = ctx.getBean("testBean13", TestBean13.class);  
    Assert.assertEquals("hello", testBean13.getMessage());  
   
    TestBean14 testBean14 = ctx.getBean("testBean14", TestBean14.class);  
    Assert.assertEquals("hello", testBean14.getMessage());  
    Assert.assertEquals(ctx.getBean("list", List.class), testBean14.getList());  
}  
```

## @Qualifier

- @Autowired是根据类型自动装配的, 加上@Qualifier则可以根据byName的方式自动装配
- @Qualifier不能单独使用

**测试**

- 配置文件修改内容, 保证类型存在对象,且名字不为类的默认名字

```xml
<bean id="dog1" class="com.example.pojo.Dog"/>
<bean id="dog2" class="com.example.pojo.Dog"/>
<bean id="cat1" class="com.example.pojo.Cat"/>
<bean id="cat2" class="com.example.pojo.Cat"/>
```

- 没有加Qualifier测试, 直接报错
- 在属性上添加Qualifier注解

```java
@Autowired
@Qualifier(value = "cat2")
private Cat cat;
@Autowired
@Qualifier(value = "dog2")
private Dog dog;
```

- 测试正常

## @Resource

- @Resource如有指定的name属性, 先按该属性进行byName方式查找装配
- 其次再进行默认的byName方式进行装配
- 如果以上都不成功, 则按byType的方式自动装配
- 都不成功, 则报异常

**测试**

- 实体类:

```java
public class User {
   //如果允许对象为null, 设置required = false,默认为true
   @Resource(name = "cat2")
   private Cat cat;
   @Resource
   private Dog dog;
   private String str;
}
```

- beans.xml

```xml
<bean id="dog" class="com.example.pojo.Dog"/>
<bean id="cat1" class="com.example.pojo.Cat"/>
<bean id="cat2" class="com.example.pojo.Cat"/>

<bean id="user" class="com.example.pojo.User"/>
```

- 测试正常
- beans.xml ,删掉cat2

```xml
<bean id="dog" class="com.example.pojo.Dog"/>
<bean id="cat1" class="com.example.pojo.Cat"/>
```

- 实体类上只保留注解

```java
@Resource
private Cat cat;
@Resource
private Dog dog;
```

- 测试正常
- 先进行byName查找,失败,再进行byType查找, 成功

### @Autowired与@Resource异同:

- @Autowired与@Resource都可以用来装配bean,都可以写在字段上, 或写在setter方法上
- @Autowired默认按类型装配(属于Spring规范), 默认情况下必须要求依赖对象必须存在, 如果要允许null 值, 可以设置它的required属性为false, 如:@Autowired(required=false), 如果我们想使用名称装配可以结合@Qualifier注解进行使用
- @Resource(属于J2EE复返), 默认按照名称进行装配, 名称可以通过name属性进行指定,如果没有指定name属性, 当注解写在字段上时, 默认取字段名进行按照名称查找, 如果注解写在setter方法上默认取属性名进行装配,当找不到与名称匹配的bean时才按照类型进行装配,但是需要注意的是, 如果name属性一旦指定, 就只会按照名称进行装配
- 它们的作用相同都是用注解方式注入对象, 但执行顺序不同,@Autowired先byType, @Resource先byName

## Setter方法注入

- 要求被注入的属性 , 必须有set方法 , set方法的方法名由`set + 属性首字母大写`,如果该属性类型为boolean,必须有is方法
- `<bean>`代表java类
    - `id`:bean的唯一标识符
    - `name`:class属性的一个别名
        - 如果不指定id,只指定name,那么name为Bean的标识符,并且需要在容器中唯一
        - 同时指定name和id,此时id为标识符,而name为Bean的别名,两者都可以找到目标Bean
    - `class`:类的全名
- `<property>`代表类中的属性
    - `name`:属性名
    - `ref`:引用其他的bean

### Bean注入

```java
 <bean id="addr" class="com.example.pojo.Address">
     <property name="address" value="重庆"/>
 </bean>

 <bean id="student" class="com.example.pojo.Student">
     <property name="name" value="小明"/>
     <property name="address" ref="addr"/>
 </bean>
```

### 常量注入

- `value`:表示属性的值

```xml
 <bean id="student" class="com.example.pojo.Student">
     <property name="name" value="小明"/>
 </bean>
```

- 测试

```java
 @Test
 public void test01(){
     ApplicationContext context = newClassPathXmlApplicationContext("applicationContext.xml");
     Student student = (Student) context.getBean("student");
     System.out.println(student.getName());
 }
```

### 数组注入

```java
 <bean id="student" class="com.example.pojo.Student">
     <property name="name" value="小明"/>
     <property name="address" ref="addr"/>
     <property name="books">
         <array>
             <value>西游记</value>
             <value>红楼梦</value>
             <value>水浒传</value>
         </array>
     </property>
 </bean>
```

### List注入

```java
 <property name="hobbys">
     <list>
         <value>听歌</value>
         <value>看电影</value>
         <value>爬山</value>
     </list>
 </property>
```

### Map注入

```java
 <property name="card">
     <map>
         <entry key="中国邮政" value="456456456465456"/>
         <entry key="建设" value="1456682255511"/>
     </map>
 </property>
```

### set注入

```java
 <property name="games">
     <set>
         <value>LOL</value>
         <value>BOB</value>
         <value>COC</value>
     </set>
 </property>
```

### Null注入

```java
 <property name="wife"><null/></property>
```

### Properties注入

```java
 <property name="info">
     <props>
         <prop key="学号">20190604</prop>
         <prop key="性别">男</prop>
         <prop key="姓名">小明</prop>
     </props>
 </property>
```

## p命名和c命名注入

```java
 public class User {
     private String name;
     private int age;

     public void setName(String name) {
         this.name = name;
    }

     public void setAge(int age) {
         this.age = age;
    }

     @Override
     public String toString() {
         return "User{" +
                 "name='" + name + '\'' +
                 ", age=" + age +
                 '}';
    }
 }
```

### P命名空间注入

- 需要在头文件中加入约束文件

```
xmlns:p="http://www.springframework.org/schema/p"
```

- P(属性: properties)命名空间 , 属性依然要设置set方法

```xml
 <bean id="user" class="com.example.pojo.User" p:name="test" p:age="18"/>
```

### C命名空间注入

- 需要在头文件中加入约束文件

```
 xmlns:c="http://www.springframework.org/schema/c"
```

- C(构造: Constructor)命名空间 , 属性依然要设置set方法
- 需要加上有参构造器

```xml
 <bean id="user" class="com.example.pojo.User" c:name="test" c:age="18"/>
```

## 构造器注入

- 构造器注入是指带有参数的构造函数注入
- `<constructor-arg>`:bean中有参构造函数的形式参数
    - `ref`:引用其他的bean

### 根据index参数下标设置

```html
<bean id="userT" class="com.example.pojo.UserT">
   <!-- index指构造方法 , 下标从0开始 -->
   <constructor-arg index="0" ref="name"/>
</bean>
```

### 根据参数名字设置

```xml
<bean id="userT" class="com.example.pojo.UserT">
   <!-- name指参数名 -->
   <constructor-arg name="name" ref="name"/>
</bean>
```

### 根据参数类型设置

```xml
<bean id="userT" class="com.example.pojo.UserT">
   <constructor-arg type="java.lang.String" ref="name"/>
</bean>
```

## 自动装配

- 在Spring中,支持 5 自动装配模式
    - **no** – 缺省情况下,自动配置是通过"ref”属性手动设定
    - **byName** – 根据属性名称自动装配,如果一个bean的名称和其他bean属性的名称是一样的,将会自装配它
    - **byType** – 按数据类型自动装配,如果一个bean的数据类型是用其它bean属性的数据类型,兼容并自动装配它
    - **constructor** – 在构造函数参数的byType方式
    - **autodetect** – 如果找到默认的构造函数,使用"自动装配用构造”; 否则,使用"按类型自动装配”
- Spring的自动装配的步骤
    - 组件扫描(component scanning):Spring会自动发现应用上下文中所创建的bean
    - 自动装配(autowiring):Spring自动满足bean之间的依赖,也就是我们说的IoC/DI

### 配置

- 在Spring框架,可以用 `auto-wiring` 功能会自动装配Bean,要启用它,只需要在 `<bean>` 定义`autowire`属性
- `<beans>`标签可以定义 `default-autowire-candidate="false"`属性让它和它包含的所有 `bean` 都不做为候选`bean`

```xml
1 <bean id="customer" class="com.yiibai.common.Customer" autowire="byName" />
```

### byType

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans.xsd">

    <!-- Type自动装配注入 -->
    <bean id="userServerId" class="serviceImpl.UserServiceImpl" autowire="byType"/>
    	<!-- id可以与bean的属性名可以一样  -->
    	<bean id="userDaoId" class="daoImpl.UserDaoImpl"></bean>
</beans>
```

### byName

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans.xsd">

    <!-- Name 自动装配注入 -->
    <bean id="userServerId" class="serviceImpl.UserServiceImpl" autowire="byName"/>
    	<!-- id必须与bean的属性名一样 -->
    	<bean id="userDao" class="daoImpl.UserDaoImpl"></bean>
</beans>
```

### constructor

- 自动装配用构造函数启用后,你可以不设置构造器属性,Spring会找到兼容的数据类型,并自动装配它

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans.xsd">

     <!-- Constructor  构造自动装配 -->
     <bean id="dogId" class="serviceImpl.DogServiceImpl" autowire="constructor"/>
    	<!-- id可以与bean的属性名可以一样  -->
    	<bean id="dogDaos" class="daoImpl.DogDaoImpl"></bean>
</beans>
```

## 静态工厂的方法注入

- 静态工厂顾名思义,就是通过调用静态工厂的方法来获取自己需要的对象
- 为了让Spring管理所有对象,我们不能直接通过"工程类.静态方法()"来获取对象,而是依然通过spring注入的形式获取:

```java
package com.bless.springdemo.factory;  

public class DaoFactory {  
    //静态工厂  
    public static final FactoryDao getFactoryDao(){  
        return new FacotryDao();  
    }  
}  
```

- 需要注入一个FactoryDao对象,看起来跟setter注入一模一样,但是xml会有很大差别:

```java
 public class SpringAction {  
        //注入对象  
    private FactoryDao factoryDao;  
      
    //注入对象的set方法  
    public void setFactoryDao(FactoryDao factoryDao) {  
        this.factoryDao = factoryDao;  
    }  
}  
```

- Spring的IOC配置文件,注意看`<bean name="staticFactoryDao">`指向的class并不是FactoryDao,而是指向静态工厂DaoFactory,并且配置 `factory-method="getFactoryDao"`指定调用哪个工厂方法:

```html
<!--配置bean,配置后该类由Spring管理-->  
    <bean name="springAction" class="com.bless.springdemo.action.SpringAction" >  
        <!--使用静态工厂的方法注入对象,对应下面的配置文件-->  
        <property name="factoryDao" ref="factoryDao"></property>
    </bean>  
    <!--此处获取对象的方式是从工厂类中获取静态方法-->  
    <bean name="factoryDao" class="com.bless.springdemo.factory.DaoFactory" factory-method="getFactoryDao"></bean>  
```

##    实例工厂的方法注入

- 实例工厂的意思是获取对象实例的方法不是静态的,所以需要首先new工厂类,再调用普通的实例方法:

```java
public class DaoFactory {  
    //实例工厂  
    public FactoryDao getFactoryDao(){  
        return new FactoryDao();  
    }  
}  
```

- 需要通过实例工厂类创建FactoryDao对象:

```java
public class SpringAction {  
    //注入对象  
    private FactoryDao factoryDao;  
      
    public void setFactoryDao(FactoryDao factoryDao) {  
        this.factoryDao = factoryDao;  
    }  
} 
```

- 最后看Spring配置文件:

```html
<!--配置bean,配置后该类由Spring管理-->  
    <bean name="springAction" class="com.bless.springdemo.action.SpringAction">  
        <!--使用实例工厂的方法注入对象,对应下面的配置文件-->  
        <property name="factoryDao" ref="factoryDao"></property>  
    </bean>  
      
    <!--此处获取对象的方式是从工厂类中获取实例方法-->  
    <bean name="daoFactory" class="com.bless.springdemo.factory.DaoFactory"></bean>  
    <bean name="factoryDao" factory-bean="daoFactory" factory-method="getFactoryDaoImpl"></bean> 
```

## Bean的作用域

- 在Spring中,那些组成应用程序的主体及由Spring IoC容器所管理的对象,被称之为bean
- bean就是由IoC容器初始化,装配及管理的对象

![img](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-640-20201017143022056.png)

- 几种作用域中,request,session作用域仅在基于web的应用中使用(不必关心你所采用的是什么web应用框架),只能用在基于web的Spring ApplicationContext环境

#### Singleton

- 当一个bean的作用域为Singleton,那么Spring IoC容器中只会存在一个共享的bean实例,并且所有对bean的请求,只要id与该bean定义相匹配,则只会返回bean的同一实例,Singleton是单例类型,就是在创建起容器时就同时自动创建了一个bean的对象,不管你是否使用,他都存在了,每次获取到的对象都是同一个对象,注意,Singleton作用域是Spring中的缺省作用域,要在XML中将bean定义成singleton,可以这样配置:

```xml
 <bean id="ServiceImpl" class="cn.csdn.service.ServiceImpl" scope="singleton">
```

- 测试

```java
 @Test
 public void test03(){
     ApplicationContext context = newClassPathXmlApplicationContext("applicationContext.xml");
     User user = (User) context.getBean("user");
     User user2 = (User) context.getBean("user");
     System.out.println(user==user2);
 }
```

#### Prototype

- 当一个bean的作用域为Prototype,表示一个bean定义对应多个对象实例,Prototype作用域的bean会导致在每次对该bean请求(将其注入到另一个bean中,或者以程序的方式调用容器的getBean()方法)时都会创建一个新的bean实例,Prototype是原型类型,它在我们创建容器的时候并没有实例化,而是当我们获取bean的时候才会去创建一个对象,而且我们每次获取到的对象都不是同一个对象,根据经验,对有状态的bean应该使用prototype作用域,而对无状态的bean则应该使用singleton作用域,在XML中将bean定义成prototype,可以这样配置:

```java
 <bean id="account" class="com.foo.DefaultAccount" scope="prototype"/>
  或者
 <bean id="account" class="com.foo.DefaultAccount" singleton="false"/>
```

#### Request

- 当一个bean的作用域为Request,表示在一次HTTP请求中,一个bean定义对应一个实例,即每个HTTP请求都会有各自的bean实例,它们依据某个bean定义创建而成,该作用域仅在基于web的Spring ApplicationContext情形下有效,考虑下面bean定义:

```xml
 <bean id="loginAction" class=cn.csdn.LoginAction" scope="request"/>
```

- 针对每次HTTP请求,Spring容器会根据loginAction bean的定义创建一个全新的LoginAction bean实例,且该loginAction bean实例仅在当前HTTP request内有效,因此可以根据需要放心的更改所建实例的内部状态,而其他请求中根据loginAction bean定义创建的实例,将不会看到这些特定于某个请求的状态变化,当处理请求结束,request作用域的bean实例将被销毁

#### Session

- 当一个bean的作用域为Session,表示在一个HTTP Session中,一个bean定义对应一个实例,该作用域仅在基于web的Spring ApplicationContext情形下有效,考虑下面bean定义:

```xml
 <bean id="userPreferences" class="com.foo.UserPreferences" scope="session"/>
```

- 针对某个HTTP Session,Spring容器会根据userPreferences bean定义创建一个全新的userPreferences bean实例,且该userPreferences bean仅在当前HTTP Session内有效,与request作用域一样,可以根据需要放心的更改所创建实例的内部状态,而别的HTTP Session中根据userPreferences创建的实例,将不会看到这些特定于某个HTTP Session的状态变化,当HTTP Session最终被废弃的时候,在该HTTP Session作用域内的bean也会被废弃掉