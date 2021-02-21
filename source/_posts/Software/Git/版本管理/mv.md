---
title: Git mv
categories:
- Software
- Git
- 版本管理
---
# Git mv

- 使用git命令移动工作区的文件

```shell
git mv 旧文件名 新文件名
```

- 上述命令等同于:

```shell
ren/mv 旧文件名 新文件名
git rm 旧文件名
git add 新文件名
```

