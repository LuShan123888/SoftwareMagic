---
title: Spring 整合Druid
categories:
- Software
- Backend
- SpringFramework
- Spring
---
# Spring 整合Druid

## Druid 简介

- Druid 是阿里巴巴开源平台上一个数据库连接池实现,结合了 C3P0,DBCP 等 DB 池的优点,同时加入了日志监控
- Druid 可以很好的监控 DB 池连接和 SQL 的执行情况,天生就是针对监控而生的 DB 连接池
- Spring Boot 2.0 以上默认使用 Hikari 数据源,可以说 Hikari 与 Driud 都是当前 Java Web 上最优秀的数据源

### 基本配置参数

- `com.alibaba.druid.pool.DruidDataSource `

| 配置                          | 缺省值             | 说明                                                         |
| ----------------------------- | ------------------ | ------------------------------------------------------------ |
| name                          |                    | 配置这个属性的意义在于,如果存在多个数据源,监控的时候可以通过名字来区分开来,如果没有配置,将会生成一个名字,格式是:"DataSource-" + System.identityHashCode(this).  另外配置此属性至少在1.0.5版本中是不起作用的,强行设置name会出错 [详情-点此处](http://blog.csdn.net/lanmo555/article/details/41248763),|
| url                           |                    | 连接数据库的url,不同数据库不一样,例如:MySQL : jdbc:mysql://10.20.153.104:3306/druid2  oracle : jdbc:oracle:thin:@10.20.149.85:1521:ocnauto |
| username                      |                    | 连接数据库的用户名                                           |
| password                      |                    | 连接数据库的密码,如果你不希望密码直接写在配置文件中,可以使用ConfigFilter,详细看这里:https://github.com/alibaba/druid/wiki/%E4%BD%BF%E7%94%A8ConfigFilter |
| driverClassName               | 根据url自动识别    | 这一项可配可不配,如果不配置druid会根据url自动识别dbType,然后选择相应的driverClassName |
| initialSize                   | 0                  | 初始化时建立物理连接的个数,初始化发生在显示调用init方法,或者第一次getConnection时 |
| maxActive                     | 8                  | 最大连接池数量                                               |
| maxIdle                       | 8                  | 已经不再使用,配置了也没效果                                 |
| minIdle                       |                    | 最小连接池数量                                               |
| maxWait                       |                    | 获取连接时最大等待时间,单位毫秒,配置了maxWait之后,缺省启用公平锁,并发效率会有所下降,如果需要可以通过配置useUnfairLock属性为true使用非公平锁,|
| poolPreparedStatements        | false              | 是否缓存preparedStatement,也就是PSCache,PSCache对支持游标的数据库性能提升巨大,比如说oracle,在mysql下建议关闭,|
| maxOpenPreparedStatements     | -1                 | 要启用PSCache,必须配置大于0,当大于0时,poolPreparedStatements自动触发修改为true,在Druid中,不会存在Oracle下PSCache占用内存过多的问题,可以把这个数值配置大一些,比如说100 |
| validationQuery               |                    | 用来检测连接是否有效的sql,要求是一个查询语句,如果validationQuery为null,testOnBorrow,testOnReturn,testWhileIdle都不会其作用,|
| validationQueryTimeout        |                    | 单位:秒,检测连接是否有效的超时时间,底层调用jdbc Statement对象的void setQueryTimeout(int seconds)方法 |
| testOnBorrow                  | true               | 申请连接时执行validationQuery检测连接是否有效,做了这个配置会降低性能,|
| testOnReturn                  | false              | 归还连接时执行validationQuery检测连接是否有效,做了这个配置会降低性能 |
| testWhileIdle                 | false              | 建议配置为true,不影响性能,并且保证安全性,申请连接的时候检测,如果空闲时间大于timeBetweenEvictionRunsMillis,执行validationQuery检测连接是否有效,|
| timeBetweenEvictionRunsMillis | 1分钟(1.0.14)| 有两个含义:1) Destroy线程会检测连接的间隔时间,如果连接空闲时间大于等于minEvictableIdleTimeMillis则关闭物理连接 2) testWhileIdle的判断依据,详细看testWhileIdle属性的说明 |
| numTestsPerEvictionRun        |                    | 不再使用,一个DruidDataSource只支持一个EvictionRun           |
| minEvictableIdleTimeMillis    | 30分钟(1.0.14)| 连接保持空闲而不被驱逐的最长时间                             |
| connectionInitSqls            |                    | 物理连接初始化的时候执行的sql                                |
| exceptionSorter               | 根据dbType自动识别 | 当数据库抛出一些不可恢复的异常时,抛弃连接                   |
| filters                       |                    | 属性类型是字符串,通过别名的方式配置扩展插件,常用的插件有:监控统计用的filter:stat 日志用的filter:log4j 防御sql注入的filter:wall |
| proxyFilters                  |                    | 类型是List<com.alibaba.druid.filter.Filter>,如果同时配置了filters和proxyFilters,是组合关系,并非替换关系 |

