---
title: Markdown Mermaid
categories:
- Software
- Markdown
---
# Markdown Mermaid

## Graph

```
graph LR
    A --> B
```

![这里写图片描述](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-03-17-006tNbRwgy1gb6eetirmmj3095037jr5.jpg)

- 这是申明一个由左到右,水平向右的图
- 可能方向有:
    - TB - top bottom
    - BT - bottom top
    - RL - right left
    - LR - left right
    - TD - same as TB

#### 节点与形状

###### 默认节点

> graph LR
> id1

![  ](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-03-17-006tNbRwgy1gb6ef20jloj30df02i741.jpg)

- **注意**:`id`显示在节点内部

###### 文本节点

![这里写图片描述](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-03-17-006tNbRwgy1gb6eet11ecj30dh02mt8i.jpg)

```
graph LR
id[This is the text in the box];1212
```

###### 圆角节点

![这里写图片描述](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-03-17-006tNbRwgy1gb6eevxiwhj309302qgle.jpg)

```
graph LR
id(This is the text in the box);1212
```

###### 圆节点(The form of a circle)

![这里写图片描述](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-03-17-006tNbRwgy1gb6eeslcu3j30a8070q2r.jpg)

```
graph LR
id((This is the text in the circle));1212
```

###### 非对称节点(asymetric shape)

![这里写图片描述](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-03-17-006tNbRwgy1gb6ef0jxx0j3094031mwy.jpg)

```
graph LR
id>This is the text in the box]1212
```

###### 菱形节点(rhombus)

![这里写图片描述](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-03-17-006tNbRwgy1gb6eeqv0oqj309y06rglf.jpg)

```
graph LR
id{This is the text in the box}1212
```

#### 连接线

节点间的连接线有多种形状,而且可以在连接线中加入标签:

###### 箭头形连接

![这里写图片描述](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-03-17-006tNbRwgy1gb6ef05braj306i038jr5.jpg)

```
graph LR;
  A-->B;1212
```

###### 开放行连接

![img](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-03-17-006tNbRwgy1gb6eexe53xj307y037gld.jpg)

```
graph LR
A --- B1212
```

###### 标签连接

![这里写图片描述](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-03-17-006tNbRwgy1gb6ef2i4mvj3096033q2q.jpg)

```
graph LR
A -- This is the label text --- B;1212
```

###### 箭头标签连接

> A–>|text|B\
> 或者\
> A– text –>B

![这里写图片描述](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-03-17-006tNbRwgy1gb6eeuffzlj308y03kt8h.jpg)

```
graph LR
 A-- text -->B1212
```

###### 虚线(dotted link,点连线)

> -.->

![这里写图片描述](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-03-17-006tNbRwgy1gb6eewfy0wj3086035q2p.jpg)

```
graph LR
A-.->B1212
```

> -.-.

![这里写图片描述](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-03-17-006tNbRwgy1gb6eexurx2j306j02tjr5.jpg)

```
graph LR
A-.-.B1212
```

###### 标签虚线

> -.text.->

```
graph LR
A-.text.->B1212
```

