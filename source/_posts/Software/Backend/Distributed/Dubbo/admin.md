---
title: Dubbo admin
categories:
- Software
- Backend
- Distributed
- Dubbo
---
# Dubbo admin

- Dubbo本身并不是一个服务软件,而是一个jar包,能够帮你的java程序连接到zookeeper,并利用zookeeper消费,提供服务
- 但是为了让用户更好的管理监控众多的dubbo服务,官方提供了一个可视化的监控程序dubbo-admin,不过这个监控即使不装也不影响使用

## 下载dubbo-admin

地址 :https://github.com/apache/dubbo-admin/tree/master

## 解压进入目录

- 修改`dubbo-admin\src\main\resources\application.properties`指定zookeeper地址

```properties
server.port=7001
spring.velocity.cache=false
spring.velocity.charset=UTF-8
spring.velocity.layout-url=/templates/default.vm
spring.messages.fallback-to-system-locale=false
spring.messages.basename=i18n/message
spring.root.password=root
spring.guest.password=guest

dubbo.registry.address=zookeeper://127.0.0.1:2181
```

## 打包dubbo-admin

- **注意**:需要在项目目录下

```shell
mvn clean package -Dmaven.test.skip=true
```

## 运行服务

- `dubbo-admin\target`下`的dubbo-admin-0.0.1-SNAPSHOT.jar`

```bash
java -jar dubbo-admin-0.0.1-SNAPSHOT.jar
```

- 注意:zookeeper的服务要提前打开

## 测试

- 访问 http://localhost:7001/,这时候我们需要输入登录账户和密码默认为root:root

![image-20201118124849858](https://cdn.jsdelivr.net/gh/LuShan123888/Files@master/Pictures/2020-12-10-2020-11-18-image-20201118124849858.png)