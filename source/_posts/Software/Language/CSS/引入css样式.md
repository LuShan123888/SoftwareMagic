---
title: CSS 引入Css样式
categories:
- Software
- Language
- CSS
---
# CSS 引入Css样式

## 嵌入样式表

利用这种方法定义的样式，优先级最好，但是其效果只能控制某个标签，所以比较适用于指定网页中，某个元素的样式，或某局部的样式

```html
<h3 style="font-size: 36px;font-family: FangSong,serif;">CSS嵌入样式表</h3>
```

## 内部样式表

```html
<style type="text/css">
    p {
        background: #4c7ba8;
        color: #99cc99;
        font-size: 25px;
        font-family: FangSong, sans-serif;
    }
</style>
```

##  导入外部样式表

```html
<style type="text/css">
    @import url(导入外部样式表.css);
</style>
```

## 嵌入外部样式表

```html
<head>
    <link rel="stylesheet" type="text/css" href="嵌入外部样式表">
</head>
```

