---
title: PHP SSL
categories:
- Software
- Language
- PHP
- Web
---
# PHP SSL

- SSL(Secure Sockets Layer,安全性套接字层)为普通的HTTP请求和响应提供一个安全的通讯通道,PHP没有特别考虑SSL所以你不能用PHP来控制SSL加密
- 一个`https://URL`地址意味着使用安全连接访问当前文件,`http://URL`则使用常规连接
- 如果PHP页面通过SSL安全连接，根据请求来生成响应，则`$_SERVER`数组中的HTTPS元素会被设置为"on",为了阻滞一个非加密连接的页面，只需要这样:

```php
if($_SERVER['HTTPS'] !== 'on'){
    die("Must be a secure connection.");
}
```

- 一个常见的错误是将一个表单通过SSL发送，但是将form的action提交给一个`http://URL`,所有的用户输入的表单参数都通过不安全的连接发送
- 即随便一个数据包嗅探器就可以截取并暴露它们的数据