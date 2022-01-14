---
title: Vue 整合Jquery
categories:
- Software
- Frontend
- Vue
---
# Vue 整合Jquery

## 安装

```bash
$ yarn add jquery
```

## 配置

- `vue.config.js`

```js
const webpack = require('webpack')
module.exports = {
  //Webpack配置
  configureWebpack: {
    plugins: [
        // 引入Jquery
      new webpack.ProvidePlugin({
        $: 'jquery',
        jQuery: 'jquery'
      })
    ]
  }
}
```