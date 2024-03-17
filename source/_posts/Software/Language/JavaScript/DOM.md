---
title: JavaScript DOM
categories:
- Software
- Language
- JavaScript
---
# JavaScript DOM

- 通过 HTML DOM，可访问 JavaScript HTML 文档的所有元素。

## 查找 HTML 元素

- 通常，通过 JavaScript，您需要操作 HTML 元素。
- 为了做到这件事情，您必须首先找到该元素，有三种方法来做这件事：
    - 通过 id 找到 HTML 元素。
    - 通过标签名找到 HTML 元素。
    - 通过类名找到 HTML 元素。

### 通过 id 查找 HTML 元素

- 在 DOM 中查找 HTML 元素的最简单的方法，是通过使用元素的 id
- 本例查找 id="intro" 元素：

```js
var x=document.getElementById("intro");
```

- 如果找到该元素，则该方法将以对象（在 x 中）的形式返回该元素。
- 如果未找到该元素，则 x 将包含 null

### 通过标签名查找 HTML 元素

- 本例查找 id="main" 的元素，然后查找 id="main" 元素中的所有 `<p>` 元素：

```js
var x=document.getElementById("main");
var y=x.getElementsByTagName("p");
```

### 通过类名找到 HTML 元素

- 本例通过 [getElementsByClassName](https://www.runoob.com/jsref/met-document-getelementsbyclassname.html）函数来查找 class="intro" 的元素：

```js
var x=document.getElementsByClassName("intro");
```

## 改变HTML元素

- HTML DOM 允许 JavaScript 改变 HTML 元素的内容。

### 改变 HTML 输出流

- JavaScript 能够创建动态的 HTML 内容：
- 在 JavaScript 中，`document.write() `可用于直接向 HTML 输出流写内容。

```html
<!DOCTYPE html>
<html>
<body>

<script>
document.write(Date());
</script>

</body>
</html>
```

- 绝对不要在文档（DOM）加载完成之后使用 `document.write()`，这会覆盖该文档。

### 改变 HTML 内容

- 修改 HTML 内容的最简单的方法是使用 `innerHTML` 属性。
- 如需改变 HTML 元素的内容，请使用这个语法：

```js
document.getElementById(*id*).innerHTML=*新的 HTML*
```

- 本例改变了 `<p>`元素的内容：

```html
<html>
<body>

<p id="p1">Hello World!</p>

<script>
document.getElementById("p1").innerHTML="新文本!";
</script>

</body>
</html>
```

- 本例改变了 `<h1>` 元素的内容：

```html
<!DOCTYPE html>
<html>
<body>

<h1 id="header">Old Header</h1>

<script>
var element=document.getElementById("header");
element.innerHTML="新标题";
</script>

</body>
</html>
```

### 改变 HTML 属性

- 如需改变 HTML 元素的属性，请使用这个语法：

```js
document.getElementById(*id*).*attribute=新属性值*
```

- 本例改变了 `<img>` 元素的 src 属性：

```html
<!DOCTYPE html>
<html>
<body>

<img id="image" src="smiley.gif">

<script>
document.getElementById("image").src="landscape.jpg";
</script>

</body>
</html>
```

### 改变 HTML 样式

- 如需改变 HTML 元素的样式，请使用这个语法：

```js
document.getElementById(*id*).style.*property*=*新样式*
```

- 下面的例子会改变 `<p>` 元素的样式：

```html
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>test</title>
</head>
<body>

<p id="p1">Hello World!</p>
<p id="p2">Hello World!</p>
<script>
document.getElementById("p2").style.color="blue";
document.getElementById("p2").style.fontFamily="Arial";
document.getElementById("p2").style.fontSize="larger";
</script>
<p>以上段落通过脚本修改，</p>

</body>
</html>
```

## 分配事件

- HTML DOM 允许您使用 JavaScript 来向 HTML 元素分配事件：

**实例**

- 向 button 元素分配 `onclick` 事件：

```js
<script> document.getElementById("myBtn").onclick=function(){displayDate()}; </script>
```

- 在上面的例子中，名为 `displayDate` 的函数被分配给 `id="myBtn"` 的 HTML 元素。
- 按钮点击时Javascript函数将会被执行。

## EventListener

### addEventListener(）方法

**语法**

```
 element.addEventListener(event, function, useCapture);
```

- 第一个参数是事件的类型（如 "click" 或 "mousedown")
- 第二个参数是事件触发后调用的函数。
- 第三个参数是个布尔值用于描述事件是冒泡还是捕获，该参数是可选的。
- **注意**：不要使用 "on" 前缀，例如，使用 "click" ，而不是使用 "onclick"

**实例**

- 在用户点击按钮时触发监听事件：

```js
document.getElementById("myBtn").addEventListener("click", displayDate);
```

