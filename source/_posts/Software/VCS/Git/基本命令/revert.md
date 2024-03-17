---
title: Git revert
categories:
- Software
- VCS
- Git
- 基本命令
---
# Git revert

- 新建一个 commit, 用来撤销指定 commit, 后者的所有变化都将被前者抵消，并且应用到当前分支

```shell
$ git revert [commit]
```

- 假设 ec 5 be 添加了一个 index. js 文件，但之后我们发现其实我们再也不需要由这个提交引入的修改了，那就还原 ec 5 be 提交吧!

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-381df5ae9b3d97906e9235f3723f84a8.gif)

提交 9 e 78 i 还原了由提交 ec 5 be 引入的修改，在撤销特定的提交时, git revert 非常有用，同时也不会修改分支的历史