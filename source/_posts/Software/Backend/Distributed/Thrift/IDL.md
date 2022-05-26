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

## 基本类型(Base Types)

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

## 特殊类型 (Special Types)

`binary`:未编码的字节序列,是string的一种特殊形式;这种类型主要是方便某些场景下JAVA调用.JAVA中对应的是`java.nio.ByteBuffer`类型,GO中是`[]byte`

## 集合容器 (Containers)

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
    3: 1ist<double> doublelist
}
```

## 常量及类型别名 (Const&&Typedef)

```idl
//常量定义
const i32 MALE_INT = 1
const map<i32,string> GENDER_MAP = {1:"male",2:"female"}
//某些数据类型比较长可以用别名简化
typedef map<i32,string> gmp T
```



struct类型

选择语言