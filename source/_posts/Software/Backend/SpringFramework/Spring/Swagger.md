---
title: Spring 整合Swagger
categories:
- Software
- BackEnd
- SpringFramework
- Spring
---
# Spring 整合Swagger

## 简介

- 号称世界上最流行的API框架,Restful Api 文档在线自动生成器，即API 文档与API 定义同步更新
- 官网:https://swagger.io/

## pom.xml

```xml
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-boot-starter</artifactId>
    <version>3.0.0</version>
</dependency>
```

## Swagger配置

### 配置类

```java
@Configuration
@EnableOpenApi
public class SwaggerConfig {

    @Bean
    public Docket createRestApi() {
        return new Docket(DocumentationType.OAS_30)
            .apiInfo(apiInfo())
            .select()
            .apis(RequestHandlerSelectors.basePackage("com.*.*"))
            .paths(PathSelectors.any())
            .build()
            .securitySchemes(securitySchemes());
    }

    private ApiInfo apiInfo() {
        return new ApiInfoBuilder()
            .title("基于Swagger构建的Rest API文档")
            .version("3.0")
            .build();
    }

    private List<SecurityScheme> securitySchemes() {
        return CollUtil.newArrayList(new ApiKey("Authorization", "Authorization", "header"));
    }

}
```

### Docket

- Swagger实例Bean是Docket,所以通过配置Docket实例来配置Swaggger

```java
@Bean
public Docket createRestApi() {
    return new Docket(DocumentationType.OAS_30)
        .select()
        .apis(RequestHandlerSelectors.basePackage("com.example.controller"))
        .apis(RequestHandlerSelectors.any())
        .apis(RequestHandlerSelectors.none())
        .apis(RequestHandlerSelectors.withClassAnnotation(RestController.class))
        .apis(RequestHandlerSelectors.withMethodAnnotation(GetMapping.class))
        .paths(PathSelectors.any())
        .groupName("group1")
        .build();
}
```

- `select()`:配置扫描接口
- `RequestHandlerSelectors`:配置如何扫描接口
    - `basePackage(final String basePackage)`:根据包路径扫描接口
    - `any()`:扫描所有，项目中的所有接口都会被扫描到
    - `none()`:不扫描接口
    - `withMethodAnnotation(final Class<? extends Annotation> annotation)`:通过方法上的注解扫描，如`withMethodAnnotation(GetMapping.class)`只扫描get请求
    - `withClassAnnotation(final Class<? extends Annotation> annotation)`:通过类上的注解扫描，如`withClassAnnotation(Controller.class)`只扫描有controller注解的类中的接口
- `PathSelectors`:配置路径过滤
    - `any()`:任何请求都扫描
    - `none()`:任何请求都不扫描
    - `regex(final String pathRegex)`:通过正则表达式控制
    - `ant(final String antPattern)`:通过ant()控制
- `enable()`:配置是否启用swagger
- `groupName()`:配置分组，如果没有配置分组，默认是default,配置多个分组只需要配置多个docket即可

### apiInfo()

- 文档信息

```java
private ApiInfo apiInfo() {
    return new ApiInfoBuilder()
        .title("标题")
        .description("描述")
        .termsOfServiceUrl("组织链接")
        .contcat(contect) // 联系人信息
        .license("许可")
        .licenseUrl("许可链接")
        .version("版本")
        .vendorExtensions("扩展")
        .build();
}
```

### securitySchemes()

- 安全模式

```java
private List<SecurityScheme> securitySchemes() {
    return CollUtil.newArrayList(new ApiKey("Authorization", "Authorization", "header"));
}
```

## 常用注解

| Swagger注解                                            | 简单说明                                             |
| ------------------------------------------------------ | ---------------------------------------------------- |
| @Api(tags = "xxx模块说明")                             | 作用在模块类上                                       |
| @ApiOperation("xxx接口说明")                           | 作用在接口方法上                                     |
| @ApiModel("xxxPOJO说明")                               | 作用在模型类上：如VO,BO                             |
| @ApiModelProperty(value = "xxx属性说明",hidden = true) | 作用在类方法和属性上,hidden设置为true可以隐藏该属性 |
| @ApiParam("xxx参数说明")                               | 作用在参数，方法和字段上，类似@ApiModelProperty      |

#### @Api()

- 用于类，表示标识这个类是swagger的资源
    - **tags**:表示说明	
    - **value**:也是说明，可以使用tags替代
