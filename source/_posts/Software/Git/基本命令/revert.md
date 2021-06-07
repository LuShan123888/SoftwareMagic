---
title: Git revert
categories:
- Software
- Git
- 基本命令
---
# Git revert

- 通过对特定的提交执行还原操作,创建一个包含已还原修改的新提交

```shell
git revert 版本号
```

- 假设 ec5be 添加了一个 index.js 文件,但之后我们发现其实我们再也不需要由这个提交引入的修改了,那就还原 ec5be 提交吧!

![img](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-381df5ae9b3d97906e9235f3723f84a8.gif)

提交 9e78i 还原了由提交 ec5be 引入的修改,在撤销特定的提交时,git revert 非常有用,同时也不会修改分支的历史