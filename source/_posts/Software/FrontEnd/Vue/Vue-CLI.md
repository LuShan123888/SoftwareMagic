---
title: Vue Vue-CLI
categories:
- Software
- FrontEnd
- Vue
---
# Vue Vue-CLI

## 安装

```bash
npm install -g @vue/cli
# OR
yarn global add @vue/cli
```

- 查看版本。

```
vue --version
```

- 升级。

如需升级全局的 Vue CLI 包，请运行：

```bash
npm update -g @vue/cli
# OR
yarn global upgrade --latest @vue/cli
```

## 命令

### 创建一个项目

```
vue creare <项目名>
```

#### 使用图形化界面

```
vue ui
```

### 安装插件

- 在现有的项目中安装插件。

```
vue add <插件名>
```

## 全局 CLI 配置

- 有些针对 `@vue/cli` 的全局配置，例如你惯用的包管理器和你本地保存的 preset，都保存在 home 目录下一个名叫 `.vuerc` 的 JSON 文件，你可以用编辑器直接编辑这个文件来更改已保存的选项。

```json
{
    "latestVersion": "4.5.7",
    "lastChecked": 1602748738512,
    "presets": {},
    "packageManager": "yarn"
}
```

- `presets`：预设。
- `packageManager`：包管理器。

## vue.config.js

- `vue.config.js` 是一个可选的配置文件，如果项目的（和 `package.json` 同级的）根目录中存在这个文件，那么它会被 `@vue/cli-service` 自动加载，你也可以使用 `package.json` 中的 `vue` 字段，但是注意这种写法需要你严格遵照 JSON 的格式来写。

```js
const webpack = require('webpack')
module.exports = {
  // 基本路径 baseURL已经过时。
  publicPath: './',

  // 输出文件目录。
  outputDir: 'dist',

  // 放置生成的静态资源（js,css,img,fonts）的（相对于 outputDir 的）目录。
  assetsDir: 'static',

  // eslint-loader 是否在保存的时候检查。
  lintOnSave: false,

  //Webpack配置。
  configureWebpack: {
    plugins: [
        // 引入Jquery
      new webpack.ProvidePlugin({
        $: 'jquery',
        jQuery: 'jquery'
      })
    ]
  },

  // 生产环境是否生成 sourceMap 文件。
  productionSourceMap: true,

  // 是否为 Babel 或 TypeScript 使用 thread-loader，该选项在系统的 CPU 有多于一个内核时自动启用，仅作用于生产构建。
  parallel: require('os').cpus().length > 1,

  devServer: {
    open: process.platform === 'darwin',
    disableHostCheck: true,
    host: 'localhost',
    port: 8000,
    https: false,
    hotOnly: false,
    before: app => { },
    proxy: {
      '/api': {
        target: 'http://localhost:8080',
        changeOrigin: true, // 开启跨域。
        pathRewrite: { // 重写/api路径。
          '^/api': '/' // 重映射路径。
        }
      }
    }
  },
  transpileDependencies: [
    'vuetify'
  ]
}
```
