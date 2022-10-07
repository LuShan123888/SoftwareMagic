---
title: jQuery Dom操作
categories:
- Software
- FrontEnd
- jQuery
---
# jQuery Dom操作

- jQuery也提供了对HTML节点的操作,而且在原生js的基础之上进行了优化,使用起来更加方便,注意:以下的操作方式只适用于jQuery对象

## 操作元素的属性

### 获取属性

| 方法           | 说明                                                         | 举例                        |
| -------------- | ------------------------------------------------------------ | --------------------------- |
| attr(属性名称) | 获取指定的属性值 | attr('checked')<br>attr('name') |
| prop(属性名称) | 获取具有true和false两个属性的属性值                          | prop('checked')             |

**实例**

```html
<form action="" id="myform">
    <input type="checkbox" name="ch" checked="checked"/> aa
    <input type="checkbox" name="ch"/> bb
</form>
<script type="text/javascript">
    var ch = $("input[type='checkbox']")
    console.log(ch)
    ch.each(function (index, element) {
        console.log(index + "-" + $(element) + "=" + this)
        console.log($(element).attr('checked') + "==" + $(element).prop('checked'))
        console.log('--------------')
    })
</script>
```

### 设置属性

| 方法                         | 说明                        | 举例                                            |
| ---------------------------- | --------------------------- | ----------------------------------------------- |
| attractive(属性名称,属性值) | 设置指定的属性值            | at tr('checked','checked')<br>attr('name','zs') |
| prop(属性名称,属性值)       | 设置具有true和false的属性值 | prop('checked','true')                          |

**注意**

- 操作checkbox时,选中属性值为checked,没有选中属性值为undefined

```html
<a href="http://www.baidu.com" id="a1">百度</a>
<input type="checkbox" name="all" checked="checked"/>全选
<script type="text/javascript">
    // 设置属性值
    $('#a1').attr('href', 'https://jquery.com');
    $(":checkbox").prop("checked", false);
</script>
```

### 移除属性

| 方法               | 说明           | 举例                  |
| ------------------ | -------------- | --------------------- |
| removeAttr(属性名) | 移除指定的属性 | removeAttr('checked') |

```html
<a href="http://www.sina.com" id="a2">新浪</a>
<script type="text/javascript">
    // 移除属性
    $('#a2').removeAttr('href');
</script>
```

## 操作元素的样式

- 对于元素的样式,也是一种属性,由于样式使用更加频繁,所以对于样式除了当做属性处理外还可以有专门的方法进行处理

