---
title: Spring 整合 Shiro
categories:
  - Software
  - Language
  - SpringFramework
  - Spring
---
# Spring 整合 Shiro

- Apache Shiro 是一个功能强大，灵活的，开源的安全框架，它可以干净利落地处理身份验证，授权，企业会话管理和加密。
- Apache Shiro 的首要目标是易于使用和理解，安全通常很复杂，甚至让人感到很痛苦，但是 Shiro 却不是这样子的，一个好的安全框架应该屏蔽复杂性，向外暴露简单，直观的 API，来简化开发人员实现应用程序安全所花费的时间和精力。
- Shiro 能做什么呢？
    - 验证用户身份。
    - 用户访问权限控制，比如：判断用户是否分配了一定的安全角色，判断用户是否被授予完成某个操作的权限。
    - 在非 Web 或 EJB 容器的环境下可以任意使用 Session API
    - 可以响应认证，访问控制，或者 Session 生命周期中发生的事件。
    - 可将一个或以上用户安全数据源数据组合成一个复合的用户"view”（视图）
    - 支持单点登录（SSO）功能。
    - 支持提供"Remember Me”服务，获取用户关联信息而无需登录。
    - 等等——都集成到一个有凝聚力的易于使用的 API
- Shiro 致力在所有应用环境下实现上述功能，小到命令行应用程序，大到企业应用中，而且不需要借助第三方框架，容器，应用服务器等，当然 Shiro 的目的是尽量的融入到这样的应用环境中去，但也可以在它们之外的任何环境下开箱即用。

## Shiro 特性

- Apache Shiro 是一个全面的，蕴含丰富功能的安全框架，下图为描述 Shiro 功能的框架图：

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-2020-11-18-ShiroFeatures.png)

- Authentication（认证）, Authorization（授权）, Session Management（会话管理）, Cryptography（加密）被 Shiro 框架的开发团队称之为应用安全的四大基石，那么就让我们来看看它们吧：
    - **Authentication（认证）**：用户身份识别，通常被称为用户"登录”
    - **Authorization（授权）**：访问控制，比如某个用户是否具有某个操作的使用权限。
    - **Session Management（会话管理）**：特定于用户的会话管理，甚至在非web 或 EJB 应用程序。
    - **Cryptography（加密）**：在对数据源使用加密算法加密的同时，保证易于使用。
- 还有其他的功能来支持和加强这些不同应用环境下安全领域的关注点，特别是对以下的功能支持：
    - Web支持：Shiro 提供的 Web 支持 api，可以很轻松的保护 Web 应用程序的安全。
    - 缓存：缓存是 Apache Shiro 保证安全操作快速，高效的重要手段。
    - 并发：Apache Shiro 支持多线程应用程序的并发特性。
    - 测试：支持单元测试和集成测试，确保代码和预想的一样安全。
    - Run As：这个功能允许用户假设另一个用户的身份（在许可的前提下）
    - Remember Me：跨 session 记录用户的身份，只有在强制需要时才需要登录。
- **注意**:Shiro 不会去维护用户，维护权限，这些需要我们自己去设计/提供，然后通过相应的接口注入给 Shiro

## High-Level Overview 高级概述

- 在概念层，Shiro 架构包含三个主要的理念：Subject,SecurityManager和 Realm，下面的图展示了这些组件如何相互作用，我们将在下面依次对其进行描述。

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-2020-11-18-ShiroBasicArchitecture.png)

- Subject：当前用户，Subject 可以是一个人，但也可以是第三方服务，守护进程帐户，时钟守护任务或者其它–当前和软件交互的任何事件。
- SecurityManager：管理所有Subject,SecurityManager 是 Shiro 架构的核心，配合内部安全组件共同组成安全伞。
- Realms：用于进行权限信息的验证，由我们自己实现，Realm 本质上是一个特定的安全 DAO，它封装与数据源连接的细节，得到Shiro 所需的相关的数据，在配置 Shiro 的时候，你必须指定至少一个Realm 来实现认证（authentication）和/或授权（authorization)

