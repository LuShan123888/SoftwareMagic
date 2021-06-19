---
title: Spring 整合Thymeleaf
categories:
- Software
- Backend
- Java
- SpringFramework
- Spring
---
# Spring 整合Thymeleaf

## 模板引擎

模板引擎的作用就是通过一个页面模板,将表达式解析,从后台提取数值并填充到指定的位置,最终生成一个静态页面

![img](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-2020-11-16-640-20201116091443136.png)

## pom.xml

```xml 
<!--thymeleaf-->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-thymeleaf</artifactId>
</dependency>
```

## Thymeleaf配置

**ThymeleafProperties.class**

```java
@ConfigurationProperties(
    prefix = "spring.thymeleaf"
)
public class ThymeleafProperties {
    private static final Charset DEFAULT_ENCODING;
    public static final String DEFAULT_PREFIX = "classpath:/templates/";
    public static final String DEFAULT_SUFFIX = ".html";
    private boolean checkTemplate = true;
    private boolean checkTemplateLocation = true;
    private String prefix = "classpath:/templates/";
    private String suffix = ".html";
    private String mode = "HTML";
    private Charset encoding;
}
```

- 默认前缀:`classpath:/templates/`
- 默认后缀:`.html`
- 所以如果我们返回视图:`users`,会指向到 `classpath:/templates/users.html`

- Thymeleaf默认会开启页面缓存,提高页面并发能力,但会导致我们修改页面不会立即被展现,因此我们关闭缓存:

```properties
# 关闭Thymeleaf的缓存
spring.thymeleaf.cache=false
```

## Thymeleaf 语法

- Thymeleaf 官网:https://www.thymeleaf.org

### 命名空间

```html
<html lang="en" xmlns:th="http://www.thymeleaf.org">
```

### 指令

- Thymeleaf中所有的表达式都需要写在`指令`中,指令是HTML5中的自定义属性,在Thymeleaf中所有指令都是以`th:`开头
- 静态页面中,`th`指令不被识别,但是浏览器也不会报错,把它当做一个普通属性处理
- 如果是在Thymeleaf环境下,`th`指令就会被识别和解析
- 指令的设计,正是Thymeleaf的高明之处,也是它优于其它模板引擎的原因,动静结合的设计,使得无论是前端开发人员还是后端开发人员可以完美契合
- 可以使用任意的 th:attr 来替换Html中原生属性的值

![img](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-2020-11-19-640-20201116170238354.jpeg)

### 变量

Thymeleaf通过`${}`来获取model中的变量,注意这不是el表达式,而是ognl表达式,但是语法非常像

```html
<h1>
    欢迎您:<span th:text="${user.name}">请登录</span>
</h1>
```

#### ognl表达式的语法糖

- 刚才获取变量值,使用的是经典的`对象.属性名`方式,但有些情况下,我们的属性名可能本身也是变量
- ognl提供了类似js的语法方式
- 例如:`${user.name}` 可以写作`${user['name']}`

#### 自定义变量

**实例**

- 获取用户的所有信息并分别展示

```html
<h2>
    <p>Name: <span th:text="${user.name}">Jack</span>.</p>
    <p>Age: <span th:text="${user.age}">21</span>.</p>
    <p>friend: <span th:text="${user.friend.name}">Rose</span>.</p>
</h2>
```

- 当数据量比较多的时候,频繁的写`user.`就会非常麻烦
- 因此,Thymeleaf提供了自定义变量来解决

```html
<h2 th:object="${user}">
    <p>Name: <span th:text="*{name}">Jack</span>.</p>
    <p>Age: <span th:text="*{age}">21</span></p>
    <p>friend: <span th:text="*{friend.name}">Rose</span>.</p>
</h2>
```

- 首先在 `h2`上 用 `th:object="${user}"`获取user的值,并且保存
- 然后,在`h2`内部的任意元素上,可以通过 `*{属性名}`的方式,来获取user中的属性,这样就省去了大量的`user.`前缀了

### 方法

- ognl表达式本身就支持方法调用,例如:

```html
<h2 th:object="${user}">
    <p>FirstName: <span th:text="*{name.split(' ')[0]}">Jack</span>.</p>
    <p>LastName: <span th:text="*{name.split(' ')[1]}">Li</span>.</p>
</h2>
```

- 这里我们调用了字符串的`split()`方法

Thymeleaf中提供了一些内置对象,并且在这些对象中提供了一些方法,方便我们来调用,获取这些对象,需要使用`#对象名`来引用

**环境相关对象**

|       对象        | 作用                                          |
| :---------------: | :-------------------------------------------- |
|      `#ctx`       | 获取Thymeleaf自己的Context对象                |
|    `#requset`     | 如果是web程序,可以获取HttpServletRequest对象 |
|    `#response`    | 如果是web程序,可以获取HttpServletReponse对象 |
|    `#session`     | 如果是web程序,可以获取HttpSession对象        |
| `#servletContext` | 如果是web程序,可以获取HttpServletContext对象 |

**Thymeleaf提供的全局对象**

|     对象     | 作用                             |
| :----------: | :------------------------------- |
|   `#dates`   | 处理java.util.date的工具对象     |
| `#calendars` | 处理java.util.calendar的工具对象 |
|  `#numbers`  | 用来对数字格式化的方法           |
|  `#strings`  | 用来处理字符串的方法             |
|   `#bools`   | 用来判断布尔值的方法             |
|  `#arrays`   | 用来护理数组的方法               |
|   `#lists`   | 用来处理List集合的方法           |
|   `#sets`    | 用来处理set集合的方法            |
|   `#maps`    | 用来处理map集合的方法            |

**实例**

- 在环境变量中添加日期类型对象

```java
@GetMapping("show")
public String show3(Model model){
    model.addAttribute("today", new Date());
    return "show3";
}
```

