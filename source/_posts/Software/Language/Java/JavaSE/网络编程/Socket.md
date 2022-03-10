---
title: Java Socket
categories:
- Software
- Language
- Java
- JavaSE
- 网络编程
---
# Java Socket

- Java提供了Socket类和ServerSocket类分别用于Client端的Server端的Socket通信编程,可将联网的任何两台计算机进行Socket通信,一台作为服务器,另一台作为客户端,也可以用一台计算机上运行的两个进程分别运行服务端和客户端程序

## Socket类

- Socket类用在客户端,通过构造一个Socket类来建立与服务器的连接,Socket连接可以是流连接,也可以是数据报连接,这取决于构造Socket类时使用的构造方法,一般使用流连接,流连接的优点是所有数据都能准确,有序地送到接收方,缺点是速度较慢,Socket类的构造方法有如下4种:
    - `Socket(String host,int port)`:构造一个连接指定主机,指定端口的流Socket
    - `Socket(String host,int port,boolean kind)`:构造一个连接指定主机,指定端口的Socket类,boolean类型的参数用来设置是流Socket还是数据报Socket
    - `Socket(InetAddress address,int port)`:构造一个连接指定Internet地址,指定端口的流Socket
    - `Socket(InetAddress address,int port,boolean kind)`:构造一个连接指定Internet地址,指定端口的Socket类,boolean类型的参数用来设置是流Socket还是数据报Socket
- 在构造完Socket类后,就可以通过Socket类来建立输入,输出流,通过流来传送数据

## ServerSocket类

- ServerSocket类用在服务器端,常用的构造方法有两种:
    - `ServerSocket(int port)`:在制定端口上构造一个ServerSocket类
    - `ServerSocket(int port ,int queue length)`:在指定端口上构造一个ServerSocket类,第2个参数queueLength用于限制并发等待连接的客户最大数目

## 建立连接与数据通信

- Socket通信的基本过程
    1. 在服务器端创建一个ServerSocket对象,通过执行`accept()`方法监听客户连接,这将使线程处于等待状态
    2. 在客户端建立Socket类,与某服务器的指定端口进行连接,服务a器监听到连接请求后,就可在两者之间建立连接
    3. 连接建立之后,就可以取得相应的输入/输出流进行通信,一方的输出流发送的数据将被另一方的输入流读取

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-2020-11-07-socker1.svg)

**[例16-1]**:下面是一个简单的Socket通信演示程序

**客户方程序**

```java
class Client {
    public static void main(String[] args) throws IOException {
        Socket socket = new Socket("localhost",5432);
        //申请与服务器的5432端口连接
        InputStream sln = socket.getInputStream();//取得Socket的输入流
        DataInputStream dis = new DataInputStream(sln);
        String message = dis.readUTF();
        System.out.println(message);
        s.close();
    }
}
```

- 这里客户机要访问的计算机为本地主机(localhost),也就是在一台计算机上自己与自己通信,客户通过创建Socket与服务端建立连接后,可以取得Socket的输入流,用过滤流`DataInputStream`的`readUTF()`方法读取来自服务方的字符串,最后关闭Socket连接


**服务方程序**

```java
class Server {
    public static void main(String[] args) {
        try{
            ServerSocket socket = new ServerSocket(5423);//创建服务
            while (true){
                Socket s1 = socket.accept(); //监听客户端的连接
                OutputStream s1out = s1.getOutputStream();
                DataOutputStream dos = new DataOutputStream(s1out);
                dos.writeUTF("Hello  World!");
                System.out.println("a client is connected...");
                s1.close();
            }
        }catch (IOException e){  }
    }
}
```

- 通过`accpet()`方法等待客户连接,如果无客户连接,线程将进入阻塞状态,一旦有客户连接成功,则将在客户与服务器间建立一条Socket数据传输通道,
- 通过Socket的`getOutputStream()`方法可获得该通道本方的输出流,为了方便流操作,可以用DataOutputStream流对其进行过滤,并用`DataOutputStream`对象的`writeUTF()`方法给客户发送数据,而后关闭与该客户的连接,继续循环等待其他客户的访问