- 我们需要实现Realms的Authentication 和 Authorization，其中 Authentication 是用来验证用户身份，Authorization 是授权访问控制，用于对用户进行的操作授权，证明该用户是否允许进行当前操作，如访问某个链接，某个资源文件等。

## 运行原理

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-2020-11-18-1-5714097.png)

1. Subject：主体，可以看到主体可以是任何与应用交互的"用户”
2. SecurityManager：相当于 SpringMVC 中的 DispatcherServlet 或者 Struts2 中的 FilterDispatcher，它是 Shiro 的核心，所有具体的交互都通过 SecurityManager 进行控制，它管理着所有 Subject，且负责进行认证和授权，及会话，缓存的管理。
3. Authenticator：认证器，负责主体认证的，这是一个扩展点，如果用户觉得 Shiro 默认的不好，我们可以自定义实现，其需要认证策略（Authentication Strategy)，即什么情况下算用户认证通过了。
4. Authrizer：授权器，或者访问控制器，它用来决定主体是否有权限进行相应的操作，即控制着用户能访问应用中的哪些功能。
5. Realm：可以有1个或多个 Realm，可以认为是安全实体数据源，即用于获取安全实体的，它可以是 JDBC 实现，也可以是 LDAP 实现，或者内存实现等。
6. SessionManager：如果写过 Servlet 就应该知道 Session 的概念，Session 需要有人去管理它的生命周期，这个组件就是 SessionManager，而 Shiro 并不仅仅可以用在 Web 环境，也可以用在如普通的 JavaSE 环境。
7. SessionDAO：数据访问对象，用于会话的 CRUD，我们可以自定义 SessionDAO 的实现，控制 session 存储的位置，如通过 JDBC 写到数据库或通过 jedis 写入 Redis 中，另外 SessionDAO 中可以使用 Cache 进行缓存，以提高性能。
8. CacheManager：缓存管理器，它来管理如用户，角色，权限等的缓存的，因为这些数据基本上很少去改变，放到缓存中后可以提高访问的性能。
9. Cryptography：密码模块，Shiro 提高了一些常见的加密组件用于如密码加密/解密的。

## pom.xml

```xml
<dependency>
    <groupId>org.apache.shiro</groupId>
    <artifactId>shiro-spring</artifactId>
    <version>1.4.0</version>
</dependency>
```

## 实体类

### 用户信息

```java
@Data
public class UserInfo {
    private Long id; // 主键。
    private String username; // 登录账户，唯一。
    private String name; // 名称（匿名或真实姓名），用于UI显示。
    private String password; // 密码。
    private String salt; // 加密密码的盐。
    @JsonIgnoreProperties(value = {"userInfos"})
    private List<SysRole> roles; // 一个用户具有多个角色。
}
```

### 角色信息

```java
@Data
public class SysRole {
    private Long id; // 主键。
    private String name; // 角色名称，如 admin/user
    private String description; // 角色描述，用于UI显示。
    // 角色 -- 权限关系：多对多。
    @JsonIgnoreProperties(value = {"roles"})
    private List<SysPermission> permissions;
    // 用户 -- 角色关系：多对多。
    @JsonIgnoreProperties(value = {"roles"})
    private List<UserInfo> userInfos;// 一个角色对应多个用户。

}
```

### 权限信息

```java
@Data
public class SysPermission {
    private Long id; // 主键。
    private String name; // 权限名称，如 user:select
    private String description; // 权限描述，用于UI显示。
    private String url; // 权限地址。
    @JsonIgnoreProperties(value = {"permissions"})
    private List<SysRole> roles; // 一个权限可以被多个角色使用。

}
```

-  **注意**：当要使用RESTful风格返回给前台JSON数据的时候，比如当我们想要返回给前台一个用户信息时，由于一个用户拥有多个角色，一个角色又拥有多个权限，而权限跟角色也是多对多的关系，也就是造成了查用户→查角色→查权限→查角色→查用户…这样的无限循环，导致传输错误，所以我们根据这样的逻辑在每一个实体类返回JSON时使用了一个`@JsonIgnoreProperties`注解，来排除自身的无限引用的过程，也就是打断这样的无限循环。

