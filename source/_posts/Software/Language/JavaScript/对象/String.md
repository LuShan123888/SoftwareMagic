---
title: JavaScript String对象
categories:
- Software
- Language
- JavaScript
- 对象
---
# JavaScript String对象

- JavaScript 字符串用于存储和处理文本

## 创建String对象

- String 对象用于处理文本(字符串)
- String 对象创建方法: **new String()**

```js
var txt = new String("string");
```

- 或者更简单方式:

```js
var txt = "string";
```

## String特性

- 字符串可以存储一系列字符
- 字符串可以是插入到引号中的任何字符,你可以使用单引号或双引号:

```js
var carname = "Volvo XC60";
var carname = 'Volvo XC60';
```

- 你可以使用索引位置来访问字符串中的每个字符:

```js
var character = carname[7];
```

- 字符串的索引从 0 开始,这意味着第一个字符索引值为 [0],第二个为 [1], 以此类推
- 你可以在字符串中使用引号,字符串中的引号不要与字符串的引号相同:

```js
var answer = "It's alright";
var answer = "He is called 'Johnny'";
var answer = 'He is called "Johnny"';
```

##  转义字符

- 在 JavaScript 中,字符串写在单引号或双引号中
- 因为这样,以下实例 JavaScript 无法解析:

```js
 "We are the so-called "Vikings" from the north."
```

- 字符串 "We are the so-called " 被截断
- 如何解决以上的问题呢?可以使用反斜杠 `\` 来转义 "Vikings" 字符串中的双引号,如下:

```js
 "We are the so-called "Vikings" from the north."
```

- 反斜杠是一个转义字符, 转义字符将特殊字符转换为字符串字符:
- 转义字符`\`可以用于转义撇号,换行,引号,等其他特殊字符
- 下表中列举了在字符串中可以使用转义字符转义的特殊字符:

| 代码 | 输出        |
| :--- | :---------- |
| \'   | 单引号      |
| \"   | 双引号      |
| \\   | 反斜杠      |
| \n   | 换行        |
| \r   | 回车        |
| \t   | tab(制表符) |
| \b   | 退格符      |
| \f   | 换页符      |

## 模板字符串

- 通过反引号将字符串包围,可使用el表达式拼接变量

```js
person = {
    name : "Test",
    age : 20,
    sex : male
}

let string = `Hello, I am ${person.name} ,${person.age} years old, ,${person.sex} person`;
```

- 字符串的换行不用拼接`\n`,直接回车即可

## String 属性

### 字符串长度

- 可以使用内置属性 **length** 来计算字符串的长度:

```js
 var txt = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
 var sln = txt.length;
```

## String 方法

### 在字符串中查找字符串

- 字符串使用 `indexOf()` 来定位字符串中某一个指定的字符首次出现的位置:

```js
var str="Hello world, welcome to the universe.";
var n=str.indexOf("welcome");
```

- 如果没找到对应的字符函数返回-1
- 类似的,`lastIndexOf()` 方法在字符串末尾开始查找字符串出现的位置

### 内容匹配

- `match()`函数用来查找字符串中特定的字符,并且如果找到的话,则返回这个字符

```js
var str="Hello world!";
document.write(str.match("world") + "<br>");
document.write(str.match("World") + "<br>");
document.write(str.match("world!"));
```

### 替换内容

- `replace()` 方法在字符串中用某些字符替换另一些字符

```js
str="Please visit Microsoft!"
var n=str.replace("Microsoft","test");
```

### 字符串大小写转换

- 字符串大小写转换使用函数 `toUpperCase()` / `toLowerCase()`:

```js
var txt="Hello World!";       // String
var txt1=txt.toUpperCase();   // txt1 文本会转换为大写
var txt2=txt.toLowerCase();   // txt2 文本会转换为小写
```

### 字符串转为数组

- 字符串使用`split()`函数转为数组:

```js
txt="a,b,c,d,e"   // String
txt.split(",");   // 使用逗号分隔
txt.split(" ");   // 使用空格分隔
txt.split("|");   // 使用竖线分隔
```

## String 对象属性

| 属性        | 描述                       |
| :---------- | :------------------------- |
| constructor | 对创建该对象的函数的引用   |
| length      | 字符串的长度               |
| prototype   | 允许您向对象添加属性和方法 |

## String 对象方法

| 方法                | 描述                                                         |
| :------------------ | :----------------------------------------------------------- |
| charAt()            | 返回在指定位置的字符,                                        |
| charCodeAt()        | 返回在指定的位置的字符的 Unicode 编码,                       |
| concat()            | 连接两个或更多字符串,并返回新的字符串,                       |
| fromCharCode()      | 将 Unicode 编码转为字符,                                     |
| indexOf()           | 返回某个指定的字符串值在字符串中首次出现的位置,              |
| includes()          | 查找字符串中是否包含指定的子字符串,                          |
| lastIndexOf()       | 从后向前搜索字符串,并从起始位置(0)开始计算返回字符串最后出现的位置, |
| match()             | 查找找到一个或多个正则表达式的匹配,                          |
| repeat()            | 复制字符串指定次数,并将它们连接在一起返回,                   |
| replace()           | 在字符串中查找匹配的子串, 并替换与正则表达式匹配的子串,      |
| search()            | 查找与正则表达式相匹配的值,                                  |
| slice()             | 提取字符串的片断,并在新的字符串中返回被提取的部分,           |
| split()             | 把字符串分割为字符串数组,                                    |
| startsWith()        | 查看字符串是否以指定的子字符串开头,                          |
| substr()            | 从起始索引号提取字符串中指定数目的字符,                      |
| substring()         | 提取字符串中两个指定的索引号之间的字符,                      |
| toLowerCase()       | 把字符串转换为小写,                                          |
| toUpperCase()       | 把字符串转换为大写,                                          |
| trim()              | 去除字符串两边的空白                                         |
| toLocaleLowerCase() | 根据本地主机的语言环境把字符串转换为小写,                    |
| toLocaleUpperCase() | 根据本地主机的语言环境把字符串转换为大写,                    |
| valueOf()           | 返回某个字符串对象的原始值,                                  |
| toString()          | 返回一个字符串,                                              |

## String HTML 包装方法

- HTML 返回包含在相对应的 HTML 标签中的内容
- 下方法并非标准方法,所以可能在某些浏览器下不支持

| 方法                                                         | 描述                         |
| :----------------------------------------------------------- | :--------------------------- |
| anchor()   | 创建 HTML 锚,               |
| big()         | 用大号字体显示字符串,       |
| blink()     | 显示闪动字符串,             |
| bold()       | 使用粗体显示字符串,         |
| fixed()     | 以打字机文本显示字符串,     |
| fontcolor() | 使用指定的颜色来显示字符串, |
| fontsize() | 使用指定的尺寸来显示字符串, |
| italics() | 使用斜体显示字符串,         |
| link()       | 将字符串显示为链接,         |
| small()     | 使用小字号来显示字符串,     |
| strike()   | 用于显示加删除线的字符串,   |
| sub()         | 把字符串显示为下标,         |
| sup()         | 把字符串显示为上标,         |