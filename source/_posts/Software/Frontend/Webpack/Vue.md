---
title: Webpack 整合Vue
categories:
- Software
- FrontEnd
- Webpack
---
# Webpack 整合Vue

## 安装

```bash
$ yarn add  vue vue-loader vue-style-loader vue-template-compiler
```

## 配置

- `webpack.config.js`

```js
const VueLoaderPlugin = require('vue-loader/lib/plugin')

module.exports = {
    mode: 'development',
    module: {
        rules: [
            {
                test: /\.vue$/,
                loader: 'vue-loader'
            },
            // 它会应用到普通的 `.js` 文件
            // 以及 `.vue` 文件中的 `<script>` 块
            {
                test: /\.js$/,
                loader: 'babel-loader'
            },
            // 它会应用到普通的 `.css` 文件
            // 以及 `.vue` 文件中的 `<style>` 块
            {
                test: /\.css$/,
                use: [
                    'vue-style-loader',
                    'css-loader'
                ]
            }
        ]
    },
    plugins: [
        new VueLoaderPlugin()
    ]
}
```

## 导入测试

- `index.js`

```js
import Vue from 'vue'
import App from './App.vue'

new Vue({
    el: '#app',
    render: h => h(App)
})
```

- `App.vue`

```vue
<template>
<div id="app">
    <h1 class="title">{{ message }}</h1>
    </div>
</template>

<script>
    export default {
        name: "App",
        data() {
            return {
                message: "Hello Vue-Webpack"
            };
        }
    };
</script>
<style scoped>
    .title{
        color: blue;
    }
</style>
```