## MyShiroRealm

```java
public class MyShiroRealm extends AuthorizingRealm {
    @Resource
    private UserInfoService userInfoService;

    @Override
    protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principalCollection) {
        SimpleAuthorizationInfo simpleAuthorizationInfo = new SimpleAuthorizationInfo();
        // 运行到这里说明用户已经通过验证了。
        UserInfo userInfo = (UserInfo) principalCollection.getPrimaryPrincipal();
        for (SysRole role : userInfo.getRoles()) {
            simpleAuthorizationInfo.addRole(role.getName());
            for (SysPermission permission : role.getPermissions()) {
                simpleAuthorizationInfo.addStringPermission(permission.getName());
            }
        }
        return simpleAuthorizationInfo;
    }

    @Override
    protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken authenticationToken) throws AuthenticationException {
        // 获取用户输入的账户。
        String username = (String) authenticationToken.getPrincipal();
        System.out.println(authenticationToken.getPrincipal());
        // 通过username从数据库中查找 UserInfo 对象。
        // 实际项目中，这里可以根据实际情况做缓存，如果不做，Shiro自己也是有时间间隔机制，2分钟内不会重复执行该方法。
        UserInfo userInfo = userInfoService.findByUsername(username);
        if (null == userInfo) {
            return null;
        }

        SimpleAuthenticationInfo simpleAuthenticationInfo = new SimpleAuthenticationInfo(
            userInfo, // 用户名。
            userInfo.getPassword(), // 密码。
            ByteSource.Util.bytes(userInfo.getSalt()), // salt=username+salt
            getName() // realm name
        );
        return simpleAuthenticationInfo;
    }
}
```

## ShiroConfig

```java
@Configuration
public class ShiroConfig {

    @Bean
    public ShiroFilterFactoryBean shirFilter(SecurityManager securityManager) {
        System.out.println("ShiroConfiguration.shirFilter()");
        ShiroFilterFactoryBean shiroFilterFactoryBean = new ShiroFilterFactoryBean();
        shiroFilterFactoryBean.setSecurityManager(securityManager);
        // 拦截器。
        Map<String, String> filterChainDefinitionMap = new LinkedHashMap<String, String>();
        // 配置不会被拦截的链接以顺序判断。
        filterChainDefinitionMap.put("/static/**", "anon");
        // 配置退出过滤器。
        filterChainDefinitionMap.put("/logout", "logout");
        // 过滤链定义，从上向下顺序执行，一般将/**放在最为下边。
        filterChainDefinitionMap.put("/**", "authc");
        shiroFilterFactoryBean.setFilterChainDefinitionMap(filterChainDefinitionMap);

        // 登陆Url，如果不设置默认会自动寻找Web工程根目录下的"/login.jsp"页面。
        shiroFilterFactoryBean.setLoginUrl("/login");
        // 登录成功后要跳转的链接。
        shiroFilterFactoryBean.setSuccessUrl("/index");
        // 未授权界面;
        shiroFilterFactoryBean.setUnauthorizedUrl("/403");
        return shiroFilterFactoryBean;
    }

    /**
     * 凭证匹配器。
     *（由于密码校验交给Shiro的SimpleAuthenticationInfo进行处理了）
     * @return
     */
    @Bean
    public HashedCredentialsMatcher hashedCredentialsMatcher() {
        HashedCredentialsMatcher hashedCredentialsMatcher = new HashedCredentialsMatcher();
        hashedCredentialsMatcher.setHashAlgorithmName("md5"); // 散列算法：这里使用MD5算法;
        hashedCredentialsMatcher.setHashIterations(2); // 散列的次数，比如散列两次，相当于 md5(md5(""));
        return hashedCredentialsMatcher;
    }

    @Bean
    public MyShiroRealm myShiroRealm() {
        MyShiroRealm myShiroRealm = new MyShiroRealm();
        myShiroRealm.setCredentialsMatcher(hashedCredentialsMatcher());
        return myShiroRealm;
    }

    @Bean
    public SecurityManager securityManager() {
        DefaultWebSecurityManager securityManager = new DefaultWebSecurityManager();
        securityManager.setRealm(myShiroRealm());
        return securityManager;
    }

    /**
     * 开启shiro aop注解支持。
     * 使用代理方式;所以需要开启代码支持;
     * @param securityManager
     * @return
     */
    @Bean
    public AuthorizationAttributeSourceAdvisor authorizationAttributeSourceAdvisor(SecurityManager securityManager) {
        AuthorizationAttributeSourceAdvisor authorizationAttributeSourceAdvisor = new AuthorizationAttributeSourceAdvisor();
        authorizationAttributeSourceAdvisor.setSecurityManager(securityManager);
        return authorizationAttributeSourceAdvisor;
    }

    @Bean(name = "simpleMappingExceptionResolver")
    public SimpleMappingExceptionResolver createSimpleMappingExceptionResolver() {
        SimpleMappingExceptionResolver r = new SimpleMappingExceptionResolver();
        Properties mappings = new Properties();
        mappings.setProperty("DatabaseException", "databaseError"); // 数据库异常处理。
        mappings.setProperty("UnauthorizedException", "403");
        r.setExceptionMappings(mappings);  // None by default
        r.setDefaultErrorView("error");    // No default
        r.setExceptionAttribute("ex");     // Default is "exception"
        //r.setWarnLogCategory("example.MvcLogger");     // No default
        return r;
    }
}
```

