---
title: Spring MVC 视图解析器
categories:
  - Software
  - Language
  - SpringFramework
  - SpringMVC
---
# Spring MVC 视图解析器

- Spring MVC 借助视图解析器（ViewResolver）得到最终的视图对象（View)，最终的视图可以是JSP也可是Excell
    JFreeChart等各种表现形式的视图。

## 配置视图解析器

```xml
<bean class="org.springframework.web.servlet.view.InternalResourceViewResolver"  id="internalResourceViewResolver">
   <property name="prefix" value="/WEB-INF/jsp/" />
   <property name="suffix" value=".jsp" />
</bean>
```

- `prefix`：表示视图前缀。
- `suffix`：表示视图后缀。
- **注意**：最终的视图地址为`视图前缀`+`视图名`+`视图后缀`