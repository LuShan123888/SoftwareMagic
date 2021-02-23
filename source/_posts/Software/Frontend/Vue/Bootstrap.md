---
title: Vue  整合Bootstrap
categories:
- Software
- Frontend
- Vue
---
# Vue  整合Bootstrap

## 安装

```bash
npm install --sava jquery popper.js bootstrap
```

## 配置

- `/main.js`

```js
import 'bootstrap'
import "./styles/index.scss"
```

- `/styles/index.scss`

```scss
@import "style";
@import "~bootstrap/scss/bootstrap";
```

- `/vue.config.js`

```js
const webpack = require('webpack')
module.exports = {
    configureWebpack: {
        plugins: [
            new webpack.ProvidePlugin({
                $: 'jquery',
                jQuery: 'jquery'
            })
        ]
    }
}
```

