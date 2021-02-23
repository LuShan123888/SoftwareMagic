---
title: CSS background
categories:
- Software
- Frontend
- CSS
- 样式属性
---
# CSS background

## background

**语法**

```css
background:bg-color bg-image position/bg-size bg-repeat bg-origin bg-clip bg-attachment initial|inherit;
```

**实例**

在一个div元素中设置多个背景图像(并指定他们的位置):

```css
body {     background: #00ff00 url('smiley.gif') no-repeat fixed center;  }
```

##  background-color

**标签定义及使用说明**

background-color属性设置一个元素的背景颜色,元素的背景是元素的总大小,包括填充和边界(但不包括边距)

**属性值**

| 值          | 描述                                                         |
| :---------- | :----------------------------------------------------------- |
| *color*     | 指定背景颜色,在[CSS颜色值](https://www.runoob.com/css/css-colors-legal.html)近可能的寻找一个颜色值的完整列表, |
| transparent | 指定背景颜色应该是透明的,这是默认                           |
| inherit     | 指定背景颜色,应该从父元素继承                               |

**实例**

设置不同元素的背景色:

```css
body
{
    background-color:yellow;
}
h1
{
    background-color:#00ff00;
}
p
{
    background-color:rgb(255,0,255);
}
```

## background-position

**标签定义及使用说明**

background-position属性设置背景图像的起始位置

**注意**对于这个工作在Firefox和Opera,background-attachment必须设置为 "fixed(固定)"

**属性值**

| 值                                                           | 描述                                                         |
| :----------------------------------------------------------- | :----------------------------------------------------------- |
| left top left center left bottom right top right center right bottom center top center center center bottom | 如果仅指定一个关键字,其他值将会是"center"                   |
| *x% y%*                                                      | 第一个值是水平位置,第二个值是垂直,左上角是0％0％,右下角是100％100％,如果仅指定了一个值,其他值将是50％, ,默认值为:0％0％ |
| *xpos ypos*                                                  | 第一个值是水平位置,第二个值是垂直,左上角是0,单位可以是像素(0px0px)或任何其他 [CSS单位](https://www.runoob.com/try/css-units.html),如果仅指定了一个值,其他值将是50％,你可以混合使用％和positions |
| inherit                                                      | 指定background-position属性设置应该从父元素继承              |

## background-size

**标签定义及使用说明**

background-size属性指定背景图片大小

```css
background-size: length|percentage|cover|contain;
```

| 值         | 描述                                                         |
| :--------- | :----------------------------------------------------------- |
| length     | 设置背景图片高度和宽度,第一个值设置宽度,第二个值设置的高度,如果只给出一个值,第二个是设置为 **auto**(自动) |
| percentage | 将计算相对于背景定位区域的百分比,第一个值设置宽度,第二个值设置的高度,如果只给出一个值,第二个是设置为"auto(自动)" |
| cover      | 此时会保持图像的纵横比并将图像缩放成将完全覆盖背景定位区域的最小大小, |
| contain    | 此时会保持图像的纵横比并将图像缩放成将适合背景定位区域的最大大小, |

## background-repeat

**标签定义及使用说明**

设置如何平铺对象的 background-image 属性

默认情况下,重复background-image的垂直和水平方向

**提示和注释**

**提示**:background-position属性设置背景图像位置,如果指定的位置是没有任何背景,图像总是放在元素的左上角

**属性值**

| 值        | 说明                                         |
| :-------- | :------------------------------------------- |
| repeat    | 背景图像将向垂直和水平方向重复,这是默认     |
| repeat-x  | 只有水平位置会重复背景图像                   |
| repeat-y  | 只有垂直位置会重复背景图像                   |
| no-repeat | background-image不会重复                     |
| inherit   | 指定background-repea属性设置应该从父元素继承 |

## background-origin

**标签定义及使用说明**

background-Origin属性指定background-position属性应该是相对位置

**注意**如果背景图像background-attachment是"固定",这个属性没有任何效果

**语法**

```css
background-origin: padding-box|border-box|content-box;
```

| 值          | 描述                       |
| :---------- | :------------------------- |
| padding-box | 背景图像填充框的相对位置   |
| border-box  | 背景图像边界框的相对位置   |
| content-box | 背景图像的相对位置的内容框 |

## background-clip

**标签定义及使用说明**

background-clip属性指定背景绘制区域

**语法**

```css
background-clip: border-box|padding-box|content-box;
```

| 值          | 说明                                             |
| :---------- | :----------------------------------------------- |
| border-box  | 默认值,背景绘制在边框方框内(剪切成边框方框), |
| padding-box | 背景绘制在衬距方框内(剪切成衬距方框),         |
| content-box | 背景绘制在内容方框内(剪切成内容方框),         |

## background-attachment

**标签定义及使用说明**

background-attachment设置背景图像是否固定或者随着页面的其余部分滚动

**属性值**

| 值      | 描述                                                |
| :------ | :-------------------------------------------------- |
| scroll  | 背景图片随着页面的滚动而滚动,这是默认的,          |
| fixed   | 背景图片不会随着页面的滚动而滚动,                  |
| local   | 背景图片会随着元素内容的滚动而滚动,                |
| initial | 设置该属性的默认值,                                |
| inherit | 指定 background-attachment 的设置应该从父元素继承, |

## background-image

**标签定义及使用说明**

background-image 属性设置一个元素的背景图像,元素的背景是元素的总大小,包括填充和边界(但不包括边距),默认情况下,background-image放置在元素的左上角,并重复垂直和水平方向

**提示**:请设置一种可用的背景颜色,这样的话,假如背景图像不可用,可以使用背景色带代替

**属性值**

| 值                          | 说明                                      |
| :-------------------------- | :---------------------------------------- |
| url(*'URL'*)                | 图像的URL                                 |
| none                        | 无图像背景会显示,这是默认                |
| linear-gradient()           | 创建一个线性渐变的 "图像"(从上到下)       |
| radial-gradient()           | 用径向渐变创建 "图像", (center to edges) |
| repeating-linear-gradient() | 创建重复的线性渐变 "图像",               |
| repeating-radial-gradient() | 创建重复的径向渐变 "图像"                 |
| inherit                     | 指定背景图像应该从父元素继承              |