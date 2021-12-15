---
title: HTTP Cookie&Session&Token
categories:
- Internet
- HTTP
---
# HTTP Cookie&Session&Token

## Cookie

- Cookie是一个非常具体的东西,指的就是浏览器里面能永久存储的一种数据,仅仅是浏览器实现的一种数据存储功能
- Cookie由服务器生成,发送给浏览器,浏览器把Cookie以键值对形式保存到某个目录下的文本文件内,下一次请求同一网站时会把该Cookie发送给服务器
- 由于Cookie是存在客户端上的,所以浏览器加入了一些限制确保Cookie不会被恶意使用,同时不会占据太多磁盘空间,所以每个域的Cookie数量是有限的

### Cookie的结构

- Cookie的内容主要包括:名字,值,过期时间,路径和域,路径与域合在一起就构成了Cookie的作用范围
- 如果不设置过期时间,则表示这个Cookie的生命期为浏览器会话期间,只要关闭浏览器窗口,Cookie就消失了,这种生命期为浏览器会话期的 Cookie被称为会话Cookie,会话Cookie一般不存储在硬盘上而是保存在内存里,如果设置了过期时间,浏览器就会把Cookie保存到硬盘上,关闭后再次打开浏览器,这些Cookie仍然有效直到超过设定的过期时间

### Cookie的使用

- Cookie 的使用是由浏览器按照一定的原则在后台自动发送给服务器的
- 当客户端二次向服务器发送请求的时候,浏览器检查所有存储的Cookie,如果某个Cookie所声明的作用范围大于等于将要请求的资源所在的位置,则把该Cookie附在请求资源的HTTP请求头上发送给服务器
- 有了Cookie这样的技术实现,服务器在接收到来自客户端浏览器的请求之后,就能够通过分析存放于请求头的Cookie得到客户端特有的信息,从而动态生成与该客户端相对应的内容,通常,我们可以从很多网站的登录界面中看到"请记住我”这样的选项,如果你勾选了它之后再登录,那么在下一次访问该网站的时候就不需要进行重复而繁琐的登录动作了,而这个功能就是通过Cookie实现的

### Cookie作用域

- 只能向当前域或者更高级域设置Cookie
- 例如 `client.com` 不能向 `a.client.com` 设置Cookie, 而 `a.client.com` 可以向 `client.com` 设置Cookie
- 读取Cookie情况同上

### 客户端设置Cookie与服务端设置Cookie的区别

- 无论是客户端还是服务端, 都只能向自己的域或者更高级域设置Cookie,例如 `client.com` 不能向 `server.com` 设置Cookie, 同样 `server.com` 也不能向 `client.com` 设置Cookie
- 服务端可以设置 `httpOnly: true`, 带有该属性的Cookie客户端无法读取
- 客户端只会带上与请求同域的Cookie, 例如 `client.com/index.html` 会带上 `client.com` 的Cookie,`server.com/app.js` 会带上 `server.com` 的Cookie, 并且也会带上`httpOnly`的Cookie
- 但是, 如果是向服务端的ajax请求, 默认不会带上Cookie

## Session

- Session一般叫做回话,Session技术是http状态保持在服务端的解决方案,它是通过服务器来保持状态的,我们可以把客户端浏览器与服务器之间一系列交互的动作称为一个 Session,是服务器端为客户端所开辟的存储空间,在其中保存的信息就是用于保持状态
- 服务器要知道当前发请求给自己的是谁,为了做这种区分,服务器就要给每个客户端分配不同的"身份标识”,然后客户端每次向服务器发请求的时候,都带上这个"身份标识”,服务器就知道这个请求来自于谁了,至于客户端怎么保存这个"身份标识”,可以有很多种方式,对于浏览器客户端,大家都默认采用Cookie的方式
- 因此,session是解决http协议无状态问题的服务端解决方案,它能让客户端和服务端一系列交互动作变成一个完整的事务
- Cookie和session的方案虽然分别属于客户端和服务端,但是服务端的session的实现对客户端的Cookie有依赖关系的,服务端执行session机制时候会生成session的id值,这个id值会发送给客户端,客户端每次请求都会把这个id值放到http请求的头部发送给服务端,而这个id值在客户端会保存下来,保存的容器就是Cookie,因此当我们完全禁掉浏览器的Cookie的时候,服务端的session也会不能正常使用

### Session的创建与删除

