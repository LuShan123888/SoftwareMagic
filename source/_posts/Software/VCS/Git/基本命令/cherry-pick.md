---
title: Git cherry-pick
categories:
- Software
- VCS
- Git
- 基本命令
---
# Git cherry-pick

**选择一个commit,合并进当前分支**

```shell
 $ git cherry-pick [commit]
```

- 假设 dev 分支上的提交 76d12 为 index.js 文件添加了一项修改，而希望将其整合到 master 分支中，但并不想要整个 dev 分支，而只需要这个提交

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-486f540aaf172d27349c217f87e9fba8.gif)

- 现在 master 分支包含 76d12 引入的修改了