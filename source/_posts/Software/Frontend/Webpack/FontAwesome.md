---
title: Webpack 整合 Font Awesom5
categories:
- Software
- Frontend
- Webpack
---
# Webpack 整合 Font Awesom5

## 安装

```bash
npm i --save @fortawesome/fontawesome
npm i --save @fortawesome/fontawesome-free-solid
npm i --save @fortawesome/fontawesome-free-regular
npm i --save @fortawesome/fontawesome-free-brands
```

## 配置

- `index.js`

```js
import fontawesome from "@fortawesome/fontawesome";
import solid from "@fortawesome/fontawesome-free-solid";
import regular from "@fortawesome/fontawesome-free-regular";
import brands from "@fortawesome/fontawesome-free-brands";

fontawesome.library.add(solid);
fontawesome.library.add(regular);
fontawesome.library.add(brands);
```

## 导入使用

- `index.html`

```html
<i class="fas fa-check"></i>
```



