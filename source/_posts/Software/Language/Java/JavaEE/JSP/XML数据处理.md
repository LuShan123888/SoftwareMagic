---
title: JSP XML 数据处理
categories:
- Software
- Language
- Java
- JavaEE
- JSP
---
# JSP XML 数据处理

- 当通过HTTP发送XML数据时，就有必要使用JSP来处理传入和流出的XML文档了，比如RSS文档，作为一个XML文档，它仅仅只是一堆文本而已，使用JSP创建XML文档并不比创建一个HTML文档难。

## 使用JSP发送XML

- 使用JSP发送XML内容就和发送HTML内容一样，唯一的不同就是您需要把页面的context属性设置为text/xml，要设置context属性，使用`<%@page % >`命令，就像这样：

```jsp
<%@ page contentType="text/xml" %>
```

- 接下来这个例子向浏览器发送XML内容：

```jsp
<%@ page contentType="text/xml" %>

<books>
   <book>
      <name>Padam History</name>
      <author>ZARA</author>
      <price>100</price>
   </book>
</books>
```

- 使用不同的浏览器来访问这个例子，看看这个例子所呈现的文档树。

## 在JSP中处理XML

- 在使用JSP处理XML之前，您需要将与XML 和XPath相关的两个库文件放在`<Tomcat Installation Directory>\lib`目录下：
    - XercesImpl.jar：在这下载http://www.apache.org/dist/xerces/j/
    - xalan.jar：在这下载http://archive.apache.org/dist/xml/xalan-j/
- `books.xml`文件：

```xml
<books>
<book>
  <name>Padam History</name>
  <author>ZARA</author>
  <price>100</price>
</book>
<book>
  <name>Great Mistry</name>
  <author>NUHA</author>
  <price>2000</price>
</book>
</books>
```

- `main.jsp`文件：

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>

<html>
<head>
  <title>JSTL x:parse Tags</title>
</head>
<body>
<h3>Books Info:</h3>
<c:import var="bookInfo" url="http://localhost:8080/books.xml"/>

<x:parse xml="${bookInfo}" var="output"/>
<b>The title of the first book is</b>:
<x:out select="$output/books/book[1]/name" />
<br>
<b>The price of the second book</b>:
<x:out select="$output/books/book[2]/price" />

</body>
</html>
```

- 访问http://localhost:8080/main.jsp，运行结果如下：

```
BOOKS INFO:
The title of the first book is:Padam History
The price of the second book: 2000
```

## 使用JSP格式化XML

- XSLT样式表style.xsl文件：

```xml
<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl=
"http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="html" indent="yes"/>

<xsl:template match="/">
  <html>
  <body>
   <xsl:apply-templates/>
  </body>
  </html>
</xsl:template>

<xsl:template match="books">
  <table border="1" width="100%">
    <xsl:for-each select="book">
      <tr>
        <td>
          <i><xsl:value-of select="name"/></i>
        </td>
        <td>
          <xsl:value-of select="author"/>
        </td>
        <td>
          <xsl:value-of select="price"/>
        </td>
      </tr>
    </xsl:for-each>
  </table>
</xsl:template>
</xsl:stylesheet>
```

- main.jsp文件：

```jsp
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>

<html>
<head>
  <title>JSTL x:transform Tags</title>
</head>
<body>
<h3>Books Info:</h3>
<c:set var="xmltext">
  <books>
    <book>
      <name>Padam History</name>
      <author>ZARA</author>
      <price>100</price>
    </book>
    <book>
      <name>Great Mistry</name>
      <author>NUHA</author>
      <price>2000</price>
    </book>
  </books>
</c:set>

<c:import url="http://localhost:8080/style.xsl" var="xslt"/>
<x:transform xml="${xmltext}" xslt="${xslt}"/>

</body>
</html>
```

- 运行结果如下：

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-xml-1.jpg)