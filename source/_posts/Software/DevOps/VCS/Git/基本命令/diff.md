---
title: Git diff
categories:
  - Software
  - DevOps
  - VCS
  - Git
  - 基本命令
---
# Git diff

**显示暂存区和工作区的差异**

```shell
$ git diff
```

- `--cached`：使用暂存区与其他版本比较，如果未指定其他版本，比较暂存区和上一次提交（commit）的差异。
- `--stat`：查看简单的 diff 结果。
- `[<path>...]`：只比较单个文件的路径。
- `-shortstat "@{0 day ago}"`：显示今天你写了多少行代码。

**比较暂存区与指定 commit 的差异**

```shell
$ git diff <commit-id>
```

**比较两个 commit 之间的差异**

```shell
$ git diff [<commit-id>] [<commit-id>]
```

**制作补丁**

- patch 作用是当希望将本仓库工作区的修改拷贝一份到其他机器上使用，但是修改的文件比较多，拷贝量比较大，此时可以将修改的代码做成补丁。

```shell
$ git diff <patch_name>
```

- `--cached`：将暂存区与版本库的差异做成补丁。
- `--HEAD`：将工作区与版本库的差异做成补丁。
