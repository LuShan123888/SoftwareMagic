---
title: Git log
categories:
  - Software
  - VCS
  - Git
  - 基本命令
---
# Git log

**显示当前分支的版本历史**

 ```shell
 git log
 ```

- ` --decorate`：显示所有的引用，包括分支和标签。
- ` --oneline`：简短的显示快照。
- `--graph`：以图形化的方式显示。
- `--all`：显示所有的分支。
- `--stat`：显示 commit 历史，以及每次 commit 发生变更的文件。
- `--pretty=format:%s`：设置 log 格式，每个 commit 占据一行。
- `--grep`：显示某个 commit 之后的所有变动，其"提交说明"必须符合搜索条件。
- `-[num]`：显示过去 n 次提交。
- `[commit`]：显示某个 commit 之后的所有变动。

**搜索提交历史，根据关键词**

```shell
$ git log -S [keyword]
```

**显示某个文件的版本历史，包括文件改名**

```shell
$ git log --follow [file]
```

**显示指定文件相关的每一次 diff**

 ```bash
$ git log -p [file]
 ```

