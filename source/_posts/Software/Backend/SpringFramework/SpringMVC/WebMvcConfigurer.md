---
title: Spring MVC WebMvcConfigurer
categories:
- Software
- BackEnd
- SpringFramework
- SpringMVC
---
# Spring MVC WebMvcConfigurer

- WebMvcConfigurer配置类其实是`Spring`内部的一种配置方式，采用`JavaBean`的形式来代替传统的`xml`配置文件形式进行针对框架个性化定制，基于java-based方式的Spring MVC配置，需要创建一个配置类并实现`WebMvcConfigurer` 接口。
- `WebMvcConfigurerAdapter` 抽象类是对`WebMvcConfigurer`接口的简单抽象（增加了一些默认实现)，但在SpringBoot2.0及Spring5.0中WebMvcConfigurerAdapter已被废弃，官方推荐直接实现WebMvcConfigurer或者直接继承WebMvcConfigurationSupport

```java
public interface WebMvcConfigurer {
    void configurePathMatch(PathMatchConfigurer var1);

    void configureContentNegotiation(ContentNegotiationConfigurer var1);

    void configureAsyncSupport(AsyncSupportConfigurer var1);

    void configureDefaultServletHandling(DefaultServletHandlerConfigurer var1);

    void addFormatters(FormatterRegistry var1);

    void addInterceptors(InterceptorRegistry var1);

    void addResourceHandlers(ResourceHandlerRegistry var1);

    void addCorsMappings(CorsRegistry var1);

    void addViewControllers(ViewControllerRegistry var1);

    void configureViewResolvers(ViewResolverRegistry var1);

    void addArgumentResolvers(List<HandlerMethodArgumentResolver> var1);

    void addReturnValueHandlers(List<HandlerMethodReturnValueHandler> var1);

    void configureMessageConverters(List<HttpMessageConverter<?>> var1);

    void extendMessageConverters(List<HttpMessageConverter<?>> var1);

    void configureHandlerExceptionResolvers(List<HandlerExceptionResolver> var1);

    void extendHandlerExceptionResolvers(List<HandlerExceptionResolver> var1);

    Validator getValidator();

    MessageCodesResolver getMessageCodesResolver();
}
```

## addInterceptors

- 拦截器配置，此方法用来专门注册一个Interceptor，如HandlerInterceptorAdapter

```java
@Override
public void addInterceptors(InterceptorRegistry registry) {
    registry.addInterceptor(new MyInterceptor())
        .addPathPatterns("/**").excludePathPatterns("/login","/logout","/js/**","/css/**","/images/**");
}

```

- `addPathPatterns("/**")`对所有请求都拦截，但是排除了`/toLogin`和`/login`请求的拦截。

## addViewControllers

- 页面跳转。

```java
@Override
public void addViewControllers(ViewControllerRegistry registry) {
    registry.addViewController("/toLogin").setViewName("login");
}
```

- 以前要访问一个页面需要先创建个Controller控制类，再写方法跳转到页面，在这里配置后就不需要那么麻烦了，直接访问http://localhost:8080/toLogin就跳转到login.jsp页面了。
- **注意**：在这里重写`addViewControllers`方法，并不会覆盖`WebMvcAutoConfiguration`中的`addViewControllers`(在此方法中，Spring Boot将`/`映射至index.html)，这也就意味着我们自己的配置和Spring Boot的自动配置同时有效，这也是推荐添加自己的MVC配置的方式。

## addResourceHandlers

- 自定义资源映射。
- **注意**：如果继承WebMvcConfigurationSupport类实现配置时必须要重写该方法。

```java
@Override
public void addResourceHandlers(ResourceHandlerRegistry registry) {
    registry.addResourceHandler("/img/**").addResourceLocations("/usr/local/img/");
}
```

