---
title: Git reset
categories:
- Software
- VCS
- Git
- 基本命令
---
# Git reset

- 重置当前分支的 HEAD 为指定 commit

```shell
$ git reset [commit]
```

- `--soft`: 不修改暂存区域和工作目录
- `--hard`: 重置暂存区与工作区，与上一次 commit 保持一致
- `--mixed`: 重置暂存区，但工作区不变

**重置暂存区的指定文件，与上一次 commit 保持一致，但工作区不变**

```shell
$ git reset [file]
```
