---
title:  Spring MVC 控制器
categories:
- Software
- Backend
- SpringFramework
- SpringMVC
---
#  Spring MVC 控制器

- 控制器复杂提供访问应用程序的行为,通常通过接口定义或注解定义两种方法实现
- 控制器负责解析用户的请求并将其转换为一个模型
- 在Spring MVC中一个控制器类可以包含多个方法
- 在Spring MVC中,对于Controller的配置方式有很多种

## 创建Controller

### 实现Controller接口

- Controller是一个接口,在org.springframework.web.servlet.mvc包下,接口中只有一个方法

```java
//实现该接口的类获得控制器功能
public interface Controller {
   //处理请求且返回一个模型与视图对象
   ModelAndView handleRequest(HttpServletRequest var1, HttpServletResponse var2) throws Exception;
}
```

- 编写完毕后,去Spring配置文件中注册请求的bean,name对应请求路径,class对应处理请求的类

```java
<bean name="/t1" class="com.example.controller.ControllerTest1"/>
```

**说明**:

- 实现接口Controller定义控制器是较老的办法

- 缺点是:一个控制器中只有一个方法,如果要多个方法则需要定义多个Controller,定义的方式比较麻烦

### 使用注解@Controller

- @Controller注解类型用于声明Spring类的实例是一个控制器
- Spring可以使用扫描机制来找到应用程序中所有基于注解的控制器类,为了保证Spring能找到你的控制器,需要在配置文件中声明组件扫描

```xml
<!-- 自动扫描指定的包,下面所有注解类交给IOC容器管理 -->
<context:component-scan base-package="com.example.controller"/>
```

- 增加一个ControllerTest2类,使用注解实现

```java
//@Controller注解的类会自动添加到Spring上下文中
@Controller
public class ControllerTest2{

   //映射访问路径
   @RequestMapping("/t2")
   public String index(Model model){
       //Spring MVC会自动实例化一个Model对象用于向视图中传值
       model.addAttribute("msg", "ControllerTest2");
       //返回视图名
       return "test";
  }
}
```

## 接收请求

### @RequestMapping

- @RequestMapping注解用于映射url到控制器类或一个特定的处理程序方法,可用于类或方法上

**只注解在方法上面**

```java
@Controller
public class TestController {
   @RequestMapping("/h1")
   public String test(){
       return "test";
  }
}
```

- 访问路径:`http://localhost:8080 / 项目名 / h1`

**同时注解类与方法**

- 用于类上,表示类中的所有响应请求的方法都是以该地址作为父路径

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

- 访问路径:`http://localhost:8080 / 项目名/ admin /h1 ` , 需要先指定类的路径再指定方法的路径

**属性**

`value`:表示映射URL, 可以用集合表示同时匹配多个URL

- `@RequestMapping()`括号中默认为value

```java
@Controller
public class TestController {
   @RequestMapping(value={"/h1","/h2","/h3"})
   public String test(){
       return "test";
  }
}
```

`method`:用于约束请求的类型,可以收窄请求范围,指定请求谓词的类型如GET, POST, HEAD, OPTIONS, PUT, PATCH, DELETE, TRACE等

```java
//映射访问路径,必须是POST请求
@RequestMapping(value = "/hello",method = {RequestMethod.POST})
public String index2(Model model){
   model.addAttribute("msg", "hello!");
   return "test";
}
```

- **注意**:所有的地址栏请求默认都会是 HTTP GET 类型的
- 方法级别的注解变体有如下几个:

```
@GetMapping
@PostMapping
@PutMapping
@DeleteMapping
@PatchMapping
```

- @GetMapping 是一个组合注解,平时使用的会比较多!
- 它所扮演的是` @RequestMapping(method =RequestMethod.GET) `的一个快捷方式

### @PathVariable

- 让方法参数的值对应绑定到一个URI模板变量上

```java
@Controller
public class RestFulController {

   //映射访问路径
   @RequestMapping("/commit/{p1}/{p2}")
   public String index(@PathVariable int p1, @PathVariable int p2, Model model){

       int result = p1+p2;
       //Spring MVC会自动实例化一个Model对象用于向视图中传值
       model.addAttribute("msg", "结果:"+result);
       //返回视图名
       return "test";
  }
}
```

