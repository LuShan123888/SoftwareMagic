---
title: Spring 整合 Spring  Security
categories:
- Software
- Backend
- SpringFramework
- Spring
---
# Spring 整合 Spring  Security

## 简介

- Spring Security 是针对Spring项目的安全框架,也是Spring Boot底层安全模块默认的技术选型,可以实现强大的Web安全控制,对于安全控制,仅需要引入 spring-boot-starter-security 模块,进行少量的配置,即可实现强大的安全管理
- Spring Security的两个主要目标
    - 认证(Authentication)
        - 身份验证是关于验证您的凭据,如用户名/用户ID和密码,以验证您的身份
        - 身份验证通常通过用户名和密码完成,有时与身份验证因素结合使用
    - 授权(Authorization)
        - 授权发生在系统成功验证您的身份后,最终会授予您访问资源(如信息,文件,数据库,资金,位置,几乎任何内容)的完全权限
        - 这个概念是通用的,而不是只在Spring Security 中存在

## 过滤器

- Spring Security 基本都是通过过滤器来完成配置的身份认证,权限认证以及登出
- Spring Security 在 Servlet 的过滤链(filter chain)中注册了一个过滤器 `FilterChainProxy`,它会把请求代理到 Spring Security 自己维护的多个过滤链,每个过滤链会匹配一些 URL,如果匹配则执行对应的过滤器,过滤链是有顺序的,一个请求只会执行第一条匹配的过滤链,Spring Security 的配置本质上就是新增,删除,修改过滤器
- 默认情况下系统帮我们注入的这 15 个过滤器,分别对应配置不同的需求,例如 `UsernamePasswordAuthenticationFilter` 是用来使用用户名和密码登录认证的过滤器,但是很多情况下登录不止是简单的用户名和密码,又可能是用到第三方授权登录,这个时候我们就需要使用自定义过滤器

```java
@Override
protected void configure(HttpSecurity http) throws Exception {

    http.addFilterAfter(...);
}
```

## 核心类

### SecurityContextHolder

- `SecurityContextHolder` 存储 `SecurityContext` 对象,`SecurityContextHolder` 是一个存储代理,有三种存储模式分别是:
    - MODE_THREADLOCAL:SecurityContext 存储在线程中
    - MODE_INHERITABLETHREADLOCAL:`SecurityContext` 存储在线程中,但子线程可以获取到父线程中的 `SecurityContext`
    - MODE_GLOBAL:`SecurityContext` 在所有线程中都相同
- `SecurityContextHolder` 默认使用 MODE_THREADLOCAL 模式,`SecurityContext` 存储在当前线程中,调用 `SecurityContextHolder` 时不需要显示的参数传递,在当前线程中可以直接获取到 `SecurityContextHolder` 对象

```java
//获取当前线程里面认证的对象
SecurityContext context = SecurityContextHolder.getContext();
Authentication authentication = context.getAuthentication();

//保存认证对象 (一般用于自定义认证成功保存认证对象)
SecurityContextHolder.getContext().setAuthentication(authResult);

//清空认证对象 (一般用于自定义登出清空认证对象)
SecurityContextHolder.clearContext();
```

### Authentication

- `Authentication` 即验证,表明当前用户是谁,什么是验证,比如一组用户名和密码就是验证,当然错误的用户名和密码也是验证,只不过 Spring Security 会校验失败

```java
public interface Authentication extends Principal, Serializable {
    //获取用户权限,一般情况下获取到的是用户的角色信息
    Collection<? extends GrantedAuthority> getAuthorities();
    //获取证明用户认证的信息,通常情况下获取到的是密码等信息,不过登录成功就会被移除
    Object getCredentials();
    //获取用户的额外信息,比如 IP 地址,经纬度等
    Object getDetails();
    //获取用户身份信息,在未认证的情况下获取到的是用户名,在已认证的情况下获取到的是 UserDetails (暂时理解为,当前应用用户对象的扩展)
    Object getPrincipal();
    //获取当前 Authentication 是否已认证
    boolean isAuthenticated();
    //设置当前 Authentication 是否已认证
    void setAuthenticated(boolean isAuthenticated);
}
```

### AuthenticationManager/ProviderManager/AuthenticationProvider

- 其实这三者很好区分,`AuthenticationManager` 主要就是为了完成身份认证流程,`ProviderManager`是 `AuthenticationManager` 接口的具体实现类,`ProviderManager` 里面有个记录 `AuthenticationProvider` 对象的集合属性 `providers`,`AuthenticationProvider` 接口类里有两个方法

