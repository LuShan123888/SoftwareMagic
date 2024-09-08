---
title: Git stash
categories:
  - Software
  - DevOps
  - VCS
  - Git
  - 基本命令
---
# Git stash

- 保存当前工作进度，会把暂存区和工作区的改动保存起来。

```shell
$ git stash
$ git stash save 'message' #添加一些注释。
```

##  list

- 显示保存进度的列表，也就意味着， `git stash` 命令可以多次执行。

```shell
$ git stash list
```

## pop

- 通过 git stash pop 命令恢复进度后，会删除当前进度。

```shell
$ git stash pop #恢复最新的进度到工作区，git默认会把工作区和暂存区的改动都恢复到工作区。
$ git stash pop <stash_id> #恢复指定的进度到工作区。
```

- `--index`：恢复最新的进度到工作区和暂存区， （尝试将原来暂存区的改动还恢复到暂存区）

## apply

- 除了不删除恢复的进度之外，其余和 `git stash pop` 命令一样。

```shell
$ git stash apply #恢复最新的进度到工作区，git默认会把工作区和暂存区的改动都恢复到工作区。
$ git stash apply <stash_id> #恢复指定的进度到工作区。
```

- `--index`：恢复最新的进度到工作区和暂存区， （尝试将原来暂存区的改动还恢复到暂存区）

## drop

- 删除一个存储的进度，如果不指定 stash_id，则默认删除最新的存储进度。

```shell
$ git stash drop [stash_id]
```

## clear

- 删除所有存储的进度。

```shell
$ git stash clears
```

