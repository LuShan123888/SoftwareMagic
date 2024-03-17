---
title: Git add
categories:
- Software
- VCS
- Git
- 基本命令
---
# Git add

**添加工作目录的文件放入暂存区**

```shell
git add [file1] [file2] ...
```

- `-A`:提交所有变化
- `-P`:添加每个变化前，都会要求确认，对于同一个文件的多处变化，可以实现分次提交

**添加所有工作目录的文件放入暂存区**

```shell
git add .
```