---
title: CSS zoom
categories:
- Software
- Frontend
- CSS
- 样式属性
---
# CSS zoom

**属性定义及使用说明**

cursor属性定义了鼠标指针放在一个元素边界范围内时所用的光标形状

- `zoom`  属性会根据 `@viewport` 来初始化一个缩放因数
- 当设置`1.0` 或 `100%`时表示不缩放,更大的值放大,更小的值缩小

**语法**

```css
/* Keyword value */
zoom: auto;

/* <number> values */
zoom: 0.8;
zoom: 2.0;

/* <percentage> values */
zoom: 150%;
```

| 值             | 描述                                                         |
| -------------- | ------------------------------------------------------------ |
| `auto`         | 根据`viewport`来既定当前标签的缩放,                          |
| `<number>`     | 必须是一个非负数,1表示没有缩放,大于1表示放大的倍数,小于1亦然, |
| `<percentage>` | 必须是一个非负的百分比,以100%为基础进行缩放,                 |