---
title: Git add
categories:
- Software
- Git
- 版本管理
---
# Git add

- 用于把工作目录的文件放入暂存区

```shell
git add 文件名
```

- 提交所有变化

```shell
git add -A
```

- 提交被修改(modified)和被删除(deleted)文件,不包括新文件(new)

```shell
git add -u
```

- 提交新文件(new)和被修改(modified)文件,不包括被删除(deleted)文件

```shell
git add .
```