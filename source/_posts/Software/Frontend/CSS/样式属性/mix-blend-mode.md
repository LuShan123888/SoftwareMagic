---
title: CSS mix-blend-mode
categories:
- Software
- Frontend
- CSS
- 样式属性
---
# CSS mix-blend-mode

**标签定义及使用说明**

mix-blend-mode 属性描述了元素的内容应该与元素的直系父元素的内容和元素的背景如何混合

**语法**

```css
mix-blend-mod:  <blend-mode>
```

`<blend-mode>` 的值可以是以下几个:

```css
mix-blend-mode: normal;
mix-blend-mode: multiply;
mix-blend-mode: screen;
mix-blend-mode: overlay;
mix-blend-mode: darken;
mix-blend-mode: lighten;
mix-blend-mode: color-dodge
mix-blend-mode: color-burn;
mix-blend-mode: hard-light;
mix-blend-mode: soft-light;
mix-blend-mode: difference;
mix-blend-mode: exclusion;
mix-blend-mode: hue;
mix-blend-mode: saturation;
mix-blend-mode: color;
mix-blend-mode: luminosity;
```

多个值可以使用逗号隔开

## 实例

各种混合模式实例:

```css
.normal {mix-blend-mode: normal;}
.multiply {mix-blend-mode: multiply;}
.screen {mix-blend-mode: screen;}
.overlay {mix-blend-mode: overlay;}
.darken {mix-blend-mode: darken;}
.lighten {mix-blend-mode: lighten;}
.color-dodge {mix-blend-mode: color-dodge;}
.color-burn {mix-blend-mode: color-burn;}
.difference {mix-blend-mode: difference;}
.exclusion {mix-blend-mode: exclusion;}
.hue {mix-blend-mode: hue;}
.saturation {mix-blend-mode: saturation;}
.color {mix-blend-mode: color;}
.luminosity {mix-blend-mode: luminosity;}
```