### 过滤器

- Filter Chain定义说明。
    - 一个URL可以配置多个Filter，使用逗号分隔。
    - 当设置多个过滤器时，全部验证通过，才视为通过。
    - 部分过滤器可指定参数，如perms,roles

| 过滤器简称 |                        对应的 Java 类                        |
| :--------: | :----------------------------------------------------------: |
|    anon    |      org.apache.shiro.web.filter.authc.AnonymousFilter       |
|   authc    |  org.apache.shiro.web.filter.authc.FormAuthenticationFilter  |
| authcBasic | org.apache.shiro.web.filter.authc.BasicHttpAuthenticationFilter |
|   perms    | org.apache.shiro.web.filter.authz.PermissionsAuthorizationFilter |
|    port    |         org.apache.shiro.web.filter.authz.PortFilter         |
|    rest    | org.apache.shiro.web.filter.authz.HttpMethodPermissionFilter |
|   roles    |  org.apache.shiro.web.filter.authz.RolesAuthorizationFilter  |
|    ssl     |         org.apache.shiro.web.filter.authz.SslFilter          |
|    user    |         org.apache.shiro.web.filter.authc.UserFilter         |
|   logout   | org.apache.shiro.web.filter.authc.LogoutFilter noSessionCreation |

- `anon`：表示任何人都可以访问。
- `authc `：表示该 uri 需要认证才能访问。
- `authcBasic`：表示该 uri 需要 httpBasic 认证。
- `perms[user:add:*]`：表示该 uri 需要认证用户拥有 user:add:* 权限才能访问。
- `port[8081]`：表示该 uri 需要使用 8081 端口。
- `rest[user]`：相当于`/admins/=perms[user:method]`，其中，method 表示  get,post,delete 等。
- `roles[admin]`：表示该 uri 需要认证用户拥有 admin 角色才能访问。
- `ssl`：表示该 uri 需要使用 https 协议。
- `user`：表示该 uri 需要认证或通过记住我认证才能访问。
- `logout`：表示注销，可以当作固定配置。

**注意**

- anon,authcBasic,auchc,user 是认证过滤器。
- perms,roles,ssl,rest,port 是授权过滤器。

## ShiroController

