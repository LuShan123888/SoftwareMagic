---
title: Git fetch
categories:
- Software
- VCS
- Git
- 基本命令
---
# Git fetch

- 如果有一个远程 Git 分支，比如在 GitHub 上的分支，当远程分支上包含当前分支没有的提交时，可以使用取回，比如当合并了另一个分支或你的同事推送了一个快速修复时
- 通过在这个远程分支上执行 git fetch,就可在本地获取这些修改，这不会以任何方式影响你的本地分支:fetch 只是单纯地下载新的数据而已

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-hVziLcuZmjHIS5D.gif)

**下载远程仓库的所有修改**

```shell
$ git fetch [remote]
```

- `--all`:取回所有主机的所有分支
- `--hard`:强制覆盖本地目录

**只取回特定分支的更新**

```shell
git fetch <远程主机名> <分支名>
```