```java
public interface AuthenticationProvider {
    //实现具体的身份认证逻辑,认证失败抛出对应的异常
    Authentication authenticate(Authentication authentication)
        throws AuthenticationException;
    //该认证类是否支持该 Authentication 的认证
    boolean supports(Class<?> authentication);
}
```

- 接下来就是遍历 `ProviderManager` 里面的 `providers` 集合,找到和合适的 `AuthenticationProvider`完成身份认证

### UserDetailsService/UserDetails

- `UserDetail`是Spring Security中的用户实体类
- 在 `UserDetailsService` 接口中只有一个简单的方法

```java
public interface UserDetailsService {
    //根据用户名查到对应的 UserDetails 对象
    UserDetails loadUserByUsername(String username) throws UsernameNotFoundException;
}
```

## 身份认证流程

1. 在运行到 `UsernamePasswordAuthenticationFilter` 过滤器的时候首先是进入其父类 `AbstractAuthenticationProcessingFilter` 的 `doFilter()` 方法中

```java
public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
    throws IOException, ServletException {
    //首先配对是不是配置的登录的URI,是则执行下面的认证,不是则跳过
    if (!requiresAuthentication(request, response)) {
        chain.doFilter(request, response);
        return;
    }
    Authentication authResult;
    try {
        //关键方法, 实现认证逻辑并返回 Authentication
        authResult = attemptAuthentication(request, response);
        if (authResult == null) {
            // return immediately as subclass has indicated that it hasn't completed
            // authentication
            return;
        }
        sessionStrategy.onAuthentication(authResult, request, response);
    }
    catch (InternalAuthenticationServiceException failed) {
        //认证失败调用
        unsuccessfulAuthentication(request, response, failed);
        return;
    }
    catch (AuthenticationException failed) {
        //认证失败调用
        unsuccessfulAuthentication(request, response, failed);
        return;
    }
    // Authentication success
    if (continueChainBeforeSuccessfulAuthentication) {
        chain.doFilter(request, response);
    }
    //认证成功调用
    successfulAuthentication(request, response, chain, authResult);
}
```

2. `AbstractAuthenticationProcessingFilter`调用`UsernamePasswordAuthenticationFilter`的`attemptAuthentication()`方法完成身份认证

```java
public class UsernamePasswordAuthenticationFilter extends AbstractAuthenticationProcessingFilter {
    public static final String SPRING_SECURITY_FORM_USERNAME_KEY = "username";
    public static final String SPRING_SECURITY_FORM_PASSWORD_KEY = "password";
    private String usernameParameter = SPRING_SECURITY_FORM_USERNAME_KEY;
    private String passwordParameter = SPRING_SECURITY_FORM_PASSWORD_KEY;
    private boolean postOnly = true;

    //开始身份认证逻辑
    public Authentication attemptAuthentication(HttpServletRequest request, HttpServletResponse response) throws AuthenticationException {
        if (postOnly && !request.getMethod().equals("POST")) {
            throw new AuthenticationServiceException("Authentication method not supported: " + request.getMethod());
        }
        String username = obtainUsername(request);
        String password = obtainPassword(request);
        if (username == null) {
            username = "";
        }
        if (password == null) {
            password = "";
        }
        username = username.trim();
        //先用前端提交过来的 username 和 password 封装一个简易的 AuthenticationToken
        UsernamePasswordAuthenticationToken authRequest = new UsernamePasswordAuthenticationToken(username, password);
        // Allow subclasses to set the "details" property
        setDetails(request, authRequest);
        //具体的认证逻辑还是交给 AuthenticationManager 对象的 authenticate() 方法完成
        return this.getAuthenticationManager().authenticate(authRequest);
    }
}
```

- 通过 `AuthenticationManager` 接口实现类 `ProviderManager` 来遍历得到Provider,调用对应的`authenticate()`方法

```java
public class ProviderManager implements AuthenticationManager, MessageSourceAware,InitializingBean {
    private List<AuthenticationProvider> providers = Collections.emptyList();
    public Authentication authenticate(Authentication authentication) throws AuthenticationException {
        //遍历所有的 AuthenticationProvider, 找到合适的完成身份验证
        for (AuthenticationProvider provider : getProviders()) {
            if (!provider.supports(toTest)) {
                continue;
            }
            try {
                //进行具体的身份验证逻辑
                result = provider.authenticate(authentication);
                if (result != null) {
                    copyDetails(authentication, result);
                    break;
                }
            }
            catch
        }
        throw lastException;
    }
}
```

3. 调用Provider的`authenticate()`方法
    - 例如Provider为`DaoAuthenticationProvider` 继承自 `AbstractUserDetailsAuthenticationProvider`,后者实现了 `AuthenticationProvider` 接口,所以调用的是`AbstractUserDetailsAuthenticationProvider`的`authenticate()`方法