- `addEventListener()` 方法用于向指定元素添加事件句柄。
- `addEventListener()` 方法添加的事件句柄不会覆盖已存在的事件句柄。
- 你可以向一个元素添加多个事件句柄。
- 你可以向同个元素添加多个同类型的事件句柄，如：两个 "click" 事件。
- 你可以向任何 DOM 对象添加事件监听，不仅仅是 HTML 元素，如： window 对象。
- `addEventListener()` 方法可以更简单的控制事件（冒泡与捕获）
- 当你使用 `addEventListener()` 方法时， JavaScript 从 HTML 标记中分离开来，可读性更强，在没有控制HTML标记时也可以添加事件监听。
- 你可以使用 `removeEventListener()` 方法来移除事件的监听。

### 向原元素添加事件句柄

- 当用户点击元素时弹出 "Hello World!" :

```js
element.addEventListener("click", function(){ alert("Hello World!"); });
```

- 你可以使用函数名，来引用外部函数：
- 当用户点击元素时弹出 "Hello World!" :

```js
element.addEventListener("click", myFunction);

function myFunction() {
    alert ("Hello World!");
}
```

### 向同一个元素中添加多个事件句柄

- `addEventListener()` 方法允许向同一个元素添加多个事件，且不会覆盖已存在的事件：

```js
element.addEventListener("click", myFunction);
element.addEventListener("click", mySecondFunction);
```

- 你可以向同个元素添加不同类型的事件：

```js
element.addEventListener("mouseover", myFunction);
element.addEventListener("click", mySecondFunction);
element.addEventListener("mouseout", myThirdFunction);
```

### 向 Window 对象添加事件句柄

- `addEventListener()` 方法允许你在 HTML DOM 对象添加事件监听， HTML DOM 对象如： HTML 元素， HTML 文档， window 对象，或者其他支出的事件对象如： `xmlHttpRequest` 对象。

**实例**

- 当用户重置窗口大小时添加事件监听：

```js
window.addEventListener("resize", function(){
    document.getElementById("demo").innerHTML = sometext;
});
```

### 传递参数

- 当传递参数值时，使用"匿名函数"调用带参数的函数：

```js
element.addEventListener("click", function(){ myFunction(p1, p2); });
```

### 事件冒泡和事件捕获

- 事件传递有两种方式：冒泡与捕获。
- 事件传递定义了元素事件触发的顺序，如果你将 `<p>` 元素插入到 `<div>` 元素中，用户点击 `<p>` 元素，哪个元素的 "click" 事件先被触发呢?
- 在 **冒泡** 中，内部元素的事件会先被触发，然后再触发外部元素，即： `<p>` 元素的点击事件先触发，然后会触发 `<div>` 元素的点击事件。
- 在 **捕获** 中，外部元素的事件会先被触发，然后才会触发内部元素的事件，即： `<div>` 元素的点击事件先触发，然后再触发 `<p>` 元素的点击事件。
- `addEventListener()` 方法可以指定 "useCapture" 参数来设置传递类型：

```js
addEventListener(event, function, useCapture);
```

默认值为 false，即冒泡传递，当值为 true 时，事件使用捕获传递。

```js
document.getElementById("myDiv").addEventListener("click", myFunction, true);
```

### removeEventListener(）方法

- `removeEventListener()` 方法移除由 `addEventListener()` 方法添加的事件句柄：

```js
element.removeEventListener("mousemove", myFunction);
```

## 创建新的 HTML 元素

### appendChild()

- 要创建新的 HTML 元素（节点）需要先创建一个元素，然后在已存在的元素中添加它。

```html
<div id="div1">
<p id="p1">这是一个段落，</p>
<p id="p2">这是另外一个段落，</p>
</div>

<script>
var para = document.createElement("p");
var node = document.createTextNode("这是一个新的段落，");
para.appendChild(node);

var element = document.getElementById("div1");
element.appendChild(para);
</script>
```

**实例**

- 以下代码是用于创建 `<p>` 元素：

```js
var para = document.createElement("p");
```

- 为 `<p>` 元素创建一个新的文本节点：

```js
var node = document.createTextNode("这是一个新的段落，");
```

- 将文本节点添加到 `<p>` 元素中：

```js
para.appendChild(node);
```

- 最后，在一个已存在的元素中添加 p 元素。
- 查找已存在的元素：

```js
var element = document.getElementById("div1");
```

- 添加到已存在的元素中：

```js
element.appendChild(para);
```

### insertBefore()

- 以上的实例我们使用了 **appendChild()** 方法，它用于添加新元素到尾部。
- 如果我们需要将新元素添加到开始位置，可以使用 **insertBefore()** 方法：

```html
<div id="div1">
<p id="p1">这是一个段落，</p>
<p id="p2">这是另外一个段落，</p>
</div>

<script>
var para = document.createElement("p");
var node = document.createTextNode("这是一个新的段落，");
para.appendChild(node);

var element = document.getElementById("div1");
var child = document.getElementById("p1");
element.insertBefore(para, child);
</script>
```

## 移除已存在的HTML元素

- 要移除一个元素，你需要知道该元素的父元素。

```html
<div id="div1">
<p id="p1">这是一个段落，</p>
<p id="p2">这是另外一个段落，</p>
</div>

<script>
var parent = document.getElementById("div1");
var child = document.getElementById("p1");
parent.removeChild(child);
</script>
```