- 通过addResourceHandler添加映射路径，然后通过addResourceLocations来指定路径，我们访问自定义文件夹中的elephant.jpg 图片的地址为 http://localhost:8080/img/elephant.jpg
- `addResourceLocations`：文件放置的目录。
- `addResoureHandler`：对外暴露的访问路径。

## configureDefaultServletHandling

```java
@Override
public void configureDefaultServletHandling(DefaultServletHandlerConfigurer configurer) {
    configurer.enable();
    configurer.enable("defaultServletName");
}
```

- 此时会注册一个默认的Handler:`DefaultServletHttpRequestHandler`，这个Handler也是用来处理静态文件的，它会尝试映射`/*`

- 当DispatcherServelt映射`/`时(`/`和`/*`是有区别的)，并且没有找到合适的Handler来处理请求时，就会交给`DefaultServletHttpRequestHandler`来处理。

- **注意**：这里的静态资源是放置在web根目录下，而非`WEB-INF`下。

- 例如：在webroot目录下有一个图片`1.png`我们知道Servelt规范中web根目录(webroot)下的文件可以直接访问的，但是由于`DispatcherServlet`配置了映射路径是：`/`，它几乎把所有的请求都拦截了，从而导致`1.png`访问不到，这时注册一个`DefaultServletHttpRequestHandler`就可以解决这个问题，其实可以理解为`DispatcherServlet`破坏了Servlet的一个特性（根目录下的文件可以直接访问),`DefaultServletHttpRequestHandler`是帮助回归这个特性的。

## configureViewResolvers

- 从方法名称我们就能看出这个方法是用来配置视图解析器的，该方法的参数`ViewResolverRegistry`是一个注册器，用来注册你想自定义的视图解析器等，`ViewResolverRegistry`常用的几个方法：

- enableContentNegotiation()：启用内容裁决视图解析器。

```java
@Override
public void enableContentNegotiation(View... defaultViews) {
    initContentNegotiatingViewResolver(defaultViews);
}
```

- 该方法会创建一个内容裁决解析器`ContentNegotiatingViewResolver`，该解析器不进行具体视图的解析，而是管理你注册的所有视图解析器，所有的视图会先经过它进行解析，然后由它来决定具体使用哪个解析器进行解析，具体的映射规则是根据请求的media types来决定的。

- UrlBasedViewResolverRegistration

```java
@Override
public UrlBasedViewResolverRegistration jsp(String prefix, String suffix) {
    InternalResourceViewResolver resolver = new InternalResourceViewResolver();
    resolver.setPrefix(prefix);
    resolver.setSuffix(suffix);
    this.viewResolvers.add(resolver);
    return new UrlBasedViewResolverRegistration(resolver);
}
```

- 该方法会注册一个内部资源视图解析器`InternalResourceViewResolver`显然访问的所有jsp都是它进行解析的，该方法参数用来指定路径的前缀和文件后缀，如：　　

```java
registry.jsp("/WEB-INF/jsp/", ".jsp");
```

- 对于以上配置，假如返回的视图名称是example，它会返回`/WEB-INF/jsp/example.jsp`给前端，找不到则报404,　　


## beanName

```java
public void beanName() {
    BeanNameViewResolver resolver = new BeanNameViewResolver();
    this.viewResolvers.add(resolver);
}
```

- 该方法会注册一个`BeanNameViewResolver`视图解析器，它主要是将视图名称解析成对应的bean
- 假如返回的视图名称是example，它会到spring容器中找有没有一个叫example的bean，并且这个bean是View.class类型的？如果有，返回这个bean,　　


## viewResolver

```java
@Override
public void viewResolver(ViewResolver viewResolver) {
    if (viewResolver instanceof ContentNegotiatingViewResolver) {
        throw new BeanInitializationException(
            "addViewResolver cannot be used to configure a ContentNegotiatingViewResolver. Please use the method enableContentNegotiation instead.");
    }
    this.viewResolvers.add(viewResolver);
}
```

- 用来注册各种各样的视图解析器的，包括自己定义的。

## configureContentNegotiation

