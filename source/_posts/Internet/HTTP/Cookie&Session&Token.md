---
title: HTTP Cookie&Session&Token
categories:
- Internet
- HTTP
---
# HTTP Cookie&Session&Token

## Cookie

- cookie是一个非常具体的东西,指的就是浏览器里面能永久存储的一种数据,仅仅是浏览器实现的一种数据存储功能
- cookie由服务器生成,发送给浏览器,浏览器把cookie以kv键值对形式保存到某个目录下的文本文件内,下一次请求同一网站时会把该cookie发送给服务器
- 由于cookie是存在客户端上的,所以浏览器加入了一些限制确保cookie不会被恶意使用,同时不会占据太多磁盘空间,所以每个域的cookie数量是有限的

### Cookie的结构

- cookie的内容主要包括：名字，值，过期时间，路径和域。路径与域合在一起就构成了cookie的作用范围。
- 如果不设置过期时间，则表示这个cookie的生命期为浏览器会话期间，只要关闭浏览器窗口，cookie就消失了，这种生命期为浏览器会话期的 cookie被称为会话cookie。会话cookie一般不存储在硬盘上而是保存在内存里。如果设置了过期时间，浏览器就会把cookie保存到硬盘上，关闭后再次打开浏览器，这些cookie仍然有效直到超过设定的过期时间。

### Cookie的使用

- cookie 的使用是由浏览器按照一定的原则在后台自动发送给服务器的。
- 当客户端二次向服务器发送请求的时候，浏览器检查所有存储的cookie，如果某个cookie所声明的作用范围大于等于将要请求的资源所在的位置，则把该cookie附在请求资源的HTTP请求头上发送给服务器。
- 有了Cookie这样的技术实现，服务器在接收到来自客户端浏览器的请求之后，就能够通过分析存放于请求头的Cookie得到客户端特有的信息，从而动态生成与该客户端相对应的内容。通常，我们可以从很多网站的登录界面中看到“请记住我”这样的选项，如果你勾选了它之后再登录，那么在下一次访问该网站的时候就不需要进行重复而繁琐的登录动作了，而这个功能就是通过Cookie实现的。

### Cookie作用域

- 只能向当前域或者更高级域设置cookie
- 例如 `client.com` 不能向 `a.client.com` 设置cookie, 而 `a.client.com` 可以向 `client.com` 设置cookie
- 读取cookie情况同上

### 客户端设置cookie与服务端设置cookie的区别

- 无论是客户端还是服务端, 都只能向自己的域或者更高级域设置cookie,例如 `client.com` 不能向 `server.com` 设置cookie, 同样 `server.com` 也不能向 `client.com` 设置cookie
- 服务端可以设置 `httpOnly: true`, 带有该属性的cookie客户端无法读取
- 客户端只会带上与请求同域的cookie, 例如 `client.com/index.html` 会带上 `client.com` 的cookie,`server.com/app.js` 会带上 `server.com` 的cookie, 并且也会带上`httpOnly`的cookie
- 但是, 如果是向服务端的ajax请求, 则不会带上cookie

### 同域/跨域ajax请求的cookie

- fetch在默认情况下, 不管是同域还是跨域ajax请求都不会带上cookie, 只有当设置了 `credentials` 时才会带上该ajax请求所在域的cookie, 服务端需要设置响应头 `Access-Control-Allow-Credentials: true`, 否则浏览器会因为安全限制而报错, 拿不到响应
- Axios和jQuery在同域ajax请求时会带上cookie, 跨域请求不会, 跨域请求需要设置 `withCredentials` 和服务端响应头

#### fetch 设置 credentials

> By default, fetch won't send or receive any cookies from the server, resulting in unauthenticated requests if the site relies on maintaining a user session (to send cookies, the credentials init option must be set). Since Aug 25, 2017. The spec changed the default credentials policy to same-origin. Firefox changed since 61.0b13.

- 使fetch带上cookie

```js
fetch(url, {
    credentials: "include", // include, same-origin, omit
})
```

- include: 跨域ajax带上cookie
- same-origin: 仅同域ajax带上cookie
- omit: 任何情况都不带cookie