```java
@Controller
public class ShiroController {

    @GetMapping({"/", "/index"})
    public String toIndex(Model model) {
        model.addAttribute("msg", "Hello Shiro");
        return "index";
    }

    @RequestMapping("/toLogin")
    public String toLogin() {
        return "login";
    }

    @RequiresRoles( "admin" )
    @RequiresPermissions("userInfo:add")
    @GetMapping("/user/add")
    public String add() {
        return "user/add";
    }

    @RequiresRoles( "admin")
    @RequiresPermissions("userInfo:update")
    @GetMapping("/user/update")
    public String update() {
        return "user/update";
    }


    @RequestMapping("/login")
    public String login(String username, String password, Model model) {
        // 获取当前的用户。
        Subject currentUser = SecurityUtils.getSubject();
        // 封装用户的登录数据。
        UsernamePasswordToken token = new UsernamePasswordToken(username, password);
        try {
            // 执行登录的方法。
            currentUser.login(token);
            // 开启记住登录状态功能。
            token.setRememberMe(true);
            // 用户名不存在。
        } catch (UnknownAccountException e) {
            model.addAttribute("msg", "用户名错误");
            return "login";
            // 密码不存在。
        } catch (IncorrectCredentialsException e) {
            model.addAttribute("msg", "密码错误");
            return "login";
            // 账户被锁定。
        } catch (LockedAccountException e) {
            System.out.println("用户名 " + token.getPrincipal() + " 被锁定 !");
            return "login";
        }
        // 认证成功后。
        if (currentUser.isAuthenticated()) {
            System.out.println("用户 " + currentUser.getPrincipal() + " 登陆成功!");
            // 测试角色。
            System.out.println("是否拥有 manager 角色：" + currentUser.hasRole("manager"));
            // 测试权限。
            System.out.println("是否拥有 user:create 权限" + currentUser.isPermitted("user:create"));
        }
        return "index";
    }

    @RequestMapping("/403")
    @ResponseBody
    public String unauthorized() {
        return "未经授权无法访问此页面";
    }

    @RequestMapping("/logout")
    @ResponseBody
    public String logout() {
        Subject currentUser = SecurityUtils.getSubject();
        currentUser.logout();
        return "注销成功";
    }
}
```

## 注解

- 在使用 Shiro 的注解之前，请确保项目中已经添加支持 AOP 功能的相关jar包。

```java
// 角色校验。
@RequiresRoles( "manager" )
public String save() {
    //TODO
}
// 权限校验。
@RequiresPermissions("user:manage")
public String delete() {
    //TODO
}
// 用户校验。
@RequiresUser
public Map<String,Object> getLogout(){
    //TODO
}
```

| 注解名称                | 说明                                                         |
| ----------------------- | ------------------------------------------------------------ |
| @RequiresAuthentication | 使用该注解标注的类，方法等在访问时，当前Subject必须在当前session中已经过认证 |
| @RequiresGuest          | 使用该注解标注的类，方法等在访问时，当前Subject可以是"Guest"身份，不需要经过认证或者在原先的session中存在记录 |
| @RequersUser            | 验证用户是否被记忆，有两种含义一种是成功登录的（subject.isAuthenticated(）结果为true);另外一种是被记忆的（subject.isRemembere(）结果为true). |
| @RequiresPermission     | 当前Subject需要拥有某些特定的权限时，才能执行被该注解标主的方法如果没有权限，则方法不会执行还会抛出AuthorizationException异常 |
| @RequiresRoles          | 当前Subject必须拥有所有指定的角色时，才能访问被该注解标主的方法如果没有角色则方法不会执行还会抛出AuthorizationException异常 |

- 允许存在多个角色和权限，默认逻辑是 AND，也就是同时拥有这些才可以访问方法，可以在注解中以参数的形式设置成 OR

```java
// 拥有其中一个角色就可以访问。
@RequiresRoles(value={"ADMIN","USER"},logical = Logical.OR)
// 拥有所有权限才可以访问。
@RequiresPermissions (value={"sys:user:info" ,"sys:role: info", logical = Logical.AND)
```

- Shiro 注解是存在顺序的，当多个注解在一个方法上的时候，会逐个检查，知道全部通过为止。
- 默认拦截顺序是： RequiresRoles->RequiresPermissions->RequiresAuthentication->RequiresUser->RequiresGuest

```java
// 拥有ADMIN角色同时还要拥有有sys:role:info权限。
@RequiresRoles (value={"ADMIN")
@RequiresPermissions("sys:role:info")
```