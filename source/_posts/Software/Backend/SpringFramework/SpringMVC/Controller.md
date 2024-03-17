---
title:  Spring MVC 控制器
categories:
- Software
- BackEnd
- SpringFramework
- SpringMVC
---
#  Spring MVC 控制器

- 控制器负责提供访问应用程序的行为，解析用户的请求并将其转换为一个模型。
- 在Spring MVC中一个控制器类可以包含多个方法。

## Controller类

### 实现Controller接口

- Controller是一个接口，在`org.springframework.web.servlet.mvc`包下，接口中只有一个方法。

```java
// 实现该接口的类获得控制器功能。
public interface Controller {
    // 处理请求且返回一个模型与视图对象。
    ModelAndView handleRequest(HttpServletRequest var1, HttpServletResponse var2) throws Exception;
}
```

- 实现该类后，去Spring配置文件中注册请求的bean

```java
<bean name="/test" class="com.example.controller.ControllerTest"/>
```

- **name**：对应请求路径。
- **class**：对应处理请求的类。

**说明**

- 实现接口Controller定义控制器是较老的办法。

- **缺点**：一个控制器中只有一个方法，如果要多个方法则需要定义多个Controller，定义的方式比较麻烦。

### @Controller

- @Controller注解类型用于声明Spring类的实例是一个控制器。
- Spring可以使用扫描机制来找到应用程序中所有基于注解的控制器类，为了保证Spring能找到你的控制器，需要在配置文件中声明组件扫描。

```xml
<!-- 自动扫描指定的包，下面所有注解类交给IoC容器管理 -->
<context:component-scan base-package="com.example.controller"/>
```

- 增加一个Controller，使用注解实现。

```java
//@Controller注解的类会自动添加到Spring上下文中。
@Controller
public class ControllerTest2{

   // 映射访问路径。
   @RequestMapping("/t2")
   public String index(Model model){
       //Spring MVC会自动实例化一个Model对象用于向视图中传值。
       model.addAttribute("msg", "ControllerTest2");
       // 返回视图名。
       return "test";
  }
}
```

### @RestController

- 添加在Controller类上，等同于该类所有的方法加上@ResponseBody注解。

```java
@RestController
public class TestController {
   @RequestMapping("/h1")
    public List<User> ajax2(){
   	List<User> list = new ArrayList<User>();
   	list.add(new User("test1",3,"男"));
   	list.add(new User("test2",3,"男"));
   	list.add(new User("test3",3,"男"));
     return list;
}
```

### @SessionAttributes

- 用于声明特定控制器使用的会话属性，一般在Servlet会话中存储model属性。

```java
@SessionAttributes("user")
public class LoginController {

    @ModelAttribute("user")
    public User setUpUserForm() {
        return new User();
    }
}
```

- 如上面的例子，定义了一个名为"User”的model并把它存储在Session中。

### @RequestMapping

- @RequestMapping注解用于映射url到控制器类或一个特定的处理程序方法，可用于类或方法上。
- 用于类上，表示类中的所有响应请求的方法都是以该地址作为父路径。

```java
@Controller
@RequestMapping("/admin")
public class TestController {
    @RequestMapping("/h1")
    public String test(){
        return "test";
    }
}
```

- 访问路径：`http://localhost:8080 / 项目名/ admin /h1 ` ，需要先指定类的路径再指定方法的路径。

## Controller 方法

### @RequestMapping

- @RequestMapping注解用于映射url到控制器类或一个特定的处理程序方法，可用于类或方法上。

```java
@Controller
public class TestController {
   @RequestMapping("/h1")
   public String test(){
       return "test";
  }
}
```

- `value`：表示映射URL，可以用集合表示同时匹配多个URL
- `method`：用于约束请求的类型，可以收窄请求范围，指定请求谓词的类型如GET, POST, HEAD, OPTIONS, PUT, PATCH, DELETE, TRACE等。
- 方法级别的注解变体有如下几个。

```
@GetMapping
@PostMapping
@PutMapping
@DeleteMapping
@PatchMapping
```

### @PathVariable

- 让方法参数的值对应绑定到一个URI模板变量上。

