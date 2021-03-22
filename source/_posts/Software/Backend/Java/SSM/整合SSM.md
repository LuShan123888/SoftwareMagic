---
title: SSM 整合SSM框架
categories:
- Software
- Backend
- Java
- SSM
---
# SSM 整合SSM框架

## Mysql

```sql
CREATE DATABASE `test`;

USE `test`;

DROP TABLE IF EXISTS `user`;

CREATE TABLE `user` (
  `user_id` INT(10) NOT NULL AUTO_INCREMENT COMMENT '用户编号' PRIMARY KEY,
  `user_name` VARCHAR(100) NOT NULL COMMENT '用户名',
  `user_pwd` VARCHAR(100) NOT NULL COMMENT '密码',
  KEY `user_id` (`user_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;

INSERT  INTO `user`(`user_name`,`user_pwd`)VALUES
('LuShan','123123'),
('XiaoMing','123123'),
('ZhangHua','123123');
```

## pom.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>

  <groupId>org.example</groupId>
  <artifactId>test</artifactId>
  <packaging>war</packaging>
  <version>1.0-SNAPSHOT</version>
  <dependencies>

    <!--Test-->
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>4.12</version>
    </dependency>
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-test</artifactId>
      <version>5.2.5.RELEASE</version>
    </dependency>
    <!--数据库驱动-->
    <dependency>
      <groupId>mysql</groupId>
      <artifactId>mysql-connector-java</artifactId>
      <version>5.1.47</version>
    </dependency>
    <!-- 数据库连接池 -->
    <dependency>
      <groupId>com.mchange</groupId>
      <artifactId>c3p0</artifactId>
      <version>0.9.5.2</version>
    </dependency>

    <!--Servlet - JSP -->
    <dependency>
      <groupId>javax.servlet</groupId>
      <artifactId>javax.servlet-api</artifactId>
      <version>4.0.1</version>
      <scope>provided</scope>
    </dependency>
    <dependency>
      <groupId>javax.servlet.jsp</groupId>
      <artifactId>jsp-api</artifactId>
      <version>2.2</version>
    </dependency>
    <dependency>
      <groupId>javax.servlet</groupId>
      <artifactId>jstl</artifactId>
      <version>1.2</version>
    </dependency>

    <!--Mybatis-->
    <dependency>
      <groupId>org.mybatis</groupId>
      <artifactId>mybatis</artifactId>
      <version>3.5.2</version>
    </dependency>
    <dependency>
      <groupId>org.mybatis</groupId>
      <artifactId>mybatis-spring</artifactId>
      <version>2.0.2</version>
    </dependency>

    <!--Spring-->
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-webmvc</artifactId>
      <version>5.1.9.RELEASE</version>
    </dependency>
    <!--Json-->
    <dependency>
      <groupId>com.fasterxml.jackson.core</groupId>
      <artifactId>jackson-databind</artifactId>
      <version>2.11.1</version>
      <scope>test</scope>
    </dependency>
  </dependencies>
  <properties>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <encoding>UTF-8</encoding>
    <!--指定Java版本-->
    <java.version>1.8</java.version>
    <maven.compiler.source>1.8</maven.compiler.source>
    <maven.compiler.target>1.8</maven.compiler.target>
  </properties>
  <build>
    <plugins>
      <!-- 配置Tomcat插件 -->
      <plugin>
        <groupId>org.apache.tomcat.maven</groupId>
        <artifactId>tomcat7-maven-plugin</artifactId>
        <version>2.2</version>
        <configuration>
          <path>/</path>
          <port>8081</port>
          <server>tomcat7</server>
        </configuration>
      </plugin>
    </plugins>
  </build>
</project>
```

### 防止Maven过滤配置文件

```xml
<build>
  <resources>
    <resource>
      <directory>src/main/java</directory>
      <includes>
        <include>**/*.properties</include>
        <include>**/*.xml</include>
      </includes>
      <filtering>false</filtering>
    </resource>
    <resource>
      <directory>src/main/resources</directory>
      <includes>
        <include>**/*.properties</include>
        <include>**/*.xml</include>
      </includes>
      <filtering>false</filtering>
    </resource>
  </resources>
</build>
```

