---
title: Git checkout
categories:
- Software
- VCS
- Git
- 基本命令
---
# Git checkout

## 还原文件

**恢复暂存区的所有文件到工作区**

```shell
$ git checkout
```

**恢复暂存区的指定文件到工作区**

```shell
$ git checkout --[file]
```

-   如果文件名不是分支名可省略--

**恢复某个commit的指定文件到暂存区和工作区**

```shell
$ git checkout [commit] [file]
```

## 分支操作

**切换到指定分支,并更新工作区**

 ```shell
 $ git checkout [branch-name]
 ```

**新建一个分支,并切换到该分支**

- git的分支其实就是添加一个指向快照的指针,切换分支除了修改 HEAD 指针的指向,还会改变暂存区域和工作目录的内容

```shell
git checkout -b [branch] [tag]
```

- `[tag]`:指向指定tag

### 匿名分支

```shell
git checkout <commit-id>
```

- 如果不指定分支名,而指定版本号, 那么git会自动帮你创建一个匿名分支，此时stage和workspace还原成该版本
- 此时HEAD指针是游离的，当你切换到别的分支时,这个匿名分支所做的所有操作提交都会被抛弃掉

### 基于匿名分支创建新分支

```bash
git checkout -b <commit-id>
```

### 创建孤立分支

```bash
git checkout --orphan <new_branch>
```

- 它会基于当前所在分支新建一个赤裸裸的分支, 没有任何的提交历史, 但是当前分支的内容一一俱全
- 新建的分支, 严格意义上说, 还不是一个分支, 因为HEAD指向的引用中没有commit值, 只有在进行一次提交后, 它才算得上真正的分支

**本地分支与远程分支关联**

- 本地新建一个分支名叫 `branch_name` ,会自动跟踪远程的同名分支 `branch_name`

```shell
git checkout --track origin/branch_name
```

