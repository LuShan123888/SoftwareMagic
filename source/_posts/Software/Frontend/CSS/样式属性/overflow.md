---
title: CSS overflow
categories:
- Software
- Frontend
- CSS
- 样式属性
---
# CSS overflow

**属性定义及使用说明**

overflow属性指定如果它溢出了元素的内容区是否剪辑内容

**语法**

```css
overflow : visible|hidden|scroll|auto|no-display|no-content;
```

**属性值**

| 值         | 描述                                   |
| :--------- | :------------------------------------- |
| visible    | 不裁剪内容,可能会显示在内容框之外,   |
| hidden     | 裁剪内容 - 不提供滚动机制,            |
| scroll     | 裁剪内容 - 提供滚动机制,              |
| auto       | 如果溢出框,则应该提供滚动机制,       |
| no-display | 如果内容不适合内容框,则删除整个框,   |
| no-content | 如果内容不适合内容框,则隐藏整个内容, |