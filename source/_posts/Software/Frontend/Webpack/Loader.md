---
title: Webpack Loader
categories:
- Software
- FrontEnd
- Webpack
---
# Webpack Loader

- Webpack使用多个Loader时，从右向左加载

## css-loader与style-loader

- `css-loader` 会对 `@import` 和 `url()` 进行处理，就像 js 解析 `import/require()` 一样
- `stype-loader`将模块导出的内容作为样式并添加到 DOM 中
- 二者组合在一起使你能够把样式表嵌入webpack打包后的JS文件中

**安装**

```bash
$ yarn add -D css-loader style-loader
```

**配置**

- `webpack.config.js`

```js
module.exports = {
    module: {
        rules: [
            {
                test: /\.css$/i,
                use: [
                    'style-loader',
                    {
                        loader: 'css-loader',
                        options: {
                            modules: true,
                            localIdentName: '[name]__[local]--[hash:base64:5]'
                        }
                    }
                ],
            },
        ],
    },
};
```

- `modules`:是否启用css modules
- ` localIdentName`:指定css的类名格式

**导入**

- `index.js`

```js
import css from "style.css";
```

### 使用CSS Modules定义类名

- 相同的类名也不会造成不同组件之间的污染
- `style.css`

```css
.className {
    color: green;
}
```

- `index.js`

```js
import styles from "./style.css";
// import { className } from "./style.css";

element.innerHTML = '<div class="' + styles.className + '">';
```

## sass-loader

- 加载 Sass/SCSS 文件并将他们编译为 CSS

**安装**

```bash
$ yarn add -D sass-loader sass
```

**配置**

- `webpack.config.js`

```js
module.exports = {
    module: {
        rules: [
            {
                test: /\.s[ac]ss$/i,
                use: [
                    "style-loader",
                    "css-loader",
                    "sass-loader"
                ],
            },
        ],
    },
};
```

1. 将 Sass 编译成 CSS
2. 将 CSS 转化成 CommonJS 模块
3. 将 JS 字符串生成为 style 节点

**导入**

- `index.js`

```js
import "./style.scss";
```

### 解析 import 的规则

- Webpack 提供一种 [解析文件的高级机制](https://webpack.docschina.org/concepts/module-resolution/)
- `sass-loader` 使用 Sass 提供的 custom importer 特性，将所有 query 传递给 Webpack 解析引擎，只要在包名前加上 `~`,告诉 Webpack 这不是一个相对路径，这样就可以从 `node_modules` 中 import 自己的 Sass 模块了:

```scss
@import "~bootstrap";
```

- **注意**:只在前面加上 `~`,因为`~/` 将会解析到用户的主目录(home directory)
- 因为 CSS 和 Sass 文件没有用于导入相关文件的特殊语法，所以 Webpack 需要区分 `bootstrap` 和 `~bootstrap`
-  `@import "style.scss"` 和 `@import "./style.scss";` 两种写法是相同的

## less-loader

- webpack 将 Less 编译为 CSS 的 loader

**安装**

```bash
$ yarn add -D less less-loader
```

**配置**

- `webpack.config.js`

```js
module.exports = {
    module: {
        rules: [
            {
                test: /\.s[ac]ss$/i,
                use: [
                    "style-loader",
                    "css-loader",
                    "less-loader"
                ],
            },
        ],
    },
};
```

1. 将 Less 编译成 CSS
2. 将 CSS 转化成 CommonJS 模块
3. 将 JS 字符串生成为 style 节点

**导入**

- `index.js`

```js
import "./style.less";
```

## postcss-loader

- 对CSS增强，可以安装丰富的插件

**安装**

```bash
$ yarn add -D postcss-loader postcss
```

**插件安装**

```bash
$ yarn add -D autoprefixer postcss-preset-env
```

- `autoprefixer`:动态添加浏览器前缀，提高兼容性
- `postcss-preset-env`:转换现代CSS以兼容大多数浏览器

**配置**

- `webpack.config.js`

```js
module.exports = {
    module: {
        rules: [
            {
                test: /\.css$/i,
                use: [
                    "style-loader",
                    "css-loader",
                    {
                        loader: "postcss-loader",
                        options: {
                            postcssOptions: {
                                plugins: [
                                    [
                                        "postcss-preset-env",
                                        {
                                            // 其它选项
                                        },
                                    ],
                                    [
                                        "autoprefixer",
                                        {
                                            // 其它选项
                                        },
                                    ]
                                ]
                                ],
                            },
                        },
                    },
                ],
            },
        ],
    },
};
```

- `postcss.config.js`

```js
module.exports = {
    plugins: [
        "autoprefixer": {},
        "postcss-preset-env": {}
    ]
}
```

**导入**

```js
import css from "style.css";
```

## babel-loader

**安装**

```bash
$ yarn add -D babel-loader @babel/core @babel/preset-env
```

**配置**

- `webpack.config.js`

```js
module: {
    rules: [
        {
            test: /\.m?js$/,
            exclude: /node_modules/,
            use: {
                loader: 'babel-loader',
                options: {
                    presets: [
                        ['@babel/preset-env', { targets: "defaults" }]
                    ]
                }
            }
        }
    ]
}
```

- 或者使用`~/.babelrc`

```json
{
    "presets": ['@babel/preset-env', { targets: "defaults" }]
}
```

### 手动执行Babel

**全局安装**

```bash
$ yarn global add babel-cli
```

**转码结果写入一个文件**

- `--out-file`或`-o`参数指定输出目录

```shell
babel src/example.js --out-file dist1/compiled.js
#或者
babel src/example.js -o dist1/compiled.js
```

 **整个目录转码**

- `--out-dir`或`-d`参数指定输出目录

```bash
babel src --out-dir dist2
# 或者
babel src -d dist2
```

## file-loader

- 将文件保存至输出文件夹中并返回（相对)URL