## 配置数据源

### pom.xml

```xml
<!-- https://mvnrepository.com/artifact/com.alibaba/druid -->
<dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>druid</artifactId>
    <version>1.1.21</version>
</dependency>
<dependency>
    <groupId>log4j</groupId>
    <artifactId>log4j</artifactId>
    <version>1.2.17</version>
</dependency>
```

## 配置文件

### Spring Boot

```yaml
spring:
  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://localhost:3306/tally-test?useSSL=false&useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai
    username: root
    password: 123456
    type: com.alibaba.druid.pool.DruidDataSource
    druid:
      # 下面为连接池的补充设置，应用到上面所有数据源中
      # 初始化大小，最小，最大
      initial-size: 5
      min-idle: 5
      max-active: 20
      # 配置获取连接等待超时的时间
      max-wait: 60000
      # 配置间隔多久才进行一次检测，检测需要关闭的空闲连接，单位是毫秒
      time-between-eviction-runs-millis: 60000
      # 配置一个连接在池中最小生存的时间，单位是毫秒
      min-evictable-idle-time-millis: 300000
      validation-query: SELECT 1 FROM DUAL
      test-while-idle: true
      test-on-borrow: false
      test-on-return: false
      # 打开PSCache，并且指定每个连接上PSCache的大小
      pool-prepared-statements: true
      # 配置监控统计拦截的filters，去掉后监控界面sql无法统计，'wall'用于防火墙
      max-pool-prepared-statement-per-connection-size: 20
      filters: stat,wall
      use-global-data-source-stat: true
      # 通过connectProperties属性来打开mergeSql功能；慢SQL记录
      connect-properties: druid.stat.mergeSql=true;druid.stat.slowSqlMillis=5000
      # 添加IP白名单
      # allow:
      # 添加IP黑名单，当白名单和黑名单重复时，黑名单优先级更高
      # deny:
      web-stat-filter:
        # 添加过滤规则
        url-pattern: /*
        # 忽略过滤格式
        exclusions: "*.js,*.gif,*.jpg,*.png,*.css,*.ico,/druid/*"
```

- filters:配置监控统计拦截
    - stat:监控统计
    - log4j:日志记录
    - wall:防御sql注入

### Spring

```xml
<!-- 配置数据源 -->
<bean name="dataSource" class="com.alibaba.druid.pool.DruidDataSource"
      init-method="init" destroy-method="close">
    <property name="url" value="${jdbc_url}" />
    <property name="username" value="${jdbc_username}" />
    <property name="password" value="${jdbc_password}" />

    <!-- 初始化连接大小 -->
    <property name="initialSize" value="0" />
    <!-- 连接池最大使用连接数量 -->
    <property name="maxActive" value="180" />
    <!-- 连接池最小空闲 -->
    <property name="minIdle" value="0" />
    <!-- 获取连接最大等待时间 -->
    <property name="maxWait" value="60000" />

    <!-- <property name="poolPreparedStatements" value="true" /> <property
   name="maxPoolPreparedStatementPerConnectionSize" value="33" /> -->

    <property name="validationQuery" value="${validationQuery}" />
    <property name="testOnBorrow" value="false" />
    <property name="testOnReturn" value="false" />
    <property name="testWhileIdle" value="true" />

    <!-- 配置间隔多久才进行一次检测,检测需要关闭的空闲连接,单位是毫秒 -->
    <property name="timeBetweenEvictionRunsMillis" value="60000" />
    <!-- 配置一个连接在池中最小生存的时间,单位是毫秒 -->
    <property name="minEvictableIdleTimeMillis" value="25200000" />

    <!-- 打开removeAbandoned功能 -->
    <property name="removeAbandoned" value="true" />
    <!-- 1800秒,也就是30分钟 -->
    <property name="removeAbandonedTimeout" value="1800" />
    <!-- 关闭abanded连接时输出错误日志 -->
    <property name="logAbandoned" value="true" />

    <!-- 监控数据库 -->
    <!-- <property name="filters" value="stat" /> -->
    <property name="filters" value="mergeStat" />
</bean>

<!-- myBatis文件 -->
<bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
    <property name="dataSource" ref="dataSource" />
    <!-- 自动扫描entity目录, 省掉Configuration.xml里的手工配置 -->
    <property name="configLocation" value="classpath:spring/mybatis-page.xml" />
    <property name="mapperLocations" value="classpath:mapping/*.xml" />
</bean>

<bean class="org.mybatis.spring.mapper.MapperScannerConfigurer">
    <property name="basePackage" value="com.lantaiyuan.ebus.custom.dao,com.lantaiyuan.ebus.realtime.dao" />
    <property name="sqlSessionFactoryBeanName" value="sqlSessionFactory" />
</bean>

<!-- 配置事务管理器 -->
<bean id="transactionManager"
      class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
    <property name="dataSource" ref="dataSource" />
</bean>

<!-- 配置druid监控Springjdbc -->
<bean id="druid-stat-interceptor"
      class="com.alibaba.druid.support.spring.stat.DruidStatInterceptor">
</bean>
<bean id="druid-stat-pointcut" class="org.springframework.aop.support.JdkRegexpMethodPointcut"
      scope="prototype">
    <property name="patterns">
        <list>
            <value>com.lantaiyuan.ebus.custom.service.*</value>
        </list>
    </property>
</bean>
<aop:config>
    <aop:advisor advice-ref="druid-stat-interceptor"
                 pointcut-ref="druid-stat-pointcut" />
</aop:config>
<aop:aspectj-autoproxy proxy-target-class="true" />
```

