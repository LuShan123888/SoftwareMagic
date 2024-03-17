---
title: Thrift Server
categories:
- Software
- BackEnd
- Distributed
- Thrift
---
# Thrift Server

Thrif提供的网络服务模型包括阻塞服务模型与非阻塞服务模型

- 阻塞服务模型:TSimpleServer、TThreadPoolServer
- 非阻塞服务模型:TNonblockingserver、THsHaServer和TThreadedselectorServer

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/image-20220528001252494.png" alt="image-20220528001252494" style="zoom:50%;" />

## TServer

TServer定义了静态内部类Args，Args继承自抽象类AbstractServerArgs。AbstractServerArgs采用了建造者模式，向TServer提供各种工厂:

| 工厂属性               | 工厂类型          | 作用                                            |
| ---------------------- | ----------------- | ----------------------------------------------- |
| ProcessorFactory       | TProcessorFactory | 处理层工厂类，用于具体的TProcessor对象的创建     |
| InputTransportFactory  | TTransportFactory | 传输层输入工厂类，用于具体的TTransport对象的创建 |
| OutputTransportFactory | TTransportFactory | 传输层输出工厂类，用于具体的TTransport对象的创建 |
| InputProtocolFactory   | TProtocolFactory  | 协议层输入工厂类，用于具体的TProtocol对象的创建  |
| OutputProtocolFactory  | TProtocolFactory  | 协议层输出工厂类，用于具体的TProtocol对象的创建  |

TServer的三个方法:`serve()`,`stop()`和`isServing()`,`serve()`用于启动服务,`stop()`用于关闭服务,`isServing()`用于检测服务的起停状态

## TSimpleServer

TSimpleServer的工作模式采用最简单的阻塞IO，实现方法相对，但是一次只能接收和处理一个socket连接，效率比较低。主要用于演示Thrift的工作过程，在实际开发过程中很少用到它

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/image-20220528023005364.png" alt="image-20220528023005364" style="zoom:33%;" />

## TThreadPoolServer

TThreadPoolServer模式采用阻塞socket方式工作，主线程负责阻塞式监听是否有新socket到来，具体的业务处理交由一个线程池来处理

**优点**

- 拆分了监听线程(Accept Thread)和处理客户端连接的工作线程(Worker Thread)，数据读取和业务处理都交给线程池处理。因此在并发量较大时新连接也能够被及时接受。
- 线程池模式比较适合服务器端能预知最多有多少个客户端并发的情况，这时每个请求都能被业务线程池及时处理，性能也非常高

**缺点**

- 线程池模式的处理能力受限于线程池的工作能力，当并发请求数大于线程池中的线程数时，新请求也只能排队等待
- 默认线程池允许创建的最大线程数量为Integer.MAXVALUE，可能会创建出大量线程，导致OOM

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/image-20220528015654998.png" alt="image-20220528015654998" style="zoom:33%;" />

## TNonblockingServer

TNonblockingServer模式也是单线程工作，但是采用NIO的模式，利用IO多路复用模型处理socket就绪事件，对于有数据到来的socket进行数据读取操作，对于有数据发送的socket则进行数据发送娱作，对于监听socke侧产生一个新业务socket并将其注册到selector上

**注意**:TNonblockingServer要求底层的传输通道必须使用TFramedTransport

**优点**：相比于TSimpleServer效率提升主要体现在IO多路复用上，TNonblockingServer采用非阻塞IO，对accept/read/write等IO事件进行监控和处理，同时监控多个socket的状态变化。

**缺点**：TNonblockingServer模式在业务处理上还是采用单线程顺序来完成。在业务处理比较复杂、耗时的时候，例如某些接口函数需要读取据库执行时间较长，会导致整个服务被阻塞住，此时该模式效率也不高，因为多个调用请求任务依然是顺序—个接—个执行。

## THsHaServer

鉴于TNonblockingServer的缺点,THsHaserver继承于TNonblockingserver,引入了线程池提高了任务处理的并发能力

**注意**:THsHaServer和TNonblockingServer一样，要求底层的传输通道必须使用TFramedTransport

**优点**：THSHaServer与TNonblockingServer模式相比，THSHaServer在完成数据读取之后，将业务处理过程交由一个线程池来完成，主线程直接返回进行下一次循环操作，效率大大提升

**缺点**：主线程仍然需要完成所有socket的监听接收、数据读取和数据写入操作。当并发请求数较大时，且发送数据量较多时，监听socket上新连接请求不能被及时接受。

## TThreadedSelectorServer

ThreadedSelectorserver是对THSHaServer的一种扩充，它将selector中的读写IO事件(read/write)从主线程中分离出来.同时3入 worker工作线程池

TThreadedSelectorServer模式是目前Thrif提供的最高级的线程服务模型，它内部有如下部分构成:

- —个AcceptThread专门用于处理监听socket上的新连接
- 若干个SelectorThread专门用于处理业务socket的网络I/O读写操作，所有网络数据的读写均是有这些线程来完成
- 一个负载均衡器SelectorThreadLoadBalancer对象，主要用于AcceptThread线程接收到一个新socket连接请求时，决定将这个新连求分配给哪个SelectorThread线程
- 一个ExecutorService类型的工作线程池，在SelectorThread线程中，监听到有业务socket中有调用请求过来，则将请求数据读取之后，交给ExecutorService线程池中的线程完成此次调用的具体执行.主要用于处理每个RPC请求的handler回调处理

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/image-20220528023059587.png" alt="image-20220528023059587" style="zoom:50%;" />