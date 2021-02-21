---
title: Webpack 整合Bootstrap
categories:
- Software
- Frontend
- Webpack
---
# Webpack 整合Bootstrap

## 安装

```bash
npm install --sava jquery popper.js bootstrap
```

## 配置

- `index.js`

```js
import 'bootstrap';
import "./style/style.scss"
```

- `style.scss`

```scss
@import "custom";
@import "~bootstrap/scss/bootstrap";
```

- `webpack.config.js`

```js
...
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
  ...
Pulgin[
    new webpack.ProvidePlugin({
        $: 'jquery',
        jQuery: 'jquery'
    }]
 ]
```