## 绑定全局配置文件

- 将自定义的 Druid数据源添加到容器中,不再让 Spring Boot 自动创建
- 绑定全局配置文件中的 druid 数据源属性到`com.alibaba.druid.pool.DruidDataSource`从而让它们生效

```java
@Configuration
public class DruidConfig {

    @ConfigurationProperties(prefix = "spring.datasource")
    @Bean
    public DataSource druidDataSource() {
        return new DruidDataSource();
    }

}
```

- `@ConfigurationProperties(prefix = "spring.datasource")`:将全局配置文件中前缀为`spring.datasource`的属性值注入到 `com.alibaba.druid.pool.DruidDataSource`的同名参数中

## 配置Druid数据源监控

- Druid 数据源具有监控的功能,并提供了一个 web 界面方便用户查看
- 配置 Druid 监控管理后台的Servlet
- 内置 Servlet 容器时没有web.xml文件,所以使用 Spring Boot 的注册 Servlet 方式

```java
@Bean
public ServletRegistrationBean servletRegistrationBean() {
    //注意，请求时 /druid/*
    ServletRegistrationBean<StatViewServlet> bean = new ServletRegistrationBean(new StatViewServlet(), "/druid/*");
    Map<String, String> initParm = new HashMap<>();
    //登陆页面账户与密码
    initParm.put(ResourceServlet.PARAM_NAME_USERNAME, "root");
    initParm.put(ResourceServlet.PARAM_NAME_PASSWORD, "123456");
    //监控后台 允许ip
    initParm.put(ResourceServlet.PARAM_NAME_ALLOW, "");
    //黑名单
    initParm.put(ResourceServlet.PARAM_NAME_DENY, "192.168.0.1");

    bean.setInitParameters(initParm);
    return bean;
}
```

- `initParams`中的配置参数可以在`com.alibaba.druid.support.http.StatViewServlet`的父类 `com.alibaba.druid.support.http.ResourceServlet`中找到
    - `loginUsername`:登录用户名
    - `loginPassword`:登录密码
    - `allow`:允许访问
        - `initParams.put("allow", "localhost")`:表示只有本机可以访问
        - `initParams.put("allow", "")`:为空或者为null时,表示允许所有访问
    - `deny`:拒绝访问
        - `initParams.put("deny", "192.168.1.20")`:表示禁止此ip访问

**测试**:访问http://localhost:8080/druid/login.html

## 配置Druid web监控 filter过滤器

- `WebStatFilter`:用于配置Web和Druid数据源之间的管理关联监控统计

```java
@Bean
public FilterRegistrationBean webStatFilter() {
    FilterRegistrationBean<Filter> bean = new FilterRegistrationBean<>();
    bean.setFilter(new WebStatFilter());

    Map<String, String> initPrams = new HashMap<>();
    initPrams.put(WebStatFilter.PARAM_NAME_EXCLUSIONS, "*.js,*.css,/druid/*");
    bean.setInitParameters(initPrams);

    //设置拦截器请求
    bean.setUrlPatterns(Arrays.asList("/"));
    return bean;
}
```

- `exclusions`:设置哪些请求进行过滤排除掉,从而不进行统计
- `setUrlPatterns`:`/*`表示过滤所有请求