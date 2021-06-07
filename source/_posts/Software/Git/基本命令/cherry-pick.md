---
title: Git cherry-pick
categories:
- Software
- Git
- 基本命令
---
# Git cherry-pick

- 当一个特定分支包含活动分支需要的某个提交时,对那个提交执行 cherry-pick,对一个提交执行 cherry-pick 时,会在活动分支上创建一个新的提交,其中包含由拣选出来的提交所引入的修改

```shell
git cherry-pick 版本号
```

- 假设 dev 分支上的提交 76d12 为 index.js 文件添加了一项修改,而希望将其整合到 master 分支中,但并不想要整个 dev 分支,而只需要这个提交

![img](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-486f540aaf172d27349c217f87e9fba8.gif)

- 现在 master 分支包含 76d12 引入的修改了