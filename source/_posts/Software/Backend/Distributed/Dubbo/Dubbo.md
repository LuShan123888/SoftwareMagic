---
title: Spring Boot 整合 Dubbo
categories:
- Software
- Backend
- Distributed
- Dubbo
---
# Spring Boot 整合 Dubbo

## 准备工作

1. 安装并启动Zookeeper
2. 启动Dubbo-admin可视化界面
3. 创建Spring Boot 空项目

## 服务提供者

- 在项目中新建模块,并添加web框架
- 将服务提供者注册到注册中心,需要整合Dubbo和zookeeper

### pom.xml

#### Dubbo

```xml
<!-- Dubbo Spring Boot Starter -->
<dependency>
    <groupId>org.apache.dubbo</groupId>
    <artifactId>dubbo-spring-boot-starter</artifactId>
    <version>2.7.3</version>
</dependency>
<!-- zkclient -->
<dependency>
    <groupId>com.github.sgroschupf</groupId>
    <artifactId>zkclient</artifactId>
    <version>0.1</version>
</dependency>
<!-- 引入zookeeper -->
<dependency>
    <groupId>org.apache.curator</groupId>
    <artifactId>curator-framework</artifactId>
    <version>2.12.0</version>
</dependency>
<dependency>
    <groupId>org.apache.curator</groupId>
    <artifactId>curator-recipes</artifactId>
    <version>2.12.0</version>
</dependency>
<dependency>
    <groupId>org.apache.zookeeper</groupId>
    <artifactId>zookeeper</artifactId>
    <version>3.4.14</version>
    <!--排除slf4j-log4j12-->
    <exclusions>
        <exclusion>
            <groupId>org.slf4j</groupId>
            <artifactId>slf4j-log4j12</artifactId>
        </exclusion>
    </exclusions>
</dependency>
```

### 配置dubbo相关属性

```properties
#当前应用名字
dubbo.application.name=provider-server
#注册中心地址
dubbo.registry.address=zookeeper://127.0.0.1:2181
#扫描指定包下服务
dubbo.scan.base-packages=com.exampel.provider.service
```

###  提供服务

- 配置服务注解`@Service`,发布服务
- 注意导包问题

```java
import org.apache.dubbo.config.annotation.Service;
import org.springframework.stereotype.Component;

@Service
@Component
public class TicketServiceImpl implements TicketService {
   @Override
   public String getTicket() {
       return "《Ticket》";
  }
}
```

## 服务消费者

- 在项目中新建模块,并添加web框架

### pom.xml

```xml
<!-- Dubbo Spring Boot Starter -->
<dependency>
   <groupId>org.apache.dubbo</groupId>
   <artifactId>dubbo-spring-boot-starter</artifactId>
   <version>2.7.3</version>
</dependency>
<!--zKclient-->
<!-- https://mvnrepository.com/artifact/com.github.sgroschupf/zkclient -->
<dependency>
   <groupId>com.github.sgroschupf</groupId>
   <artifactId>zkclient</artifactId>
   <version>0.1</version>
</dependency>
<!-- 引入zookeeper -->
<dependency>
   <groupId>org.apache.curator</groupId>
   <artifactId>curator-framework</artifactId>
   <version>2.12.0</version>
</dependency>
<dependency>
   <groupId>org.apache.curator</groupId>
   <artifactId>curator-recipes</artifactId>
   <version>2.12.0</version>
</dependency>
<dependency>
   <groupId>org.apache.zookeeper</groupId>
   <artifactId>zookeeper</artifactId>
   <version>3.4.14</version>
   <!--排除slf4j-log4j12-->
   <exclusions>
       <exclusion>
           <groupId>org.slf4j</groupId>
           <artifactId>slf4j-log4j12</artifactId>
       </exclusion>
   </exclusions>
</dependency>
```

### 配置dubbo相关属性

```properties
#当前应用名字
dubbo.application.name=consumer-server
#注册中心地址
dubbo.registry.address=zookeeper://127.0.0.1:2181
```

### 注册服务提供者

- 正常步骤是需要将服务提供者的接口打包,然后用pom文件导入
- 这里使用简单的方式,直接将服务的接口拿过来,路径必须保证正确,即和服务提供者相同

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-2020-11-18-image-20201118151125167.png" alt="image-20201118151125167" style="zoom:50%;" />

### 使用服务

```java
import com.example.provider.service.TicketService;
import org.apache.dubbo.config.annotation.Reference;
import org.springframework.stereotype.Service;

@Service
public class UserService {

   @Reference //远程引用指定的服务,按照全类名进行匹配,看谁给注册中心注册了这个全类名
   TicketService ticketService;

   public void bugTicket(){
       String ticket = ticketService.getTicket();
       System.out.println("在注册中心获得"+ticket);
  }

}
```

### 编写测试类

```java
@RunWith(SpringRunner.class)
@SpringBootTest
public class ConsumerServerApplicationTests {

   @Autowired
   UserService userService;

   @Test
   public void contextLoads() {
       userService.bugTicket();
  }
}
```

## 测试

1. 开启zookeeper
2. 打开dubbo-admin实现监控
3. 开启服务者
4. 消费者消费测试

**控制台**

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-2020-11-18-640-20201118153138639.png)

**监控中心 **

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-2020-11-18-640-20201118153138762.png)