> - **注意**:该程序在同一机器上运行时要开辟两个DOS窗口,首先运行服务器程序,然后在另一个窗口运行客户程序,服务器端循环运行等待客户连接,每个客户连接到服务器后,在客户方将显示服务器发送的信息"Hello World!",而服务方将显示”a client is connected...",本程序中只是服务方给客户方发送数据,如果客户要给服务方发送数据,方法一样,只是要注意双方收发的配合
> - **思考**:上面的程序如果要实现双向通行,则服务器需要获取客户发送的数据,如果客户连接和读取客户数据安排在一个循环中,那么等待读取客户发送的数据将导致线程阻塞,不能及时转向执行`accept()`方法去等待其他客户连接,因此,对于复杂的多用户通信是不可行的
>

## 实例

### **[例16-2]**:一个简单的多用户聊天程序

#### 聊天客户端程序

- 聊天客户端的职责有两个:
    - 能提供一个图形界面实现聊天信息的输入和显示,其中包括处理用户输入时间
    - 要随时接受来自其他客户的信息并显示出来,因此在客户端也采用多线程实现,应用程序主线程负责图形界面的输入处理,而接受消息线程负责读取其他客户发来的数据

```java
class TalkClient {
    public static void main(String[] args) throws IOException {
        Socket s1 = new Socket(args[0], 5432);  //连接服务器
        //输入输出流
        DataInputStream dis = new DataInputStream(s1.getInputStream());
        final DataOutputStream dos = new DataOutputStream(s1.getOutputStream());
        //GUI
        Frame myframe = new Frame("简易聊天室");
        Panel panelx = new Panel();
        final TextField input = new TextField(20);
        TextArea display = new TextArea(5, 20);
        panelx.add(input);
        panelx.add(display);
        myframe.add(panelx);
        //根据文本框的动作事件处理,将文本框的数据发送给服务器
        new receiveThread(dis, display);//创建启动接受消息线程
        input.addActionListener(new ActionListener() {//匿名内嵌类
            public void actionPerformed(ActionEvent e) {
                try {
                    dos.writeUTF(input.getText());//发送数据
                } catch (IOException z) {
                }
            }
        });
        myframe.setSize(300, 300);
        myframe.setVisible(true);
    }
}

/*接收消息线程循环读取网络消息,显示在文本域*/
class receiveThread extends Thread {
    DataInputStream dis;
    TextArea displayarea;

    public receiveThread(DataInputStream dis, TextArea m) {
        this.dis = dis;
        displayarea = m;
        this.start();
    }

    //循环读取来自服务器的数据,并显示在文本域中
    public void run() {
        for (; ; ) {
            try {
                String str = dis.readUTF();//读来自服务器的消息
                displayarea.append(str + "\n");//将消息添加到文本域显示
            } catch (IOException e) {
            }
        }
    }
}
```

#### 聊天服务端程序

- 聊天服务端的任务主要有两个
    - 监听某端口,建立与客户的Socket连接,处理一个客户的连接后,能很快再进入监听状态
    - 处理与客户的通信,由于聊天是在客户之间进行的,所以服务器的职责是将客户发送的消息转发给其他客户,为了实现这两个任务,必须设法将人物分开,可以借助多线程技术,在服务方为每个客户连接建立一个通信线程,通信线程负责接收客户的消息并将消息转发给其他客户,这样主程序的任务就简单化了,循环监听客户连接,每个客户连接成功后,创建一个通信线程,并将与Socket对应的输入/输出流传给该线程
- 此例中还有一个关键问题是,由于要将数据转发给其他客户,因此某个客户对应的通信线程要设法获取其他客户的Socket输出流,也就是必须设法将所有客户的资料在连接处理时保存在一个公共能访问的地方,因此,在TalkServer类中引入了一个静态ArrayList方法存放所有客户的通信线程,这样要取得其他客户相关的输出流可通过该ArrayList方法去间接访问