#### axios 设置 withCredentials

> // `withCredentials` indicates whether or not cross-site Access-Control requests, should be made using credentials // default: withCredentials: false

- 使axios带上cookie

```js
axios.get('http://server.com', {withCredentials: true})
```

#### jQuery 设置 withCredentials

```js
$.ajax({
    method: 'get',
    url: 'http://server.com',
    xhrFields: {
        withCredentials: true
    }
})
```

## Session

- Session一般叫做回话，Session技术是http状态保持在服务端的解决方案，它是通过服务器来保持状态的。我们可以把客户端浏览器与服务器之间一系列交互的动作称为一个 Session。是服务器端为客户端所开辟的存储空间，在其中保存的信息就是用于保持状态。
- 服务器要知道当前发请求给自己的是谁,为了做这种区分,服务器就要给每个客户端分配不同的"身份标识”,然后客户端每次向服务器发请求的时候,都带上这个"身份标识”,服务器就知道这个请求来自于谁了,至于客户端怎么保存这个"身份标识”,可以有很多种方式,对于浏览器客户端,大家都默认采用cookie的方式    
- 因此，session是解决http协议无状态问题的服务端解决方案，它能让客户端和服务端一系列交互动作变成一个完整的事务。
- cookie和session的方案虽然分别属于客户端和服务端，但是服务端的session的实现对客户端的cookie有依赖关系的，服务端执行session机制时候会生成session的id值，这个id值会发送给客户端，客户端每次请求都会把这个id值放到http请求的头部发送给服务端，而这个id值在客户端会保存下来，保存的容器就是cookie，因此当我们完全禁掉浏览器的cookie的时候，服务端的session也会不能正常使用。

### Session的创建与删除

- 那么Session在何时创建呢？当然还是在服务器端程序运行的过程中创建的，不同语言实现的应用程序有不同创建Session的方法。
- 当客户端第一次请求服务端，当server端程序调用`HttpServletRequest.getSession(true)`这样的语句时的时候，服务器会为客户端创建一个session，并将通过特殊算法算出一个session的ID，用来标识该session对象。
- Session存储在服务器的内存中(tomcat服务器通过StandardManager类将session存储在内存中)，也可以持久化到file，数据库，memcache，redis等。客户端只保存sessionid到cookie中，而不会保存session。
- 浏览器的关闭并不会导致Session的删除，只有当超时、程序调用`HttpSession.invalidate()`以及服务端程序关闭才会删除。

### Tomcat中的Session创建

- ManagerBase是所有session管理工具类的基类，它是一个抽象类，所有具体实现session管理功能的类都要继承这个类，该类有一个受保护的方法，该方法就是创建sessionId值的方法：
- tomcat的session的id值生成的机制是一个随机数加时间加上jvm的id值，jvm的id值会根据服务器的硬件信息计算得来，因此不同jvm的id值都是唯一的
- StandardManager类是tomcat容器里默认的session管理实现类，它会将session的信息存储到web容器所在服务器的内存里。
- PersistentManagerBase也是继承ManagerBase类，它是所有持久化存储session信息的基类，PersistentManager继承了PersistentManagerBase，但是这个类只是多了一个静态变量和一个getName方法，目前看来意义不大，对于持久化存储session，tomcat还提供了StoreBase的抽象类，它是所有持久化存储session的基类，另外tomcat还给出了文件存储FileStore和数据存储JDBCStore两个实现。

### Session 共享

- session是有状态的,一般存于服务器内存或硬盘中,当服务器采用分布式或集群时,session就会面对负载均衡问题
- 服务器集群Session共享的问题，在客户端与服务器通讯会话保持过程中，Session记录整个通讯的会话基本信息。但是在集群环境中，假设客户端第一次访问服务A，服务A响应返回了一个sessionId并且存入了本地Cookie中。第二次不访问服务A了，转去访问服务B。因为客户端中的Cookie中已经存有了sessionId，所以访问服务B的时候，会将sessionId加入到请求头中，而服务B因为通过sessionId没有找到相对应的数据，因此它就会创建一个新的sessionId并且响应返回给客户端。这样就造成了不能共享Session的问题。

