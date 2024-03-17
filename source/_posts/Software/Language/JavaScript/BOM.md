---
title: JavaScript BOM
categories:
- Software
- Language
- JavaScript
---
# JavaScript BOM

- 浏览器对象模型(**B**rowser **O**bject **M**odel (BOM))尚无正式标准
- 由于现代浏览器已经（几乎）实现了 JavaScript 交互性方面的相同方法和属性，因此常被认为是 BOM 的方法和属性

## Window 对象

- 所有浏览器都支持 window 对象，它表示浏览器窗口
- 所有 JavaScript 全局对象，函数以及变量均自动成为 window 对象的成员
- 全局变量是 window 对象的属性
- 全局函数是 window 对象的方法
- 甚至 HTML DOM 的 document 也是 window 对象的属性之一:

```js
window.document.getElementById("header");
```

- 与此相同:

```js
document.getElementById("header");
```

### Window 尺寸

- 有三种方法能够确定浏览器窗口的尺寸
- 对于Internet Explorer,Chrome,Firefox,Opera 以及 Safari:
    - window.innerHeight - 浏览器窗口的内部高度（包括滚动条)
    - window.innerWidth - 浏览器窗口的内部宽度（包括滚动条)
- 对于 Internet Explorer 8,7,6,5:
    - document.documentElement.clientHeight
    - document.documentElement.clientWidth
- 或者
    - document.body.clientHeight
    - document.body.clientWidth

- 实用的 JavaScript 方案（涵盖所有浏览器):

```js
var w=window.innerWidth
|| document.documentElement.clientWidth
|| document.body.clientWidth;

var h=window.innerHeight
|| document.documentElement.clientHeight
|| document.body.clientHeight;
```

- 该例显示浏览器窗口的高度和宽度

### 其他 Window 方法

- 一些其他方法:
    - `window.open()` :打开新窗口
    - `window.close()` :关闭当前窗口
    - `window.moveTo()` :移动当前窗口
    - `window.resizeTo()` :调整当前窗口的尺寸

## Window Screen

- **window.screen**对象在编写时可以不使用 window 这个前缀
- 一些属性:
    - `screen.availWidth` - 可用的屏幕宽度
    - `screen.availHeight` - 可用的屏幕高度

### Window Screen 可用宽度

- `screen.availWidth` 属性返回访问者屏幕的宽度，以像素计，减去界面特性，比如窗口任务栏
- 返回您的屏幕的可用宽度:

```js
<script>
	document.write("可用宽度: " + screen.availWidth);
</script>
```

- 以上代码输出为:

```js
可用宽度: 1440
```

### Window Screen 可用高度

- `screen.availHeight` 属性返回访问者屏幕的高度，以像素计，减去界面特性，比如窗口任务栏
- 返回您的屏幕的可用高度:

```js
<script>
	document.write("可用高度: " + screen.availHeight);
</script>
```

- 以上代码将输出:

```js
可用高度: 810
```

## Window Location

- **window.location** 对象在编写时可不使用 window 这个前缀
- 一些例子:
    - `location.hostname` 返回 web 主机的域名
    - `location.pathname` 返回当前页面的路径和文件名
    - `location.port` 返回 web 主机的端口 (80 或 443)
    - `location.protocol` 返回所使用的 web 协议(http: 或 https:)

### Window Location Href

- `location.href` 属性返回当前页面的 URL
- 返回（当前页面的）整个 URL:

```html
<script>  document.write(location.href);  </script>
```

- 以上代码输出为:

```
https://www.runoob.com/js/js-window-location.html
```

### Window Location Pathname

- `location.pathname` 属性返回 URL 的路径名
- 返回当前 URL 的路径名:

```html
<script>  document.write(location.pathname);  </script>
```

- 以上代码输出为:

```
/js/js-window-location.html
```

### Window Location Assign

- `location.assign()` 方法加载新的文档
- 加载一个新的文档:

