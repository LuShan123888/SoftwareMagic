---
title: JSON
categories:
- Software
- Concept
---
# JSON

- JSON 是用于存储和传输数据的格式
- JSON 通常用于服务端向网页传递数据

## JSON 语法规则

- 数据为键值对
- 数据由逗号分隔
- 大括号保存对象
- 方括号保存数组

## JSON 数据

- JSON 数据格式为 键/值 对,就像 JavaScript 对象属性
- 键/值对包括字段名称(在双引号中),后面一个冒号,然后是值:

```js
"name":"test"
```

## JSON 对象

- JSON 对象保存在大括号内
- 就像在 JavaScript 中, 对象可以保存多个 键/值 对:

```js
{"name":"test", "url":"www.test.com"}
```

## JSON 数组

- JSON 数组保存在中括号内
- 就像在 JavaScript 中, 数组可以包含对象:

```js
"sites":[
    {"name":"test", "url":"www.test.com"},
    {"name":"Google", "url":"www.google.com"},
    {"name":"Taobao", "url":"www.taobao.com"}
]
```

- 在以上实例中,对象 "sites" 是一个数组,包含了三个对象
- 每个对象为站点的信息(网站名和网站地址)