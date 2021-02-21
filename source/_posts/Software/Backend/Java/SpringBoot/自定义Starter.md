---
title: Spring Boot 自定义Starter
categories:
- Software
- Backend
- Java
- SpringBoot
---
# Spring Boot 自定义Starter

## 概述

启动器模块是一个 空 jar 文件,仅提供辅助性依赖管理,这些依赖可能用于自动装配或者其他类库

### 命名规约

- 官方命名

    - **前缀**:spring-boot-starter-xxx

        例如:spring-boot-starter-web

- 自定义命名

    - xxx-spring-boot-starter

        例如:mybatis-spring-boot-starter

## 编写启动器

1. 在IDEA中新建一个空项目`spring-boot-starter-diy`
2. 新建一个普通Maven模块`test-spring-boot-starter`
3. 新建一个Spring Boot模块`test-spring-boot-starter-autoconfigure`
4. 点击apply即可,基本结构
5. 在我们的 starter模块中导入 autoconfigure 的依赖

```xml
    <dependency>
        <groupId>com.test</groupId>
        <artifactId>test-spring-boot-starter-autoconfigure</artifactId>
        <version>0.0.1-SNAPSHOT</version>
    </dependency>
```

6. 将 autoconfigure 项目下多余的文件都删掉,`Pom.xml`中只留下一个`spring-boot-starter`,这是所有的启动器基本配置
7. 编写一个自定义的服务类

```java
package com.test;

public class HelloService {

    HelloProperties helloProperties;

    public HelloProperties getHelloProperties() {
        return helloProperties;
    }

    public void setHelloProperties(HelloProperties helloProperties) {
        this.helloProperties = helloProperties;
    }

    public String sayHello(String name){
        return helloProperties.getPrefix() + name + helloProperties.getSuffix();
    }

}
```

8. 编写HelloProperties配置类

```java
package com.test;

import org.springframework.boot.context.properties.ConfigurationProperties;

// 前缀 test.hello
@ConfigurationProperties(prefix = "test.hello")
public class HelloProperties {

    private String prefix;
    private String suffix;

    public String getPrefix() {
        return prefix;
    }

    public void setPrefix(String prefix) {
        this.prefix = prefix;
    }

    public String getSuffix() {
        return suffix;
    }

    public void setSuffix(String suffix) {
        this.suffix = suffix;
    }
}
```

9. 编写自定义的自动配置类并注入bean,测试

```java
package com.test;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.condition.ConditionalOnWebApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
@ConditionalOnWebApplication //web应用生效
@EnableConfigurationProperties(HelloProperties.class)
public class HelloServiceAutoConfiguration {

    @Autowired
    HelloProperties helloProperties;

    @Bean
    public HelloService helloService(){
        HelloService service = new HelloService();
        service.setHelloProperties(helloProperties);
        return service;
    }

}
```

10. 在resources编写一个自己的`META-INF\spring.factories`

```properties
# Auto Configure
org.springframework.boot.autoconfigure.EnableAutoConfiguration=\
com.test.HelloServiceAutoConfiguration
```

11. 编写完成后,可以安装到maven仓库中

```shell
mvn install
```

## 测试启动器

1. 新建一个Spring Boot 项目
2. 导入我们自己写的启动器

```xml
<dependency>
    <groupId>com.test</groupId>
    <artifactId>test-spring-boot-starter</artifactId>
    <version>1.0-SNAPSHOT</version>
</dependency>
```

2. 编写一个 HelloController  进行测试我们自己的写的接口

```java
package com.test.controller;

@RestController
public class HelloController {

    @Autowired
    HelloService helloService;

    @RequestMapping("/hello")
    public String hello(){
        return helloService.sayHello("zxc");
    }

}
```

3. 编写配置文件`application.properties`

```properties
test.hello.prefix="aaa"
test.hello.suffix="bbb"
```

4. 启动项目进行测试,结果成功