---
title: Webpack 整合Bootstrap
categories:
- Software
- FrontEnd
- Webpack
---
# Webpack 整合Bootstrap

## 安装

```bash
$ yarn add jquery popper.js bootstrap
```

## 配置

- `index.js`

```js
import 'bootstrap'
import "./styles/index.scss"
```

- `index.scss`

```scss
@import "style";
@import "~bootstrap/scss/bootstrap";
```

- `webpack.config.js`

```js
const webpack = require('webpack')

module.exports = {
    module: {
        rules: [
            {
                test: /\.(scss)$/,
                use: [{
                    loader: 'style-loader', // inject CSS to page
                }, {
                    loader: 'css-loader', // translates CSS into CommonJS modules
                }, {
                    loader: 'postcss-loader', // Run post css actions
                    options: {
                        plugins: function () { // post css plugins, can be exported to postcss.config.js
                            return [
                                require('autoprefixer')
                            ];
                        }
                    }
                }, {
                    loader: 'sass-loader' // compiles SASS to CSS
                }]
            },
        ],
        plugins: [
            new webpack.ProvidePlugin({
                $: 'jquery',
                jQuery: 'jquery'
            })
        ]
    },
};
```
