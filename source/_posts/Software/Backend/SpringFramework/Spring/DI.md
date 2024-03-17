---
title: Spring DI
categories:
- Software
- BackEnd
- SpringFramework
- Spring
---
# Spring DI

## Bean的实现

### @Component

1. 配置扫描包的注解

```xml
<!--指定注解扫描包-->
<context:component-scan base-package="com.example.entity"/>
```

2. 在指定包下编写类，增加注解

```java
@Component("user")
public class User {
    public String name = "test";
}
```

- 相当于配置文件中`<bean id="user" class="当前注解的类"/>`

- **@Component三个衍生注解**:为了更好的进行分层, Spring可以使用其它三个注解，功能一样，目前使用哪一个功能都一样
    - **@Controller**:Web层
    - **@Service**:Service层
    - **@Repository**:Dao层
- 写上这些注解，就相当于将这个类交给Spring管理装配了

### @Configuration&@Bean&@Import

- JavaConfig 原来是 Spring 的一个子项目，它通过 Java 类的方式提供 Bean 的定义信息，在 Spring4 的版本,  JavaConfig 已正式成为 Spring4 的核心功能

**实例**

2. 新建一个config配置包，编写一个MyConfig配置类

```java
@Configuration  // 代表这是一个配置类
public class MyConfig {
    @Bean // 通过方法注册一个bean, 这里的返回值就Bean的类型，方法名就是bean的id
    public Dog dog(){
        return new Dog();
    }
}
```

**导入其他配置**

1. 编写一个配置类

```java
@Configuration  // 代表这是一个配置类
public class MyConfig {
    @Bean
    public Dog dog(){
        return new Dog();
    }
}
```

2. 在之前的配置类中选择导入这个配置类

```java
@Configuration
@Import(MyConfig.class)  // 导入合并其他配置类，类似于配置文件中的 inculde 标签
public class MyConfig2 {
}
```

## 属性注入

###  @Autowired

- 自动装配，用于替代基于XML配置的自动装配
- @Autowired默认按类型装配（属于Spring规范), 默认情况下必须要求依赖对象必须存在，如果要允许null 值，可以设置它的required属性为false, 如果我们想使用名称装配可以结合@Qualifier注解进行使用

#### required

- @Autowired默认是根据参数类型进行自动装配，且必须有一个Bean候选者注入默认`required=true`,如果允许出现0个Bean候选者需要设置属性`required=false`
- `required`属性含义和`@Required`一样，只是`@Required`只适用于基于XML配置的setter注入方式，只能打在setting方法上

#### 构造器注入

- 通过将@Autowired注解放在构造器上来完成构造器注入，默认构造器参数通过类型自动装配，如下所示:

```java
@Data
public class TestBean {  

    private String message;

    @Autowired
    private TestBean(String message) {  
        this.message = message;  
    }  
}  
```

#### 字段注入

- 字段注入在基于XML配置中无相应概念，字段注入不支持静态类型字段的注入
- 通过将@Autowired注解放在字段上来完成字段注入
- 使用字段自动注入可以省略setter方法

```java
@Data
public class TestBean { 

    @Autowired // 字段注入  
    private String message;  
} 
```

#### 方法参数注入

- 通过将@Autowired注解放在方法上来完成方法参数注入
-  方法参数注入除了支持setter方法注入，还支持1个或多个参数的普通方法注入
- 在基于XML配置中不支持1个或多个参数的普通方法注入
- 方法注入不支持静态类型方法的注入

```java
@Data
public class TestBean {  

    private String message;  

    @Autowired //setter方法注入  
    public void setMessage(String message) {  
        this.message = message;  
    }
}  
```

```java
@Data
public class TestBean {  

    private String message;  

    private List<String> list;  

    @Autowired // 任意一个或多个参数方法注入  
    private void initMessage(String message, ArrayList<String> list) {  
        this.message = message;  
        this.list = list;  
    }  

}  
```

### @Qualifier

- @Autowired是基于byType自动装配的，加上@Qualifier则可以根据byName的方式自动装配
- @Qualifier不能单独使用

**测试**

```java
@Autowired
@Qualifier(value = "cat1")
private Cat cat;

@Autowired
@Qualifier(value = "cat2")
private Cat cat;
```

### @Resource

