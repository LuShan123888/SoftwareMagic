---
title: Vue 整合Axios
categories:
- Software
- Frontend
- Vue
---
# Vue 整合Axios

## 安装

```bash
yarn add  axios vue-axios
```

## 配置

- `/main.js`

```js
import axios from 'axios'
import VueAxios from 'vue-axios'

Vue.use(VueAxios, axios)
```

- 在组件中使用

```vue
<template>
<div class="home">
    {{ info }
    </div>
</template>
<script>
    export default {
        data: function () {
            return {
                info: null,
            };
        },
        mounted() {
            this.axios
                .get("https://api.coindesk.com/v1/bpi/currentprice.json")
                .then((response) => (this.info = response));
        },
    };
</script>
```