**实例**

- HTML 文档中 `<div>` 元素包含两个子节点（两个 `<p>` 元素）:

```html
<div id="div1">
<p id="p1">这是一个段落，</p>
<p id="p2">这是另外一个段落，</p>
</div>
```

- 查找 id="div1" 的元素：

```js
var parent = document.getElementById("div1");
```

- 查找 id="p1" 的 `<p>` 元素：

```js
var child = document.getElementById("p1");
```

- 从父元素中移除子节点：

```js
parent.removeChild(child);
```

- 如果能够在不引用父元素的情况下删除某个元素，就太好了，不过很遗憾，DOM 需要清楚您需要删除的元素，以及它的父元素。
- 以下代码是已知要查找的子元素，然后查找其父元素，再删除这个子元素（删除节点必须知道父节点）:

```js
var child = document.getElementById("p1");
child.parentNode.removeChild(child);
```

## 替换 HTML 元素

- 我们可以使用 `replaceChild()` 方法来替换 HTML DOM 中的元素。

```html
<div id="div1">
<p id="p1">这是一个段落，</p>
<p id="p2">这是另外一个段落，</p>
</div>

<script>
var para = document.createElement("p");
var node = document.createTextNode("这是一个新的段落，");
para.appendChild(node);

var parent = document.getElementById("div1");
var child = document.getElementById("p1");
parent.replaceChild(para, child);
</script>
```

## Collection 对象

- `getElementsByTagName()` 方法返回 [HTMLCollection](https://www.runoob.com/jsref/dom-htmlcollection.html）对象。
- HTMLCollection 对象类似包含 HTML 元素的一个数组。
- 以下代码获取文档所有的 `<p>` 元素：

```js
var x = document.getElementsByTagName("p");
```

- 集合中的元素可以通过索引（以 0 为起始位置）来访问。
- 访问第二个 `<p>` 元素可以是以下代码：

```js
y = x[1];
```

###  length 属性

- HTMLCollection 对象的 length 属性定义了集合中元素的数量。

```js
var myCollection = document.getElementsByTagName("p");
document.getElementById("demo").innerHTML = myCollection.length;
```

- 集合 length 属性常用于遍历集合中的元素。
- 修改所有 `<p>` 元素的背景颜色：

```js
var myCollection = document.getElementsByTagName("p");
var i;
for (i = 0; i < myCollection.length; i++) {
    myCollection[i].style.backgroundColor = "red";
}
```

**注意**

- **HTMLCollection 不是一个数组!**
- HTMLCollection 看起来可能是一个数组，但其实不是。
- 你可以像数组一样，使用索引来获取元素。
- HTMLCollection 无法使用数组的方法： `valueOf()`, `pop()`, `push()`，或 `join()`

## NodeList 对象

- **NodeList** 对象是一个从文档中获取的节点列表（集合）
- NodeList 对象类似 [HTMLCollection](https://www.runoob.com/js/js-htmldom-elements.html）对象。
- 一些旧版本浏览器中的方法（如`getElementsByClassName()`）返回的是 NodeList 对象，而不是 HTMLCollection 对象。
- 所有浏览器的`childNodes`属性返回的是 NodeList 对象。
- 大部分浏览器的 `querySelectorAll()`返回 NodeList 对象。
- 下代码选取了文档中所有的 `<p>` 节点：

```js
var myNodeList = document.querySelectorAll("p");
```

- NodeList 中的元素可以通过索引（以 0 为起始位置）来访问。
- 访问第二个 `<p>` 元素可以是以下代码：

```js
y = myNodeList[1];
```

### length 属性

- NodeList 对象 length 属性定义了节点列表中元素的数量。

```js
var myNodelist = document.querySelectorAll("p");
document.getElementById("demo").innerHTML = myNodelist.length;
```

- length 属性常用于遍历节点列表。
- 修改节点列表中所有 `<p>` 元素的背景颜色：

```js
var myNodelist = document.querySelectorAll("p");
var i;
for (i = 0; i < myNodelist.length; i++) {
    myNodelist[i].style.backgroundColor = "red";
}
```

**注意**

- **节点列表不是一个数组**
- 节点列表看起来可能是一个数组，但其实不是。
- 你可以像数组一样，使用索引来获取元素。
- 节点列表无法使用数组的方法： `valueOf()`, `pop()`, `push()`，或 `join()`

## HTMLCollection 与 NodeList 的区别

- [HTMLCollection](https://www.runoob.com/js/js-htmldom-collections.html）是 HTML 元素的集合。
- NodeList 是一个文档节点的集合。
- NodeList 与 HTMLCollection 有很多类似的地方。
- NodeList 与 HTMLCollection 都与数组对象有点类似，可以使用索引（0, 1, 2, 3, 4, ...）来获取元素。
- NodeList 与 HTMLCollection 都有 length 属性。
- HTMLCollection 元素可以通过 name,id 或索引来获取。
- NodeList 只能通过索引来获取。
- 只有 NodeList 对象有包含属性节点和文本节点。