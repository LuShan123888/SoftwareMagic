---
title: Git reflog
categories:
  - Software
  - DevOps
  - VCS
  - Git
  - 基本命令
---
# Git reflog

- reflog 是一个非常有用的命令，可以展示已经执行过的所有动作的日志，包括合并，重置，还原，基本上包含对分支所做的任何修改。

```shell
git reflog <commit-id>
```

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-I2AefJEHuZ5BCbo.gif)

- 如果犯了错，可以根据 reflog 提供的信息通过重置 HEAD 来轻松地重做。
- 假设实际上并不需要合并原有分支，当我们执行 git reflog 命令时，我们可以看到这个 repo 的状态在合并前位于 HEAD@{1}，那我们就执行一次 git reset，将 HEAD 重新指向在 HEAD@{1} 的位置。

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-JwAvN9GISlOoQUD-20200820130837647-20201210112841369.gif)

- 可以看到最新的动作已被推送给 reflog