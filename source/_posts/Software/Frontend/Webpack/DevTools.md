---
title: Webpack Dev Tools
categories:
- Software
- Frontend
- Webpack
---
# Webpack Dev Tools

## Webpack Dev Server

### 安装

```bash
$ yarn add -D webpack-dev-server
```

### 配置

- `webpack.config.js`

```json
devServer: {
    contentBase: "./public",
    port: 8000,
    stats: { colors: true },
    historyApiFallback: true,
    inline: true,
    hot: true,
}
```

- `contentBase`:本地服务器所加载的页面所在的目录
- `stats`:`colors: true`,终端中输出结果为彩色
- `historyApiFallback`:在SPA页面中,依赖HTML5的history模式
- `inline`:当源文件改变时会自动刷新页面
- `hot`:webpack 的模块热替换特性

- `package.json`

```json
"scripts": {
    "build": "webpack",
    "server": "webpack serve"
},
```

### 启动

```bash
yarn server
```

## Source Map

- 开发总是离不开调试,方便的调试能极大的提高开发效率,不过有时候通过打包后的文件,你是不容易找到出错了的地方,对应的你写的代码的位置的,`Source Maps`就是来帮我们解决这个问题的
- 通过简单的配置,`webpack`就可以在打包时为我们生成的`source maps`,这为我们提供了一种对应编译文件和源文件的方法,使得编译后的代码可读性更高,也更容易调试
- 在`webpack`的配置文件中配置`source maps`,需要配置`devtool`,它有以下四种不同的配置选项,各具优缺点,描述如下:

| devtool选项                    | 配置结果                                                     |
| ------------------------------ | ------------------------------------------------------------ |
| `source-map`                   | 在一个单独的文件中产生一个完整且功能完全的文件,这个文件具有最好的`source map`,但是它会减慢打包速度,|
| `cheap-module-source-map`      | 在一个单独的文件中生成一个不带列映射的`map`,不带列映射提高了打包速度,但是也使得浏览器开发者工具只能对应到具体的行,不能对应到具体的列(符号),会对调试造成不便,|
| `eval-source-map`              | 使用`eval`打包源文件模块,在同一个文件中生成干净的完整的`source map`,这个选项可以在不影响构建速度的前提下生成完整的`sourcemap`,但是对打包后输出的JS文件的执行具有性能和安全的隐患,在开发阶段这是一个非常好的选项,在生产阶段则一定不要启用这个选项,|
| `cheap-module-eval-source-map` | 这是在打包文件时最快的生成`source map`的方法,生成的`Source Map` 会和打包后的`JavaScript`文件同行显示,没有列映射,和`eval-source-map`选项具有相似的缺点,|

- 正如上表所述,上述选项由上到下打包速度越来越快,不过同时也具有越来越多的负面作用,较快的打包速度的后果就是对打包后的文件的的执行有一定影响
- 对小到中型的项目中,`eval-source-map`是一个很好的选项,再次强调你只应该开发阶段使用它,我们继续对上文新建的`webpack.config.js`,进行如下配置:

```js
devtool: 'eval-source-map'
```

- **注意**:`cheap-module-eval-source-map`方法构建速度更快,但是不利于调试,推荐在大型项目考虑时间成本时使用