- @Resource(属于J2EE规范), 默认按照名称进行装配
- 名称可以通过name属性进行指定，如果没有指定name属性，当注解写在字段上时，默认取字段名进行按照名称查找，如果注解写在setter方法上默认取属性名进行装配，当找不到与名称匹配的bean时才按照类型进行装配
- **注意**:如果name属性一旦指定，就只会按照名称进行装配

**测试**

- 实体类

```java
public class User {

    @Resource(name = "cat2")
    private Cat cat;

    @Resource
    private Dog dog;

}
```

### @Value

- 可以不用提供set方法，直接在直接名上添加@Value("值")

```java
@Component("user")
public class User {

    @Value("test")
    public String name;
}
```

- 相当于配置文件中`<property name="name" value="test"/>`
- 除了字面量，也可以使用其他表达式获得值

```java
@Component
public class User {

    @Value("${user.name}") // 从配置文件中取值
    private String name;
    @Value("#{9*2}")  // #{SPEL} Spring表达式
    private int age;
    @Value("男")  // 字面量
    private String sex;

}
```

### Setter方法注入

- 要求被注入的属性，必须有set方法 , set方法的方法名由`set + 属性首字母大写`,如果该属性类型为boolean,必须有is方法
- `<bean>`代表java类
    - `id`:bean的唯一标识符
    - `name`:class属性的一个别名
        - 如果不指定id,只指定name,那么name为Bean的标识符，并且需要在容器中唯一
        - 同时指定name和id,此时id为标识符，而name为Bean的别名，两者都可以找到目标Bean
    - `class`:类的全名
- `<property>`代表类中的属性
    - `name`:属性名
    - `ref`:引用其他的bean

#### Bean注入

```xml
<bean id="student" class="com.example.entity.Student">
    <property name="name" value="小明"/>
    <property name="address" ref="addr"/>
</bean>

<bean id="addr" class="com.example.entity.Address">
    <property name="address" value="重庆"/>
</bean>
```

#### 常量注入

- `value`:表示属性的值

```xml
<bean id="student" class="com.example.entity.Student">
    <property name="name" value="小明"/>
</bean>
```

#### 数组注入

```xml
<bean id="student" class="com.example.entity.Student">
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

#### List注入

```xml
<property name="hobbys">
    <list>
        <value>听歌</value>
        <value>看电影</value>
        <value>爬山</value>
    </list>
</property>
```

#### Map注入

```xml
<property name="card">
    <map>
        <entry key="中国邮政" value="456456456465456"/>
        <entry key="建设" value="1456682255511"/>
    </map>
</property>
```

#### Set注入

```xml
<property name="games">
    <set>
        <value>LOL</value>
        <value>BOB</value>
        <value>COC</value>
    </set>
</property>
```

#### Null注入

```java
<property name="wife"><null/></property>
```

#### Properties注入

```xml
<property name="info">
    <props>
        <prop key="学号">20190604</prop>
        <prop key="性别">男</prop>
        <prop key="姓名">小明</prop>
    </props>
</property>
```

### p命名空间和c命名空间注入

```java
@Data
public class User {

    private String name;

    private int age;
}
```

#### P命名空间注入

- 需要在头文件中加入约束文件

```xml
xmlns:p="http://www.springframework.org/schema/p"
```

- P(属性: properties)命名空间，属性依然要设置set方法

```xml
<bean id="user" class="com.example.entity.User" p:name="test" p:age="18"/>
```

#### C命名空间注入

- 需要在头文件中加入约束文件

```
 xmlns:c="http://www.springframework.org/schema/c"
```

- C(构造: Constructor)命名空间，属性依然要设置set方法
- 需要加上有参构造器

```xml
<bean id="user" class="com.example.entity.User" c:name="test" c:age="18"/>
```

### 构造器注入

- 构造器注入是指带有参数的构造函数注入
- `<constructor-arg>`:bean中有参构造函数的形式参数

#### 根据参数index设置

```html
<bean id="userT" class="com.example.entity.User">
    <constructor-arg index="0" ref="name"/>
</bean>
```

- index指构造方法参数index , 下标从0开始

#### 根据参数名字设置

```xml
<bean id="userT" class="com.example.entity.User">
    <constructor-arg name="name" ref="name"/>
</bean>
```

#### 根据参数类型设置

```xml
<bean id="userT" class="com.example.entity.User">
    <constructor-arg type="java.lang.String" ref="name"/>
