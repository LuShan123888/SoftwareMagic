---
title: Git commit
categories:
- Software
- VCS
- Git
- 基本命令
---
# Git commit

- 用于把暂存区域的文件提交到Git仓库

```shell
git commit -m "提交说明"
```

- 将所有已跟踪文件中的执行修改或删除操作的文件都提交到本地仓库,即使它们没有经过git add添加到暂存区

```shell
git commit -a -m "massage”
```

- 执行下列命令,Git就会进入vim更正最近的一次提交说明

```shell
git commit --amend
```

- 如果不需要进入vim进行编辑,则使用下列命令

```shell
git commit --amend -m "更正的说明描述"
```

