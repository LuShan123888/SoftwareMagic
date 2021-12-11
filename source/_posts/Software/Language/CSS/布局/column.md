---
title: CSS column
categories:
- Software
- Language
- CSS
- 布局
---
# CSS column

## column-count

**属性定义及使用说明**

column-count属性指定某个元素应分为的列数

**语法**

```css
column-count: number|auto;
```

| 值       | 说明                                       |
| :------- | :----------------------------------------- |
| *number* | 列的最佳数目将其中的元素的内容无法流出     |
| auto     | 列数将取决于其他属性,例如:"column-width" |

## column-fill

**属性定义及使用说明**

column-fill属性指定如何填充列

**语法**

```css
column-fill: balance|auto;
```

| 值      | 说明                                     |
| :------ | :--------------------------------------- |
| balance | 列长短平衡,浏览器应尽量减少改变列的长度 |
| auto    | 列顺序填充,他们将有不同的长度           |

## column-gap

**属性定义及使用说明**

column-gap的属性指定的列之间的差距

**注意**:如果指定了列之间的距离规则,它会取平均值

#### 语法

```css
column-gap: length|normal;
```

| 值       | 描述                                    |
| :------- | :-------------------------------------- |
| *length* | 一个指定的长度,将设置列之间的差距      |
| normal   | 指定一个列之间的普通差距, W3C建议1EM值 |

## column-rule

**属性定义及使用说明**

column-rule属性是一个速记属性设置所有column-rule-*属性,column-rule属性设置列之间的宽度,样式和颜色

**语法**

```css
column-rule: column-rule-width column-rule-style column-rule-color;
```

| 值                                                           | 说明                   |
| :----------------------------------------------------------- | :--------------------- |
| *[column-rule-width](https://www.runoob.com/cssref/css3-pr-column-rule-width.html)* | 设置列中之间的宽度规则 |
| *[column-rule-style](https://www.runoob.com/cssref/css3-pr-column-rule-style.html)* | 设置列中之间的样式规则 |
| *[column-rule-color](https://www.runoob.com/cssref/css3-pr-column-rule-color.html)* | 设置列中之间的颜色规则 |

## column-span

**属性定义及使用说明**

column-span属性指定某个元素应该跨越多少列

**语法**

```css
column-span: 1|all;
```

| 值   | 描述                 |
| :--- | :------------------- |
| 1    | 元素应跨越一列       |
| all  | 该元素应该跨越所有列 |

## column-width

**属性定义及使用说明**

column-width属性指定列的宽度

**语法**

```css
column-width: auto|length;
```

| 值       | 描述                 |
| :------- | :------------------- |
| auto     | 浏览器将决定列的宽度 |
| *length* | 指定列宽的长度       |
