---
title: Spring 整合 JDBC
categories:
  - Software
  - Language
  - Java
  - SpringFramework
  - Spring
---
# Spring 整合 JDBC

## Srping Data

- 对于数据访问层，无论是 SQL（关系型数据库）还是 NOSQL（非关系型数据库）,Spring Boot 底层都是采用 Spring Data 的方式进行统一处理。
- Spring Boot 底层都是采用 Spring Data 的方式进行统一处理各种数据库，Spring Data 也是 Spring 中与 Spring Boot,Spring Cloud 等齐名的知名项目。

## 整合JDBC

### 创建测试项目测试数据源

1. 新建一个项目测试，引入相应的模块`JDBC-API`
2. 项目建好之后，发现自动导入了如下的启动器。

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-jdbc</artifactId>
</dependency>
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <scope>runtime</scope>
</dependency>
```

3. 编写yaml配置文件连接数据库。

```yaml
spring:
  datasource:
    username: root
    password: 123456
    url: jdbc:mysql://localhost:3306/springboot?serverTimezone=UTC&useUnicode=true&characterEncoding=utf-8
    driver-class-name: com.mysql.cj.jdbc.Driver
```

4. 测试。

```java
public class SpringbootDataJdbcApplicationTests {

    //DI注入数据源。
    @Autowired
    DataSource dataSource;

    @Test
    public void contextLoads() throws SQLException {
        // 看一下默认数据源。
        System.out.println(dataSource.getClass());
        // 获得连接。
        Connection connection = dataSource.getConnection();
        System.out.println(connection);
        // 关闭连接。
        connection.close();
    }
}
```

- **注意**：可以看到默认配置的数据源为：`class com.zaxxer.hikari.HikariDataSource`
- 数据源的所有自动配置都在`DataSourceAutoConfiguration`文件中。

```java
@Import(
    {Hikari.class, Tomcat.class, Dbcp2.class, Generic.class, DataSourceJmxConfiguration.class}
)
protected static class PooledDataSourceConfiguration {
    protected PooledDataSourceConfiguration() {
    }
}
```

- 这里导入的类都在`DataSourceConfiguration`配置类下，可以看出Spring Boot 2.2.5默认使用`HikariDataSource`数据源，而以前版本，如Spring Boot 1.5默认使用 `org.apache.tomcat.jdbc.pool.DataSource`作为数据源。
- `HikariDataSource`：号称 Java WEB 当前速度最快的数据源，相比于传统的 C3P0,DBCP,Tomcat jdbc 等连接池更加优秀。
- 可以使用`spring.datasource.type`指定自定义的数据源类型，值为要使用的连接池实现的完全限定名。

## JDBC Template

- 有了数据源`com.zaxxer.hikari.HikariDataSource`，然后可以拿到数据库连接`java.sql.Connection`有了连接，就可以使用原生的 JDBC 语句来操作数据库。
- 即使不使用第三方第数据库操作框架，如 MyBatis等，Spring 本身也对原生的JDBC 做了轻量级的封装，即JdbcTemplate
- 数据库操作的所有 CRUD 方法都在 JdbcTemplate 中。
- Spring Boot 不仅提供了默认的数据源，同时默认已经配置好了`JdbcTemplate`放在了容器中，程序员只需自己注入即可使用。
- JdbcTemplate 的自动配置是依赖`org.springframework.boot.autoconfigure.jdbc`包下的`JdbcTemplateConfiguration`类。

**JdbcTemplate主要提供以下几类方法**:

- `execute`：可以用于执行任何SQL语句，一般用于执行DDL语句。
- `update`与`batchUpdate方法`:`update`用于执行新增，修改，删除等语句，`batchUpdate`用于执行批处理相关语句。
- `query`与`queryForXXX`：用于执行查询相关语句。
- `call`：用于执行存储过程，函数相关语句。

### 测试

- 编写一个Controller，注入 jdbcTemplate，编写测试方法进行访问测试。

```java
@RestController
@RequestMapping("/jdbc")
public class JdbcController {

    @Autowired
    JdbcTemplate jdbcTemplate;

    // 查询employee表中所有数据。
    //List中的1个Map对应数据库的1行数据。
    //Map中的key对应数据库的字段名，value对应数据库的字段值。
    @GetMapping("/list")
    public List<Map<String, Object>> userList(){
        String sql = "select * from employee";
        List<Map<String, Object>> maps = jdbcTemplate.queryForList(sql);
        return maps;
    }

    // 新增一个用户。
    @GetMapping("/add")
    public String addUser(){
        String sql = "insert into employee(last_name, email,gender,department,birth)" +
            " values ('test','24736743@qq.com',1,101,'"+ new Date().toLocaleString() +"')";
        jdbcTemplate.update(sql);
        return "addOk";
    }

    // 修改用户信息。
    @GetMapping("/update/{id}")
    public String updateUser(@PathVariable("id") int id){
        String sql = "update employee set last_name=?,email=? where id="+id;
        Object[] objects = new Object[2];
        objects[0] = "test";
        objects[1] = "123123@test.com";
        jdbcTemplate.update(sql,objects);
        return "updateOk";
    }

    // 删除用户。
    @GetMapping("/delete/{id}")
    public String delUser(@PathVariable("id") int id){
        String sql = "delete from employee where id=?";
        jdbcTemplate.update(sql,id);
        return "deleteOk";
    }

}
```