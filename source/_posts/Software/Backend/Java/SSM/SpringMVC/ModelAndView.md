---
title: Spring MVC ModelAndView
categories:
- Software
- Backend
- Java
- SSM
- SpringMVC
---
# Spring MVC ModelAndView

- 可由`Controller`类的`handleRequest`方法返回
- 对于Controller的目标方法,无论其返回值是String,View,ModelMap或是ModelAndView,Spring MVC都会在内部将它们封装为一个`ModelAndView`对象进行返回
- 可以在该对象上设置数据与视图


## method

**addObject**

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

**setViewName**

- 设置ModelAndView对象 , 根据view的名称 , 和视图解析器跳到指定的页面
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

