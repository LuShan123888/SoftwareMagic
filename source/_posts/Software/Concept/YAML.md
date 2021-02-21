---
title: YAML
categories:
- Software
- Concept
---
# YAML

- YAML是 "YAML Ain't a Markup Language"(YAML不是一种标记语言)的递归缩写,在开发的这种语言时,YAML 的意思其实是:"Yet Another Markup Language"(仍是一种标记语言)

## 基础语法

- 空格不能省略
- 以缩进来控制层级关系,只要是左边对齐的一列数据都是同一个层级的
- 属性和值的大小写都是十分敏感的

```
字面量:普通的值  [ 数字,布尔值,字符串  ]
```

- 字面量直接写在后面就可以,字符串默认不用加上双引号或者单引号

```
k: v
```

**注意**

- `"` 双引号:会转义字符串里面的特殊字符,特殊字符会作为本身想表示的意思
    - 比如: `name: "hello \n world"`  输出:hello  换行  world
- `'`单引号:不会转义特殊字符,特殊字符最终会变成和普通字符一样输出
    - 比如:`name: ‘hello \n world’`输出:hello  \n  world

## 数据类型

### Map(键值对)

```yaml
k:
    v1:
    v2:
```

### 对象

```yaml
student:
    name: test
    age: 3

# 行内写法
student: {name: test,age: 3}
```

### 数组(List,set )

- 用`-`表示数组中的一个元素

```yaml
pets:
 - cat
 - dog
 - pig
```

- 行内写法

```yaml
pets: [cat,dog,pig]
```