```html
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>test</title>
</head>
<head>
<script>
function newDoc(){
    window.location.assign("https://www.baidu.com")
}
</script>
</head>
<body>

<input type="button" value="加载新文档" onclick="newDoc()">

</body>
</html>
```

## Window History

- **window.history**对象在编写时可不使用 window 这个前缀
- 为了保护用户隐私，对 JavaScript 访问该对象的方法做出了限制
- 一些方法:
    - `history.back()` - 与在浏览器点击后退按钮相同
    - `history.forward()` - 与在浏览器中点击向前按钮相同

### Window history.back()

- `history.back()` 方法加载历史列表中的前一个 URL
- 这与在浏览器中点击后退按钮是相同的
- 在页面上创建后退按钮:

```html
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<head>
<script>
function goBack()
{
    window.history.back()
}
</script>
</head>
<body>

<input type="button" value="Back" onclick="goBack()">

</body>
</html>
```

### Window history.forward()

- `history forward()` 方法加载历史列表中的下一个 URL
- 这与在浏览器中点击前进按钮是相同的
- 在页面上创建一个向前的按钮:

```html
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<script>
function goForward()
{
    window.history.forward()
}
</script>
</head>
<body>

<input type="button" value="Forward" onclick="goForward()">

</body>
</html>
```

## Window Navigator

- **window.navigator** 对象包含有关访问者浏览器的信息
- **window.navigator** 对象在编写时可不使用 window 这个前缀

```html
<div id="example"></div>
<script>
txt = "<p>浏览器代号: " + navigator.appCodeName + "</p>";
txt+= "<p>浏览器名称: " + navigator.appName + "</p>";
txt+= "<p>浏览器版本: " + navigator.appVersion + "</p>";
txt+= "<p>启用Cookies: " + navigator.cookieEnabled + "</p>";
txt+= "<p>硬件平台: " + navigator.platform + "</p>";
txt+= "<p>用户代理: " + navigator.userAgent + "</p>";
txt+= "<p>用户代理语言: " + navigator.systemLanguage + "</p>";
document.getElementById("example").innerHTML=txt;
</script>
```

- 来自 navigator 对象的信息具有误导性，不应该被用于检测浏览器版本，这是因为:
    - navigator 数据可被浏览器使用者更改
    - 一些浏览器对测试站点会识别错误
    - 浏览器无法报告晚于浏览器发布的新操作系统

## 弹窗

- 可以在 JavaScript 中创建三种消息框：警告框，确认框，提示框
- 弹窗使用 反斜杠 + "n"(\n) 来设置换行

### 警告框

- 警告框经常用于确保用户可以得到某些信息
- 当警告框出现后，用户需要点击确定按钮才能继续进行操作

**语法**

```js
window.alert("*sometext*");
```

- **window.alert()** 方法可以不带上window对象，直接使用**alert()**方法

```html
<!DOCTYPE html>
<html>
<head>
<script>
function myFunction()
{
    alert("你好，我是一个警告框!");
}
</script>
</head>
<body>

<input type="button" onclick="myFunction()" value="显示警告框">

</body>
</html>
```

### 确认框

- 确认框通常用于验证是否接受用户操作
- 当确认卡弹出时，用户可以点击 "确认" 或者 "取消" 来确定用户操作
- 当你点击 "确认", 确认框返回 true, 如果点击 "取消", 确认框返回 false

**语法**

```js
window.confirm("sometext");
```

- **window.confirm()** 方法可以不带上window对象，直接使用**confirm()**方法

```js
var r=confirm("按下按钮");
if (r==true)
{
    x="你按下了\"确定\"按钮!";
}
else
{
    x="你按下了\"取消\"按钮!";
}
```

### 提示框

- 提示框经常用于提示用户在进入页面前输入某个值
- 当提示框出现后，用户需要输入某个值，然后点击确认或取消按钮才能继续操纵
- 如果用户点击确认，那么返回值为输入的值，如果用户点击取消，那么返回值为 null

**语法**

```js
window.prompt("sometext","defaultvalue");
```

- **window.prompt()** 方法可以不带上window对象，直接使用**prompt()**方法