</bean>
```

### 自动装配

- Spring的自动装配的步骤
    - 组件扫描(component scanning):Spring会自动发现应用上下文中所创建的bean
    - 自动装配(autowiring):Spring自动满足bean之间的依赖，也就是我们说的IoC/DI

#### 配置

- 在Spring框架，可以用 `auto-wiring` 功能会自动装配Bean,要启用它，只需要在 `<bean>` 定义`autowire`属性
- `<beans>`标签可以定义 `default-autowire-candidate="false"`属性让它和它包含的所有 `bean` 都不做为候选`bean`

```xml
<bean id="customer" class="com.example.entity.Customer" autowire="byName" />
```

- **autowire**:在Spring中，支持 5 自动装配模式
    - **no**: 缺省情况下，自动配置是通过"ref”属性手动设定
    - **byName**:根据属性名称自动装配，如果一个bean的名称和其他bean属性的名称是一样的，将会自装配它
    - **byType**:按数据类型自动装配，如果一个bean的数据类型是用其它bean属性的数据类型，兼容并自动装配它
    - **constructor**:在构造函数参数的byType方式
    - **autodetect**;如果找到默认的构造函数，使用"自动装配用构造”; 否则，使用"按类型自动装配”

#### byType

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
                           http://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean id="userService" class="com.service.serviceImpl.UserServiceImpl" autowire="byType"/>
    <!-- id可以与bean的属性名不一样  -->
    <bean id="userMapper" class="com.service.mapper.UserMapperImpl"></bean>
</beans>
```

#### byName

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
                           http://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean id="userService" class="com.service.serviceImpl.UserServiceImpl" autowire="byName"/>
    <!-- id必须与bean的属性名一样 -->
    <bean id="userMapper" class="com.service.mapper.UserMapperImpl"></bean>
</beans>
```

#### constructor

- 自动装配用构造函数启用后，你可以不设置构造器属性,Spring会找到兼容的数据类型，并自动装配它

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
                           http://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean id="userService" class="com.service.serviceImpl.UserServiceImpl" autowire="constructor"/>
    <!-- id可以与bean的属性名可以不一样  -->
    <bean id="userMapper" class="com.service.mapper.UserMapperImpl"></bean>
</beans>
```

### 静态工厂的方法注入

- 静态工厂顾名思义，就是通过调用静态工厂的方法来获取自己需要的对象
- 为了让Spring管理所有对象，我们不能直接通过`工程类。静态方法()`来获取对象，而是依然通过spring注入的形式获取:

```java
public class UserMapperFactory {  

    public static final UserMapper getUserMapper(){  
        return new UserMapper();  
    }  

}
```

- 需要注入一个FactoryDao对象，看起来跟setter注入一模一样，但是xml会有很大差别:

```java
public class UserServiceImpl {  

    private UserMapper userMapper;  

    public void setUserMapper(UserMapper userMapper) {  
        this.userMapper = userMapper;  
    }  

}
```

- **注意**:`<bean name="userService">`指向的class并不是userMapper,而是指向静态工厂UserMapperFactory,并且配置 `factory-method`指定调用哪个工厂方法

```xml
<bean name="userService" class="com.example.service.serviceImpl.UserServiceImpl" >  
    <!--使用静态工厂的方法注入对象，对应下面的配置文件-->  
    <property name="userMapper" ref="UserMapperFactory"/>
</bean>  
<!--此处获取对象的方式是从工厂类中获取静态方法-->  
<bean name="UserMapperFactory" class="com.example.mapper.UserMapperFactory" factory-method="getUserMapper"/>
```

###    实例工厂的方法注入

- 实例工厂的意思是获取对象实例的方法不是静态的，所以需要首先new工厂类，再调用普通的实例方法

```java
public class UserMapperFactory {

    public UserMapper getUserMapper(){  
        return new UserMapper();  
    }  
}  
```

- 需要通过实例工厂类创建FactoryDao对象:

```java
public class UserServiceImpl {  

    private UserMapper userMapper;  

    public void setUserMapper(UserMapper userMapper) {  
        this.userMapper = userMapper;  
    }
} 
```

- Spring配置文件

```xml
<bean name="userService" class="com.example.service.serviceImpl.UserServiceImpl">  
    <!--使用实例工厂的方法注入对象，对应下面的配置文件-->  
    <property name="userMapper" ref="userMapper"/>
</bean>  

<!--此处获取对象的方式是从工厂类中获取实例方法-->  
<bean name="userMapperFactory" class="com.example.mapper.UserMapperFactory"/>
<bean name="userMapper" factory-bean="userMapperFactory" factory-method="getUserMapper"/>
```