```java
public abstract class AbstractUserDetailsAuthenticationProvider implements AuthenticationProvider, InitializingBean, MessageSourceAware {
    private UserDetailsChecker preAuthenticationChecks = new DefaultPreAuthenticationChecks();
    private UserDetailsChecker postAuthenticationChecks = new DefaultPostAuthenticationChecks();

    public Authentication authenticate(Authentication authentication) throws AuthenticationException {
        // 获得提交过来的用户名
        String username = (authentication.getPrincipal() == null) ? "NONE_PROVIDED" : authentication.getName();
        //根据用户名从缓存中查找 UserDetails
        boolean cacheWasUsed = true;
        UserDetails user = this.userCache.getUserFromCache(username);
        if (user == null) {
            cacheWasUsed = false;
            try {
                // 获取需要比对的 UserDetails 对象,子类实现该方法
                user = retrieveUser(username,(UsernamePasswordAuthenticationToken) authentication);
            }
            catch
        }
        try {
            //比对前的检查,例如账户以一些状态信息(是否锁定, 过期...)
            preAuthenticationChecks.check(user);
            //定义比对方式,子类实现该方法
            additionalAuthenticationChecks(user, (UsernamePasswordAuthenticationToken) authentication);
        }
        catch (AuthenticationException exception) {
            if (cacheWasUsed) {
                cacheWasUsed = false;
                // 获取需要比对的 UserDetails 对象,子类实现该方法
                user = retrieveUser(username, (UsernamePasswordAuthenticationToken) authentication);
                preAuthenticationChecks.check(user);
                //定义比对方式,子类实现该方法
                additionalAuthenticationChecks(user, (UsernamePasswordAuthenticationToken) authentication);
            }
            else {
                throw exception;
            }
        }
        postAuthenticationChecks.check(user);
        if (!cacheWasUsed) {
            this.userCache.putUserInCache(user);
        }
        Object principalToReturn = user;
        if (forcePrincipalAsString) {
            principalToReturn = user.getUsername();
        }
        //根据最终user的一些信息重新生成具体详细的 Authentication 对象并返回
        return createSuccessAuthentication(principalToReturn, authentication, user);
    }
    //子类实现该方法
    protected Authentication createSuccessAuthentication(Object principal, Authentication authentication, UserDetails user) {
        UsernamePasswordAuthenticationToken result = new UsernamePasswordAuthenticationToken(principal, authentication.getCredentials(),   authoritiesMapper.mapAuthorities(user.getAuthorities()));
        result.setDetails(authentication.getDetails());
        return result;
    }
}
```

- 接下来我们来看下 `DaoAuthenticationProvider` 里面的三个重要的方法

    - **additionalAuthenticationChecks**:定义比对方式

    - **retrieveUser**:获取需要比对的 `UserDetails` 对象
    - **createSuccessAuthentication**:生产最终返回 `Authentication` 的方法

```java
public class DaoAuthenticationProvider extends AbstractUserDetailsAuthenticationProvider {
    //密码比对
    @SuppressWarnings("deprecation")
    protected void additionalAuthenticationChecks(UserDetails userDetails, UsernamePasswordAuthenticationToken authentication) throws AuthenticationException {
        if (authentication.getCredentials() == null) {
            logger.debug("Authentication failed: no credentials provided");
            throw new BadCredentialsException(messages.getMessage("AbstractUserDetailsAuthenticationProvider.badCredentials", "Bad credentials"));
        }
        String presentedPassword = authentication.getCredentials().toString();
        //通过 PasswordEncoder 进行密码比对, 注: 可自定义
        if (!passwordEncoder.matches(presentedPassword, userDetails.getPassword())) {
            logger.debug("Authentication failed: password does not match stored value");
            throw new BadCredentialsException(messages.getMessage("AbstractUserDetailsAuthenticationProvider.badCredentials", "Bad credentials"));
        }
    }
    //通过 UserDetailsService 获取 UserDetails
    protected final UserDetails retrieveUser(String username, UsernamePasswordAuthenticationToken authentication) throws AuthenticationException {
        prepareTimingAttackProtection();
        try {
            //通过 UserDetailsService 获取 UserDetails
            UserDetails loadedUser = this.getUserDetailsService().loadUserByUsername(username);
            if (loadedUser == null) {
                throw new InternalAuthenticationServiceException("UserDetailsService returned null, which is an interface contract violation");
            }
            return loadedUser;
        }
        catch (UsernameNotFoundException ex) {
            mitigateAgainstTimingAttack(authentication);
            throw ex;
        }
        catch (InternalAuthenticationServiceException ex) {
            throw ex;
        }
        catch (Exception ex) {
            throw new InternalAuthenticationServiceException(ex.getMessage(), ex);
        }
    }

    //生成身份认证通过后最终返回的 Authentication, 记录认证的身份信息
    @Override
    protected Authentication createSuccessAuthentication(Object principal, Authentication authentication, UserDetails user) {
        boolean upgradeEncoding = this.userDetailsPasswordService != null && this.passwordEncoder.upgradeEncoding(user.getPassword());
        if (upgradeEncoding) {
            String presentedPassword = authentication.getCredentials().toString();
            String newPassword = this.passwordEncoder.encode(presentedPassword);
            user = this.userDetailsPasswordService.updatePassword(user, newPassword);
        }
        return super.createSuccessAuthentication(principal, authentication, user);
    }
}
```