```java
class TalkServer {
    //存放所有通信线程
    public static ArrayList<Client> allclient = new ArrayList<Client>();
    //统计客户连接的计数变量
    public static int clientnum = 0;

    public static void main(String[] args) {
        try {
            ServerSocket s = new ServerSocket(5432);//规定服务端口
            while (true) {
                Socket s1 = s.accept(); //等待客户连接
                DataOutputStream dos = new DataOutputStream(s1.getOutputStream());
                DataInputStream din = new DataInputStream(s1.getInputStream());
                Client x = new Client(clientnum, dos, din);
                //创建与客户对应的通信线程
                allclient.add(x);
                x.start();
                clientnum++;
            }
        } catch (IOException e) {
        }
    }
}

/*通信线程处理与对应客户的通信,将来自客户数据发往其他客户*/
class Client extends Thread {
    int id; //客户的标识
    DataOutputStream dos;//去往客户的输出流
    DataInputStream din;//来自客户的输入流
    
    public Client(int id, DataOutputStream dos, DataInputStream din) {
        this.id = id;
        this.dos = dos;
        this.din = din;
    }
    
    public void run() {//循环读取客户数据转发给其他客户
        //循环将数据发送给所有客户(包括自己)的Socket通道
        while (true) {
            try {
                //等待接收自己客户发送过来的数据
                String message = "客户" + id + ":" + din.readUTF();
                for (int i = 0; i < TalkServer.clientnum; i++) {
                    //将消息转发给所有客户
                    TalkServer.allclient.get(i).dos.writeUTF(message);
                }
            } catch (IOException e) {
            }
        }
    }
}
```

- 运行该程序前首先要运行服务方程序,运行客户方程序要注意提供一个代表服务器地址的参数,如果客户方程序与服务方程序在同一机器上运行,则客户方运行命令为:

```java
java TalkClient localhost
```

> **思考**
>
> 该程序仅实现了简单的多用户聊天演示,在程序中还有许多问题值得改进,例如:
>
> - 如何修改服务方,使用户自己发送的消息不显示在自己的文本域中
> - 增加一个用户名输入界面,用户输入身份后再进入聊天界面
> - 在客户方显示用户列表,可以选择将信息发送给哪些用户
> - 如何在服务方对退出的用户进行处理,保证聊天发送的消息只发给在场的用户,这点要客户方与服务方配合编程,客户退出时给服务方发消息,或者给服务器设置一个监视线程,检查各通信线程的Socket通道是否正常,对于不正常的通道自动停止相关的通信线程
>

### TCP文件上传实现

```java
class Client {
    public static void main(String[] args) throws IOException {
        //创建一个Socket连接
        Socket socket = new Socket(InetAddress.getByName("127.0.0.1"), 9000);
        //创建一个输出流
        OutputStream outputStream = socket.getOutputStream();
        //读取文件
        FileInputStream fileInputStream = new FileInputStream("test.txt");
        //写出文件
        byte[] buffer = new byte[1024];
        int length;
        while ((length = fileInputStream.read(buffer)) != -1) {
            outputStream.write(buffer, 0, length);
        }
        //通知服务器,文件传输完成
        socket.shutdownOutput();
        //确定服务器接收完成
        InputStream inputStream = socket.getInputStream();
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        byte[] buffer2 = new byte[1024];
        int length2;
        while ((length2 = inputStream.read(buffer2)) != -1) {
            byteArrayOutputStream.write(buffer2, 0, length2);
        }
        System.out.println(byteArrayOutputStream);
        //关闭资源
        fileInputStream.close();
        outputStream.close();
        socket.close();

    }
}

class Server {
    public static void main(String[] args) throws IOException {
        //创建服务
        ServerSocket serverSocket = new ServerSocket(9000);
        //监听客服端的连接
        Socket socket = serverSocket.accept();//阻塞式监听,会一直等待客户端连接
        //获取输入流
        InputStream inputStream = socket.getInputStream();
        //文件输出
        FileOutputStream fileOutputStream = new FileOutputStream(new File("receive.txt"));
        byte[] buffer = new byte[1024];
        int length;
        while ((length = inputStream.read(buffer)) != -1) {
            fileOutputStream.write(buffer, 0, length);
        }
        //通知客服端接收完成
        OutputStream os = socket.getOutputStream();
        os.write("Receive successful!".getBytes());
        //关闭资源
        fileOutputStream.close();
        inputStream.close();
        socket.close();
        serverSocket.close();
    }
}
```