## Bean的作用域

- 在Spring中，那些组成应用程序的主体及由Spring IoC容器所管理的对象，被称之为Bean
- Bean就是由IoC容器初始化，装配及管理的对象

| 类别      | 说明                                                         |
| --------- | ------------------------------------------------------------ |
| singleton | 在Spring IoC容器中仅存在一个Bean实例,Bean以单例方式存在，默认值 |
| prototype | 每次从容器中调用Bean时，都返回一个新的实例，即每次调用`getBean()`时，相当执行`new XxxBean()` |
| request   | 每次HTTP请求都会创建一个新的Bean,该作用域仅适用于WebApplicationContext环境 |
| session   | 同一个HTTP Session共享一个Bean,不同的Session使用不同Bean,仅适用于WebApplicationContext环境 |

### Singleton

- 当一个bean的作用域为Singleton,那么Spring IoC容器中只会存在一个共享的bean实例，并且所有对bean的请求，只要id与该bean定义相匹配，则只会返回bean的同一实例,Singleton是单例类型，就是在创建起容器时就同时自动创建了一个bean的对象，不管你是否使用，他都存在了，每次获取到的对象都是同一个对象，注意,Singleton作用域是Spring中的缺省作用域，要在XML中将bean定义成singleton,可以这样配置:

```xml
<bean id="user" class="com.example.entity.User" scope="singleton">
```

```java
@Test
public void test(){
    ApplicationContext context = newClassPathXmlApplicationContext("applicationContext.xml");
    User user1 = (User) context.getBean("user");
    User user2 = (User) context.getBean("user");
    System.out.println(user1 == user2);
}
```

### Prototype

- 当一个bean的作用域为Prototype,表示一个bean定义对应多个对象实例,Prototype作用域的bean会导致在每次对该bean请求（将其注入到另一个bean中，或者以程序的方式调用容器的getBean()方法）时都会创建一个新的bean实例
- Prototype是原型类型，它在我们创建容器的时候并没有实例化，而是当我们获取bean的时候才会去创建一个对象，而且我们每次获取到的对象都不是同一个对象，根据经验，对有状态的bean应该使用prototype作用域，而对无状态的bean则应该使用singleton作用域

```xml
<bean id="user" class="com.example.entity.User" scope="prototype"/>
// 或者
<bean id="user" class="com.example.entity.User" singleton="false"/>
```

### Request

- 当一个bean的作用域为Request,表示在一次HTTP请求中，一个bean定义对应一个实例，即每个HTTP请求都会有各自的bean实例，它们依据某个bean定义创建而成，该作用域仅在基于web的Spring ApplicationContext情形下有效，考虑下面bean定义:

```xml
<bean id="loginAction" class="com.example.servlet.loginAction" scope="request"/>
```

- 针对每次HTTP请求,Spring容器会根据loginAction bean的定义创建一个全新的LoginAction bean实例，且该loginAction bean实例仅在当前HTTP request内有效，因此可以根据需要放心的更改所建实例的内部状态，而其他请求中根据loginAction bean定义创建的实例，将不会看到这些特定于某个请求的状态变化，当处理请求结束,request作用域的bean实例将被销毁

### Session

- 当一个bean的作用域为Session,表示在一个HTTP Session中，一个bean定义对应一个实例，该作用域仅在基于web的Spring ApplicationContext情形下有效，考虑下面bean定义:

```xml
<bean id="userPreferences" class="com.example.servlet.userPreferences" scope="session"/>
```

- 针对某个HTTP Session,Spring容器会根据userPreferences bean定义创建一个全新的userPreferences bean实例，且该userPreferences bean仅在当前HTTP Session内有效，与request作用域一样，可以根据需要放心的更改所创建实例的内部状态，而别的HTTP Session中根据userPreferences创建的实例，将不会看到这些特定于某个HTTP Session的状态变化，当HTTP Session最终被废弃的时候，在该HTTP Session作用域内的bean也会被废弃掉

### @Scope

- 使用注解配置Bean的作用域
    - **singleton**:默认的, Spring会采用单例模式创建这个对象，关闭工厂，所有的对象都会销毁
    - **prototype**:原型模式，关闭工厂，所有的对象不会销毁，内部的垃圾回收机制会回收

```java
@Controller("user")
@Scope("prototype")
public class User {

    @Value("test")
    public String name;
}
```
