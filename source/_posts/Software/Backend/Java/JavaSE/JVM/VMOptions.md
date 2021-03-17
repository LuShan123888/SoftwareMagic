---
title: JVM VM Options
categories:
- Software
- Backend
- Java
- JavaSE
- JVM
---
# JVM VM Options

- `-Xms`:设置初始化内存分配大小，默认本机内存的1/64
- `-Xmx`:设置最大分配内存，默认本机内存的1/4
- `-XX:+PrintGCDetails`:打印GC垃圾回收信息
- `-XX:+HeapDumpOnOutOfMemoryError`生成oomDump文件

**实例**

```shell
-Xms1m -Xmx8m -XX:+HeapDumpOnOutOfMemoryError # 设置初始化内存 1M 最大内存 8M 输出 OOM 错误文件
-Xms1024m -Xmx1024m -XX:+PrintGCDetails # 设置初始化内存 1024M 最大内存 1024M 输出 GC 详细信息
```