## Web.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
         version="4.0">

  <!--DispatcherServlet-->
  <servlet>
    <servlet-name>DispatcherServlet</servlet-name>
    <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
    <init-param>
      <param-name>contextConfigLocation</param-name>
      <!--注意:这里加载的是总的配置文件-->
      <param-value>classpath:applicationContext.xml</param-value>
    </init-param>
    <load-on-startup>1</load-on-startup>
  </servlet>
  <servlet-mapping>
    <servlet-name>DispatcherServlet</servlet-name>
    <url-pattern>/</url-pattern>
  </servlet-mapping>

  <!--encodingFilter-->
  <filter>
    <filter-name>encodingFilter</filter-name>
    <filter-class>
      org.springframework.web.filter.CharacterEncodingFilter
    </filter-class>
    <init-param>
      <param-name>encoding</param-name>
      <param-value>utf-8</param-value>
    </init-param>
  </filter>
  <filter-mapping>
    <filter-name>encodingFilter</filter-name>
    <url-pattern>/*</url-pattern>
  </filter-mapping>

  <!--Session过期时间-->
  <session-config>
    <session-timeout>15</session-timeout>
  </session-config>

</web-app>
```

## POJO

### User

```java
public class User {
  private Integer userId;
  private String userName;
  private String userPwd;

  public User() {
  }

  public User(Integer userId, String userName, String userPwd) {
    this.userId = userId;
    this.userName = userName;
    this.userPwd = userPwd;
  }

  public Integer getUserId() {
    return userId;
  }

  public void setUserId(Integer userId) {
    this.userId = userId;
  }

  public String getUserName() {
    return userName;
  }

  public void setUserName(String userName) {
    this.userName = userName;
  }

  public String getUserPwd() {
    return userPwd;
  }

  public void setUserPwd(String userPwd) {
    this.userPwd = userPwd;
  }

  @Override
  public String toString() {
    return "User{" +
      "userId=" + userId +
      ", userName='" + userName + '\'' +
      ", userPwd='" + userPwd + '\'' +
      '}';
  }
}
```

## Mapper

### UserMapper

```java
public interface UserMapper{

  //增加一个User
  int addUser(User user);

  //根据id删除一个User
  int deleteUserById(int userId);

  //更新User
  int updateUser(User user);

  //根据id查询,返回一个User
  User queryUserById(int userId);

  //查询全部User,返回list集合
  List<User> queryAllUser();

}
```

### Mapper.xml

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

<mapper namespace="com.example.mapper.UserMapper">


  <!--增加一个User-->
  <insert id="addUser" parameterType="User">
    insert into test.user(user_name,user_pwd)
    values (#{userName}, #{userPwd})
  </insert>

  <!--根据id删除一个User-->
  <delete id="deleteUserById" parameterType="int">
    delete from test.user where user_id=#{userId}
  </delete>

  <!--更新Book-->
  <update id="updateUser" parameterType="User">
    update test.user
    set user_name = #{userName},user_pwd = #{userPwd}
    where user_id= #{userId}
  </update>

  <!--根据id查询,返回一个Book-->
  <select id="queryUserById" resultType="User">
    select * from test.user
    where user_id = #{userId}
  </select>

  <!--查询全部Book-->
  <select id="queryAllUser" resultType="User">
    SELECT * from test.user
  </select>

</mapper>
```

### database.properties

```properties
jdbc.driver=com.mysql.jdbc.Driver
jdbc.url=jdbc:mysql://localhost:3306/test?useSSL=false&useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai
jdbc.username=root
jdbc.password=123456
```

### mybatis-config.xml

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
  <!-- 开启驼峰映射 ，为自定义的SQL语句服务-->
  <!--设置启用数据库字段下划线映射到java对象的驼峰式命名属性，默认为false-->
  <settings>
    <setting name="mapUnderscoreToCamelCase" value="true"/>
  </settings>
  <!--配置别名,默认为实体类类名-->
  <typeAliases>
    <package name="com.example.pojo"/>
  </typeAliases>
  <!--Mapper.xml文件位置-->
  <mappers>
    <package name="com.example.mapper"/>
  </mappers>

</configuration>
```

### spring-dao.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
                           http://www.springframework.org/schema/beans/spring-beans.xsd
                           http://www.springframework.org/schema/context
                           https://www.springframework.org/schema/context/spring-context.xsd">

  <!-- 配置整合mybatis -->
  <!-- 关联数据库文件 -->
  <context:property-placeholder location="classpath:database.properties"/>

  <!--数据库连接池
        dbcp 半自动化操作 不能自动连接
        c3p0 自动化操作（自动的加载配置文件 并且设置到对象里面）
    -->
  <bean id="dataSource" class="com.mchange.v2.c3p0.ComboPooledDataSource">
    <!-- 配置连接池属性 -->
    <property name="driverClass" value="${jdbc.driver}"/>
    <property name="jdbcUrl" value="${jdbc.url}"/>
    <property name="user" value="${jdbc.username}"/>
    <property name="password" value="${jdbc.password}"/>

    <!-- c3p0连接池的私有属性 -->
    <property name="maxPoolSize" value="30"/>
    <property name="minPoolSize" value="10"/>
    <!-- 关闭连接后不自动commit -->
    <property name="autoCommitOnClose" value="false"/>
    <!-- 获取连接超时时间 -->
    <property name="checkoutTimeout" value="10000"/>
    <!-- 当获取连接失败重试次数 -->
    <property name="acquireRetryAttempts" value="2"/>
  </bean>

  <!-- 配置SqlSessionFactory对象 -->
  <bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
    <!-- 注入数据库连接池 -->
    <property name="dataSource" ref="dataSource"/>
    <!-- 配置MyBaties全局配置文件:mybatis-config.xml -->
    <property name="configLocation" value="classpath:mybatis-config.xml"/>
  </bean>

  <!-- 配置扫描Dao接口包，动态实现Dao接口注入到spring容器中 -->
  <bean class="org.mybatis.spring.mapper.MapperScannerConfigurer">
    <!-- 注入sqlSessionFactory -->
    <property name="sqlSessionFactoryBeanName" value="sqlSessionFactory"/>
    <!-- 给出需要扫描Dao接口包 -->
    <property name="basePackage" value="com.example.mapper"/>
  </bean>

  <!-- 配置事务管理器 -->
  <bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
    <!-- 注入数据库连接池 -->
    <property name="dataSource" ref="dataSource"/>
  </bean>
</beans>
```

## Service

### UserService

```java
package com.example.service;
import com.example.pojo.User;
import java.util.List;

public interface UserService {

  /**
     * 增加一个用户
     *
     * @param user 用户对象
     * @return 收影响的行数
     */
  int addUser(User user);

  /**
     * 根据id删除一个User
     *
     * @param userId 用户编号
     * @return 受影响的行数
     */
  int deleteUserById(int userId);

  /**
     * 更新User
     *
     * @param user 用户对象
     * @return 受影响的行数
     */
  int updateUser(User user);

  /**
     * 根据id查询User
     *
     * @param userId 用户编号
     * @return 用户对象
     */
  User queryUserById(int userId);

  /**
     * 查询全部User,返回list集合
     *
     * @return 用户列表
     */
  List<User> queryAllUser();
}
```

### UserServiceImpl

```java
@Service
public class UserServiceImpl implements UserService {

