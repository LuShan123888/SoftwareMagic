---
title: CSS position
categories:
  - Software
  - Language
  - CSS
  - 布局
---
# CSS position

## top

**属性定义及使用说明**

top 属性规定元素的顶部边缘，该属性定义了一个定位元素的上外边距边界与其包含块上边界之间的偏移。

对于相对定义元素，如果 top 和 bottom 都是 auto，其计算值则都是 0;如果其中之一为 auto，则取另一个值的相反数;如果二者都不是 auto,bottom 将取 top 值的相反数。

**注意**：如果 "position" 属性的值为 "static"，那么设置 "top" 属性不会产生任何效果。

**属性值**

| 值      | 描述                                               |
| :------ | :------------------------------------------------- |
| auto    | 默认值，通过浏览器计算上边缘的位置，               |
| %       | 设置以包含元素的百分比计的上边位置，可使用负值，   |
| length  | 使用 px,cm 等单位设置元素的上边位置，可使用负值， |
| inherit | 规定应该从父元素继承 top 属性的值，                |

## left

**属性定义及使用说明**

left 属性规定元素的左边缘，该属性定义了定位元素左外边距边界与其包含块左边界之间的偏移。

如果 "position" 属性的值为 "static"，那么设置 "left" 属性不会产生任何效果。

**属性值**

| 值      | 描述                                               |
| :------ | :------------------------------------------------- |
| auto    | 默认值，通过浏览器计算左边缘的位置，               |
| %       | 设置以包含元素的百分比计的左边位置，可使用负值，   |
| length  | 使用 px,cm 等单位设置元素的左边位置，可使用负值， |
| inherit | 规定应该从父元素继承 left 属性的值，               |

## right

**属性定义及使用说明**

对于 static 元素，为 auto;对于长度值，则为相应的绝对长度;对于百分比数值，为指定值;否则为 auto，对于相对定义元素，left 的计算值始终等于 right

right 属性规定元素的右边缘，该属性定义了定位元素右外边距边界与其包含块右边界之间的偏移。

**注意**：如果 "position" 属性的值为 "static"，那么设置 "right" 属性不会产生任何效果。

**属性值**

| 值      | 描述                                               |
| :------ | :------------------------------------------------- |
| auto    | 默认值，通过浏览器计算右边缘的位置，               |
| %       | 设置以包含元素的百分比计的右边位置，可使用负值，   |
| length  | 使用 px,cm 等单位设置元素的右边位置，可使用负值， |
| inherit | 规定应该从父元素继承 right 属性的值，              |

## bottom

**属性定义及使用说明**

对于绝对定位元素，bottom属性设置单位高于/低于包含它的元素的底边。

对于相对定位元素，bottom属性设置单位高于/低于其正常位置的元素的底边。

**注意**：如果"position:static"，底部的属性没有任何效果。

**说明**：对于 static 元素，为 auto;对于长度值，则为相应的绝对长度;对于百分比数值，为指定值;否则为 auto，对于相对定义元素，如果 bottom 和 top 都是 auto，其计算值则都是 0;如果其中之一为 auto，则取另一个值的相反数;如果二者都不是 auto,bottom 将取 top 值的相反数。

**属性值**

| 值      | 描述                                               |
| :------ | :------------------------------------------------- |
| auto    | 默认值，通过浏览器计算底部的位置，                 |
| %       | 设置以包含元素的百分比计的底边位置，可使用负值，   |
| length  | 使用 px,cm 等单位设置元素的底边位置，可使用负值， |
| inherit | 规定应该从父元素继承 bottom 属性的值，             |

## z-index

**属性定义及使用说明**

z-index 属性指定一个元素的堆叠顺序。

拥有更高堆叠顺序的元素总是会处于堆叠顺序较低的元素的前面。

**注意**:z-index 进行定位元素（position:absolute, position:relative, or position:fixed)

**属性值**

| 值       | 描述                                    |
| :------- | :-------------------------------------- |
| auto     | 默认，堆叠顺序与父元素相等，            |
| *number* | 设置元素的堆叠顺序，                    |
| inherit  | 规定应该从父元素继承 z-index 属性的值， |

## position

**属性定义及使用说明**

position属性指定一个元素（静态的，相对的，绝对或固定）的定位方法的类型。

**属性值**

| 值                                                           | 描述                                                         |
| :----------------------------------------------------------- | :----------------------------------------------------------- |
| [absolute](https://www.runoob.com/css/css-positioning.html#position-absolute) | 生成绝对定位的元素，相对于 static 定位以外的第一个父元素进行定位，元素的位置通过 "left", "top", "right" 以及 "bottom" 属性进行规定， |
| [fixed](https://www.runoob.com/css/css-positioning.html#position-fixed) | 生成固定定位的元素，相对于浏览器窗口进行定位，元素的位置通过 "left", "top", "right" 以及 "bottom" 属性进行规定， |
| [relative](https://www.runoob.com/css/css-positioning.html#position-relative) | 生成相对定位的元素，相对于其正常位置进行定位，因此，"left:20" 会向元素的 LEFT 位置添加 20 像素， |
| [static](https://www.runoob.com/css/css-positioning.html#position-static) | 默认值，没有定位，元素出现在正常的流中（忽略 top, bottom, left, right 或者 z-index 声明）, |
| [sticky](https://www.runoob.com/css/css-positioning.html#position-sticky) | 粘性定位，该定位基于用户滚动的位置，它的行为就像 position:relative; 而当页面滚动超出目标区域时，它的表现就像 position:fixed;，它会固定在目标位置，**注意**:Internet Explorer, Edge 15 及更早 IE 版本不支持 sticky 定位， Safari 需要使用 -webkit- prefix (查看以下实例）, |
| inherit                                                      | 规定应该从父元素继承 position 属性的值，                     |
| initial                                                      |                                                              |