- 路径参数支持正则表达式,例如我们在使用/sex/sex}接口的时候,要求sex必须是F(Female)或者M(Male),那么我们的URL模板可以定义为/sex/{sex:MF,代码如下:

```javascript
@GetMapping(value = "/sex/{sex:M|F}")
public String findUser2(@PathVariable(value = "sex") String sex){
    log.info(sex);
    return sex;
}
```

- 只有/sex/F或者/sex/M的请求才会进入findUser2控制器方法,其他该路径前缀的请求都是非法的,会返回404状态码

### @RequestParam

- 可接收url中的键值对(GET)
- 可接受ContentType指定为application/x-www-form-urlencoded的请求体(POST)
- 如果请求为以上两种方法请求且参数名与形式参数名相同,可以省略该注释
- 这种情况下,用到的参数处理器是`RequestParamMapMethodArgumentResolver`
- **注意**:形式参数可以为实体类的对象,这时请求的键值对会自动按照键名与属性名匹配的原则自动注入,这种情况下,不能使用本注解,参数处理器为ServletModelAttributeMethodProcessor,主要是把HttpServletRequest中的表单参数封装到MutablePropertyValues实例中,再通过参数类型实例化(通过构造反射创建User实例),反射匹配属性进行值的填充

**属性**

- `value`:默认的属性,指定键值对中的键名
- `require`:该参数是否是必须的
- `defaultValue`:默认参数值,如果设置了该值require由true自动转为false,如果没有转该参数,就是使用默认值

### @RequestBody

- 将接收到的json格式的数据转换为指定的数据对象user,比如`{name:"test"},name`为User类的属性域
- 通过ResponseBody注解,可以返回json格式的数据
- Spring MVC默认使用Jackson处理@RequestBody的参数转换

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

- **注意**:在一个方法内使用一次@RequestBody后,就无法再读取请求体内的其他参数,因为request的content-body是以流的形式进行读取的,读取完一次后,便无法再次读取了,所以转换为多个对象在以上方式是不支持的

**解决方法**

- 增加一个包装类

```java
@Controller
public class TestController{
  @RequestMapping("\test")
  @ResponseBody
  public RetureResult test(@RequestBody Param param){
    return new ReturnResult();
  }
}
class Param{
  public User user;
  public Address address;
}
```

- **注意**:类中属性必须为public,或者有setter和getter
- Param类中的属性只能比json中的属性多,不能少
- 此时传输的json数据格式变为{user:{name:"test"},address:{location:"新华路"}}
- 由于只是在TestController中增加一个包装类,不会影响其他的类以及已经定义好的model类,因此可以非常方便的达到接收多个对象参数的目的

- 将接收参数定义为Map<String, Object>

```java
@Controller
public class TestController{
  @RequestMapping("\test")
  @ResponseBody
  public Object test(@RequestBody Map<String, Object> models){
　　　User user=JsonXMLUtils.map2object((Map<String, Object>)models.get("user"),User.class);
　　　Address address=JsonXMLUtils.map2object((Map<String, Object>)models.get("address"),Address.class);
　　　return models;
　}
}
```

- 此时,即使自定义的Param类中的属性即使比json数据中的属性少了,也没关系
- 其中JSONUtils为自定义的工具类,可使用常见的fastjson等工具包包装实现

```java
import com.alibaba.fastjson.JSON;

public class JsonXMLUtils {
    public static String obj2json(Object obj) throws Exception {
        return JSON.toJSONString(obj);
    }

    public static <T> T json2obj(String jsonStr, Class<T> clazz) throws Exception {
        return JSON.parseObject(jsonStr, clazz);
    }

    public static <T> Map<String, Object> json2map(String jsonStr)     throws Exception {
            return JSON.parseObject(jsonStr, Map.class);
    }

    public static <T> T map2obj(Map<?, ?> map, Class<T> clazz) throws Exception {
        return JSON.parseObject(JSON.toJSONString(map), clazz);
    }
    }
```

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

- 可知MultipartFile实例的主要属性分别来自Content-Disposition,content-type和content-length,另外,InputStream用于读取请求体的最后部分(文件的字节序列)

### @RequestHeader

- 请求头的值主要通过@RequestHeader注解的参数获取
- 参数处理器是RequestHeaderMethodArgumentResolver,需要在注解中指定请求头的Key

```java
@PostMapping(value = "/header")
public String header(@RequestHeader(name = "Content-Type") String contentType) {
   return contentType;
}
```

### @CookieValue

- Cookie的值主要通过@CookieValue注解的参数获取
- 参数处理器为ServletCookieValueMethodArgumentResolver,需要在注解中指定Cookie的Key

```javascript
@PostMapping(value = "/cookie")
public String cookie(@CookieValue(name = "JSESSIONID") String sessionId) {
    return sessionId;}
```

## 返回响应

### 转发与重定向

- 转发与重定向不通过视图解析器

```java
@Controller
public class Redirect {
    @RequestMapping("/redirect")
    public String redirect() {
    //转发
    	return "forward:/index.jsp";
//    	return "include:/index.jsp";
    //重定向
//        return "redirect:/index.jsp";
    }
}
```

### 返回页面与数据

#### ModelAndView

```java a
public class ControllerTest1 implements Controller {

   public ModelAndView handleRequest(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse) throws Exception {
       //返回一个模型视图对象
       ModelAndView mv = new ModelAndView();
       mv.addObject("msg","ControllerTest1");
       mv.setViewName("test");
       return mv;
  }
}
```

#### ModelMap

```java
@RequestMapping("/hello")
public String hello(@RequestParam("username") String name, ModelMap model){
   //封装要显示到视图中的数据
   //相当于req.setAttribute("name",name);
   model.addAttribute("name",name);
   System.out.println(name);
   return "hello";
}
```

#### Model

```java
@RequestMapping("/ct2/hello")
public String hello(@RequestParam("username") String name, Model model){
   //封装要显示到视图中的数据
   //相当于req.setAttribute("name",name);
   model.addAttribute("msg",name);
   System.out.println(name);
   return "test";
}
```

**对比**

- Model 只有寥寥几个方法只适合用于储存数据,简化了新手对于Model对象的操作和理解
- ModelMap 继承了 LinkedMap ,除了实现了自身的一些方法,同样的继承 LinkedMap 的方法和特性
- ModelAndView 可以在储存数据的同时,可以进行设置返回的逻辑视图,进行控制展示层的跳转

### 返回Json字符串

- Controller类的方法返回的Java对象会自动由`Jackson`转换为Json字符串,并返回响应

#### @ResponseBody

- 表示该方法返回的是Json字符串

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

#### @RestController

- 添加在Controller类上,等同于该类所有的方法加上@ResponseBody注解

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

## Servlet API

### HttpServletRequest&HttpServletResponse

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
       //转发
       req.setAttribute("msg","/result/t3");
       req.getRequestDispatcher("/WEB-INF/jsp/test.jsp").forward(req,rsp);
  }
}
```

### HttpSsession

```java
@Controller
public class ResultGo {