```java
@Controller
public class RestFulController {

   // 映射访问路径。
   @RequestMapping("/commit/{p1}/{p2}")
   public String index(@PathVariable int p1, @PathVariable int p2, Model model){

       int result = p1+p2;
       //Spring MVC会自动实例化一个Model对象用于向视图中传值。
       model.addAttribute("msg", "结果："+result);
       // 返回视图名。
       return "test";
  }
}
```

- 路径参数支持正则表达式，例如我们在使用接口的时候要求sex必须是F(Female)或者M(Male)，那么我们的URL模板可以定义如下。

```javascript
@GetMapping(value = "/sex/{sex:M|F}")
public String findUser2(@PathVariable(value = "sex") String sex){
    log.info(sex);
    return sex;
}
```

- 只有/sex/F或者/sex/M的请求才会进入findUser2控制器方法，其他该路径前缀的请求都是非法的，会返回404状态码。

### @RequestParam

- 可接收url中的键值对（GET)
- 可接受ContentType指定为`application/x-www-form-urlencoded`或 `multipart/form-data`的请求体。
- 如果请求为以上两种方法请求且参数名与形式参数名相同，可以省略该注释。
- 这种情况下，用到的参数处理器是`RequestParamMapMethodArgumentResolver`
- **注意**：形式参数可以为实体类的对象，这时请求的键值对会自动按照键名与属性名匹配的原则自动注入，这种情况下，不能使用本注解，参数处理器为ServletModelAttributeMethodProcessor，主要是把HttpServletRequest中的表单参数封装到MutablePropertyValues实例中，再通过参数类型实例化（通过构造反射创建User实例），反射匹配属性进行值的填充。

**属性**

- `value`：默认的属性，指定键值对中的键名。
- `require`：该参数是否是必须的。
- `defaultValue`：默认参数值，如果设置了该值require由true自动转为false，如果没有转该参数，就是使用默认值。

### @RequestBody

- 将接收到的json格式的数据转换为指定的数据对象。
- Spring MVC默认使用Jackson处理@RequestBody的参数转换。

```java
@Controller
public class TestController{
  @RequestMapping("\test")
  @ResponseBody
  public String test(@RequestBody User user){
    return new user.name();
  }
}
```

- **注意**：在一个方法内使用一次@RequestBody后，就无法再读取请求体内的其他参数，因为request的content-body是以流的形式进行读取的，读取完一次后，便无法再次读取了，所以转换为多个对象在以上方式是不支持的。

**解决方法**

- 增加包装类。
- 将接收参数定义为Map<String, Object>

### @RequestPart

- 请求的Content-Type需要为`form-data`
- 该注解的参数处理器用到的是`RequestPartMethodArgumentResolver`

```java
@PostMapping(value = "/file1")
public String file1(@RequestPart(name = "file1") MultipartFile multipartFile) {
    String content = String.format("name = %s,originName = %s,size = %d",
            multipartFile.getName(), multipartFile.getOriginalFilename(), multipartFile.getSize());
    log.info(content);
    return content;
}
```

- 可知MultipartFile实例的主要属性分别来自Content-Disposition,content-type和content-length，另外，InputStream用于读取请求体的最后部分（文件的字节序列）

### @RequestHeader

- 请求头的值主要通过@RequestHeader注解的参数获取。
- 参数处理器是RequestHeaderMethodArgumentResolver，需要在注解中指定请求头的Key

```java
@PostMapping(value = "/header")
public String header(@RequestHeader(name = "Content-Type") String contentType) {
   return contentType;
}
```

### @CookieValue

- Cookie的值主要通过@CookieValue注解的参数获取。
- 参数处理器为ServletCookieValueMethodArgumentResolver，需要在注解中指定Cookie的Key

```javascript
@PostMapping(value = "/cookie")
public String cookie(@CookieValue(name = "JSESSIONID") String sessionId) {
    return sessionId;}
```

### @ResponseBody

- 表示该方法返回的是Json字符串。

