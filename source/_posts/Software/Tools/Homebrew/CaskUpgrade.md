---
title: Homebrew Cask Upgrade
categories:
- Software
- Tools
- Homebrew
---
# Homebrew Cask Upgrade

- `Homebrew Cask`是 `Homebrew`的扩展，借助它可以方便地在 macOS 上安装图形接口进程，即我们常用的各类应用

## 安装

```shell
brew tap buo/cask-upgrade
```

## 命令

### Upgrade outdated apps:

```
brew cu
```

### Upgrade a specific app:

```
brew cu [CASK]
```

- It is also possible to use `*` to install multiple casks at once, i.e. `brew cu flash-*` to install all casks starting with `flash-` prefix.
