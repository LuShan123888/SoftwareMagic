---
title: TCP/IP参考模型
categories:
- Internet
- TCPIP
---
# TCP/IP参考模型

## OSI参考模型

OSI参考模型虽然完备,但是太过复杂,不实用,而之后的TCP/IP参考模型经过一系列的修改和完善得到了广泛的应用,TCP/IP参考模型包括应用层,传输层,网络层和网络接口层,TCP/IP参考模型与OSI参考模型有较多相似之处,各层也有一定的对应关系,具体对应关系如下图所示:

![2019042317573274](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-zrXt8dNwZ21Olc9.png)

- 应用层,TCP/IP参考模型的应用层包含了所有高层协议,该层与OSI的会话层,表示层和应用层相对应
- 传输层,TCP/IP参考模型的传输层与OSI的传输层相对应,该层允许源主机与目标主机上的对等体之间进行对话,该层定义了两个端到端的传输协议:TCP协议和UDP协议
- 网络层,TCP/IP参考模型的网络层对应OSI的网络层,该层负责为经过逻辑互联网络路径的数据进行路由选择
- 网络接口层,TCP/IP参考模型的最底层是网络接口层,该层在TCP/IP参考模型中并没有明确规定

## TCP/IP参考模型

- TCP/IP参考模型是一个协议族,各层对应的协议已经得到广泛应用,TCP/IP参考模型主要协议的层次关系如图1-5所示
- TCP/IP参考模型与OSI参考模型有很多相同之处,都是以协议栈为基础的,对应各层功能也大体相似,当然也有一些区别,如OSI模型最大的优势是强化了服务,接口和协议的概念,这种做法能明确规范与实现,侧重理论框架的完备
- TCP/IP模型是事实上的工业标准,而改进后的TCP/IP模型却没有做到,因此其不适用于新一代网络架构设计
- TCP/IP模型没有区分物理层和数据链路层这两个功能完全不同的层
- OSI模型比较适合理论研究和新网络技术研究,而TCP/IP模型真正做到了流行和应用

![20190423192449566](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-20190423192449566.PNG)

![img](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-04-21-v2-2d62ba265be486cb94ab531912aa3b9c_720w.jpg)