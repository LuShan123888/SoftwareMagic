---
title: Git rm
categories:
- Software
- VCS
- Git
- 基本命令
---
# Git rm

- 删除工作区文件，并且将这次删除放入暂存区

```shell
$ git rm [file1] [file2] ...
```

- `-f`: 在当工作目录域暂存区的文件不一样时，仍然删除这两个文件
- `--cached`:停止追踪指定文件，但该文件会保留在工作区
- `-r`:删除文件夹及其子目录