```java
@Controller
public class TestController {
   @RequestMapping("/h1")
    @ResponseBody
    public List<User> ajax2(){
   	List<User> list = new ArrayList<User>();
   	list.add(new User("test1",3,"男"));
   	list.add(new User("test2",3,"男"));
   	list.add(new User("test3",3,"男"));
     return list;
}
```

### 转发与重定向

- 转发与重定向不通过视图解析器。

```java
@Controller
public class Redirect {
    @RequestMapping("/redirect")
    public String redirect() {
    // 转发。
    	return "forward:/index.jsp";
//    	return "include:/index.jsp";
    // 重定向。
//        return "redirect:/index.jsp";
    }
}
```

### Servlet API

#### HttpServletRequest&HttpServletResponse

```java
@Controller
public class ResultGo {

    @RequestMapping("/result/t1")
    public void test1(HttpServletRequest req, HttpServletResponse rsp) throwsIOException {
        rsp.getWriter().println("Hello,Spring BY servlet API");
    }

    @RequestMapping("/result/t2")
    public void test2(HttpServletRequest req, HttpServletResponse rsp) throwsIOException {
        rsp.sendRedirect("/index.jsp");
    }

    @RequestMapping("/result/t3")
    public void test3(HttpServletRequest req, HttpServletResponse rsp) throws Exception{
        // 转发。
        req.setAttribute("msg","/result/t3");
        req.getRequestDispatcher("/WEB-INF/jsp/test.jsp").forward(req,rsp);
    }
}
```

#### HttpSession

```java
@Controller
public class ResultGo {

    @RequestMapping("/result/t1")
    public void test1(HttpSession session) throwsIOException {
        session.addAttribute("meg","Hello,Spring BY servlet API");
    }
}
```

### URL匹配

- Spring MVC中会按照URL的模式进行匹配，使用的是Ant路径风格，处理工具类为`org.springframework.util.AntPathMatcher`，从此类的注释来看，匹配规则主要包括下面四点：
    - `?`匹配1个字符。
    - `*`匹配0个或者多个**字符**
    - `**`匹配路径中0个或者多个**目录**
    - `{key:[a-z]+}`将正则表达式[a-z]+匹配到的值，赋值给名为`key`的路径变量。

**实例**

- ?形式的URL:

```java
@GetMapping(value = "/pattern?")public String pattern() {
    return "success";
}

/pattern  404 Not Found
/patternd  200 OK
/patterndd  404 Not Found
/pattern/  404 Not Found
/patternd/s  404 Not Found
```

- *形式的URL:

```java
@GetMapping(value = "/pattern*")
public String pattern() {
    return "success";
}

/pattern  200 OK
/pattern/  200 OK
/patternd  200 OK
/pattern/a  404 Not Found
```

- **形式的URL:

```java
@GetMapping(value = "/pattern/**/p")public String pattern() {
    return "success";
}

/pattern/p  200 OK
/pattern/x/p  200 OK
/pattern/x/y/p  200 OK
```

- {key:[a-z]+}形式的URL:

```java
@GetMapping(value = "/pattern/{key:\[a-c\]+}")
public String pattern(@PathVariable(name = "key") String key) {
    return "success";
}

/pattern/a  200 OK
/pattern/ab  200 OK
/pattern/abc  200 OK
/pattern  404 Not Found
/pattern/abcd  404 Not Found
```

- 上面的四种URL模式可以组合使用。
- URL匹配还遵循**精确匹配原则**，也就是存在两个模式对同一个URL都能够匹配成功，则选取最精确的URL匹配，进入对应的控制器方法。

```java
@GetMapping(value = "/pattern/**/p")
public String pattern1() {
    return "success";
}

@GetMapping(value = "/pattern/p")
public String pattern2() {
    return "success";
}
```

- 上面两个控制器，如果请求URL为/pattern/p，最终进入的方法为`pattern2`
- 最后，`org.springframework.util.AntPathMatcher`作为一个工具类，可以单独使用，不仅仅可以用于匹配URL，也可以用于匹配系统文件路径，不过需要使用其带参数构造改变内部的pathSeparator变量，例如：

```java
AntPathMatcher antPathMatcher = new AntPathMatcher(File.separator);
```
