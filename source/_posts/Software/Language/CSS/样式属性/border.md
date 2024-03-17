---
title: CSS border
categories:
  - Software
  - Language
  - CSS
  - 样式属性
---
# CSS border

## border

**标签定义及使用说明**

缩写边框属性设置在一个声明中所有的边框属性。

```css
border : border-width, border-style,border-color.
```

**属性值**

| 值           | 说明                             |
| :----------- | :------------------------------- |
| border-width | 指定边框的宽度                   |
| border-style | 指定边框的样式                   |
| border-color | 指定边框的颜色                   |
| inherit      | 指定应该从父元素继承border属性值 |

## border-width

**属性定义及使用说明**

border-width属性设置一个元素的四个边框的宽度，此属性可以有一到四个值。

**实例**:

```css
border-width:thin medium thick 10px;
```

- 上边框是细边框。
- 右边框是中等边框。
- 下边框是粗边框。
- 左边框是 10px 宽的边框。

```css
border-width:thin medium thick;
```

- 上边框是细边框。
- 右边框和左边框是中等边框。
- 下边框是粗边框。

```css
border-width:thin medium;
```

- 上边框和下边框是细边框。
- 右边框和左边框是中等边框。

```css
border-width:thin;
```

- 所有4个边框都是细边框。

**属性值**

| 值      | 描述                           |
| :------ | :----------------------------- |
| thin    | 定义细的边框，                 |
| medium  | 默认，定义中等的边框，         |
| thick   | 定义粗的边框，                 |
| length  | 允许您自定义边框的宽度，       |
| inherit | 规定应该从父元素继承边框宽度， |

## border-style

**属性定义及使用说明**

border-style属性设置一个元素的四个边框的样式，此属性可以有一到四个值。

**属性值**

| 值      | 描述                                                         |
| :------ | :----------------------------------------------------------- |
| none    | 定义无边框，                                                 |
| hidden  | 与 "none" 相同，不过应用于表时除外，对于表，hidden 用于解决边框冲突， |
| dotted  | 定义点状边框，在大多数浏览器中呈现为实线，                   |
| dashed  | 定义虚线，在大多数浏览器中呈现为实线，                       |
| solid   | 定义实线，                                                   |
| double  | 定义双线，双线的宽度等于 border-width 的值，                 |
| groove  | 定义 3D 凹槽边框，其效果取决于 border-color 的值，           |
| ridge   | 定义 3D 垄状边框，其效果取决于 border-color 的值，           |
| inset   | 定义 3D inset 边框，其效果取决于 border-color 的值，         |
| outset  | 定义 3D outset 边框，其效果取决于 border-color 的值，        |
| inherit | 规定应该从父元素继承边框样式，                               |

## border-color

**属性定义及使用说明**

border-color属性设置一个元素的四个边框颜色，此属性可以有一到四个值。

**属性值**

| 值          | 说明                                                         |
| :---------- | :----------------------------------------------------------- |
| *color*     | 指定背景颜色，在[CSS颜色值](https://www.runoob.com/cssref/css-colors-legal.html)查找颜色值的完整列表 |
| transparent | 指定边框的颜色应该是透明的，这是默认                         |
| inherit     | 指定边框的颜色，应该从父元素继承                             |

## border-raids

**属性定义及使用说明**

border-radius 属性是一个最多可指定四个 border -*- radius 属性的复合属性。

**语法**

```css
border-radius: 1-4 length|% / 1-4 length|%;
```

**注意**：每个半径的四个值的顺序是：左上角，右上角，右下角，左下角，如果省略左下角，右上角是相同的，如果省略右下角，左上角是相同的，如果省略右上角，左上角是相同的。

**属性值**

| 值       | 描述                  |
| :------- | :-------------------- |
| *length* | 定义弯道的形状，      |
| *%*      | 使用%定义角落的形状， |

## border-image

**语法**

```css
border-image: source slice width outset repeat|initial|inherit;
```

**属性值**

| 值                  | 描述                                                         |
| :------------------ | :----------------------------------------------------------- |
| border-image-source | 用于指定要用于绘制边框的图像的位置                           |
| border-image-slice  | 图像边界向内偏移                                             |
| border-image-width  | 图像边界的宽度                                               |
| border-image-outset | 用于指定在边框外部绘制 border-image-area 的量                |
| border-image-repeat | 用于设置图像边界是否应重复（repeat)，拉伸（stretch)或铺满（round), |