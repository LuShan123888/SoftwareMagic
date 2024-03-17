---
title: CSS object
categories:
  - Software
  - Language
  - CSS
  - 样式属性
---
# CSS object

## object-fit

**标签定义及使用说明**

- object-fit 属性指定元素的内容应该如何去适应指定容器的高度与宽度。
- object-fit 一般用于 img 和 video 标签，一般可以对这些元素进行保留原始比例的剪切，缩放或者直接进行拉伸等。
- 可以通过使用 [object-position](https://www.runoob.com/cssref/pr-object-position.html）属性来切换被替换元素的内容对象在元素框内的对齐方式。

**语法**

```css
object-fit: fill|contain|cover|scale-down|none|initial|inherit;
```

**属性值**

| 值         | 描述                                                         | 尝试一下                                                     |
| :--------- | :----------------------------------------------------------- | :----------------------------------------------------------- |
| fill       | 默认，不保证保持原有的比例，内容拉伸填充整个内容容器，       | [尝试一下 »](https://www.runoob.com/try/try.php?filename=trycss3_object-fit2) |
| contain    | 保持原有尺寸比例，内容被缩放，                               | [尝试一下 »](https://www.runoob.com/try/try.php?filename=trycss3_object-fit2) |
| cover      | 保持原有尺寸比例，但部分内容可能被剪切，                     | [尝试一下 »](https://www.runoob.com/try/try.php?filename=trycss3_object-fit2) |
| none       | 保留原有元素内容的长度和宽度，也就是说内容不会被重置，       | [尝试一下 »](https://www.runoob.com/try/try.php?filename=trycss3_object-fit2) |
| scale-down | 保持原有尺寸比例，内容的尺寸与 none 或 contain 中的一个相同，取决于它们两个之间谁得到的对象尺寸会更小一些， | [尝试一下 »](https://www.runoob.com/try/try.php?filename=trycss3_object-fit2) |
| initial    | 设置为默认值，[关于 *initial*](https://www.runoob.com/cssref/css-initial.html) |                                                              |
| inherit    | 从该元素的父元素继承属性， [关于 *inherit*](https://www.runoob.com/cssref/css-inherit.html) |                                                              |

## object-position

**标签定义及使用说明**

- object-position 属性一般与 [object-fit](https://www.runoob.com/cssref/pr-object-fit.html）一起使用，用来设置元素的位置。
- object-position 一般用于 img 和 video 标签。

**语法**

```css
object-position: position|initial|inherit;
```

**属性值**

| 值         | 描述                                                         |      |
| :--------- | :----------------------------------------------------------- | ---- |
| *position* | 指定 image 或 video 在容器中的位置，第一个值为 x 坐标位置的值，第二个值为 y 坐标位置的值，表示的方式有：`object-position: 50% 50%; object-position: right top; object-position: left bottom; object-position: 250px 125px;` |      |
| initial    | 设置为默认值，[关于 *initial*](https://www.runoob.com/cssref/css-initial.html) |      |
| inherit    | 从该元素的父元素继承属性， [关于 *inherit*](https://www.runoob.com/cssref/css-inherit.html) |      |