  @Autowired
  private UserMapper userMapper;

  public void setUserMapper(UserMapper userMapper) {
    this.userMapper = userMapper;
  }

  @Override
  public int addUser(User user) {
    return userMapper.addUser(user);
  }

  @Override
  public int deleteUserById(int userId) {
    return userMapper.deleteUserById(userId);
  }

  @Override
  public int updateUser(User user) {
    return userMapper.updateUser(user);
  }

  @Override
  public User queryUserById(int userId) {
    return userMapper.queryUserById(userId);
  }

  @Override
  public List<User> queryAllUser() {
    return userMapper.queryAllUser();
  }
}
```

### spring-service.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
   http://www.springframework.org/schema/beans/spring-beans.xsd
   http://www.springframework.org/schema/context
   http://www.springframework.org/schema/context/spring-context.xsd">

    <!-- 扫描service相关的bean -->
    <context:component-scan base-package="com.example.service"/>

    <!--不使用注解手动注入-->
    <!--    <bean id="userServiceImpl" class="com.example.service.UserServiceImpl">-->
    <!--        <property name="userMapper" ref="userMapper"/>-->
    <!--    </bean>-->
</beans>
```

## Controller

### UserController

```java
@Controller
public class UserController {
  @Autowired
  private UserService userService;

  @RequestMapping("/allUser")
  public String list(Model model) {
    List<User> userList = userService.queryAllUser();
    model.addAttribute("userList", userList);
    return "test";
  }
}
```

