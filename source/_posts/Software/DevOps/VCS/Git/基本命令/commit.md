---
title: Git commit
categories:
  - Software
  - DevOps
  - VCS
  - Git
  - 基本命令
---
# Git commit

**提交暂存域的文件修改**

```shell
git commit [file1] [file2] -m "提交说明"
```

- `-m`：提交说明。
- `-a`：提交工作区自上次 commit 之后的变化，直接到仓库区。
- `--amend`：重做上一次 commit，并包括指定文件的新变化。
- `-v`：提交时显示所有 diff 信息。
- 将所有已跟踪文件中的执行修改或删除操作的文件都提交到本地仓库，即使它们没有经过 git add 添加到暂存区。

