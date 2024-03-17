---
title: CSS vh&vw
categories:
  - Software
  - Language
  - CSS
  - 布局
  - 响应式单位
---
# CSS vh&vw

- vw = view width
- vh = view height
- 这两个单位是CSS3引入的，以上称为**视口单位**允许我们更接近浏览器窗口定义大小。

## 视口单位（Viewport units)

- 在桌面端，视口指的是在桌面端，指的是浏览器的可视区域;而在移动端，它涉及3个视口：Layout Viewport(布局视口）,Visual Viewport(视觉视口）,Ideal Viewport(理想视口）
- 视口单位中的"视口”，桌面端指的是浏览器的可视区域;移动端指的就是Viewport中的Layout Viewport
    <img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-QBM61YZg8vqx7NE.jpg" alt="img" style="zoom:67%;" />

## vh/vw与%区别

| 单位  | 依赖于         |
| ----- | -------------- |
| %     | 元素的祖先元素 |
| vh/vw | 视口的尺寸     |

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-MX5GjOE2ackwKBY.jpg" alt="img" style="zoom:50%;" />

| 单位 | 解释                   |
| ---- | ---------------------- |
| vw   | 1vw = 视口宽度的1%     |
| vh   | 1vh = 视口高度的1%     |
| vmin | 选取vw和vh中最小的那个 |
| vmax | 选取vw和vh中最大的那个 |

> 比如：浏览器视口尺寸为370px，那么 1vw = 370px * 1% = 6.5px(浏览器会四舍五入向下取7)