- 那么Session在何时创建呢？当然还是在服务器端程序运行的过程中创建的,不同语言实现的应用程序有不同创建Session的方法
- 当客户端第一次请求服务端,当server端程序调用`HttpServletRequest.getSession(true)`这样的语句时的时候,服务器会为客户端创建一个session,并将通过特殊算法算出一个session的ID,用来标识该session对象
- Session存储在服务器的内存中(tomcat服务器通过StandardManager类将session存储在内存中),也可以持久化到file,数据库,memcache,redis等,客户端只保存sessionid到Cookie中,而不会保存session
- 浏览器的关闭并不会导致Session的删除,只有当超时,程序调用`HttpSession.invalidate()`以及服务端程序关闭才会删除

#### Tomcat中的Session创建

- ManagerBase是所有session管理工具类的父类,它是一个抽象类,所有具体实现session管理功能的类都要继承这个类,该类有一个受保护的方法,该方法就是创建sessionId值的方法:
- tomcat的session的id值生成的机制是一个随机数加时间加上jvm的id值,jvm的id值会根据服务器的硬件信息计算得来,因此不同jvm的id值都是唯一的
- StandardManager类是tomcat容器里默认的session管理实现类,它会将session的信息存储到web容器所在服务器的内存里
- PersistentManagerBase也是继承ManagerBase类,它是所有持久化存储session信息的父类,PersistentManager继承了PersistentManagerBase,但是这个类只是多了一个静态变量和一个getName方法,目前看来意义不大,对于持久化存储session,tomcat还提供了StoreBase的抽象类,它是所有持久化存储Session的父类,另外tomcat还给出了文件存储FileStore和数据存储JDBCStore两个实现

### 分布式架构下 Session 共享方案

- Session是有状态的,一般存于服务器内存或硬盘中,当服务器采用分布式或集群时,session就会面对负载均衡问题
- 服务器集群Session共享的问题,在客户端与服务器通讯会话保持过程中,Session记录整个通讯的会话基本信息,但是在集群环境中,假设客户端第一次访问服务A,服务A响应返回了一个sessionId并且存入了本地Cookie中,第二次不访问服务A了,转去访问服务B,因为客户端中的Cookie中已经存有了sessionId,所以访问服务B的时候,会将sessionId加入到请求头中,而服务B因为通过sessionId没有找到相对应的数据,因此它就会创建一个新的sessionId并且响应返回给客户端,这样就造成了不能共享Session的问题

#### Session 复制

- 任何一个服务器上的 Session 发生改变(增删改),该节点会把这个 Session 的所有内容序列化,然后广播给所有其它节点,不管其他服务器需不需要 Session,以此来保证 Session 同步
- **优点**:可容错,各个服务器间 Session 能够实时响应
- **缺点**:会对网络负荷造成一定压力,如果 Session 量大的话可能会造成网络堵塞,拖慢服务器性能

#### 粘性 session /IP 绑定策略

- 配置ip_hash,请求随机绑定一个服务器,而且绑定后一个ip地址就固定访问一个服务器了,可以解决Session共享问题
- 但是该服务器挂了,会出现数据丢失,而且配置了IP绑定就不支持Nginx的负载均衡了

```nginx
upstream backserver {
  ip_hash;
  server 192.168.2.129:8080;
  server 192.168.2.130:8080;
}
```

#### 数据库同步session

- 将 session 存储到数据库中,保证 session 的持久化
- **优点**:服务器出现问题,session 不会丢失
- **缺点**:如果网站的访问量很大,把 session 存储到数据库中,会对数据库造成很大压力,还需要增加额外的开销维护数据库

#### JWT 代替session

- **JSON Web Token**:一般用来替换掉Session实现数据共享
- **优点**:
  - **无状态,可扩展**:在客户端存储的Token是无状态的,并且能够被扩展,基于这种无状态和不存储Session信息,负载均衡器能够将	用户信息从一个服务传到其他服务器上
  - **安全**:请求中发送token而不再是发送Cookie能够防止CSRF(跨站请求伪造)
  - **可提供接口给第三方服务**:使用token时,可以提供可选的权限给第三方应用程序
  - **多平台跨域**:对应用程序和服务进行扩展的时候,需要介入各种各种的设备和应用程序,假如我们的后端api服务器a.com只提供数据,而静态资源则存放在cdn 服务器b.com上,当我们从a.com请求b.com下面的资源时,由于触发浏览器的同源策略限制而被阻止
