---
title: Servlet HttpServletRequest
categories:
- Software
- Language
- Java
- JavaEE
- Servlet
---
# Servlet HttpServletRequest

- 当浏览器请求网页时,它会向Web服务器发送特定信息,这些信息不能被直接读取,因为这些信息是作为HTTP请求的头的一部分进行传输

## 读取 HTTP 头的方法

- 下面的方法可用在 Servlet 程序中读取HTTP头,这些方法通过`HttpServletRequest`对象可用

| 序号 | 方法 & 描述                                                  |
| :--- | :----------------------------------------------------------- |
| 1    | **Cookie[] getCookies()** 返回一个数组,包含客户端发送该请求的所有的 Cookie 对象 |
| 2    | **Enumeration getAttributeNames()** 返回一个枚举,包含提供给该请求可用的属性名称 |
| 3    | **Enumeration getHeaderNames()** 返回一个枚举,包含在该请求中包含的所有的头名 |
| 4    | **Enumeration getParameterNames()** 返回一个 String 对象的枚举,包含在该请求中包含的参数的名称 |
| 5    | **HttpSession getSession()** 返回与该请求关联的当前 session 会话,或者如果请求没有 session 会话,则创建一个 |
| 6    | **HttpSession getSession(boolean create)** 返回与该请求关联的当前 HttpSession,或者如果没有当前会话,且创建是真的,则返回一个新的 session 会话 |
| 7    | **Locale getLocale()** 基于 Accept-Language 头,返回客户端接受内容的首选的区域设置 |
| 8    | **Object getAttribute(String name)** 以对象形式返回已命名属性的值,如果没有给定名称的属性存在,则返回 null |
| 9    | **ServletInputStream getInputStream()** 使用 ServletInputStream,以二进制数据形式检索请求的主体 |
| 10   | **String getAuthType()** 返回用于保护 Servlet 的身份验证方案的名称,例如,"BASIC" 或 "SSL",如果JSP没有受到保护则返回 null |
| 11   | **String getCharacterEncoding()** 返回请求主体中使用的字符编码的名称 |
| 12   | **String getContentType()** 返回请求主体的 MIME 类型,如果不知道类型则返回 null |
| 13   | **String getContextPath()** 返回指示请求上下文的请求 URI 部分 |
| 14   | **String getHeader(String name)** 以字符串形式返回指定的请求头的值 |
| 15   | **String getMethod()** 返回请求的 HTTP 方法的名称,例如,GET,POST 或 PUT |
| 16   | **String getParameter(String name)** 以字符串形式返回请求参数的值,或者如果参数不存在则返回 null |
| 17   | **String getPathInfo()** 当请求发出时,返回与客户端发送的 URL 相关的任何额外的路径信息 |
| 18   | **String getProtocol()** 返回请求协议的名称和版本            |
| 19   | **String getQueryString()** 返回包含在路径后的请求 URL 中的查询字符串 |
| 20   | **String getRemoteAddr()** 返回发送请求的客户端的IP地址      |
| 21   | **String getRemoteHost()** 返回发送请求的客户端的Hostname    |
| 22   | **String getRemoteUser()** 如果用户已通过身份验证,则返回发出请求的登录用户,或者如果用户未通过身份验证,则返回 null |
| 23   | **String getRequestURI()** 从协议名称直到 HTTP 请求的第一行的查询字符串中,返回该请求的 URL 的一部分 |
| 24   | **String getRequestedSessionId()** 返回由客户端指定的 session 会话 ID |
| 25   | **String getServletPath()** 返回调用 JSP 的请求的 URL 的一部分 |
| 26   | **String[] getParameterValues(String name)** 返回一个字符串对象的数组,包含所有给定的请求参数的值,如果参数不存在则返回 null |
| 27   | **boolean isSecure()** 返回一个布尔值,指示请求是否使用安全通道,如 HTTPS |
| 28   | **int getContentLength()** 以字节为单位返回请求主体的长度,并提供输入流,或者如果长度未知则返回 -1 |
| 29   | **int getIntHeader(String name)** 返回指定的请求头的值为一个 int 值 |
| 30   | **int getServerPort()** 返回接收到这个请求的端口号           |
| 31   | **int getParameterMap()** 将参数封装成 Map 类型              |

## HTTP Header 请求实例

- 下面的实例使用 HttpServletRequest 的 **getHeaderNames()** 方法读取 HTTP 头信息,该方法返回一个枚举,包含与当前的 HTTP 请求相关的头信息
- 一旦我们有一个枚举,我们可以以标准方式循环枚举,使用 `hasMoreElements()` 方法来确定何时停止,使用 `nextElement()`方法来获取每个参数的名称

```java
@WebServlet("/DisplayHeader")
public class DisplayHeader extends HttpServlet {

    // 处理 GET 方法请求的方法
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        // 设置响应内容类型
        response.setContentType("text/html;charset=UTF-8");

        PrintWriter out = response.getWriter();
        String title = "HTTP Header 请求实例 - 菜鸟教程实例";
        String docType =
            "<!DOCTYPE html> \n";
            out.println(docType +
            "<html>\n" +
            "<head><meta charset=\"utf-8\"><title>" + title + "</title></head>\n"+
            "<body bgcolor=\"#f0f0f0\">\n" +
            "<h1 align=\"center\">" + title + "</h1>\n" +
            "<table width=\"100%\" border=\"1\" align=\"center\">\n" +
            "<tr bgcolor=\"#949494\">\n" +
            "<th>Header 名称</th><th>Header 值</th>\n"+
            "</tr>\n");

        Enumeration headerNames = request.getHeaderNames();

        while(headerNames.hasMoreElements()) {
            String paramName = (String)headerNames.nextElement();
            out.print("<tr><td>" + paramName + "</td>\n");
            String paramValue = request.getHeader(paramName);
            out.println("<td> " + paramValue + "</td></tr>\n");
        }
        out.println("</table>\n</body></html>");
    }
    // 处理 POST 方法请求的方法
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
```