> **实现 Session 共享的方法**
>
> - 使用cookie来完成（很明显这种不安全的操作并不可靠）
> - 使用Nginx中的ip绑定策略，同一个ip只能在指定的同一个机器访问（不支持负载均衡）
> - 使用数据库同步session（效率不高）
> - 使用tomcat内置的session同步（同步可能会产生延迟）
> - 使用token代替session
> - 使用Spring-Session+Redis实现

#### 使用Cookie实现

- 这个方式原理是将系统用户的Session信息加密、序列化后，以Cookie的方式， 统一种植在根域名下（如：.host.com）
- 利用浏览器访问该根域名下的所有二级域名站点时，会传递与之域名对应的所有Cookie内容的特性，从而实现用户的Cookie化Session在多服务间的共享访问,无需额外的服务器资源

**缺点**

- 由于受http协议头信息长度的限制，仅能够存储小部分的用户信息
- 同时Cookie化的 Session内容需要进行安全加解密（如：采用DES、RSA等进行明文加解密；再由MD5、SHA-1等算法进行防伪认证）
- 另外它也会占用一定的带宽资源，因为浏览器会在请求当前域名下任何资源时将本地Cookie附加在http头中传递到服务器
- 存在安全隐患

#### 使用Nginx中的ip绑定策略

- 配置ip_hash,请求随机绑定一个服务器，而且绑定后一个ip地址就固定访问一个服务器了，可以解决session共享问题
- 但是该服务器挂了，会出现数据丢失,而且配置了IP绑定就不支持Nginx的负载均衡了

```nginx
upstream backserver { 
  ip_hash; 
  server 192.168.2.129:8080; 
  server 192.168.2.130:8080; 
} 
```

#### 使用数据库同步session

- 以为MySQL为例，每次将session数据存到数据库中。这个方案还是比较可行的，不少开发者使用了这种方式。但它的缺点在于Session的并发读写能力取决于MySQL数据库的性能，对数据库的压力大，同时需要自己实现Session淘汰逻辑，以便定时从数据表中更新、删除 Session记录，当并发过高时容易出现表锁，虽然可以选择行级锁的表引擎，但很多时候这个方案不是最优方案。

#### 使用token代替session

- **JSON Web Token**:一般用来替换掉Session实现数据共享
- **无状态、可扩展** ：在客户端存储的Token是无状态的，并且能够被扩展。基于这种无状态和不存储Session信息，负载均衡器能够将用户信息从一个服务传到其他服务器上。
- **安全**：请求中发送token而不再是发送cookie能够防止CSRF(跨站请求伪造)。
- **可提供接口给第三方服务**：使用token时，可以提供可选的权限给第三方应用程序
- **多平台跨域**:对应用程序和服务进行扩展的时候，需要介入各种各种的设备和应用程序。 假如我们的后端api服务器a.com只提供数据，而静态资源则存放在cdn 服务器b.com上。当我们从a.com请求b.com下面的资源时，由于触发浏览器的同源策略限制而被阻止。

**通过CORS（跨域资源共享）标准和token来解决资源共享和安全问题**

- 举个例子，我们可以设置b.com的响应首部字段为：

> Access-Control-Allow-Origin: *
>
> Access-Control-Allow-Headers: Authorization, X-Requested-With, Content-Type, Accept
>
> Access-Control-Allow-Methods: GET, POST, PUT,DELETE

- 第一行指定了让服务器能接受到来自所有域的请求
- 第二行指明了实际请求中允许携带的首部字段，这里加入了Authorization，用来存放token
- 第三行用于预检请求的响应。其指明了实际请求所允许使用的 HTTP 方法
- 然后用户从a.com携带有一个通过了验证的token访问B域名，数据和资源就能够在任何域上被请求到
- **注意**:在ACAO头部标明(designating)*时,不得带有像HTTP认证,客户端SSL证书和cookies的证书

#### 使用tomcat内置的session同步

**tomcat中server.xml直接配置**

