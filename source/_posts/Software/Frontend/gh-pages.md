---
title: gh-pages
categories:
- Software
- Frontend
---
# gh-pages

- Publish files to a `gh-pages` branch on GitHub (or any other branch anywhere else).

## 安装

```bash
yarn add gh-pages --save-dev
```

## 配置package.json

```json
"scripts": {
  "deploy": "gh-pages -d dist"
}
```

- `-d`:需要上传到github的目录

## 使用

```bash
yarn deploy
```