- **注意**:tags如果有多个值，会生成多个list

```java
@Api(value="用户controller",tags={"用户操作接口"})
@RestController
public class UserController {

}
```

#### @ApiOperation()

- 用于方法，表示一个http请求的操作
    - **value**:用于方法描述	
    - **notes**:用于提示内容
    - **tags**:可以重新分组（视情况而用)

```java
public class UserController {
    @ApiOperation(value="获取用户信息",tags={"获取用户信息copy"},notes="注意问题点")
    public User getUserInfo() {
        return user;
    }
}
```

#### @ApiParam()

- 用于方法，参数，字段说明，表示对参数的添加元数据（说明或是否必填等)
    - **name**:参数名
    - **value**:参数说明
    - **required**:是否必填

```java
public class UserController {

    public User getUserInfo(@ApiParam(name="id",value="用户id",required=true) Long id,@ApiParam(name="username",value="用户名") String username) {
        User user = userService.getUserInfo();
        return user;
    }
}
```

#### @ApiModel()

- 用于类，表示对类进行说明，用于参数用实体类接收
    - **value**:表示对象名
    - **description**:描述

```java
@ApiModel(value="user对象",description="用户对象user")
public class User implements Serializable{
    private static final long serialVersionUID = 1L;
    private String username;
    private Integer state;
    private String password;
    private String nickName;
    private Integer isDeleted;

    private String[] ids;
    private List<String> idList;
    // 省略get/set
}
```

#### @ApiModelProperty()

- 用于方法，字段：表示对model属性的说明或者数据操作更改
    - **value**:字段说明
    - **name**:重写属性名字
    - **dataType**:重写属性类型
    - **required**:是否必填
    - **example**:举例说明
    - **hidden**:隐藏

```java
public class User implements Serializable{
    private static final long serialVersionUID = 1L;
    @ApiModelProperty(value="用户名",name="username",example="xingguo")
    private String username;
    @ApiModelProperty(value="状态",name="state",required=true)
    private Integer state;
    private String password;
    private String nickName;
    private Integer isDeleted;

    @ApiModelProperty(value="id数组",hidden=true)
    private String[] ids;
    private List<String> idList;
    // 省略get/set
}
```

#### @ApiIgnore()

- 用于类或者方法上：可以不被swagger显示在页面上

#### @ApiImplicitParam()

- 用于方法：表示单独的请求参数

#### @ApiImplicitParams()

-  用于方法，包含多个 @ApiImplicitParam
    - **name**:参数名
    - **value**:参数说明
    - **dataType**:数据类型
    - **paramType**:参数类型
    - **example**:举例说明

```java
@ApiOperation("查询测试")
@GetMapping("select")
//@ApiImplicitParam(name="name",value="用户名",dataType="String", paramType = "query")
@ApiImplicitParams({
    @ApiImplicitParam(name="name",value="用户名",dataType="string", paramType = "query",example="xingguo"),
    @ApiImplicitParam(name="id",value="用户id",dataType="long", paramType = "query")})
public void select(){

}
```

## Swagger-UI

- 首先需要屏蔽以下路径的过滤拦截

```
/swagger**/**
/webjars/**
/v3/**
```

- 然后需要配置静态资源映射

```java
@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/swagger-ui/").addResourceLocations("classpath:/META-INF/resources/", "/static", "/public");
        registry.addResourceHandler("/webjars/**").addResourceLocations("classpath:/META-INF/resources/webjars/");
    }
}

```

### 默认

- 地址:http://localhost:8080/swagger-ui.html

```xml
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-swagger-ui</artifactId>
    <version>2.9.2</version>
</dependency>
```

### bootstrap-ui

- 地址:http://localhost:8080/doc.html

```xml
<!-- 引入swagger-bootstrap-ui包 /doc.html-->
<dependency>
    <groupId>com.github.xiaoymin</groupId>
    <artifactId>swagger-bootstrap-ui</artifactId>
    <version>1.9.1</version>
</dependency>
```

### Layui-ui

- 地址:http://localhost:8080/docs.html

```xml
<!-- 引入swagger-ui-layer包 /docs.html-->
<dependency>
    <groupId>com.github.caspar-chen</groupId>
    <artifactId>swagger-ui-layer</artifactId>
    <version>1.1.3</version>
</dependency>
```