**安装**

```bash
$ yarn add -D file-loader
```

**配置**

```js
module.exports = {
    module: {
        rules: [
            {
                test: /\.(png|jpe?g|gif)$/i,
                use: [
                    {
                        loader: 'file-loader',
                        options: {
                            name: '[name].[ext]?[hash:8]',
                            outputPath: 'static/images/'
                        }
                    }
                ],
            },
        ],
    },
};
```

- `name`:导出的文件名
- `outputPath`:导出的路径

**导入**

```js
import img from './file.png';
```

## url-loader

- 将图片转换成base64的URIs
- 如果文件大小小于一个设置的值，则会转换为base64
- 如果文件大小大于一个设置的值，则会使用`file-loader`

**安装**

```bash
$ yarn add -D url-loader file-loader
```

**配置**

- `webpack.config.js`

```js
module.exports = {
    module: {
        rules: [
            {
                test: /\.(png|jpg|gif)$/i,
                use: [
                    {
                        loader: 'url-loader',
                        options: {
                            limit: 8192,
                            name: '[name].[ext]?[hash:8]',
                            outputPath: 'static/images/'
                        },
                    },
                ],
            },
        ],
    },
};
```

- `limit`:当加载的图片大小指定大小时才进行转换，单位为B
- `name`:导出的文件名
- `outputPath`:导出的路径

**导入**

- `index.js`

```js
import img from './image.png';
```

- `style.css`

```css
body{
    background-image: url("../assets/bg1.png");
}
```

## html-withimg-loader

html中直接使用img标签src加载图片的话，因为没有被依赖，图片将不会被打包，这个loader解决这个问题，图片会被打包，而且路径也处理妥当，额外提供html的include子页面功能

**安装**

```bash
$ yarn add -D html-withimg-loader
```

**配置**

```js
module: {
    rules: [
        {
            test: /\.(png|jpg|gif|jpeg|svg)$/i,
            use: [
                {
                    loader: 'url-loader',
                    options: {
                        limit: 8192,
                        name: '[name].[ext]?[hash:8]',
                        outputPath: 'static/img/',
                        esModule: false,
                    }
                }
            ],
        },
        {
            test: /\.(html)$/,
            loader: 'html-withimg-loader'
        }
    ]
},
```

- `esModule`:默认为true,图片打包后的默认路径带default对象