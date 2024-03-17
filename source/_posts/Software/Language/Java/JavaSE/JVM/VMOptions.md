---
title: JVM VM Options
categories:
- Software
- Language
- Java
- JavaSE
- JVM
---
# JVM VM Options

- `-Xms`:设置初始化内存分配大小，默认本机内存的1/64
- `-Xmx`:设置最大分配内存，默认本机内存的1/4
- `-XX:+HeapDumpOnOutOfMemoryError`生成oomDump文件
- -Xmn — 堆中年轻代的大小
- -XX:-DisableExplicitGC — 让System.gc()不产生任何作用
- -XX:+PrintGCDetails — 打印GC的细节
- -XX:+PrintGCDateStamps — 打印GC操作的时间戳
- -XX:NewSize / XX:MaxNewSize — 设置年轻代大小/年轻代最大大小
- -XX:NewRatio — 可以设置老生代和年轻代的比例
- -XX:PrintTenuringDistribution — 设置每次年轻代GC后输出幸存者乐园中对象年龄的分布
- -XX:InitialTenuringThreshold / -XX:MaxTenuringThreshold:设置老年代阀值的初始值和最大值
- -XX:TargetSurvivorRatio:设置幸存区的目标使用率

**实例**

```shell
-Xms1m -Xmx8m -XX:+HeapDumpOnOutOfMemoryError # 设置初始化内存 1M 最大内存 8M 输出 OOM 错误文件
-Xms1024m -Xmx1024m -XX:+PrintGCDetails # 设置初始化内存 1024M 最大内存 1024M 输出 GC 详细信息
```