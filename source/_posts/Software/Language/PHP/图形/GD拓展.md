---
title: PHP GD扩展
categories:
  - Software
  - Language
  - PHP
  - 图形
---
# PHP GD扩展

- 在用PHP来创建图像之前，你需要确保你的PHP安装无误，已经据北京了创建图片的能力，本章将讨论如何使用GD拓展，它允许PHP使用从http://www.boutell.com/gd/下载的开源GD图像库，从PHP4.3开始，PHP默认绑定了GD库（GD2.0或更高版本）
- 请载入我们熟悉的`phpinfo()`页面，并找到GD部分，你可能会找到一些类似下面所列的内容：

> gd
>
> GD Support			 enabled
>
> GD Version			  2.0 or higher
>
> FreeType Support	enabled
>
> FreeType Linkage    with freetype
>
> JPG Support			enabled
>
> PNG Support		   enabled
>
> WBMP Support		enabled

- 特别注意所列出的图像类型，那些就是PHP能生成的图像类型。
- 现在有3种主要的GD及其API的版本，在1.6版本之前的GD只支持GIF格式的图像，1.6之后的版本支持JPEG,PNG和WBMP，但不支持GIF(GIF图像格式受专利保护，需要授权）,2.x版的GD加入了一些新的绘图图元（draw primitive)
- 所有1.x版本的GD图像都只有8位颜色值，也就是说，用GD1.x生成或处理的图像最多只能包含256种颜色，如果是用来显示简单的图表或图形，256种颜色足够了，但是如果用来显示照片或其他需要256种以上颜色的图像时，它就无法令人满意，你可以将GD升级成2.x，或使用Imlib2库及其响应的PHP扩展来得到真彩色（true color）的支持，imlib2扩展的API和GD扩展的API不太一样。

