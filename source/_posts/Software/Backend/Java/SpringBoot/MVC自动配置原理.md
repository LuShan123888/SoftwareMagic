---
title: Spring Boot MVC 自动配置原理
categories:
- Software
- Backend
- Java
- SpringBoot
---
# Spring Boot MVC 自动配置原理

## 官方文档

**地址**:https://docs.spring.io/spring-boot/docs/2.2.5.RELEASE/reference/htmlsingle/#boot-features-spring-mvc-auto-configuration

> **Spring MVC Auto-configuration**
>
> - Spring Boot provides auto-configuration for Spring MVC that works well with most applications
> - The auto-configuration adds the following features on top of Spring’s defaults:
>     - Inclusion of ContentNegotiatingViewResolver and BeanNameViewResolver beans.
>     - Support for serving static resources, including support for WebJars
>     - Automatic registration of Converter, GenericConverter, and Formatter beans.
>     - HttpMessageConverters:Support for HttpMessageConverters (covered later in this document).
>     - Automatic registration of MessageCodesResolver (covered later in this document).
>     - Static index.html support.
>     - Custom Favicon support (covered later in this document).
>     - Automatic use of a ConfigurableWebBindingInitializer bean (covered later in this document).
> - If you want to keep Spring Boot MVC features and you want to add additional MVC configuration
>     (interceptors, formatters, view controllers, and other features), you can add your own
>     @Configuration class of type WebMvcConfigurer but without @EnableWebMvc. If you wish to provide
>     custom instances of RequestMappingHandlerMapping, RequestMappingHandlerAdapter, or
>     ExceptionHandlerExceptionResolver, you can declare a WebMvcRegistrationsAdapter instance to provide such components.
> - If you want to take complete control of Spring MVC, you can add your own @Configuration annotated with @EnableWebMvc.

- **Converter**:转换器,这就是我们网页提交数据到后台自动封装成为对象的东西,比如把"1"字符串自动转换为int类型
- **Formatter**:格式化器,比如页面给我们了一个2019-8-10,它会给我们自动格式化为Date对象
-  **HttpMessageConverters**: Spring MVC用来转换Http请求和响应的的,比如我们要把一个User对象转换为JSON字符串

## ContentNegotiatingViewResolver

- 内容协商视图解析器
- 自动配置了ViewResolver,就是Spring MVC的视图解析器
- 即根据方法的返回值取得视图对象(View),然后由视图对象决定如何渲染(转发,重定向)

**分析源码**

`WebMvcAutoConfiguration`类的`viewResolver`方法

```java
@Bean
@ConditionalOnBean(ViewResolver.class)
@ConditionalOnMissingBean(name = "viewResolver", value = ContentNegotiatingViewResolver.class)
public ContentNegotiatingViewResolver viewResolver(BeanFactory beanFactory) {
    ContentNegotiatingViewResolver resolver = new ContentNegotiatingViewResolver();
    resolver.setContentNegotiationManager(beanFactory.getBean(ContentNegotiationManager.class));
    // ContentNegotiatingViewResolver使用所有其他视图解析器来定位视图,因此它应该具有较高的优先级
    resolver.setOrder(Ordered.HIGHEST_PRECEDENCE);
    return resolver;
}
```

`ContentNegotiatingViewResolver`类的`resolveViewName`方法

```java
@Nullable
public View resolveViewName(String viewName, Locale locale) throws Exception {
    RequestAttributes attrs = RequestContextHolder.getRequestAttributes();
    Assert.state(attrs instanceof ServletRequestAttributes, "No current ServletRequestAttributes");
    List<MediaType> requestedMediaTypes = this.getMediaTypes(((ServletRequestAttributes)attrs).getRequest());
    if (requestedMediaTypes != null) {
        // 获取候选的视图对象
        List<View> candidateViews = this.getCandidateViews(viewName, locale, requestedMediaTypes);
        // 选择一个最适合的视图对象,然后把这个对象返回
        View bestView = this.getBestView(candidateViews, requestedMediaTypes, attrs);
        if (bestView != null) {
            return bestView;
        }
    }
    // .....
}
```

**结论**:`ContentNegotiatingViewResolver`这个视图解析器是用来组合所有的视图解析器的

`viewResolvers`通过`ContentNegotiatingViewResolver`类的`initServletContext`方法赋值

```java
protected void initServletContext(ServletContext servletContext) {
    // 这里它是从beanFactory工具中获取容器中的所有视图解析器
    // ViewRescolver.class 把所有的视图解析器来组合的
    Collection<ViewResolver> matchingBeans = BeanFactoryUtils.beansOfTypeIncludingAncestors(this.obtainApplicationContext(), ViewResolver.class).values();
    ViewResolver viewResolver;
    if (this.viewResolvers == null) {
        this.viewResolvers = new ArrayList(matchingBeans.size());
    }
    // ...............
}
```

### 自定义视图解析器

```java
@Bean
public ViewResolver myViewResolver(){
    return new MyViewResolver();
}

//写一个静态内部类,视图解析器就需要实现ViewResolver接口
private static class MyViewResolver implements ViewResolver{
    @Override
    public View resolveViewName(String s, Locale locale) throws Exception {
        return null;
    }
}
```

