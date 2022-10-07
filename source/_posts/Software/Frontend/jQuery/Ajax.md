---
title: jQuery Ajax
categories:
- Software
- FrontEnd
- jQuery
---
# jQuery Ajax

## $.ajax

- jQuery 调用 ajax 方法:

### 格式:

```js
$.ajax({
    /*参数*/
});
```

### 参数:

- `type`:请求方式 GET/POST
- `url`:请求地址 url
- `async`:是否异步,默认是 true 表示异步
- `data`:发送到服务器的数据
- `dataType`:预期服务器返回的数据类型
- `contentType`:设置请求头
- `success`:请求成功时调用此函数
- `error`:请求失败时调用此函数

### get请求

```js
$.ajax({
    type: "get",
    url: "js/cuisine_area.json", async: true,
    success: function (msg) {
        var str = msg;
        console.log(str);
        $('div').append("<ul></ul>");
        for (var i = 0; i < msg.prices.length; i++) {
            $('ul').append("<li></li>");
            $('li').eq(i).text(msg.prices[i]);
        }
    },
    error: function (errMsg) {
        console.log(errMsg);
        $('div').html(errMsg.responseText);
    }
});
```

## post请求

```js
$.ajax({
    type: "post",
    data: "name=tom",
    url: "js/cuisine_area.json",
    contentType: "application/x-www-form-urlencoded", async: true,
    success: function (msg) {
        var str = msg;
        console.log(str);
        $('div').append("<ul></ul>");
        for (var i = 0; i < msg.prices.length; i++) {
            $('ul').append("<li></li>");
            $('li').eq(i).text(msg.prices[i]);
        }
    },
    error: function (errMsg) {
        console.log(errMsg);
        $('div').html(errMsg.responseText)
    }
})
```

## $.get

- 这是一个简单的 GET 请求功能以取代复杂 `$.ajax`
-  请求成功时可调用回调函数,如果需要在出错时执行函数,请使用 `$.ajax`

**请求json文件,忽略返回值**

```js
$.get('js/cuisine_area.json');
```

**请求json文件,传递参数,忽略返回值**

```js
$.get('js/cuisine_area.json',{name:"tom",age:100});
```

**请求json文件,拿到返回值,请求成功后可拿到返回值**

```js
$.get('js/cuisine_area.json', function (data) {
    console.log(data);
}
     );
```

**请求json文件,传递参数,拿到返回值**

```js
$.get('js/cuisine_area.json', {name: "tom", age: 100}, function (data) {
    console.log(data);
});
```

## $.post

- 这是一个简单的 POST 请求功能以取代复杂 `$.ajax`
- 请求成功时可调用回调函数,如果需要在出错时执行函数,请使用 `$.ajax`
- 使用方法与`$.get`类似

## $.getJSON

- 表示请求返回的数据类型是JSON格式的ajax请求

```js
$.getJSON('js/cuisine_area.json', {name: "tom", age: 100}, function (data) {
console.log(data); // 要求返回的数据格式是JSON格式
});
```