- **缺点**:
  - 服务端无法主动让token失效
  - 无法更新token有效期

**通过CORS(跨域资源共享)标准和token来解决资源共享和安全问题**

- 举个例子,我们可以设置b.com的响应首部字段为:

> Access-Control-Allow-Origin: *
>
> Access-Control-Allow-Headers: Authorization, X-Requested-With, Content-Type, Accept
>
> Access-Control-Allow-Methods: GET, POST, PUT,DELETE

- 第一行指定了让服务器能接受到来自所有域的请求
- 第二行指明了实际请求中允许携带的首部字段,这里加入了Authorization,用来存放token
- 第三行用于预检请求的响应,其指明了实际请求所允许使用的 HTTP 方法
- 然后用户从a.com携带有一个通过了验证的token访问B域名,数据和资源就能够在任何域上被请求到
- **注意**:在ACAO头部标明(designating)*时,不得带有像HTTP认证,客户端SSL证书和Cookies的证书

#### tomcat内置的session同步

**tomcat中server.xml直接配置**

```xml
<!-- 第1步:修改server.xml,在Host节点下添加如下Cluster节点 -->
<!-- 用于Session复制 -->
<Cluster className="org.apache.catalina.ha.tcp.SimpleTcpCluster" channelSendOptions="8">
  <Manager className="org.apache.catalina.ha.session.DeltaManager" expireSessionsOnShutdown="false" notifyListenersOnReplication="true" />
  <Channel className="org.apache.catalina.tribes.group.GroupChannel">
    <Membership className="org.apache.catalina.tribes.membership.McastService" address="228.0.0.4"
                port="45564" frequency="500" dropTime="3000" />
    <!-- 这里如果启动出现异常,则可以尝试把address中的"auto"改为"localhost" -->
    <Receiver className="org.apache.catalina.tribes.transport.nio.NioReceiver" address="auto" port="4000"
              autoBind="100" selectorTimeout="5000" maxThreads="6" />
    <Sender className="org.apache.catalina.tribes.transport.ReplicationTransmitter">
      <Transport className="org.apache.catalina.tribes.transport.nio.PooledParallelSender" />
    </Sender>
    <Interceptor className="org.apache.catalina.tribes.group.interceptors.TcpFailureDetector" />
    <Interceptor className="org.apache.catalina.tribes.group.interceptors.MessageDispatchInterceptor" />
  </Channel>
  <Valve className="org.apache.catalina.ha.tcp.ReplicationValve" filter="" />
  <Valve className="org.apache.catalina.ha.session.JvmRouteBinderValve" />
  <Deployer className="org.apache.catalina.ha.deploy.FarmWarDeployer" tempDir="/tmp/war-temp/"
            deployDir="/tmp/war-deploy/" watchDir="/tmp/war-listen/" watchEnabled="false" />
  <ClusterListener className="org.apache.catalina.ha.session.ClusterSessionListener" />
</Cluster>
```

**修改web.xml**

- web.xml中需加入`<distributable/>`以支持集群

```xml
<distributable/>
```

#### 分布式缓存

- 使用分布式缓存方案比如 Memcached,Redis 来缓存 session,但是要求 Memcached 或 Redis 必须是集群
- 把 session 放到 Redis 中存储,虽然架构上变得复杂,并且需要多访问一次 Redis,但是这种方案带来的好处也是很大的:
  - 实现了 session 共享
  - 可以水平扩展(增加 Redis 服务器)
  - 服务器重启 session 不丢失(不过也要注意 session 在 Redis 中的刷新/失效机制)
  - 不仅可以跨服务器 session 共享,甚至可以跨平台(例如网页端和 APP 端)

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-03-31-1-20210331214312505.png)

**实例**Spring提供了一个解决方案:Spring-Session用来解决两个服务之间Session共享的问题

- **在pom.xml中添加相关依赖**

```xml
<dependency>
  <groupId>com.alibaba</groupId>
  <artifactId>fastjson</artifactId>
  <version>1.2.47</version>
</dependency>
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>
<!-- Spring Session 与redis应用基本环境配置,需要开启redis后才可以使用,不然启动Spring boot会报错 -->
<dependency>
  <groupId>org.springframework.session</groupId>
  <artifactId>spring-session-data-redis</artifactId>
</dependency>
<dependency>
  <groupId>org.apache.commons</groupId>
  <artifactId>commons-pool2</artifactId>
</dependency>
<dependency>
  <groupId>redis.clients</groupId>
  <artifactId>jedis</artifactId>
</dependency>
```

