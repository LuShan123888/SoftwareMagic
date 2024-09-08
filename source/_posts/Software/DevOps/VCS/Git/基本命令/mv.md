---
title: Git mv
categories:
  - Software
  - DevOps
  - VCS
  - Git
  - 基本命令
---
# Git mv

- 改名文件，并且将这个改名放入暂存区。

```shell
$ git mv [file-original] [file-renamed]
```

- 上述命令等同于：

```shell
rename/mv 旧文件名新文件名。
git rm 旧文件名。
git add 新文件名。
```