- 上面我们讲了`configureViewResolvers`方法，假如在该方法中我们启用了内容裁决解析器，那么`configureContentNegotiation(ContentNegotiationConfigurer configurer)`这个方法是专门用来配置内容裁决的一些参数的。

```java
@Override
public void configureContentNegotiation(ContentNegotiationConfigurer configurer) {
    /* 是否通过请求Url的扩展名来决定media type */
    configurer.favorPathExtension(true)
        /* 不检查Accept请求头 */
        .ignoreAcceptHeader(true)
        .parameterName("mediaType")
        /* 设置默认的media yype */
        .defaultContentType(MediaType.TEXT_HTML)
        /* 请求以.html结尾的会被当成MediaType.TEXT_HTML*/
        .mediaType("html", MediaType.TEXT_HTML)
        /* 请求以.json结尾的会被当成MediaType.APPLICATION_JSON*/
        .mediaType("json", MediaType.APPLICATION_JSON);
}
```

**实例**

```java
@Override
public void configureViewResolvers(ViewResolverRegistry registry) {
    registry.jsp("/WEB-INF/jsp/", ".jsp");
    registry.enableContentNegotiation(new MappingJackson2JsonView());
}

@Override
public void configureContentNegotiation(ContentNegotiationConfigurer configurer) {
    configurer.favorPathExtension(true)
        .ignoreAcceptHeader(true)
        .parameterName("mediaType")
        .defaultContentType(MediaType.TEXT_HTML)
        .mediaType("html", MediaType.TEXT_HTML)
        .mediaType("json", MediaType.APPLICATION_JSON);
}
```

- controller的代码如下：

```java
@Controller
public class ExampleController {
    @RequestMapping("/test")
    public ModelAndView test() {
        Map<String, String> map = new HashMap();
        map.put("test1", "Hello");
        map.put("test2", "world");
        return new ModelAndView("test", map);
    }
}
```

- 在`WEB-INF/jsp`目录下创建一个test.jsp文件，内容随意。
- 现在启动tomcat，在浏览器输入以下链接：http://localhost:8080/test.json，浏览器内容返回如下：

```json
{
    "test1":"Hello",
    "test2":"world"
}
```

在浏览器输入http://localhost:8080/test 或者http://localhost:8080/test.html，内容返回如下：

```java
this is test.jsp
```


显然，两次使用了不同的视图解析器，那么底层到底发生了什么？在配置里我们注册了两个视图解析器：`ContentNegotiatingViewResolver` 和 `InternalResourceViewResolver`，还有一个默认视图：`MappingJackson2JsonView`,controller执行完毕之后返回一个ModelAndView，其中视图的名称为example1

> 1. 返回首先会交给`ContentNegotiatingViewResolver` 进行视图解析处理，而`ContentNegotiatingViewResolver` 会先把视图名example1交给它持有的所有`ViewResolver`尝试进行解析（本实例中只有`InternalResourceViewResolver`)
> 2. 根据请求的`mediaType`，再将`example1.mediaType`(这里是`example1.json` 和`example1.html`)作为视图名让所有视图解析器解析一遍，两步解析完毕之后会获得一堆候选的`List<View>`再加上默认的`MappingJackson2JsonView`
> 3. 根据请求的`media type`从候选的`List<View>`中选择一个最佳的返回，至此视图解析完毕。

- 现在就可以理解上例中为何请求链接加上`.json`和不`.json`结果会不一样。
- 当加上`.json`时，表示请求的`media type`为`MediaType.APPLICATION_JSON`，而`InternalResourceViewResolver`解析出来的视图的`ContentType`与其不符，而与`MappingJackson2JsonView`的`ContentType`相符，所以选择了`MappingJackson2JsonView`作为视图返回。
- 当不加`.json`请求时，默认的`media type`为`MediaType.TEXT_HTML`，所以就使用了`InternalResourceViewResolver`解析出来的视图作为返回值了。