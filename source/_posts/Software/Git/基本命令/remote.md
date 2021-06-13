---
title: Git remote
categories:
- Software
- Git
- 基本命令
---
# Git remote

## 绑定远程仓库

```shell
git remote add origin https://github.com/用户名/仓库名.git
```

## Git 本地分支与远程分支关联

**如果远程新建了一个分支,本地没有该分支**

- 可以利用 `git checkout --track origin/branch_name` ,这时本地会新建一个分支名叫 `branch_name` ,会自动跟踪远程的同名分支 `branch_name`

```shell
git checkout --track origin/branch_name
```

**如果本地新建了一个分支,但是在远程没有**

- 这时候 push 和 pull 指令就无法确定该跟踪谁,一般来说我们都会使其跟踪远程同名分支
- 所以可以利用 `git push --set-upstream origin branch_name` ,这样就可以自动在远程创建一个 `branch_name` 分支,然后本地分支会 track 该分支,后面再对该分支使用 push 和 pull 就自动同步

```shell
git push --set-upstream origin branch_name
```

