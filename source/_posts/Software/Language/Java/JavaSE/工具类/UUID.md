---
title: Java UUID
categories:
- Software
- Language
- Java
- JavaSE
- 工具类
---
# Java UUID

## UUID.randomUUID

- 返回通用唯一识别码 (Universally Unique Identifier), 它保证对在同一时空中的所有机器都是唯一的，是由一个十六位的数字组成，表现出来的形式

**实例**

- 返回没有`-`的UUID字符串

```java
public class IDUtil {

    public static String genId(){
        return UUID.randomUUID().toString().replaceAll("-","");
    }
}
```
