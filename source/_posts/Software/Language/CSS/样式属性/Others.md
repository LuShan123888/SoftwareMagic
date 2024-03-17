---
title: CSS 其他样式属性
categories:
  - Software
  - Language
  - CSS
  - 样式属性
---
# CSS 其他样式属性

## user-drag

```
user-drag:auto | element | none
```

- 默认值：auto
- 适用于：所有元素。
- 继承性：有。
- 动画性：否。
- 计算值：指定值。
- 取值：
  - auto：使用默认的拖拽行为，这种情况只有图片和链接可以被拖拽。
  - element：整个元素而非它的内容可拖拽。
  - none：元素不能被拖动，在通过选中后可拖拽。

**实例**

- 设置图片不可拖动。

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>css居中对齐</title>
    <style>
      div{
        width: 500px;
        height: 500px;
        border: 1px solid red;}

      img {
        -webkit-user-drag: none;
      }
    </style>
  </head>
  <body>
    <div>
      <img src="img/3.jpg">
    </div>
  </body>
</html>
```