### spring-mvc.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:mvc="http://www.springframework.org/schema/mvc"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
                           http://www.springframework.org/schema/beans/spring-beans.xsd
                           http://www.springframework.org/schema/context
                           http://www.springframework.org/schema/context/spring-context.xsd
                           http://www.springframework.org/schema/mvc
                           https://www.springframework.org/schema/mvc/spring-mvc.xsd">

  <!-- 配置Spring MVC -->
  <!-- 开启Spring MVC注解驱动 -->
  <mvc:annotation-driven/>
  <!-- 静态资源默认servlet配置-->
  <mvc:default-servlet-handler/>

  <!-- 配置jsp 显示ViewResolver视图解析器 -->
  <bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
    <property name="viewClass" value="org.springframework.web.servlet.view.JstlView"/>
    <property name="prefix" value="/WEB-INF/jsp/"/>
    <property name="suffix" value=".jsp"/>
  </bean>

  <!-- 扫描web相关的bean -->
  <context:component-scan base-package="com.example.controller"/>

</beans>
```

## applicationContext.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
                           http://www.springframework.org/schema/beans/spring-beans.xsd">

  <import resource="spring-dao.xml"/>
  <import resource="spring-service.xml"/>
  <import resource="spring-mvc.xml"/>

</beans>
```

## test.jsp

```jsp
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>用户信息列表</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- 引入 Bootstrap -->
    <link href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
  </head>
  <body>

    <div class="container">

      <div class="row clearfix">
        <div class="col-md-12 column">
          <div class="page-header">
            <h1>
              <small>显示所有用户信息</small>
            </h1>
          </div>
        </div>
      </div>

      <div class="row clearfix">
        <div class="col-md-12 column">
          <table class="table table-hover table-striped">
            <thead>
              <tr>
                <th>用户编号</th>
                <th>用户名</th>
                <th>用户密码</th>
              </tr>
            </thead>

            <tbody>
              <c:forEach var="user" items="${requestScope.get('userList')}">
                <tr>
                  <td>${user.getUserId()}</td>
                  <td>${user.getUserName()}</td>
                  <td>${user.getUserPwd()}</td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>
      </div>
    </div>
```

## 测试

```java
package test;

import com.example.mapper.UserMapper;
import com.example.pojo.User;
import com.example.service.UserService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.List;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class UserTest {

  @Autowired
  private UserMapper userMapper;

  @Autowired
  private UserService userService;

  @Test
  public void MapperTest() {
    List<User> userList = userMapper.queryAllUser();
    for (User user : userList) {
      System.out.println(user);
    }
  }

  @Test
  public void ServiceTest() {
    List<User> userList = userService.queryAllUser();
    for (User user : userList) {
      System.out.println(user);
    }
  }

  @Test
  public void JacksonTest() {
    String json = "{\"userId\":\"123\",\"userName\":\"小明\",\"userPwd\":\"844099200000\"}";

    ObjectMapper mapper = new ObjectMapper();
    User user = null;
    try {
      user = mapper.readValue(json, User.class);
    } catch (JsonProcessingException e) {
      e.printStackTrace();
    }
    System.out.println(user);
  }
}
```

