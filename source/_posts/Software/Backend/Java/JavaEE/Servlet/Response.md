---
title: Servlet 服务器 HTTP 响应
categories:
- Software
- Backend
- Java
- JavaEE
- Servlet
---
# Servlet 服务器 HTTP 响应

正如前面的章节中讨论的那样,当一个 Web 服务器响应一个 HTTP 请求时,响应通常包括一个状态行,一些响应报头,一个空行和文档,一个典型的响应如下所示:

```html
HTTP/1.1 200 OK
Content-Type: text/html
Header2: ...
...
HeaderN: ...
  (Blank Line)
<!doctype ...>
<html>
<head>...</head>
<body>
...
</body>
</html>
```

- 状态行包括 HTTP 版本(在本例中为 HTTP/1.1),一个状态码(在本例中为 200)和一个对应于状态码的短消息(在本例中为 OK)

## 设置 HTTP 响应报头的方法

下面的方法可用于在 Servlet 程序中设置 HTTP 响应报头,这些方法通过 `HttpServletResponse` 对象可用

| 方法 & 描述                                                  |
| :----------------------------------------------------------- |
| **String encodeRedirectURL(String url)** 为 sendRedirect 方法中使用的指定的 URL 进行编码,或者如果编码不是必需的,则返回 URL 未改变, |
| **String encodeURL(String url)** 对包含 session 会话 ID 的指定 URL 进行编码,或者如果编码不是必需的,则返回 URL 未改变, |
| **boolean containsHeader(String name)** 返回一个布尔值,指示是否已经设置已命名的响应报头, |
| **boolean isCommitted()** 返回一个布尔值,指示响应是否已经提交, |
| **void addCookie(Cookie cookie)** 把指定的 cookie 添加到响应, |
| **void addDateHeader(String name, long date)** 添加一个带有给定的名称和日期值的响应报头, |
| **void addHeader(String name, String value)** 添加一个带有给定的名称和值的响应报头, |
| **void addIntHeader(String name, int value)** 添加一个带有给定的名称和整数值的响应报头, |
| **void flushBuffer()** 强制任何在缓冲区中的内容被写入到客户端, |
| **void reset()** 清除缓冲区中存在的任何数据,包括状态码和头,  |
| **void resetBuffer()** 清除响应中基础缓冲区的内容,不清除状态码和头, |
| **void sendError(int sc)** 使用指定的状态码发送错误响应到客户端,并清除缓冲区, |
| **void sendError(int sc, String msg)** 使用指定的状态发送错误响应到客户端, |
| **void sendRedirect(String location)** 使用指定的重定向位置 URL 发送临时重定向响应到客户端, |
| **void setAttribute(String key,Object value)**如果需要在服务器端进行跳转,并需要想下个页面发送新的参数时,,可以通过`setAttribute()`,将值放入到request对象,然后在其他页面使用`getAttribute()`获取对应的值,这样就达到一次请求可以在多个页面共享一些对象信息 |
| **void setBufferSize(int size)** 为响应主体设置首选的缓冲区大小, |
| **void setCharacterEncoding(String charset)** 设置被发送到客户端的响应的字符编码(MIME 字符集)例如,UTF-8, |
| **void setContentLength(int len)** 设置在 HTTP Servlet 响应中的内容主体的长度,该方法设置 HTTP Content-Length 头, |
| **void setContentType(String type)** 如果响应还未被提交,设置被发送到客户端的响应的内容类型, |
| **void setDateHeader(String name, long date)** 设置一个带有给定的名称和日期值的响应报头, |
| **void setHeader(String name, String value)** 设置一个带有给定的名称和值的响应报头, |
| **void setIntHeader(String name, int value)** 设置一个带有给定的名称和整数值的响应报头, |
| **void setLocale(Locale loc)** 如果响应还未被提交,设置响应的区域, |
| **void setStatus(int sc)** 为该响应设置状态码,               |

**getParameter()和getAttribute ()区别:**

- 赋值方式不一样,前者是客户端如浏览器端将请求参数值送给服务器端,而后者则是在请求到达服务器端之后,在服务器进行存放进去
- 两者的返回值类型不一样,前者永远返回字符串,后者返回任意对象
- 如果需要在服务器端进行跳转,并需要想下个页面发送新的参数时,parameter没法实现,但是attribute可以,可以通过`setAttribute()`,将值放入到request对象,然后在其他页面使用`getAttribute()`获取对应的值,这样就达到一次请求可以在多个页面共享一些对象信息

## HTTP Header 响应实例

您已经在前面的实例中看到 `setContentType()` 方法,下面的实例也使用了同样的方法,此外,我们会用 `setIntHeader()` 方法来设置 **Refresh** 头

```java
//导入必需的 java 库
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/Refresh")

//扩展 HttpServlet 类
public class Refresh extends HttpServlet {

    // 处理 GET 方法请求的方法
      public void doGet(HttpServletRequest request,
                        HttpServletResponse response)
                throws ServletException, IOException
      {
          // 设置刷新自动加载时间为 5 秒
          response.setIntHeader("Refresh", 5);
          // 设置响应内容类型
          response.setContentType("text/html;charset=UTF-8");

          //使用默认时区和语言环境获得一个日历
          Calendar cale = Calendar.getInstance();
          //将Calendar类型转换成Date类型
          Date tasktime=cale.getTime();
          //设置日期输出的格式
          SimpleDateFormat df=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
          //格式化输出
          String nowTime = df.format(tasktime);
          PrintWriter out = response.getWriter();
          String title = "自动刷新 Header 设置 - 菜鸟教程实例";
          String docType =
          "<!DOCTYPE html>\n";
          out.println(docType +
            "<html>\n" +
            "<head><title>" + title + "</title></head>\n"+
            "<body bgcolor=\"#f0f0f0\">\n" +
            "<h1 align=\"center\">" + title + "</h1>\n" +
            "<p>当前时间是:" + nowTime + "</p>\n");
      }
      // 处理 POST 方法请求的方法
      public void doPost(HttpServletRequest request,
                         HttpServletResponse response)
          throws ServletException, IOException {
         doGet(request, response);
      }
}
```