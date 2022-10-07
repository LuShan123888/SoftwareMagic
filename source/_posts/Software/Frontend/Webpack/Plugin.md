---
title: Webpack Plugin
categories:
- Software
- FrontEnd
- Webpack
---
# Webpack Plugin

## BannerPlugin

**配置**

- `webpack.config.js`

```js
plugins: [
    new webpack.BannerPlugin('Copyright')
]
```

- 将版权信息写在括号中

**查看**

- 在dist中生成`bundle.js.LICENSE.txt`

```txt
/*! Copyright */
```

## HtmlWebpackPlugin

- 自动生成一个`index.html`文件(可以指定模板生成)
- 将打包的`bundle.js`,自动通过script标签插入到body中

**安装**

```bash
$ yarn add -D html-webpack-plugin
```

**配置**

- `webpack.config.js`

```js
const HtmlWebpackPlugin = require('html-webpack-plugin');
//...
plugins: [
    new HtmlWebpackPlugin({
        template: __dirname + "/src/index.tmpl.html"
    })
],
```

- `index.tmpl.html`

```html
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Webpack Sample Project</title>
    </head>
    <body>
        <div id='app'>
        </div>
    </body>
</html>
```

## UglifyJsPlugin

- 压缩JS代码
- webpack4以上只需要在配置文件中配置`mode: "development"`,即可自动开启

**配置**

```js
plugins: [
    new webpack.optimize.UglifyJsPlugin()
]
```

## OccurenceOrderPlugin

- 为组件分配ID,通过这个插件webpack可以分析和优先考虑使用最多的模块,并为它们分配最小的ID

**配置**

```js
plugins: [
    new webpack.optimize.OccurrenceOrderPlugin()
]
```

## ExtractTextPlugin

- 分离CSS和JS文件

**安装**

```bash
yarn add -D extract-text-webpack-plugin
```

**配置**

```js
const ExtractTextPlugin = require('extract-text-webpack-plugin');
//...
plugins: [
    new ExtractTextPlugin("style.css")
]
```

## CleanWebpackPlugin

- 打包时自动删除指定目录的文件

**安装**

```bash
yarn add -D clean-webpack-plugin
```

**配置**

```js
const CleanWebpackPlugin = require("clean-webpack-plugin");
plugins: [
    new CleanWebpackPlugin('build/*.*', {
        root: __dirname,
        verbose: true,
        dry: false
    })
]
```

## CopyWebpackPlugin

- 把静态资源都拷贝到构建目录

**安装**

```bash
yarn add -D copy-webpack-plugin
```

**配置**

```js
const CopyPlugin = require("copy-webpack-plugin");

module.exports = {
    plugins: [
        new CopyPlugin({
            patterns: [
                { from: "source", to: "dest" },
                { from: "other", to: "public" },
            ],
        }),
    ],
};
```

- `form`:相对于项目的路径
- `to`:相对于outputDir的路径
- 将`form`指定的文件或文件夹复制到`to`目录下
- 如果省略`to`,则默认为outputDir

## ProvidePlugin

**配置**

- 遇到或处理 `jQuery` 或 `$` 都会去自动加载 jquery 这个库

```js
new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery'
})
```

**调用**

```js
$('#item');
jQuery('#item');
```
