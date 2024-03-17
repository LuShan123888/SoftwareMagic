---
title: CSS box
categories:
- Software
- Language
- CSS
- 样式属性
---
# CSS box

## box-shadow

**属性定义及使用说明**

box-shadow属性可以设置一个或多个下拉阴影的框

**语法**

```css
box-shadow: h-shadow v-shadow blur spread color inset;


/*基础投影*/
box-shadow: 0 2px 4px rgba(0, 0, 0, .12), 0 0 6px rgba(0, 0, 0, .04);
/*浅色投影*/
box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
```

**注意**:boxShadow 属性把一个或多个下拉阴影添加到框上，该属性是一个用逗号分隔阴影的列表，每个阴影由 2-4 个长度值，一个可选的颜色值和一个可选的 inset 关键字来规定，省略长度的值是 0

| 值         | 说明                                                         |
| :--------- | :----------------------------------------------------------- |
| *h-shadow* | 必需的，水平阴影的位置，允许负值                             |
| *v-shadow* | 必需的，垂直阴影的位置，允许负值                             |
| *blur*     | 可选，模糊距离                                               |
| *spread*   | 可选，阴影的大小                                             |
| *color*    | 可选，阴影的颜色，在[CSS颜色值](https://www.runoob.com/cssref/css_colors_legal.aspx)寻找颜色值的完整列表 |
| inset      | 可选，从外层的阴影（开始时）改变阴影内侧阴影                 |

## box-sizing

**属性定义及使用说明**

- box-sizing 属性允许你以某种方式定义某些元素，以适应指定区域
- 例如，假如您需要并排放置两个带边框的框，可通过将 box-sizing 设置为 "border-box",这可令浏览器呈现出带有指定宽度和高度的框，并把边框和内边距放入框中

**语法**

```css
box-sizing: content-box|border-box|inherit:
```

| 值          | 说明                                                         |
| :---------- | :----------------------------------------------------------- |
| content-box | 这是 CSS2.1 指定的宽度和高度的行为，指定元素的宽度和高度（最小/最大属性）适用于box的宽度和高度，元素的填充和边框布局和绘制指定宽度和高度除外 |
| border-box  | 指定宽度和高度（最小/最大属性）确定元素边框，也就是说，对元素指定宽度和高度包括了 padding 和 border ,通过从已设定的宽度和高度分别减去边框和内边距才能得到内容的宽度和高度, |
| inherit     | 指定 box-sizing 属性的值，应该从父元素继承                   |