   @RequestMapping("/result/t1")
   public void test1(HttpSession session) throwsIOException {
       session.addAttribute("meg","Hello,Spring BY servlet API");
  }
}
```

## **URL匹配**

- Spring MVC中会按照URL的模式进行匹配,使用的是Ant路径风格,处理工具类为`org.springframework.util.AntPathMatcher`,从此类的注释来看,匹配规则主要包括下面四点:
    - `?`匹配1个字符
    - `*`匹配0个或者多个**字符**
    - `**`匹配路径中0个或者多个**目录**
    - `{key:[a-z]+}`将正则表达式[a-z]+匹配到的值,赋值给名为`key`的路径变量

**实例**

- ?形式的URL:

```javascript
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

```javascript
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

```javascript
@GetMapping(value = "/pattern/**/p")public String pattern() {
    return "success";
}

/pattern/p  200 OK
/pattern/x/p  200 OK
/pattern/x/y/p  200 OK
```

- {key:[a-z]+}形式的URL:

```javascript
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

- 上面的四种URL模式可以组合使用
- URL匹配还遵循**精确匹配原则**,也就是存在两个模式对同一个URL都能够匹配成功,则选取最精确的URL匹配,进入对应的控制器方法

```javascript
@GetMapping(value = "/pattern/**/p")
public String pattern1() {
    return "success";
}

@GetMapping(value = "/pattern/p")
public String pattern2() {
    return "success";
}
```

- 上面两个控制器,如果请求URL为/pattern/p,最终进入的方法为`pattern2`
- 最后,`org.springframework.util.AntPathMatcher`作为一个工具类,可以单独使用,不仅仅可以用于匹配URL,也可以用于匹配系统文件路径,不过需要使用其带参数构造改变内部的pathSeparator变量,例如:

```javascript
AntPathMatcher antPathMatcher = new AntPathMatcher(File.separator);
```

## 其他注解

### @ModelAttribute

- @ModelAttribute最主要的作用是将数据添加到模型对象中, 用于视图页面展示时使用
- @ModelAttribute等价于 model.addAttribute("attributeName", abc); 但是根据@ModelAttribute注释的位置不同, 和其他注解组合使用, 致使含义有所不同

#### @ModelAttribute注释方法

- 被@ModelAttribute注释的方法会在此controller每个方法执行前被执行, 因此对于一个controller映射多个URL的用法来说, 要谨慎使用

