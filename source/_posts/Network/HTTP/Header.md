---
title: HTTP Header
categories:
  - Network
  - HTTP
---
# HTTP Header

| 头信息              | 描述                                                         |
| :------------------ | :----------------------------------------------------------- |
| Allow               | 这个头信息指定服务器支持的请求方法（GET,POST 等）,             |
| Cache-Control       | 这个头信息指定响应文档在何种情况下可以安全地缓存，可能的值有**public,private** 或 **no-cache** 等，Public 意味着文档是可缓存，Private 意味着文档是单个用户私用文档，且只能存储在私有（非共享）缓存中，no-cache 意味着文档不应被缓存， |
| Connection          | 这个头信息指示浏览器是否使用持久 HTTP 连接，值 **close** 指示浏览器不使用持久 HTTP 连接，值 **keep-alive** 意味着使用持久连接， |
| Content-Disposition | 这个头信息可以让您请求浏览器要求用户以给定名称的文件把响应保存到磁盘， |
| Content-Encoding    | 在传输过程中，这个头信息指定页面的编码方式，                   |
| Content-Language    | 这个头信息表示文档编写所使用的语言，例如，en,en-us,ru 等，      |
| Content-Length      | 这个头信息指示响应中的字节数，只有当浏览器使用持久（keep-alive)HTTP 连接时才需要这些信息， |
| Content-Type        | 这个头信息提供了响应文档的 MIME(Multipurpose Internet Mail Extension）类型， |
| Expires             | 这个头信息指定内容过期的时间，在这之后内容不再被缓存，         |
| Last-Modified       | 这个头信息指示文档的最后修改时间，然后，客户端可以缓存文件，并在以后的请求中通过 **If-Modified-Since** 请求头信息提供一个日期， |
| Location            | 这个头信息应被包含在所有的带有状态码的响应中，在 300s 内，这会通知浏览器文档的地址，浏览器会自动重新连接到这个位置，并获取新的文档， |
| Refresh             | 这个头信息指定浏览器应该如何尽快请求更新的页面，您可以指定页面刷新的秒数， |
| Retry-After         | 这个头信息可以与 503(Service Unavailable 服务不可用）响应配合使用，这会告诉客户端多久就可以重复它的请求， |
| Set-Cookie          | 这个头信息指定一个与页面关联的 cookie,                       |