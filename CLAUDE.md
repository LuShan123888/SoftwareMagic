# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

这是一个基于 Hexo 的静态博客项目，使用 Fluid 主题。文章从 Obsidian 笔记库同步而来，部署到 GitHub Pages。

## 开发命令

```bash
# 安装依赖
npm install

# 本地开发服务器（默认 http://localhost:4000）
npm run server

# 生成静态文件到 dist/ 目录
npm run build

# 清理缓存和生成的文件
npm run clean

# 部署到 GitHub Pages
npm run deploy
```

## 文章同步流程

博客文章不直接在 `source/_posts/` 中编辑，而是通过 `front_matter.sh` 脚本从 Obsidian 笔记库同步：

```bash
./front_matter.sh
```

该脚本会：
1. 从 `~/Documents/Notes/` 复制 Software、Hardware、Internet 目录到 `source/_posts/`
2. 自动为每个 Markdown 文件生成 Hexo front-matter（title、categories）
3. 根据文件所在目录自动设置分类

同步后运行 `npm run build` 生成静态文件。

## 自动部署

项目配置了 Husky pre-commit hook，每次 git commit 时自动执行：
1. `hexo generate` - 生成静态文件
2. `hexo deploy` - 推送到 GitHub Pages 仓库

配置文件：`.husky/pre-commit`

## 目录结构

- `_config.yml` - Hexo 主配置
- `_config.fluid.yml` - Fluid 主题配置
- `scaffolds/` - 文章模板
- `source/_posts/` - 博客文章（从 Obsidian 同步，不要直接编辑）
- `source/images/` - 图片资源
- `dist/` - 生成的静态文件（git tracked）
- `categories/`、`tags/` - 分类和标签页面

## 关键配置

- **Permalink**: `:title/`（文章标题作为 URL）
- **自动分类**: 根据 `source/_posts/` 目录结构自动生成（hexo-auto-category 插件）
- **部署目标**: `git@github.com:LuShan123888/SoftwareMagic.git` (gh-pages 分支)
- **域名**: https://softwaremagic.lushan.tech
