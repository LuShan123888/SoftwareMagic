---
title: CSS transform
categories:
- Software
- Language
- CSS
- 样式属性
---
# CSS transform

## transform

**属性定义及使用说明**

Transform属性应用于元素的2D或3D转换,这个属性允许你将元素旋转,缩放,移动,倾斜等

**语法**

```css
transform: none|*transform-functions*;
```

| 值                                                           | 描述                                    |
| :----------------------------------------------------------- | :-------------------------------------- |
| none                                                         | 定义不进行转换,                        |
| matrix(*n*,*n*,*n*,*n*,*n*,*n*)                              | 定义 2D 转换,使用六个值的矩阵,        |
| matrix3d(*n*,*n*,*n*,*n*,*n*,*n*,*n*,*n*,*n*,*n*,*n*,*n*,*n*,*n*,*n*,*n*) | 定义 3D 转换,使用 16 个值的 4x4 矩阵, |
| translate(*x*,*y*)                                           | 定义 2D 转换,                          |
| translate3d(*x*,*y*,*z*)                                     | 定义 3D 转换,                          |
| translateX(*x*)                                              | 定义转换,只是用 X 轴的值,             |
| translateY(*y*)                                              | 定义转换,只是用 Y 轴的值,             |
| translateZ(*z*)                                              | 定义 3D 转换,只是用 Z 轴的值,         |
| scale(*x*[,*y*]?)                                            | 定义 2D 缩放转换,                      |
| scale3d(*x*,*y*,*z*)                                         | 定义 3D 缩放转换,                      |
| scaleX(*x*)                                                  | 通过设置 X 轴的值来定义缩放转换,       |
| scaleY(*y*)                                                  | 通过设置 Y 轴的值来定义缩放转换,       |
| scaleZ(*z*)                                                  | 通过设置 Z 轴的值来定义 3D 缩放转换,   |
| rotate(*angle*)                                              | 定义 2D 旋转,在参数中规定角度,        |
| rotate3d(*x*,*y*,*z*,*angle*)                                | 定义 3D 旋转,                          |
| rotateX(*angle*)                                             | 定义沿着 X 轴的 3D 旋转,               |
| rotateY(*angle*)                                             | 定义沿着 Y 轴的 3D 旋转,               |
| rotateZ(*angle*)                                             | 定义沿着 Z 轴的 3D 旋转,               |
| skew(*x-angle*,*y-angle*)                                    | 定义沿着 X 和 Y 轴的 2D 倾斜转换,      |
| skewX(*angle*)                                               | 定义沿着 X 轴的 2D 倾斜转换,           |
| skewY(*angle*)                                               | 定义沿着 Y 轴的 2D 倾斜转换,           |
| perspective(*n*)                                             | 为 3D 转换元素定义透视视图,            |

**实例**

旋转 div 元素:

```css
div
{
    transform:rotate(7deg);
    -ms-transform:rotate(7deg); /* IE 9 */
    -webkit-transform:rotate(7deg); /* Safari and Chrome */
}
```

## transform-origin

**属性定义及使用说明**

- transform-Origin属性允许您更改转换元素的位置
- 2D转换元素可以改变元素的X和Y轴, 3D转换元素,还可以更改元素的Z轴
- 为了更好地理解Transform-Origin属性,请查看这个[演示](https://www.runoob.com/try/try.php?filename=trycss3_transform-origin_inuse).
- **注意**:使用此属性必须先使用 [transform](https://www.runoob.com/cssref/css3-pr-transform.html) 属性

**语法**

```css
transform-origin: *x-axis y-axis z-axis*;
```

| 值     | 描述                                                         |
| :----- | :----------------------------------------------------------- |
| x-axis | 定义视图被置于 X 轴的何处,可能的值:leftcenterright*length**%* |
| y-axis | 定义视图被置于 Y 轴的何处,可能的值:topcenterbottom*length**%* |
| z-axis | 定义视图被置于 Z 轴的何处,可能的值:*length*                |

**实例**

设置旋转元素的基点位置:

```css
div{
    transform: rotate(45deg);
    transform-origin:20% 40%;
    -ms-transform: rotate(45deg); /* IE 9 */
    -ms-transform-origin:20% 40%; /* IE 9 */
    -webkit-transform: rotate(45deg); /* Safari and Chrome */
    -webkit-transform-origin:20% 40%; /* Safari and Chrome */
}
```

## transform-style

**属性定义及使用说明**

- transform--style属性指定嵌套元素是怎样在三维空间中呈现
- **注意**:使用此属性必须先使用 [transform](https://www.runoob.com/cssref/css3-pr-transform.html) 属性

**语法**

```css
transform-style: flat|preserve-3d;
```

| 值          | 描述                           |
| :---------- | :----------------------------- |
| flat        | 表示所有子元素在2D平面呈现,   |
| preserve-3d | 表示所有子元素在3D空间中呈现, |