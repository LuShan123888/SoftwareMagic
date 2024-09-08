---
title: Git branch
categories:
  - Software
  - DevOps
  - VCS
  - Git
  - 基本命令
---
# Git branch

**查看分支**

```shell
$ git branch
```

- `-a`：列出所有本地分支和远程分支。
- `-r`：列出所有远程分支。

**新建一个分支，但依然停留在当前分支**

```shell
$ git branch [branch-name]
```

**新建一个分支，指向指定 commit**

```shell
$ git branch [branch] [commit]
```

**新建一个分支，与指定的远程分支建立追踪关系**

```shell
$ git branch --track [branch] [remote-branch]
```

**删除分支**

```shell
git branch -d [branch-name]
```

**删除远程分支**

```shell
$ git branch -dr [remote/branch]
```

**重命名分支**

```bash
git branch -m [branch-name]
```

**建立追踪关系，在现有分支与指定的远程分支之间**

```shell
$ git branch --set-upstream [branch] [remote-branch]
```