**实例**

**@ModelAttribute注释void返回值的方法**

```java
@Controller
 public class HelloWorldController {
     @ModelAttribute
     public void populateModel(@RequestParam String abc, Model model) {
          model.addAttribute("attributeName", abc);
       }

     @RequestMapping(value = "/helloWorld")
     public String helloWorld() {
        return "helloWorld";
         }
  }
```

- 获得请求/helloWorld 后, populateModel方法在helloWorld方法之前先被调用, 它把请求参数(/helloWorld?abc=text)加入到一个名为attributeName的model属性中, 在它执行后 helloWorld被调用, 返回视图名helloWorld和model已由@ModelAttribute方法生产好了

**@ModelAttribute注释返回具体类的方法**

```java
@ModelAttribute
public Account addAccount(@RequestParam String number) {
    return accountManager.findAccount(number);
}
```

- 这种情况, model属性的名称没有指定, 它由返回类型隐含表示, 如这个方法返回Account类型, 那么这个model属性的名称是account
- 这个例子中model属性名称有返回对象类型隐含表示, model属性对象就是方法的返回值,它无须要特定的参数

**@ModelAttribute(value="")注释返回具体类的方法**

```java
 @Controller
 public class HelloWorldController {
     @ModelAttribute("attributeName")
     public String addAccount(@RequestParam String abc) {
         return abc;
       }

     @RequestMapping(value = "/helloWorld")
     public String helloWorld() {
         return "helloWorld";
           }
    }
```

- 这个例子中使用@ModelAttribute注释的value属性, 来指定model属性的名称,model属性对象就是方法的返回值,它无须要特定的参数

**@ModelAttribute和@RequestMapping同时注释一个方法**

```java
@Controller
public class HelloWorldController {
    @RequestMapping(value = "/helloWorld.do")
    @ModelAttribute("attributeName")
    public String helloWorld() {
         return "hi";
     }
  }
```

- 这时这个方法的返回值并不是表示一个视图名称, 而是model属性的值, 视图名称由`RequestToViewNameTranslator`根据请求"/helloWorld.do"转换为逻辑视图helloWorld
- Model属性名称有@ModelAttribute(value=””)指定, 相当于在request中封装了key=attributeName, value=hi

#### @ModelAttribute注释方法的参数

**从model中获取**

```java
 @Controller
 public class HelloWorldController {
     @ModelAttribute("user")
     public User addAccount() {
        return new User("jz","123");
      }

     @RequestMapping(value = "/helloWorld")
     public String helloWorld(@ModelAttribute("user") User user) {
            user.setUserName("jizhou");
            return "helloWorld";
         }
   }
```

- 在这个例子里, `@ModelAttribute("user") User user`注释方法参数, 参数user的值来源于`addAccount()`方法中的model属性
- 此时如果方法体没有标注@SessionAttributes("user"), 那么scope为request, 如果标注了, 那么scope为session

**从Form表单或URL参数中获取**

- 实际上, 不做此注释也能拿到user对象

```java
@Controller
public class HelloWorldController {
    @RequestMapping(value = "/helloWorld")
   public String helloWorld(@ModelAttribute User user) {
        return "helloWorld";
     }
}
```

- 它的作用是将该绑定的命令对象以"user”为名称添加到模型对象中供视图页面展示使用
- 此时可以在视图页面使用${user.username}来获取绑定的命令对象的属性

#### @ModelAttribute注释方法的返回值

```java
@Controller
public class HelloWorldController {
     @RequestMapping(value = "/helloWorld")
    public @ModelAttribute("user2") User helloWorld(@ModelAttribute User user) {
        return new User();
     }
}
```

- 可以看到返回值类型是对象类型, 而且通过 @ModelAttribute("user2") 注解, 此时会添加返回值到模型数据( 名字为user2 ) 中供视图展示使用
- @ModelAttribute 注解的返回值会覆盖参数注解对象user

### @SessionAttributes

- 用于在请求之间的HTTP Servlet会话中存储model属性
- 它是类级别的注解, 用于声明特定控制器使用的会话属性
- 这通常列出应透明地存储在会话中以供后续访问请求的模型属性的名称或模型属性的类型

**实例**

```java
@SessionAttributes("user")
public class LoginController {

	@ModelAttribute("user")
	public User setUpUserForm() {
		return new User();
	}
}
```

- 可以看到@SessionAttributes是类注解, 用来在session中存储model
-  如上面的例子, 定义了一个名为"User”的model并把它存储在Session中