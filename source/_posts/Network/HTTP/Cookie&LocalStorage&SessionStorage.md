---
title: HTTP Cookie&LocalStorage&SessionStorage
categories:
  - Network
  - HTTP
---
# HTTP Cookie&LocalStorage&SessionStorage

## Cookie

- Cookie 是小甜饼的意思，顾名思义，cookie 确实非常小，它的大小限制为4KB左右，是网景公司的前雇员 Lou Montulli 在1993年3月的发明，它的主要用途有保存登录信息，比如你登录某个网站市场可以看到"记住密码”，这通常就是通过在 Cookie 中存入一段辨别用户身份的数据来实现的。

## localStorage

- localStorage 是 HTML5 标准中新加入的技术，早在 IE 6 时代，就存在 userData 用于本地存储，而当时考虑到浏览器兼容性，更通用的方案是使用 Flash，而如今 localStorage 被大多数浏览器所支持，如果你的网站需要支持 IE6+，那以 userData 作为你的 polyfill 的方案是种不错的选择。

| 特性           | Chrome | Firefox (Gecko) | Internet Explorer | Opera | Safari (WebKit) |
| -------------- | ------ | --------------- | ----------------- | ----- | --------------- |
| localStorage   | 4      | 3.5             | 8                 | 10.50 | 4               |
| sessionStorage | 5      | 2               | 8                 | 10.50 | 4               |

## sessionStorage

- sessionStorage 与 localStorage 的接口类似，但保存数据的生命周期与 localStorage 不同，它只是可以将一部分数据在当前会话中保存下来，刷新页面数据依旧存在，但当页面关闭后，sessionStorage 中的数据就会被清空。

## 三者的异同

| 特性           | Cookie                                                       | localStorage                                                | sessionStorage                               |
| -------------- | ------------------------------------------------------------ | ----------------------------------------------------------- | -------------------------------------------- |
| 数据的生命期   | 一般由服务器生成，可设置失效时间，如果在浏览器端生成Cookie，默认是关闭浏览器后失效 | 除非被清除，否则永久保存                                    | 仅在当前会话下有效，关闭页面或浏览器后被清除 |
| 存放数据大小   | 4K左右                                                       | 一般为5MB                                                   |                                              |
| 与服务器端通信 | 每次都会携带在HTTP头中，如果使用cookie保存过多数据会带来性能问题 | 仅在客户端（即浏览器）中保存，不参与和服务器的通信          |                                              |
| 易用性         | 需要程序员自己封装，源生的Cookie接口不友好                   | 源生接口可以接受，亦可再次封装来对Object和Array有更好的支持 |                                              |

## 应用场景

- 因为考虑到每个 HTTP 请求都会带着 Cookie 的信息，所以 Cookie 需要足够精简，比较常用的一个应用场景就是判断用户是否登录，针对登录过的用户，服务器端会在他登录时往 Cookie 中插入一段加密过的唯一辨识单一用户的辨识码，下次只要读取这个值就可以判断当前用户是否登录啦，曾经还使用 Cookie 来保存用户在电商网站的购物车信息，如今有了 localStorage，似乎在这个方面也可以给 Cookie 放个假了。
- 而另一方面 localStorage 接替了 Cookie 管理购物车的工作，同时也能胜任其他一些工作，比如HTML5游戏通常会产生一些本地数据，localStorage 也是非常适用的，如果遇到一些内容特别多的表单，为了优化用户体验，我们可能要把表单页面拆分成多个子页面，然后按步骤引导用户填写，这时候 sessionStorage 的作用就发挥出来了。

## 安全性的考虑

需要注意的是，不是什么数据都适合放在 Cookie,localStorage 和 sessionStorage 中的，使用它们的时候，需要时刻注意是否有代码存在 XSS 注入的风险，因为只要打开控制台，你就随意修改它们的值，也就是说如果你的网站中有 XSS 的风险，它们就能对你的 localStorage 肆意妄为，所以千万不要用它们存储你系统中的敏感数据。