**测试**

- 查看我们自定义的视图解析器是否起作用
- 给`DispatcherServlet`中的`doDispatch`方法加个断点进行调试一下,因为所有的请求都会走到这个方法中

![img](https://cdn.jsdelivr.net/gh/LuShan123888/Files@master/Pictures/2020-12-10-2020-11-17-640-20201117000436625.png)

- 启动项目,然后随便访问一个页面,看一下Debug信息
- 找到this

![img](https://cdn.jsdelivr.net/gh/LuShan123888/Files@master/Pictures/2020-12-10-2020-11-17-640-20201117000436779.png)

- 找到视图解析器,看到自定义的视图解析器名

![img](https://cdn.jsdelivr.net/gh/LuShan123888/Files@master/Pictures/2020-12-10-2020-11-17-640-20201117000436757.png)

## Formatter

**分析源码**

- `ContentNegotiatingViewResolver`类的`mvcConversionService`方法

```java
@Bean
@Override
public FormattingConversionService mvcConversionService() {
    // 拿到配置文件中的格式化规则
    WebConversionService conversionService =
        new WebConversionService(this.mvcProperties.getDateFormat());
    addFormatters(conversionService);
    return conversionService;
}
```

- `WebMvcProperties`类

```java
@ConfigurationProperties(prefix = "spring.mvc")
public class WebMvcProperties {
	/**
	 * Date format to use. For instance, `dd/MM/yyyy`.
	 */
	private String dateFormat;

	public String getDateFormat() {
	   return this.dateFormat;
    }
   // ...
}
```

- 可以查看`WebMvcProperties`这个类,通过配置文件配置`Formatter`

```properties
spring.date-format="yyyy-MM-dd"
```

## 扩展使用Spring MVC

```java
@Configuration
public class MyMvcConfig implements WebMvcConfigurer {

    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
        // 浏览器发送/test,就会跳转到test页面
        registry.addViewController("/test").setViewName("test");
    }
}
```

**分析源码**

- `WebMvcAutoConfiguration`是`Spring MVC`的自动配置类,里面有一个类`WebMvcAutoConfigurationAdapter`
- 这个类上有一个注解,在做其他自动配置时会导入:`@Import(EnableWebMvcConfiguration.class)`
- 点进`EnableWebMvcConfiguration`这个类,它继承了一个父类`DelegatingWebMvcConfiguration`
- 这个父类中有这样一段代码:

```java
public class DelegatingWebMvcConfiguration extends WebMvcConfigurationSupport {
    private final WebMvcConfigurerComposite configurers = new WebMvcConfigurerComposite();

  // 从容器中获取所有的webmvcConfigurer
    @Autowired(required = false)
    public void setConfigurers(List<WebMvcConfigurer> configurers) {
        if (!CollectionUtils.isEmpty(configurers)) {
            this.configurers.addWebMvcConfigurers(configurers);
        }
    }
}
```

- 可以在这个类中去寻找一个刚才设置的viewController当做参考,有如下方法

```java
protected void addViewControllers(ViewControllerRegistry registry) {
    this.configurers.addViewControllers(registry);
}
```

- 查看上面的`addViewControllers`方法

```java
public void addViewControllers(ViewControllerRegistry registry) {
    for (WebMvcConfigurer delegate : this.delegates) {
        delegate.addViewControllers(registry);
    }
}
```

- **结论**:所有的`WebMvcConfiguration`都会被作用,不止Spring自己的配置类,自己的配置类当然也会被调用

## 全面接管Spring MVC

- 全面接管即:SpringBoot对SpringMVC的自动配置不需要了,所有都是自己去配置
- 只需在配置类中要加一个`@EnableWebMvc`
- **不推荐使用全面接管SpringMVC**

**分析源码**

`@EnableWebMvc`为什么会使自动配置失效

- 查看`@EnableWebMvc`发现它是导入了一个类`DelegatingWebMvcConfiguration`

```java
@Import({DelegatingWebMvcConfiguration.class})
public @interface EnableWebMvc {
}
```

- 查看`DelegatingWebMvcConfiguration`:它继承了一个父类`WebMvcConfigurationSupport`

```java
public class DelegatingWebMvcConfiguration extends WebMvcConfigurationSupport {
  // ......
}
```

- 回顾`WebMvcAutoConfiguration`

```java
Configuration(proxyBeanMethods = false)
@ConditionalOnWebApplication(type = Type.SERVLET)
@ConditionalOnClass({ Servlet.class, DispatcherServlet.class, WebMvcConfigurer.class })
// 这个注解的意思是:容器中没有这个组件的时候,这个自动配置类才生效
@ConditionalOnMissingBean(WebMvcConfigurationSupport.class)
@AutoConfigureOrder(Ordered.HIGHEST_PRECEDENCE + 10)
@AutoConfigureAfter({ DispatcherServletAutoConfiguration.class, TaskExecutionAutoConfiguration.class,
    ValidationAutoConfiguration.class })
public class WebMvcAutoConfiguration {

}
```

- **总结**:`@EnableWebMvc`将`WebMvcConfigurationSupport`导入,导致`WebMvcAutoConfiguration`失效
- `WebMvcConfigurationSupport`只包含SpringMVC最基本的功能