- **修改application.properties全局配置文件(本地要开启redis服务)**

```properties
spring.redis.database=0
spring.redis.host=localhost
spring.redis.port=6379
#spring.redis.password=
spring.redis.jedis.pool.max-active=8
spring.redis.jedis.pool.max-wait=-1
spring.redis.jedis.pool.max-idle=8
spring.redis.jedis.pool.min-idle=8
spring.redis.timeout=10000
```

- **在代码中添加Session配置类**

```java
/**
 * 这个类用配置redis服务器的连接
 * maxInactiveIntervalInSeconds为SpringSession的过期时间(单位:秒)
 */
@EnableRedisHttpSession(maxInactiveIntervalInSeconds = 1800)
public class SessionConfig {
  // 冒号后的值为没有配置文件时,制动装载的默认值
  @Value("${redis.hostname:localhost}")
  private String hostName;
  @Value("${redis.port:6379}")
  private int port;
  // @Value("${redis.password}")
  // private String password;

  @Bean
  public JedisConnectionFactory jedisConnectionFactory() {
    RedisStandaloneConfiguration redisStandaloneConfiguration = new RedisStandaloneConfiguration();
    redisStandaloneConfiguration.setHostName(hostName);
    redisStandaloneConfiguration.setPort(port);
    // redisStandaloneConfiguration.setDatabase(0);
    // redisStandaloneConfiguration.setPassword(RedisPassword.of("123456"));
    return new JedisConnectionFactory(redisStandaloneConfiguration);
  }

  @Bean
  public StringRedisTemplate redisTemplate(RedisConnectionFactory redisConnectionFactory) {
    return new StringRedisTemplate(redisConnectionFactory);
  }
}
```

- **初始化Session配置**

```java
/**
* 初始化Session配置
*/
public class RedisSessionInitializer extends AbstractHttpSessionApplicationInitializer {
  public RedisSessionInitializer() {
    super(RedisSessionConfig.class);
  }
}
```

- **Spring-Sesion实现的原理**
  - 当Web服务器接收到请求后,请求会进入对应的Filter进行过滤,将原本需要由Web服务器创建会话的过程转交给Spring-Session进行创建
  - Spring-Session会将原本应该保存在Web服务器内存的Session存放到Redis中,然后Web服务器之间通过连接Redis来共享数据,达到Sesson共享的目的

## Token

- 访问资源接口(API)时所需要的资源凭证

  **特点**:

  - 服务端无状态化,可扩展性好
  - 支持移动端设备:小程序等移动端无法使用Cookies,所以可以用token的形式保存和返回sessionid
  - 支持跨程序调用
  - 可以防止 crsf 攻击

  - token 完全由应用管理,所以它可以避开同源策略

> **token 的身份验证流程**
>
>
>
> ![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-03-31-1-20210331211754249.png)
>
>
>
> 1. 客户端使用用户名跟密码请求登录
> 2. 服务端收到请求,去验证用户名与密码
> 3. 验证成功后,服务端会签发一个 token 并把这个 token 发送给客户端
> 4. 客户端收到 token 以后,会把它存储起来,比如放在 Cookie 里或者 localStorage 里
> 5. 客户端每次向服务端请求资源的时候将服务端签发的 token放在请求头中
> 6. 服务端收到请求,然后去验证客户端请求里面带着的 token,如果验证成功,就向客户端返回请求的数据

### Refresh Token

- 另外一种 token——refresh token
- refresh token 是专用于刷新 access token 的 token,如果没有 refresh token,也可以刷新 access token,但每次刷新都要用户输入登录用户名与密码,会很麻烦,有了 refresh token,可以减少这个麻烦,客户端直接用 refresh token 去更新 access token,无需用户进行额外的操作

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-03-31-1.png" alt="img" style="zoom:50%;" />

- Access Token 的有效期比较短,当 Acesss Token 由于过期而失效时,使用 Refresh Token 就可以获取到新的 Token,如果 Refresh Token 也失效了,用户就只能重新登录了
- Refresh Token 及过期时间是存储在服务器的数据库中,只有在申请新的 Acesss Token 时才会验证,不会对业务接口响应时间造成影响,也不需要向 Session 一样一直保持在内存中以应对大量的请求