![这里写图片描述](https://tva1.sinaimg.cn/large/006tNbRwgy1gb6ef1iuszj308a03awe9.jpg)

###### 粗实线

> ==>

```
graph LR
A==>B1212
```

![这里写图片描述](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-03-17-006tNbRwgy1gb6ees3g4nj306z03kmwx.jpg)

> ===

```
graph LR
A===B1212
```

![这里写图片描述](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-03-17-006tNbRwgy1gb6eeuwa41j307r02njr5.jpg)

###### 标签粗线

> =\=text\==>

```
graph LR
A==text==>B1212
```

![这里写图片描述](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-03-17-006tNbRwgy1gb6ef2wr2yj307m03b0si.jpg)

> =\=text\===

```
graph LR
A==text===B1212
```

![这里写图片描述](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-03-17-006tNbRwgy1gb6eevd27dj308303ct8h.jpg)

#### 特殊的语法

##### 使用引号可以抑制一些特殊的字符的使用,可以避免一些不必要的麻烦

> graph LR\
> d1["This is the (text) in the box”]

```
graph LR
d1["This is the (text) in the box"]1212
```

![这里写图片描述](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-03-17-006tNbRwgy1gb6eeu03bcj309h02yq2q.jpg)

##### html字符的转义字符

转义字符的使用语法:
流程图定义如下:

> graph LR\
> A["A double quote:#quot;”] –> B["A dec char:#9829;”]

渲染后的图如下:

![这里写图片描述](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-03-17-006tNbRwgy1gb6eeydnxvj30ep02odfn.jpg)

```
graph LR
        A["A double quote:#quot;"]-->B["A dec char:#9829;"]1212
```

#### 子图(Subgraphs)

> subgraph title\
> graph definition\
> end

示例:

```{mermaid}
graph TB
        subgraph one
        a1 --> a2
        en
        subgraph two
        b2 --> b2
        end
        subgraph three
        c1 --> c2
        end
        c1 --> a212345678910111234567891011
```

结果:

![这里写图片描述](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-03-17-006tNbRwgy1gb6eezr54zj30d106raa0.jpg)

#### 基础fontawesome支持

如果想加入来自frontawesome的图表字体,需要像frontawesome网站上那样引用的那样,\
详情请点击:[fontawdsome](http://fontawesome.io/)

引用的语法为:++fa:#icon class name#++

```{mermaid}
graph TD
      B["fa:fa-twitter for peace"]
      B-->C[fa:fa-ban forbidden]
      B-->D(fa:fa-spinner);
      B-->E(A fa:fa-camerra-retro perhaps?);1234512345
```

渲染图如下:

```
graph TD
      B["fa:fa-twitter for peace"]
      B-->C[fa:fa-ban forbidden]
      B-->D(fa:fa-spinner);
      B-->E(A fa:fa-camera-retro perhaps?);1234512345
```

![这里写图片描述](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-03-17-006tNbRwgy1gb6eermif1j30cw05rjr9.jpg)

以上reference:
1.[mermaid docs](https://knsv.github.io/mermaid/#initialization)

### 第二部分—图表(graph)

##### 定义连接线的样式

```{mermaid}
graph LR
     id1(Start)-->id2(Stop)
     style id1 fill:#f9f,stroke:#333,stroke-width:4px;
     style id2 fill:#ccf,stroke:#f66,stroke-width:2px,stroke-dasharray:5,5;12341234
```

渲染结果:

![这里写图片描述](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-03-17-006tNbRwgy1gb6ef10719j30bi031t8i.jpg)

```
graph LR
     id1(Start)-->id2(Stop)
     style id1 fill:#f9f,stroke:#333,stroke-width:4px;
     style id2 fill:#ccf,stroke:#f66,stroke-width:2px,stroke-dasharray:5,5;12341234
```

备注:这些样式参考CSS样式

##### 样式类

为了方便样式的使用,可以定义类来使用样式
类的定义示例:

```
classDef className fill:#f9f,stroke:#333,stroke-width:4px;11
```

对节点使用样式类:

```
class nodeId className;11
```

同时对多个节点使用相同的样式类:

```
class nodeId1,nodeId2 className;11
```

可以在CSS中提前定义样式类,应用在图表的定义中

```{mermaid}
graph LR
      A-->B[AAABBB];
      B-->D;
      class A cssClass;12341234
```

默认样式类:当没有指定样式的时候,默认采用

```
classDef default fill:#f9f,stroke:#333,stroke-width:4px;11
```

示例:

```{mermaid}
graph LR
    classDef default fill:#f90,stroke:#555,stroke-width:4px;
    id1(Start)-->id2(Stop)123123
```

结果:

```
graph LR
classDef default fill:#f90,stroke:#555,stroke-width:4px;
id1(Start)-->id2(Stop)123123
```

![这里写图片描述](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-03-17-006tNbRwgy1gb6eewxchfj309k034mwy.jpg)