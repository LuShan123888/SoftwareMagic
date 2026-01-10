# SoftwareMagic

[简体中文](#简体中文) | [English](#english)

---

## 简体中文

一个基于 Hexo 的个人编程知识库博客，使用 Fluid 主题。文章从 Obsidian 笔记库同步，自动部署到 GitHub Pages。

### 功能特性

- 📝 **Hexo 驱动** - 快速、简洁的静态博客框架
- 🎨 **Fluid 主题** - 简洁优雅的 Material Design 风格主题
- 🔄 **自动同步** - 通过脚本从 Obsidian 笔记库自动同步文章
- 🚀 **自动部署** - Git pre-commit hook 触发自动构建和部署
- 🔍 **站内搜索** - 基于 hexo-generator-search 的全文搜索
- 🌓 **暗色模式** - 支持自动/手动切换暗色主题
- 📂 **自动分类** - 根据目录结构自动生成文章分类

### 快速开始

#### 环境要求

- **Node.js** >= 14
- **Git**

#### 安装

```bash
# 克隆仓库
git clone https://github.com/LuShan123888/SoftwareMagic.git
cd SoftwareMagic

# 安装依赖
npm install

# 启动本地开发服务器
npm run server
```

访问 http://localhost:4000 查看效果。

### 常用命令

```bash
# 本地开发服务器
npm run server

# 生成静态文件到 dist/ 目录
npm run build

# 清理缓存和生成的文件
npm run clean

# 部署到 GitHub Pages
npm run deploy
```

### 文章同步

博客文章通过 `front_matter.sh` 脚本从 Obsidian 笔记库同步：

```bash
./front_matter.sh
```

脚本功能：
1. 从 `~/Documents/Notes/` 复制 Software、Hardware、Internet 目录到 `source/_posts/`
2. 自动为每个 Markdown 文件生成 Hexo front-matter（title、categories）
3. 根据文件所在目录自动设置分类

同步后运行 `npm run build` 生成静态文件。

### 自动部署

项目配置了 Husky pre-commit hook，每次 git commit 时自动执行：

1. `hexo generate` - 生成静态文件
2. `hexo deploy` - 推送到 GitHub Pages 仓库

配置文件：`.husky/pre-commit`

### 项目结构

```
SoftwareMagic/
├── _config.yml           # Hexo 主配置
├── _config.fluid.yml     # Fluid 主题配置
├── front_matter.sh       # 文章同步脚本
├── package.json          # 项目依赖
├── scaffolds/            # 文章模板
├── source/               # 源文件目录
│   ├── _posts/          # 博客文章（从 Obsidian 同步）
│   ├── images/          # 图片资源
│   └── materials/       # 其他素材
├── dist/                # 生成的静态文件
├── categories/          # 分类页面
└── tags/                # 标签页面
```

### 配置说明

#### Permalink

文章 URL 格式设置为 `:title/`，即使用文章标题作为 URL。

#### 自动分类

使用 `hexo-auto-category` 插件，根据 `source/_posts/` 目录结构自动生成分类。

#### 部署配置

- **目标仓库**: `git@github.com:LuShan123888/SoftwareMagic.git`
- **部署分支**: `gh-pages`
- **域名**: https://softwaremagic.lushan.tech

### 主题定制

Fluid 主题配置文件为 `_config.fluid.yml`，主要定制项：

- 暗色模式支持
- 导航栏菜单
- 首页 Banner 配置
- 评论插件（Disqus）
- 代码高亮（highlight.js）
- 图片懒加载
- Mermaid 流程图支持

### 依赖

| 依赖 | 版本 | 用途 |
|------|------|------|
| `hexo` | ^5.0.0 | 静态站点生成器 |
| `hexo-theme-fluid` | ^1.8.7 | 主题 |
| `hexo-auto-category` | ^0.2.2 | 自动分类 |
| `hexo-generator-search` | ^2.4.0 | 站内搜索 |
| `hexo-deployer-git` | ^2.1.0 | Git 部署 |
| `hexo-renderer-markdown-it` | git+https | Markdown 渲染 |
| `husky` | ^9.0.11 | Git hooks |

### 许可证

MIT

---

## English

A personal programming knowledge base blog powered by Hexo with the Fluid theme. Articles are synced from an Obsidian vault and automatically deployed to GitHub Pages.

### Features

- 📝 **Hexo Powered** - Fast and concise static blog framework
- 🎨 **Fluid Theme** - Clean and elegant Material Design theme
- 🔄 **Auto Sync** - Automatically sync articles from Obsidian via script
- 🚀 **Auto Deploy** - Git pre-commit hook triggers build and deploy
- 🔍 **Site Search** - Full-text search via hexo-generator-search
- 🌓 **Dark Mode** - Support for auto/manual dark theme switching
- 📂 **Auto Categories** - Automatically generate categories from directory structure

### Quick Start

#### Requirements

- **Node.js** >= 14
- **Git**

#### Installation

```bash
# Clone repository
git clone https://github.com/LuShan123888/SoftwareMagic.git
cd SoftwareMagic

# Install dependencies
npm install

# Start local development server
npm run server
```

Visit http://localhost:4000 to view.

### Common Commands

```bash
# Local development server
npm run server

# Generate static files to dist/ directory
npm run build

# Clean cache and generated files
npm run clean

# Deploy to GitHub Pages
npm run deploy
```

### Article Sync

Blog articles are synced from Obsidian via `front_matter.sh`:

```bash
./front_matter.sh
```

Script features:
1. Copy Software, Hardware, Internet directories from `~/Documents/Notes/` to `source/_posts/`
2. Automatically generate Hexo front-matter (title, categories) for each Markdown file
3. Set categories based on file directory structure

Run `npm run build` after syncing to generate static files.

### Auto Deploy

Husky pre-commit hook is configured to run automatically on each git commit:

1. `hexo generate` - Generate static files
2. `hexo deploy` - Push to GitHub Pages repository

Config file: `.husky/pre-commit`

### Project Structure

```
SoftwareMagic/
├── _config.yml           # Hexo main config
├── _config.fluid.yml     # Fluid theme config
├── front_matter.sh       # Article sync script
├── package.json          # Project dependencies
├── scaffolds/            # Article templates
├── source/               # Source directory
│   ├── _posts/          # Blog posts (synced from Obsidian)
│   ├── images/          # Image resources
│   └── materials/       # Other materials
├── dist/                # Generated static files
├── categories/          # Category pages
└── tags/                # Tag pages
```

### Configuration

#### Permalink

Article URL format is set to `:title/`, using the article title as the URL.

#### Auto Category

Uses `hexo-auto-category` plugin to automatically generate categories from `source/_posts/` directory structure.

#### Deployment

- **Target Repository**: `git@github.com:LuShan123888/SoftwareMagic.git`
- **Deploy Branch**: `gh-pages`
- **Domain**: https://softwaremagic.lushan.tech

### Theme Customization

Fluid theme configuration is in `_config.fluid.yml`. Key customizations:

- Dark mode support
- Navigation menu
- Homepage Banner
- Comment plugin (Disqus)
- Code highlighting (highlight.js)
- Image lazy loading
- Mermaid diagram support

### Dependencies

| Dependency | Version | Purpose |
|------------|---------|---------|
| `hexo` | ^5.0.0 | Static site generator |
| `hexo-theme-fluid` | ^1.8.7 | Theme |
| `hexo-auto-category` | ^0.2.2 | Auto categories |
| `hexo-generator-search` | ^2.4.0 | Site search |
| `hexo-deployer-git` | ^2.1.0 | Git deployment |
| `hexo-renderer-markdown-it` | git+https | Markdown renderer |
| `husky` | ^9.0.11 | Git hooks |

### License

MIT