| 方法                    | 说明                          |
| ----------------------- | ----------------------------- |
| attr('class')           | 获取class属性的值,即样式名称 |
| attr('class','样式名'') | 修改class属性的值,修改样式   |
| addClass('样式名')      | 添加样式名称                  |
| removeClass('class')    | 移除样式名称                  |
| css()                   | 添加具体的样式                |

### css()

- 一次添加单个样式

```css
css("样式名”,”样式值”)

$('#remove').css('color','red');
```

- 一次添加多个样式

```css
css({‘样式名’:’样式值’,’样式名2’:’样式值2’})

$('#conRed').css({"background-color":"red","color":"#fff"});
```

### 操作样式class

```html
<style type="text/css">
    div {
        padding: 8px;
        width: 180px;
    }

    .blue {
        background: blue;
    }

    .larger {
        font-size: 30px;
    }

    .green {
        background: green;
    }
</style>
<body>
<div id="conBlue" class="blue larger">天蓝色</div>
<div id="remove" class="blue larger">天蓝色</div>
</body>
<script type="text/javascript">
    // 获取样式名称
    console.log($("#remove").attr("class"));
    // 修改样式,那么id为remove的元素样式class只有green
    $('#remove').attr("class","green")
    // 添加样式名称,class名称 同时添加两个类
    $('#conBlue').addClass("blue larger");
    // 移除样式
    $("#remove").removeClass("blue larger");
</script>
```

## 操作元素的内容

| 方法             | 说明                           |
| ---------------- | ------------------------------ |
| html()           | 获取元素的html内容             |
| html('html内容') | 设定元素的html内容             |
| text()           | 获取元素的文本内容,不包含html |
| text('text内容') | 设置文本的文本内容,不包含html |
| val()            | 获取元素value值                |
| val('值')        | 指定元素的value值              |

```html
<script src="jquery-3.4.1.js" type="text/javascript"></script>
<body>
    <h3><span>html()和text()方法设置元素内容</span></h3>
    <div id="html"></div>
    <div id="text"></div>
    <input type="text" name="uname" value="oop"/>
</body>
<script type="text/javascript">
    // 获取HTML内容,包括HTML标签
    console.log($('h3').html());
    // 获取文本内容,不包括HTML标签
    console.log($('h3').text());
    // 获取value值
    console.log($('[name=uname]').val());
    // 设置
    $('#html').html("<p>使用html设置,看不到标签</p>");
    $('#text').text("<p>使用text设置,能看到标签</p>");
    $('[name=uname]').val("input");
</script>
```

## 创建元素

- > > 在jQuery中创建元素很简单,直接使用核心函数即可

```js
$('元素内容');

$('<p>this is a paragraph!!!</p>');
```

## 添加元素

| 方法                           | 说明                                                         |
| ------------------------------ | ------------------------------------------------------------ |
| prepend(content)               | 在被选元素内部的开头插入元素或内容,被追加的 content 参数,可以是字符, HTML 元素标记, |
| $(content).prependTo(selector) | 把 content 元素或内容加入 selector 元素开头                  |
| append(content)                | 在被选元素内部的结尾插入元素或内容,被追加的 content 参数,可以是字符,HTML 元素标记, |
| $(content).appendTo(selector)  | 把 content元素或内容插入selector 元素内,默认是在尾部        |
| before()                       | 在元素前插入指定的元素或内容:`$(selector).before(content)`   |
| after()                        | 在元素后插入指定的元素或内容:`$(selector).after(content)`    |

### 父级元素内添加

```html
<script type="text/javascript">
    var str = "<span id='mydiv' style='padding: 8px;width: 180px;background-color:#ADFF2F;'>动态创建span</span>";
    // 1,使用prepend前加内容
    $("body").prepend(str);
    // 2,使用prependTo前加内容
    $("<b>开头</b>").prependTo('body');
    // 3,使用append后加内容
    $("body").append(str);
    // 当把已存在的元素添加到另一处的时候相当于移动
    $("div").append($('.red'));
    // 4,使用appendTo后追加内容
    $(str).appendTo('body');
    $('.blue').appendTo("div");
</script>
```

### 同级元素添加

```html
<script type="text/javascript">
    var str1 = "<span class='red'>str1</span>";
    var str2 = "<span class='blue'>str2</span>";
    // 前置元素
    $(".green").before(str1);
    // 后存元素
    $(".green").after(str2);
</script>
```

## 删除元素

| 方法     | 说明                                                |
| -------- | --------------------------------------------------- |
| remove() | 删除所选元素或指定的子元素,包括整个标签和内容一起删 |
| empty()  | 清空所选元素的内容                                  |

```html
<script type="text/javascript">
    // 删除所选元素 或指定的子元素
    $("span").remove();
    // 删除class为blue的span
    $("span.blue").remove();
    // 清空元素
    $("span").empty();
    $(".green").empty();
</script>>
```

## 遍历元素

```js
$(selector).each(function(index,element))
```

- 参数 function 为遍历时的回调函数
- index 为遍历元素的序列号,从 0 开始
- element是当前的元素,此时是dom元素

```html
<body>
    <h3>遍历元素 each()</h3>
    <span class="green">jquery</span>
    <span class="green">javase</span>
    <span class="green">http协议</span>
    <span class="green">servlet</span>
</body>
<script type="text/javascript">
    $('span').each(function (idx , e) {
        console.log(idx + " ---> " + $(e).text());
    })
</script>
```

