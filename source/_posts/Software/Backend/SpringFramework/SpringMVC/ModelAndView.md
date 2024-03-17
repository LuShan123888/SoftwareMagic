---
title: Spring MVC ModelAndView
categories:
- Software
- BackEnd
- SpringFramework
- SpringMVC
---
# Spring MVC ModelAndView

- 可由`Controller`类的`handleRequest`方法返回。
- 对于Controller的目标方法，无论其返回值是String,View,ModelMap或是ModelAndView,Spring MVC都会在内部将它们封装为一个`ModelAndView`对象进行返回。
- 可以在该对象上设置数据与视图。

## ModelAndView

### addObject()

- 将数据对象放入`ModelAndView`

```java
public class ControllerTest1 implements Controller {

   public ModelAndView handleRequest(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse) throws Exception {
       ModelAndView mv = new ModelAndView();
       mv.addObject("msg","ControllerTest1");
       return mv;
  }
}
```

### setViewName()

- 设置ModelAndView对象，根据view的名称，和视图解析器跳到指定的页面。
- **视图地址=视图解析器前缀+viewName+视图解析器后缀**

```java
public class ControllerTest1 implements Controller {

   public ModelAndView handleRequest(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse) throws Exception {
       ModelAndView mv = new ModelAndView();
       mv.setViewName("test");
       return mv;
  }
}
```

## ModelMap

```java
@RequestMapping("/hello")
public String hello(@RequestParam("username") String name, ModelMap model){
   // 封装要显示到视图中的数据。
   // 相当于req.setAttribute("name",name);
   model.addAttribute("name",name);
   System.out.println(name);
   return "hello";
}
```

## Model

```java
@RequestMapping("/ct2/hello")
public String hello(@RequestParam("username") String name, Model model){
   // 封装要显示到视图中的数据。
   // 相当于req.setAttribute("name",name);
   model.addAttribute("msg",name);
   System.out.println(name);
   return "test";
}
```

**对比**

- Model 只有寥寥几个方法只适合用于储存数据，简化了新手对于Model对象的操作和理解。
- ModelMap 继承了 LinkedMap ，除了实现了自身的一些方法，同样的继承 LinkedMap 的方法和特性。
- ModelAndView 可以在储存数据的同时，可以进行设置返回的逻辑视图，进行控制展示层的跳转。

## @ModelAttribute

- @ModelAttribute最主要的作用是将数据添加到模型对象中，用于视图页面展示时使用。
- @ModelAttribute等价于 model.addAttribute("attributeName", abc); 但是根据@ModelAttribute注释的位置不同，和其他注解组合使用，使含义有所不同。

### @ModelAttribute注释方法

- 被@ModelAttribute注释的方法会在此controller每个方法执行前被执行，因此对于一个controller映射多个URL的用法来说，要谨慎使用。

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

- 接收请求`/helloWorld`后， populateModel方法在helloWorld方法之前先被调用，它把请求参数（/helloWorld?abc=text)加入到一个名为attributeName的model属性中，在它执行后 helloWorld被调用，返回视图名helloWorld和model已由@ModelAttribute方法生产好了。

**@ModelAttribute注释返回具体类的方法**

```java
@Controller
public class HelloWorldController {
    @ModelAttribute("attributeName")
    public Account addAccount(@RequestParam String number) {
        return accountManager.findAccount(number);
    }

    @RequestMapping(value = "/helloWorld")
    public String helloWorld() {
        return "helloWorld";
    }
}
```

- 这个例子中使用@ModelAttribute注释的value属性，来指定model属性的名称，model属性对象就是方法的返回值。
- 如果model属性的名称没有指定，它由返回类型隐含表示，如这个方法返回Account类型，那么这个model属性的名称是account

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

- 这时这个方法的返回值并不是表示一个视图名称，而是model属性的值，视图名称由`RequestToViewNameTranslator`根据请求"/helloWorld.do"转换为逻辑视图helloWorld
- Model属性名由@ModelAttribute指定，相当于在request中封装了key=attributeName, value=hi

### @ModelAttribute注释方法的参数

**从model中获取**

```java
@Controller
public class HelloWorldController {
    @ModelAttribute("user")
    public User addAccount() {
        return new User("test","123");
    }

    @RequestMapping(value = "/helloWorld")
    public String helloWorld(@ModelAttribute("user") User user) {
        user.setUserName("test");
        return "helloWorld";
    }
}
```

- 在这个例子里， `@ModelAttribute("user") User user`注释方法参数，参数user的值来源于`addAccount()`方法中的model属性。
- 此时如果方法体没有标注@SessionAttributes("user")，那么scope为request，如果标注了，那么scope为session

**从Form表单或URL参数中获取**

```java
@Controller
public class HelloWorldController {
    @RequestMapping(value = "/helloWorld")
    public String helloWorld(@ModelAttribute User user) {
        return "helloWorld";
    }
}
```

- 实际上，不做此注释也能拿到user对象，它的作用是将该绑定的命令对象以user为名称添加到模型对象中供视图页面展示使用。
- 此时可以在视图页面使用${user.username}来获取绑定的命令对象的属性。

### @ModelAttribute注释方法的返回值

```java
@Controller
public class HelloWorldController {
    @RequestMapping(value = "/helloWorld")
    public @ModelAttribute("user2") User helloWorld(@ModelAttribute User user) {
        return new User();
    }
}
```

- 可以看到返回值类型是对象类型，而且通过`@ModelAttribute("user2")`注解，此时会添加返回值到模型数据（名字为user2 ) 中供视图展示使用。
- @ModelAttribute 注解的返回值会覆盖参数注解对象user
