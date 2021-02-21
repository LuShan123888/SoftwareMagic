---
title: Vue Vue-CLI
categories:
- Software
- Frontend
- Vue
---
# Vue Vue-CLI

## 安装

```bash
npm install -g @vue/cli
# OR
yarn global add @vue/cli
```

- 查看版本

```
vue --version
```

- 升级

如需升级全局的 Vue CLI 包,请运行:

```bash
npm update -g @vue/cli
# OR
yarn global upgrade --latest @vue/cli
```

## 命令

### 创建一个项目

#### 命令行

```
vue creare <项目名>
```

#### 使用图形化界面

```
vue ui
```

### 插件

- 在现有的项目中安装插件

```
vue add <插件名>
```

## 配置文件

- `~/.vuerc`

```json
{
  "useTaobaoRegistry": true,
  "presets": {},
  "latestVersion": "4.5.7",
  "lastChecked": 1602748738512,
  "packageManager": "yarn"
}
```

- `presets`:预设
- `packageManager`:包管理器