- 在页面中处理

```html
<p>
    今天是: <span th:text="${#dates.format(today,'yyyy-MM-dd')}">2018-04-25</span>
</p>
```

### 字面值

- 有的时候,我们需要在指令中填写基本类型如:字符串,数值,布尔等,并不希望被Thymeleaf解析为变量,这个时候称为字面值

#### 字符串字面值

- 使用一对`'`引用的内容就是字符串字面值了

```html
<p>
    你正在观看 <span th:text="'thymeleaf'">template</span> 的字符串常量值.
</p>
```

- `th:text`中的thymeleaf并不会被认为是变量,而是一个字符串

#### 数字字面值

- 数字不需要任何特殊语法,可以直接进行算术运算

```html
<p>今年是 <span th:text="2018">1900</span>.</p>
<p>两年后将会是 <span th:text="2018 + 2">1902</span>.</p>
```

#### 布尔字面值

- 布尔类型的字面值是true或false

```html
<div th:if="true">
    你填的是true
</div>
```

- 这里引用了一个`th:if`指令,跟vue中的`v-if`类似

#### 拼接

- 经常会用到普通字符串与表达式拼接的情况

```html
<span th:text="'欢迎您:' + ${user.name} + '!'"></span>
```

- 字符串字面值需要用`''`,拼接起来非常麻烦,Thymeleaf对此进行了简化,使用一对`|`即可:

```html
<span th:text="|欢迎您:${user.name}|"></span>
```

- 与上面是完全等效的,这样就省去了字符串字面值的书写

### 运算

**注意**:`${}`内部的是通过OGNL表达式引擎解析的,外部的才是通过Thymeleaf的引擎解析,因此运算符尽量放在`${}`外进行

#### 算术运算

- 支持的算术运算符:`+ - * / %`

```html
<span th:text="${user.age}"></span>
<span th:text="${user.age}%2 == 0"></span>
```

#### 比较运算

- 支持的比较运算:`>`, `<`, `>=` and `<=`,但是`>`, `<`不能直接使用,因为xml会解析为标签,要使用别名
- **注意**: `==` and `!=`不仅可以比较数值,类似于equals的功能
- 可以使用的别名:`gt (>), lt (<), ge (>=), le (<=), not (!). Also eq (==), neq/ne (!=).`

### 循环

- 循环也是非常频繁使用的需求,我们使用`th:each`指令来完成
- 假如有用户的集合:users在Context中

```html
<tr th:each="user : ${users}">
    <td th:text="${user.name}">Onions</td>
    <td th:text="${user.age}">2.41</td>
</tr>
```

- `${users}`是要遍历的集合,可以是以下类型:
    - `Iterable`:实现了Iterable接口的类
    - `Enumeration`:枚举
    - `Interator`:迭代器
    - `Map`:遍历得到的是Map.Entry
    - `Array`:数组及其它一切符合数组结果的对象

- 在迭代的同时,我们也可以获取迭代的状态对象

```html
<tr th:each="user,stat : ${users}">
    <td th:text="${user.name}">Onions</td>
    <td th:text="${user.age}">2.41</td>
</tr>
```

- `stat`对象包含以下属性:
    - `index`:从0开始的角标
    - `count`:元素的个数,从1开始
    - `size`:总元素个数
    - `current`:当前遍历到的元素
    - `even/odd`:返回是否为奇偶,boolean值
    - `first/last`:返回是否为第一或最后,boolean值

### 逻辑判断

- Thymeleaf中使用`th:if` 或者 `th:unless`,两者的意思恰好相反

```html
<span th:if="${user.age} < 24">test</span>
```

- 如果表达式的值为true,则标签会渲染到页面,否则不进行渲染
- 以下情况被认定为true:
    - 表达式值为true
    - 表达式值为非0数值
    - 表达式值为非0字符
    - 表达式值为字符串,但不是`"false"`,`"no"`,`"off"`
    - 表达式不是布尔,字符串,数字,字符中的任何一种
    - 其它情况包括null都被认定为false

#### 三元运算

- 三元运算符的三个部分:`conditon ? then : else`

```html
<span th:text="${user.sex} ? '男':'女'"></span>
```

**默认值**

- 有的时候,我们取一个值可能为空,这个时候需要做非空判断,可以使用 `表达式 ?: 默认值`简写

```html
<span th:text="${user.name} ?: 'test'"></span>
```

- 当前面的表达式值为null时,就会使用后面的默认值
- **注意**:`?:`之间没有空格

### 分支控制switch

- 使用两个指令:`th:switch` 和 `th:case`

```html
<div th:switch="${user.role}">
    <p th:case="'admin'">用户是管理员</p>
    <p th:case="'manager'">用户是经理</p>
    <p th:case="*">用户是其他角色</p>
</div>
```

- **注意**,一旦有一个th:case成立,其它的则不再判断,与java中的switch是一样的
- `th:case="*"`表示默认,放在最后

### JS模板

- 模板引擎不仅可以渲染html,也可以对JS中的进行预处理,而且为了在纯静态环境下可以运行,其Thymeleaf代码可以被注释起来

```html
<script th:inline="javascript">
    const user = /*[[${user}]]*/ {};
    const age = /*[[${user.age}]]*/ 20;
    console.log(user);
    console.log(age)
</script>
```

- 在script标签中通过`th:inline="javascript"`来声明这是要特殊处理的js脚本

**语法结构**

```js
const user = /*[[Thymeleaf表达式]]*/ "静态环境下的默认值";
```

- 因为Thymeleaf被注释起来,因此即便是静态环境下,js代码也不会报错,而是采用表达式后面跟着的默认值

**控制台**

![img](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-2020-11-16-1-20201116192058797.png)
