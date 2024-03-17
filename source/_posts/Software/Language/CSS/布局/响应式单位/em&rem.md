---
title: CSS em&rem
categories:
  - Software
  - Language
  - CSS
  - 布局
  - 响应式单位
---
# CSS em&rem

## em(相对长度单位)

- 浏览器的默认字体都是16px，那么1em=16px，以此类推计算12px=0.75em,10px=0.625em,2em=32px

- 这样使用很复杂，很难很好的与px进行对应，也导致书写，使用，视觉的复杂(0.75em,0.625em全是小数点)

- 为了简化font-size的换算，我们在body中写入一下代码。

```css
body {font-size: 62.5%;  } /*  公式16px*62.5%=10px  */
```

这样页面中1em=10px,1.2em=12px,1.4em=14px,1.6em=16px，使得视觉，使用，书写都得到了极大的帮助。

**例如**:

```html
<div class="font1" style='font-size:1.6em'>我是1.6em</div>
```

**运行效果**:

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-hDvlcgFTAaq5R2V.png)

**缺点**:

- em的值并不是固定的;

- em会继承父级元素的字体大小（参考物是父元素的font-size;);

- em中所有的字体都是相对于父元素的大小决定的;所以如果一个设置了font-size:1.2em的元素在另一个设置了font-size:1.2em的元素里，而这个元素又在另一个设置了font-size:1.2em的元素里，那么最后计算的结果是1.2X1.2X1.2=1.728em

**例如**:

```html
<div class="big">
    我是大字体。
   <div class="small">我是小字体</div>
</div>
```

样式为。

```html
<style>
     body {font-size: 62.5%; } /*  公式：16px*62.5%=10px  */
    .big{font-size: 1.2em}
    .small{font-size: 1.2em}
</style>
```

但运行结果small的字体大小为：1.2em*1.2em=1.44em

**运行结果**:

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-ewCYWoGiMTHhlus.png)

**宽度高度也是同理**

## rem(相对长度单位)

- 浏览器的默认字体都是16px，那么1rem=16px，以此类推计算12px=0.75rem,10px=0.625rem,2rem=32px;

- 这样使用很复杂，很难很好的与px进行对应，也导致书写，使用，视觉的复杂(0.75rem,0.625em全是小数点) ;

- 为了简化font-size的换算，我们在根元素html中加入font-size: 62.5%;

```css
html {font-size: 62.5%;  } /*  公式16px*62.5%=10px  */
```

这样页面中1rem=10px,1.2rem=12px,1.4rem=14px,1.6rem=16px;使得视觉，使用，书写都得到了极大的帮助;

**例如**:

```css
<div class="font1" style='font-size:1.6rem'>我是1.6rem=16px</div>
```

**运行结果**:

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-PXMxFtm6VCWk7sD.png)

**特点**:

- rem单位可谓集相对大小和绝对大小的优点于一身。

- 和em不同的是rem总是相对于根元素（如：root{})，而不像em一样使用级联的方式来计算尺寸，这种相对单位使用起来更简单。

- rem支持IE9及以上，意思是相对于根元素html(网页)，不会像em那样，依赖于父元素的字体大小，而造成混乱，使用起来安全了很多。

**例如**:

```html
<div class="big">
    我是14px=1.4rem<div class="small">我是12px=1.2rem</div>
</div>
```

样式为：

```css
<style>
    html {font-size: 10px;  } /*  公式16px*62.5%=10px  */
    .big{font-size: 1.4rem}
    .small{font-size: 1.2rem}
</style>
```

**运行结果**:

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-nKrYJt45FoVcPXf.png)

**注意**:

- 值得注意的浏览器支持问题： IE8,Safari 4或 iOS 3.2中不支持rem单位。
- 如果你的用户群都使用最新版的浏览器，那推荐使用rem，如果要考虑兼容性，那就使用px，或者两者同时使用。

