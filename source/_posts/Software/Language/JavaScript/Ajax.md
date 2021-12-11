---
title: JavaScript AJAX
categories:
- Software
- Language
- JavaScript
---
# JavaScript AJAX

- AJAX = 异步 JavaScript 和 XML
- AJAX 是一种用于创建快速动态网页的技术
- 通过在后台与服务器进行少量数据交换,AJAX 可以使网页实现异步更新,这意味着可以在不重新加载整个网页的情况下,对网页的某部分进行更新
- 传统的网页(不使用 AJAX)如果需要更新内容,必需重载整个网页面

## AJAX 工作原理

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-ajax-yl.png)

## XMLHttpRequest 对象

- XMLHttpRequest 是 AJAX 的基础

### XMLHttpRequest 对象

- 所有现代浏览器均支持 XMLHttpRequest 对象(IE5 和 IE6 使用 ActiveXObject)
- XMLHttpRequest 用于在后台与服务器交换数据,这意味着可以在不重新加载整个网页的情况下,对网页的某部分进行更新

### 创建 XMLHttpRequest 对象

- 所有现代浏览器(IE7+,Firefox,Chrome,Safari 以及 Opera)均内建 XMLHttpRequest 对象
- 创建 XMLHttpRequest 对象的语法:

```js
variable=new XMLHttpRequest();
```

- 老版本的 Internet Explorer (IE5 和 IE6)使用 ActiveX 对象:

```js
variable=new ActiveXObject("Microsoft.XMLHTTP");
```

- 为了应对所有的现代浏览器,包括 IE5 和 IE6,请检查浏览器是否支持 XMLHttpRequest 对象,如果支持,则创建 XMLHttpRequest 对象,如果不支持,则创建 ActiveXObject :

```js
var xmlhttp;
if (window.XMLHttpRequest)
{
    //  IE7+, Firefox, Chrome, Opera, Safari 浏览器执行代码
    xmlhttp=new XMLHttpRequest();
}
else
{
    // IE6, IE5 浏览器执行代码
    xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
}
```

## XHR请求

- 如需将请求发送到服务器,我们使用 XMLHttpRequest 对象的 open() 和 send() 方法:
- open() 方法的 *url* 参数是服务器上文件的地址:该文件可以是任何类型的文件,比如 .txt 和 .xml,或者服务器脚本文件,比如 .asp 和 .php (在传回响应之前,能够在服务器上执行任务)
- XMLHttpRequest 对象如果要用于 AJAX 的话,其 open() 方法的 async 参数必须设置为 true

```js
xmlhttp.open("GET","ajax_info.txt",true);
xmlhttp.send();
```

| 方法                         | 描述                                                         |
| :--------------------------- | :----------------------------------------------------------- |
| open(*method*,*url*,*async*) | 规定请求的类型,URL 以及是否异步处理请求,*method*:请求的类型;GET 或 POST*url*:文件在服务器上的位置*async*:true(异步)或 false(同步) |
| send(*string*)               | 将请求发送到服务器,*string*:仅用于 POST 请求               |

### GET请求

- 一个简单的 GET 请求:

```js
xmlhttp.open("GET","/try/ajax/demo_get2.php?fname=Henry&lname=Ford",true);
xmlhttp.send();
```

### POST 请求

- 一个简单 POST 请求:

```js
xmlhttp.open("POST","/try/ajax/demo_post.php",true);
xmlhttp.send();
```

- 如果需要像 HTML 表单那样 POST 数据,请使用 setRequestHeader() 来添加 HTTP 头,然后在 send() 方法中规定您希望发送的数据:

```js
xmlhttp.open("POST","/try/ajax/demo_post2.php",true);
xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
xmlhttp.send("fname=Henry&lname=Ford");
```

| 方法                             | 描述                                                         |
| :------------------------------- | :----------------------------------------------------------- |
| setRequestHeader(*header,value*) | 向请求添加 HTTP 头,*header*: 规定头的名称*value*: 规定头的值 |

## XHR响应

- 如需获得来自服务器的响应,请使用 XMLHttpRequest 对象的 responseText 或 responseXML 属性

| 属性         | 描述                       |
| :----------- | :------------------------- |
| responseText | 获得字符串形式的响应数据, |
| responseXML  | 获得 XML 形式的响应数据,  |

### responseText 属性

- 如果来自服务器的响应并非 XML,请使用 responseText 属性
- responseText 属性返回字符串形式的响应,因此您可以这样使用:

```js
document.getElementById("myDiv").innerHTML=xmlhttp.responseText;
```

### responseXML 属性

- 如果来自服务器的响应是 XML,而且需要作为 XML 对象进行解析,请使用 responseXML 属性:

```js
xmlDoc=xmlhttp.responseXML;
txt="";
x=xmlDoc.getElementsByTagName("ARTIST");
for (i=0;i<x.length;i++)
{
    txt=txt + x[i].childNodes[0].nodeValue + "<br>";
}
document.getElementById("myDiv").innerHTML=txt;
```

## readystate

### onreadystatechange 事件

- 当请求被发送到服务器时,我们需要执行一些基于响应的任务
- 当 readyState 改变时,就会触发 onreadystatechange 事件
- readyState 属性存有 XMLHttpRequest 的状态信息
- 下面是 XMLHttpRequest 对象的三个重要的属性:

| 属性               | 描述                                                         |
| :----------------- | :----------------------------------------------------------- |
| onreadystatechange | 存储函数(或函数名),每当 readyState 属性改变时,就会调用该函数, |
| readyState         | 存有 XMLHttpRequest 的状态,从 0 到 4 发生变化,0: 请求未初始化1: 服务器连接已建立2: 请求已接收3: 请求处理中4: 请求已完成,且响应已就绪 |
| status             | 200: "OK" 404: 未找到页面                                    |

- 在 onreadystatechange 事件中,我们规定当服务器响应已做好被处理的准备时所执行的任务
- 当 readyState 等于 4 且状态为 200 时,表示响应已就绪:

```js
xmlhttp.onreadystatechange=function()
{
    if (xmlhttp.readyState==4 && xmlhttp.status==200)
    {
        document.getElementById("myDiv").innerHTML=xmlhttp.responseText;
    }
}
```

- **注意**:onreadystatechange 事件被触发 4 次(0 - 4), 分别是: 0-1,1-2,2-3,3-4,对应着 readyState 的每个变化

## 使用回调函数

- 回调函数是一种以参数形式传递给另一个函数的函数
- 如果您的网站上存在多个 AJAX 任务,那么您应该为创建 XMLHttpRequest 对象编写一个*标准*的函数,并为每个 AJAX 任务调用该函数
- 该函数调用应该包含 URL 以及发生 `onreadystatechange` 事件时执行的任务(每次调用可能不尽相同):

```js
function myFunction()
{
    loadXMLDoc("/try/ajax/ajax_info.txt",function()
    {
        if (xmlhttp.readyState==4 && xmlhttp.status==200)
        {
            document.getElementById("myDiv").innerHTML=xmlhttp.responseText;
        }
    });
}
```