## pom.xml

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>
```

## 配置

### 基础配置类

- `@EnableWebSecurity`:开启WebSecurity模式

```java
@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled = true) //开启权限注解,默认是关闭的
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    /**
     * 自定义登录成功处理器
     */
    @Resource
    private UserLoginSuccessHandler userLoginSuccessHandler;

    /**
     * 自定义登录失败处理器
     */
    @Resource
    private UserLoginFailureHandler userLoginFailureHandler;

    /**
     * 自定义注销成功处理器
     */
    @Resource
    private UserLogoutSuccessHandler userLogoutSuccessHandler;

    /**
     * 自定义暂无权限处理器
     */
    @Resource
    private UserAuthAccessDeniedHandler userAuthAccessDeniedHandler;

    /**
     * 自定义未登录的处理器
     */
    @Resource
    private UserAuthenticationEntryPointHandler userAuthenticationEntryPointHandler;

    /**
     * 自定义登录逻辑验证器
     */
    @Resource
    private UserAuthenticationProvider userAuthenticationProvider;

    /**
     * 加密方式
     */
    @Bean
    public BCryptPasswordEncoder bCryptPasswordEncoder() {
        return new BCryptPasswordEncoder();
    }

    /**
     * 注入自定义PermissionEvaluator
     */
    @Bean
    public DefaultWebSecurityExpressionHandler userSecurityExpressionHandler() {
        DefaultWebSecurityExpressionHandler handler = new DefaultWebSecurityExpressionHandler();
        handler.setPermissionEvaluator(new UserPermissionEvaluator());
        return handler;
    }

    /**
     * 配置登录验证逻辑
     */
    @Override
    protected void configure(AuthenticationManagerBuilder auth) {
        //这里可启用我们自己的登陆验证逻辑
        auth.authenticationProvider(userAuthenticationProvider);
    }

    /**
     * 跨域配置
     */
    @Bean
    CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowCredentials(true);
        configuration.setAllowedOrigins(Arrays.asList("http://localhost:8000"));
        configuration.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE"));
        // 如果所有的属性不全部配置，需要执行该方法
        configuration.applyPermitDefaultValues();

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }

    /**
     * 配置security的控制逻辑
     */
    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.authorizeRequests()
                // 不进行权限验证的请求或资源(从配置文件中读取)
                .antMatchers(JWTConfig.antMatchers.split(",")).permitAll()
                // 其他的需要登陆后才能访问
                .anyRequest().authenticated()
                .and()
                // 配置未登录自定义处理类
                .httpBasic().authenticationEntryPoint(userAuthenticationEntryPointHandler)
                .and()
                .exceptionHandling().authenticationEntryPoint(userAuthenticationEntryPointHandler)
                .and()
                // 配置登录地址
                .formLogin()
                .loginProcessingUrl("/account/signIn")
                // 配置登录成功自定义处理类
                .successHandler(userLoginSuccessHandler)
                // 配置登录失败自定义处理类
                .failureHandler(userLoginFailureHandler)
                .and()
                // 配置登出地址
                .logout()
                .logoutUrl("/account/signOut")
                // 配置用户登出自定义处理类
                .logoutSuccessHandler(userLogoutSuccessHandler)
                .and()
                // 配置没有权限自定义处理类
                .exceptionHandling().accessDeniedHandler(userAuthAccessDeniedHandler)
                .and()
                // 开启跨域
                .cors()
                .and()
                // 取消跨站请求伪造防护
                .csrf().disable();
        // 基于Token不需要session
        http.sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS);
        // 禁用缓存
        http.headers().cacheControl();
        // 添加JWT过滤器
        http.addFilter(new JWTAuthenticationTokenFilter(authenticationManager()));
    }

}
```
