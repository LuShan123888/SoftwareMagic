---
title: Dubbo admin
categories:
- Software
- BackEnd
- Distributed
- Dubbo
---
# Dubbo admin

- 为了让用户更好的管理监控众多的dubbo服务，官方提供了一个可视化的监控程序dubbo-admin

## Docker

### 创建数据库

1. 创建名为`dubbo_admin`的Schema
2. 执行SQL语句`./dubbo-admin-server/src/main/resources/schema.sql`

```mysql
CREATE TABLE IF NOT EXISTS `mock_rule` (
    `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
    `service_name` varchar(255) DEFAULT NULL COMMENT '服务名',
    `method_name` varchar(255) DEFAULT NULL COMMENT '方法名',
    `rule` text COMMENT '规则',
    `enable` tinyint(1) NOT NULL DEFAULT '1',
    `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`)
);
```

### 启动容器

```shell
$ docker run -d \
-p 8025:8080 \
--name dubbo-admin \
--net zookeeper \
--hostname dubbo-admin \
lushan123888/dubbo-admin:0.4.0
```

### 构建Docker镜像

1. 修改`./dubbo-admin-server/src/main/resources/application.properties`

```properties
# centers in dubbo2.7, if you want to add parameters, please add them to the url
admin.registry.address=zookeeper://zookeeper:2181
admin.config-center=zookeeper://zookeeper:2181
admin.metadata-report.address=zookeeper://zookeeper:2181

admin.root.user.name=root
admin.root.user.password=123456

# mysql
spring.datasource.driver-class-name=com.mysql.jdbc.Driver
spring.datasource.url=jdbc:mysql://mysql:3306/dubbo_admin?characterEncoding=utf8&connectTimeout=1000&socketTimeout=10000&autoReconnect=true
spring.datasource.username=root
spring.datasource.password=123456
```

2. 修改`./dubbo-admin-server/pom.xml`

```xml
<!-- the mysql db driver need user put it in /opt-libs path -->
<dependency>
  <groupId>mysql</groupId>
  <artifactId>mysql-connector-java</artifactId>
  <version>8.0.25</version>
  <scope>provided</scope>
</dependency>
```

3. 创建Dockerfile（需将下文配置文件存放至当前目录）

```dockerfile
FROM maven:3-openjdk-8
ARG version
RUN mkdir /source && wget https://github.com/apache/dubbo-admin/archive/$version.zip && unzip -q $version.zip -d /source
COPY application.properties /source/dubbo-admin-$version/dubbo-admin-server/src/main/resources/application.properties
COPY pom.xml /source/dubbo-admin-$version/dubbo-admin-server/pom.xml
WORKDIR /source/dubbo-admin-$version
RUN mvn --batch-mode clean package -Dmaven.test.skip=true

FROM openjdk:8-jre
ARG version
COPY --from=0 /source/dubbo-admin-$version/dubbo-admin-distribution/target/dubbo-admin-$version.jar /app.jar
ENV JAVA_OPTS ""
ENTRYPOINT exec java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /app.jar
```

4. 构建Docker镜像。

```shell
$ docker build -t lushan123888/dubbo-admin:0.4.0 --build-arg version=0.4.0 .
```
