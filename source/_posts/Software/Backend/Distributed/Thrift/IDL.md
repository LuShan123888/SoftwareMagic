---
title: Thrift IDL
categories:
- Software
- Backend
- Distributed
- Thrift
---
# Thrift IDL

Thrift是一个典型的CS(客户端/服务端结构,客户端和服务端可以使用不同的语言开发,既然客户端和服务端能使用不同的语言开发,那么一定就要有一种中间语言来关联客户端和服务端的语言,这种语言就是IDL (Interface Description Language)

Thrift 采用IDL (Interface Definition Language) 来定义通用的服务接口,然后通过Thrift提供的编译器,可以将服务接口编译成不同语言编写的代码,通过这个方式来实现跨语言的功能

## 数据结构

### 基本类型(Base Types)

基本类型就是:不管哪一种语言,都支持的数据形式表现,Apache Thrift中支持以下几种基本类型:

| Type   | Desc                        | JAVA             | GO      |
| ------ | --------------------------- | ---------------- | ------- |
| 18     | 有符号的8位整数             | byte             | int8    |
| i16    | 有符号的16位整数            | float            | int16   |
| i32    | 有符号的32位整数            | int              | int32   |
| 164    | 有符号的64位整数            | long             | int64   |
| double | 64位浮点数                  | double           | float64 |
| bool   | 布尔值                      | boolean          | bool    |
| string | 文本字符串(UTF-8编码格式)| java.lang.String | string  |

### 特殊类型 (Special Types)

`binary`:未编码的字节序列,是string的一种特殊形式;这种类型主要是方便某些场景下JAVA调用.JAVA中对应的是`java.nio.ByteBuffer`类型,GO中是`[]byte`

### 集合容器 (Containers)

有3种可用容器类型:

| Type     | Desc                            | JAVA           | GO       | remark                  |
| -------- | ------------------------------- | -------------- | -------- | ----------------------- |
| list<T>  | 元素有序列表,允许重复           | java.util.List | []T      |                         |
| set<T>   | 元素无序列表,不允许重复         | java.util.Set  | []T      | GO没有set集合以数组代替 |
| map<K,V> | key-value结构数据,key不允许重复 | java.util.Map  | map[K] V |                         |

在使用容器类型时必须指定泛型,否则无法编译idl文件,其次,泛型中的基本类型,JAVA语言中会被替换为对应的包装类型

集合中的元素可以是除了service之外的任何类型,包括exception

```idl
struct Test {
    1: map<string,User> usermap,
    2: set<i32> intset,
    3: list<double> doublelist
}
```

### 常量及类型别名 (Const&&Typedef)

```idl
//常量定义
const i32 MALE_INT = 1
const map<i32,string> GENDER_MAP = {1:"male",2:"female"}
//某些数据类型比较长可以用别名简化
typedef map<i32,string> gmp T
```

### struct类型

在面向对象语言中，表现为"类定义",在弱类型语言、动态语言中，表现为"结构/结构体"。定义格式如下：

```idl
struct <结构体名称>{
	<序号>:[字段性质]＜字段类型＞＜字段名称＞[=<默认值>][;|,]
}
```

例如：

```idl
struct User{
	1: required string name, //该字段必须填写 
	2: optional i32 age = 0;//默认值
	3: bool gender //默认字段类型为optional
}
struct bean{
	1: i32 number=10,
	2: i64 bigNumber,
	3: double decimals,
	4: string name="thrifty"
}
```

struct有以下一些约束：

 	1. struct不能继承，但是可以嵌套，不能嵌套自己
 	2. 其成员都是有明确类型
 	3. 成员是被正整数编号过的，其中的编号使不能重复的，这个是为了在传输过程中编码使用
 	4. 成员分割符可以是逗号`,`或是分号`;`，而目可以混用
 	5. 字段会有optional和required之分和protobuf一样，但是如果不指定则为无类型——可以不填充该值，但是在序列化传输的时候也会序列化进去，optional是不填充则不序列化，required是必须填充也必须序列化
 	6. 每个字段可以设置默认值
 	7. 同一文件可以定义多个struct，也可以定义在不同的文件，进行include引入

### 枚举 (enum)

Thrift不支持枚举类嵌套,枚举常量必须是32位的正整数

```idl
enum Httpstatus{
	OK 200,
	NOTFOUND=404
}
```

### 异常 (Exceptions)

异常在语法和功能上类似于结构体，差别是异常使用关键字exception，而且异常是继承每种语言的基础异常类。

```idl
exception MyException {
	1: i32 errorCode
	2: string message
}

service ExampleService {
	string GetName () throws (1: MyException e)
}
```

## 服务定义

### Service（服务定义类型）

服务的定义方法在语义上等同于面向对象语言中的接口

```idl
service HelloService{
	i32 sayInt(1:i32 param)
	string sayString(1:string param)
    bool sayBoolean (1:bool param)
    void sayVoid()
}
```

编译后的lava代码

```java
public class HelloService {
    public interface Iface{
        public int sayInt(int param) throws org.apache.thrift.TException;
        public java.lang.string sayString(java. lang.String param) throws org.apache.thrift.TException;
        public boolean sayBoolean (boolean param) throws org.apache.thrift.TException;
        public void sayvoid() throws org.apache.thrift.TException;
    }
    // 省略很多代码
}
```

## Namespace(名字空间）

Thrift中的命名空间类似于C++中的namespace和java中的package，它们提供了一种组织（隔离）代码的简便方式。命名空间也可以用于解决类型定义中的命名冲突。由于每种语言均有自己的命名空间定义方式（如python中有module)，thrift允许开发者针对特定语言定义namespace。

```idl
namespace java com.example.test
```

转化成

```
package com.example.test
```

```idl
namespace java com.example.test // 命名空间定义，规范：namespace +语言 +包路径
service Hello{ //接口定义，类似Java接口定义
	string getword(), // 方法定义，类似Java接口定义
	void writewold(1:string words） //参数类型指定
}		
```

## Comment (注释）

Thrift支持C多行风格和Java/C++单行风格

```idl
/**
* This is multi-line comment.
* Just like in c.
*/
// C++/Java style single-line comments work just as well.
```

## Include

便于管理,重用和提高模块性/组织性,我们常常分割Thrift定义在不同的文件中,包含文件搜索方式与C++一样,Thrift允许文件包含其它 thrift文件,用户需要使用thrift文件名作为前缀访问被包含的对象

```idl
include "test.thrift"
	struct stSearchResult { 
	1: i32 uid;
	}
}
```

- thrift文件名要用双引号包含,末尾没有逗号或者分号

## IDL文件编译

IDL文件可以直接用来生成各种语言的代码，下面给出常用的各种不同语言的代码生成命令：

```bash
# 生成java
$ thrift -gen java test.thrift
# 生成c++
$ thrift -gen cpp test.thrift
# 生成php
$ thrift -gen php test.thrift
# 生成node.js
$ thrift -gen js:node test.thrift
#可以通过以下命令查看生成命令的格式
$ thrift -help
# 指定输出目录
$ thrift --gen java -o target test.thrift
```