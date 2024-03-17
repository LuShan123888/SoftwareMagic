---
title: PHP 嵌入PHP代码
categories:
  - Software
  - Language
  - PHP
  - 语言基础
---
# PHP 嵌入PHP代码

- 虽然可以书写和运行独立的PHP程序，但是大多数的PHP代码都是嵌入到HTML或XML文件中的，这毕竟是PHP被创造的首要原因，处理这样的文档需要用PHP执行时源代码生成的输出来代替每块PHP源代码。
- 因为一个单独的文件中包含PHP和非PHP的源代码，所以需要一种方法来识别出属于PHP代码的区域用于执行，PHP提供了4种不同的方式来做这件事情。
- 正如你将要看到的，第一种方法（也是首选的）看起来像XML，第二种方法看起来像SGML，第三种方法基于ASP标签，第四种方法使用标准的HTML<script>标签，这使用常规的HTML编辑器编辑嵌入PHP的页面变得容易。
## XML风格

- 因为XML(eXtensible Markup Language，可拓展标记语言）的出现和HTML向XML语言的过渡(XHTML)，目前嵌入PHP的的首选技术是使用XML兼容标签来指示PHP的指令。
- 因为XML允许定义新标签，XML中用标签来区分PHP命令是很简单的，要使用这种风格，需要将PHP代码包含在`<?php和?>`之间，所有在这些标记之间的部分都当作PHP代码来解释，所有在标记之外的则不是，虽然在标记和其中的文本之间的空格并不是必须的，但是这样做会增加可读性，例如，要让PHP打印"Hello World"，可以在Web页面中插入下面一行：

```php
<?php echo"Hello, World"; ?>
```

- 因为块的末尾也强制结束表达式，所以紧随在语句之后的分号是可选的，以下示例将PHP嵌入到一个完整的HTMl文件中：

```php+HTML
<!dictype html public "-//w3c//DTD XHTML 1.0 Transitional//EN"http://www.w3.org/TR/xhtml11/DTD/xhtml11-transitional.dtd">
<html>
    <head>
        <title>This is my first PHP program!</title>
    </head>
    <body>
        <p>
            Look,me! It is my first PHP program:<br/>
            <?php echo "Hello, world"; ?><br/>
            How cool is that?
        </p>
    </body>
</html>
```

- 当然，这并不能让人非常激动，不用PHP我们也能完成它，但当我们要把从信息源（如数据库和表单值）得到的动态信息放到Web页面时，PHP就非常有价值，当用户访问这个页面并查看它的源代码时，看到的是：

```php+HTML
<!dictype html public "-//w3c//dtd html 4.0 transitional//en">
<html>
    <head>
        <title>This is my first PHP program!</title>
    </head>
    <body>
        <p>
            Look,me! It's my first PHP program:<br/>
            Hello, world<br/>
            How cool is that?
        </p>
    </body>
</html>
```

- 在这里我们看不到PHP源代码的踪迹，用户看到的只是它的输出。
- 注意所有在PHP和非PHP之间的转换都在单独的一行中，PHP命令可以放在文件里的任意地方，甚至是在HTML标签中，例如：

```php+HTML
<input type="text" name="first_name" value="<?php echo "Rasmus"; ?> "/>
当PHP处理这个文本时，将读到：
<input type="text" name="first_name" value=Rasmus" />
```

- 在开始和结束标记中的PHP代码可以不在同一行里，如果PHP命令的结束标记是在一行的末尾，则结束标记后的换行符也可以去掉，因此，我们可以改写：Hello,world"例子：

```php+HTML
<?php
Echo "Hello, world"; ?>
<br />
```

- 分行之后，生成的HTML没有任何变化。

## SGML风格

嵌入PHP的"经典"风格源于SGML命令处理标签，要使用这种方法，只需简单地将PHP包含在`<?和?>`中，下面还是"Hello world"的例子：

```php+HTML
<? echo "Hello, world"; ?>
```

- 我们把这种风格称之为短标签(short tag)，这种风格时最简短和插入最少的，并且可以在`php.ini`初始化文件中关闭它，以便不和XML PI(Process Instruction，处理指令）标签产生冲突，因此，如果想要编写完全可一至的PHP代码分发给其他人（他们可能关闭短标签)，就应该使用较长的`<?php ... ?>`标签风格，如果你不需要和他人共享你的代码，也无需告诉想使用你的代码的人来打开短标签，并且你不打打算在你的PHP代码中混入XML，那么就可以使用这种风格的标签。

## ASP风格

- 因为SGML和XML标签风格都不是严格合法的HTML，一些HTML编辑器不能正确的解析它（如语法颜色高亮，上下文相关帮助和其他细节)，一些编辑器甚至会帮助你移出这些"损坏的"代码，尽管如此，很多HTML编辑器都认可另一种嵌入代码的机制，就是微软的ASP(Active Server Pages)，和PHP一样，ASP是一种将服务器端脚本嵌入到HTML页面的方法。
- 如果你想使用ASP的工具编辑嵌入PHP的文件，你可以用ASP风格的标签来确定PHP代码区域，ASP风格的标签与SGML风格的标签类似，只是用`%`替代了`?`:

```php+HTML
<% echo "Hello,world"; %>
```

- 除此之外，ASP风格的标签的工作方式与SGML风格的标签一样。
- ASP风格的标签默认是不生效的，你需要在编译PHP时加上`--enable-asp-tags`选项或者编辑`php.int`文件，设置其中的`asp_tags`
## 脚本风格

- 最后一种从HTML中区分PHP代码的方法是用一个标签来允许在HTML页中进行客户端脚本编程，该标签是。

```php+HTML
<script language="php">
echo "Hello, world";
</script>
```

- 这种方法对于仅工作于严格合法的HTML文件，但不支持XML处理命令的HTML编辑器最有用。

## 直接输出内容

- PHP程序最常见的操作可能要数向用户显示数据，在这个WEB应用的上下文中，这意味着插入到HTML文档的信息在被用户查看时将变成HTML
- 为了简化这个操作，PHP提供了SGML和ASP标签的特别版本，这些版本自动获取标签中的值并且将其插入到HTML页面中，为了使用这个特性，可在开始标签后添加一个等号`=`，用这个技术，我们重写表单的例子，如下：

```php+HTML
<input type="text" name="first_name" value="<?="Rasmus"; ?>">
```

- 如果你启用了ASP风格的标签，则可以用ASP标签完成同样的工作：

```php+HTML
<p>This number (<%= 2+2 %>)<br />
And this number (<% echo (2+2); %>)<br />
```

- 在处理之后，产生的HTML是：

```php+HTML
<p>This number (4)  <br/>
and this number (4) <br/>
are the same.</p>
```


