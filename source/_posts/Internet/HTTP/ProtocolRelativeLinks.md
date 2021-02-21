---
title: Protocol-Relative Links
categories:
- Internet
- HTTP
---
# Protocol-Relative Links

- Protocol-Relative Links是指协议自动采用当前页面的协议,使用`//`代替url中的协议名
- 例如`//zhihu.com/path`缺省协议默认使用当前协议当前页面为HTTP时，等效 http://zhihu.com/path 当前页面为HTTPS时，等效 https://zhihu.com/path

**特点**

- 能根据用户打开页面的方式自适应的选择资源的请求协议
- 对于https页面的内容,浏览器默认会组织非https内容，可以避免这种情况
- 直接打开本地文件调试时，使用的协议是文件协议(**file://)**这个时候这个协议会变成 **file:///http://zhihu.com/path** 显然是不存在