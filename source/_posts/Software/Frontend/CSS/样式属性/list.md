---
title: CSS list
categories:
- Software
- Frontend
- CSS
- 样式属性
---
# CSS list

## list-style-image

**属性定义及使用说明**

list-style-image 属性使用图像来替换列表项的标记

**注意**:请始终规定一个 "list-style-type" 属性以防图像不可用

**属性值**

| 值      | 描述                                             |
| :------ | :----------------------------------------------- |
| *URL*   | 图像的路径,                                     |
| none    | 默认,无图形被显示,                             |
| inherit | 规定应该从父元素继承 list-style-image 属性的值, |

## list-style-position

**属性定义及使用说明**

list-style-position属性指示如何相对于对象的内容绘制列表项标记

<img src="https://cdn.jsdelivr.net/gh/LuShan123888/Files@master/Pictures/2020-12-10-E3EA5DE4-B898-450C-BE58-D2EBC1C70D8E.jpg" alt="img" style="zoom:33%;" />

**属性值**

| 值      | 描述                                                         |
| :------ | :----------------------------------------------------------- |
| inside  | 列表项目标记放置在文本以内,且环绕文本根据标记对齐,         |
| outside | 默认值,保持标记位于文本的左侧,列表项目标记放置在文本以外,且环绕文本不根据标记对齐, |
| inherit | 规定应该从父元素继承 list-style-position 属性的值,          |

## list-style-type

**属性定义及使用说明**

list-style-type 属性设置列表项标记的类型

**属性值**

| 值                   | 描述                                                        |
| :------------------- | :---------------------------------------------------------- |
| none                 | 无标记,                                                    |
| disc                 | 默认,标记是实心圆,                                        |
| circle               | 标记是空心圆,                                              |
| square               | 标记是实心方块,                                            |
| decimal              | 标记是数字,                                                |
| decimal-leading-zero | 0开头的数字标记,(01, 02, 03, 等,)                         |
| lower-roman          | 小写罗马数字(i, ii, iii, iv, v, 等,)                       |
| upper-roman          | 大写罗马数字(I, II, III, IV, V, 等,)                       |
| lower-alpha          | 小写英文字母The marker is lower-alpha (a, b, c, d, e, 等,) |
| upper-alpha          | 大写英文字母The marker is upper-alpha (A, B, C, D, E, 等,) |
| lower-greek          | 小写希腊字母(alpha, beta, gamma, 等,)                      |
| lower-latin          | 小写拉丁字母(a, b, c, d, e, 等,)                           |
| upper-latin          | 大写拉丁字母(A, B, C, D, E, 等,)                           |
| hebrew               | 传统的希伯来编号方式                                        |
| armenian             | 传统的亚美尼亚编号方式                                      |
| georgian             | 传统的乔治亚编号方式(an, ban, gan, 等,)                    |
| cjk-ideographic      | 简单的表意数字                                              |
| hiragana             | 标记是:a, i, u, e, o, ka, ki, 等,(日文平假名字符)       |
| katakana             | 标记是:A, I, U, E, O, KA, KI, 等,(日文片假名字符)       |
| hiragana-iroha       | 标记是:i, ro, ha, ni, ho, he, to, 等,(日文平假名序号)   |
| katakana-iroha       | 标记是:I, RO, HA, NI, HO, HE, TO, 等,(日文片假名序号)   |