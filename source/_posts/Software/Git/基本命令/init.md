---
title: Git init
categories:
- Software
- Git
- 基本命令
---
# Git init

- Git 使用 git init 命令来初始化一个 Git 仓库
- 在执行完成 git init 命令后,Git 仓库会生成一个 .git 目录,该目录包含了资源的所有元数据,其他的项目目录保持不变

- 使用当前目录作为Git仓库,我们只需使它初始化

```shell
git init
```

- 该命令执行完后会在当前目录生成一个 .git 目录
- 使用我们指定目录作为Git仓库

```shell
git init newrepo
```

- 初始化后,会在 newrepo 目录下会出现一个名为 .git 的目录,所有 Git 需要的数据和资源都存放在这个目录中