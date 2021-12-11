---
title: Java URL与URLConnection
categories:
- Software
- Language
- Java
- JavaSE
- 网络编程
---
# Java URL与URLConnection

- 在Internet上的所有网络资源都是用URL(Uniform Resource Locator)来表示的,一个URL地址通常由4部分组成,包括协议名,主机名,路径文件,端口号,例如华东交通大学Java课程的网上教学地址为http://cai.ecjtu.jx.cn:80/java/index.html

## URL类

- 使用URL进行网络通信,就要使用URL类创建对象,利用该对象提供的方法获取网络数据流,从而读取来自URL的网络数据,URL类安排在`java.net`包中,以下为URL的几个构造方法及说明:
    - `URL(String protocol,String host, int port,String path)`:其中,protocol是协议的类型,可以是http,ftp,file等,host是主机名,port是端口号,path给出文件名或路径名
    - `URL(String protocol,String host,String path)`:参数含义与上相同,使用协议默认端口号
    - `URL(URL url,String path)`:利用给定url中的协议,主机,加上path指定的相对路径拼接新URL
    - `URL(String url)`:使用URL字符串构造一个URL类
- 如果URL信息错误将产生`MalformedURLException`异常,在构造完一个URL类后,可以使用URL类中的`openStream()`方法与服务器上的文件建立一个流的连接,但是这个流是输入流(InputStream),只能读而不能写
- URL类提供的典型方法如下:
    - `String getFile()`:取得URL的文件名,它是带路径的文件标识
    - `String getHost()`:取得URl的主机名
    - `String getPath()`:取得URL的路径部分
    - `int getPort()`:取得URL的路径部分
    - `URLConnection openConnection()`:返回代表与URL进行连接的`URLConnection`对象
    - `InputStream openStream()`:打开与URL的连接,返回来自连接的输入流
    - `Object getContent()`:获得URL的内容

**[例16-5]**:通过流操作读取URL访问结果

- 以下程序读取网上某个URL的访问结果,将结果数据写入到某个文本文件中或者在显示屏上显示,取决于运行程序时是否提供写入的文件
- 运行程序时第1个参数指定URL地址,第2个参数可以省去,如果有该参数则表示存放结果的文件名

```java
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;

class GetURL {
    public static void main(String[] args) {
        InputStream in = null;
        OutputStream out = null;
        try {
            URL url = new URL(args[0]);//建立URL
            //获取指定URL的输入流
            in = url.openStream();
            //根据命令行参数判断输出目标是文件还是屏幕
            if (args.length == 2) {
                out = new FileOutputStream(args[1]);//输出目标为指定文件
            } else {
                out = System.out;//输出目标为屏幕
            }
            //以下将URL访问结果数据复制到输出流
            byte[] buffer = new byte[4096];
            int bytes;
            while ((bytes = in.read(buffer)) != -1)//读数据到缓冲区
                out.write(buffer, 0, bytes);
        } catch (Exception e) {
            System.err.println("Usage:java GetURL <URL> [<filename>]");
        } finally {
            try {       //关闭输入输出流
                in.close();
                out.close();
            } catch (IOException e) {
            }
        }
    }
}
```

## URLConnection类

- 前面介绍的URL访问只能读取URL数据源的数据,实际应用中,有时需要与URL资源进行双向通信,则要用到`URLConnection`类
- `URLConnection`类将创建一个对指定URL的连接对象,其构造方法是`URLConnection`(URL),当构建`URLConnection`对象并未建立与指定URL的 连接,还必须使用`URLConnection`类中的`connect()`方法建立连接
- 另一种与URL建立双向连接的方法是使用URL类中的`openConnection()`方法,它返回建立好连接的`URLConnection`对象
- URLConnection类的几个主要方法如下:
    - `void connect()`:打开URL所指资源的通信链路
    - `int getContentLenght()`:返回URL的内容长度值
    - `InputStream getInputStream()`:返回来自连接的输入流
    - `OutputStream getOutputStream()`:返回写往连接的输出流

**[例16-6]**:下载指定的URL文件

```java
import java.io.*;
import java.net.*;
class downloadFile {
    public static void main(String[] args) {
        try {
            URL url = new URL(args[0]);
            //建立与URL资源的连接
            URLConnection uc = url.openConnection();
            int len = uc.getContentLength();
            byte[] b = new byte[len];//创建字节数组存放读取的数据
            //取得连接的输入流
            InputStream stream = uc.getInputStream();
            //取得URL资源文件路径
            String theFile = url.getFile();
            //分离出文件名
            theFile = theFile.substring(theFile.lastIndexOf('/') + 1);
            //创建对应的文件输出流
            FileOutputStream fout = new FileOutputStream(theFile)
                //读取URL资源的全部数据
                stream.read(b, 0, len);//从输入流读len个字节数据存入数组b
            //将数据写入文件,从而实现资源内容的下载保存
            fout.write(b);
            //断开连接
            uc.disconnect();
        } catch (MalformedURLException e) {
            System.err.println("URL error");
        } catch (IOException e) {   }
    }
}
```

**运行示例**

```
e:/java>java downloadFile "http://localhost/images/dots.gif"
```

- 在e盘的java子目录下可以找到下载的文件dots.gif