```xml
<!-- 第1步：修改server.xml，在Host节点下添加如下Cluster节点 -->
<!-- 用于Session复制 -->
<Cluster className="org.apache.catalina.ha.tcp.SimpleTcpCluster" channelSendOptions="8">
    <Manager className="org.apache.catalina.ha.session.DeltaManager" expireSessionsOnShutdown="false" notifyListenersOnReplication="true" />
    <Channel className="org.apache.catalina.tribes.group.GroupChannel">
        <Membership className="org.apache.catalina.tribes.membership.McastService" address="228.0.0.4" 
                    port="45564" frequency="500" dropTime="3000" />
        <!-- 这里如果启动出现异常，则可以尝试把address中的"auto"改为"localhost" -->
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

- web.xml中需加入`<distributable/>`以支持集群。

```xml
<distributable/>
```

#### Spring-Session+Redis实现

- Spring提供了一个解决方案：Spring-Session用来解决两个服务之间Session共享的问题

**在pom.xml中添加相关依赖**

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
<!-- spring session 与redis应用基本环境配置,需要开启redis后才可以使用，不然启动Spring boot会报错 -->
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

**修改application.properties全局配置文件（本地要开启redis服务）**

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

**在代码中添加Session配置类**

```java
/**
 * 这个类用配置redis服务器的连接
 * maxInactiveIntervalInSeconds为SpringSession的过期时间（单位：秒）
 */
@EnableRedisHttpSession(maxInactiveIntervalInSeconds = 1800)
public class SessionConfig {
    // 冒号后的值为没有配置文件时，制动装载的默认值
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

**初始化Session配置**

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

**Spring-Sesion实现的原理**

- 当Web服务器接收到请求后，请求会进入对应的Filter进行过滤，将原本需要由Web服务器创建会话的过程转交给Spring-Session进行创建。
- Spring-Session会将原本应该保存在Web服务器内存的Session存放到Redis中。然后Web服务器之间通过连接Redis来共享数据，达到Sesson共享的目的。

## Token

- 客户端登陆传递信息给服务端,服务端收到后把用户信息加密(token)传给客户端,客户端将token存放于cookie,localStroage等容器中,客户端每次访问都传递token,服务端解密token,就知道这个用户是谁了,通过cpu加解密,服务端就不需要存储session占用存储空间,就很好的解决负载均衡多服务器的问题了,这个方法叫做JWT
- token 的认证方式类似于**临时的证书签名**, 并且是一种服务端无状态的认证方式, 非常适合于 REST API 的场景. 所谓无状态就是服务端并不会保存身份认证相关的数据
- token 在客户端一般存放于localStorage,cookie,或sessionStorage中,在服务器一般存于数据库中
- token 可以防止 crsf 攻击:因为在POST请求的瞬间,cookie会被浏览器自动添加到请求头中,但token不同,浏览器不会自动添加到headers里,攻击者也无法访问用户cookie 中的token并添加到 headers,所以提交的表单无法通过服务器过滤,也就无法形成攻击

### Token 的结构

- `uid+time+sign[+固定参数]`
  - uid: 用户唯一身份标识
  - time: 当前时间的时间戳
  - sign: 签名, 使用 hash/encrypt 压缩成定长的十六进制字符串,以防止第三方恶意拼接
  - 固定参数(可选): 将一些常用的固定参数加入到 token 中是为了避免重复查库

### 基于Token的验证原理

> 1. 客户端通过用户名和密码登录服务器
> 2. 服务端对客户端身份进行验证
> 3. 端服务端会通过一些算法对该用户生成Token，如常用的HMAC-SHA256算法，然后通过BASE64编码将这个token发送给客户端
> 4. 客户端将Token保存到本地浏览器，一般保存到cookie中；
> 5. 客户端发起请求，需要携带该Token
> 6. 服务端收到请求后，首先验证Token，之后返回数据
>
> <img src="https://cdn.jsdelivr.net/gh/LuShan123888/Files@main/Pictures/2021-03-05-1010726-20191103045557729-778248059.png" alt="img" style="zoom:33%;" />　　
