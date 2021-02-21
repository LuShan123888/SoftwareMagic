---
title: Git reset
categories:
- Software
- Git
- 版本管理
---
# Git reset

- git reset能让让我们可以控制 HEAD 应该指向的位置

## 软重置

```shell
git reset --soft HEAD~[~...]
```

- 移动HEAD的指向,将其指向上一个快照

- 不修改暂存区域和工作目录

软重置会将 HEAD 移至指定的提交(或与 HEAD 相比的提交的索引),而不会移除该提交之后加入的修改!

假设不想保留添加了一个 style.css 文件的提交 9e78i,而且也不想保留添加了一个 index.js 文件的提交 035cc,但是,又想要保留新添加的 style.css 和 index.js 文件!这是软重置的一个完美用例

![img](https://cdn.jsdelivr.net/gh/LuShan123888/Files@master/Pictures/2020-12-10-BZY9n3d4hTvziXu.gif)

输入 git status 后,会看到仍然可以访问在之前的提交上做过的所有修改,这很好,这意味着可以修复这些文件的内容,之后再重新提交它们!

## 硬重置

```shell
git reset --hard HEAD~[~...]
```

- 移动过HEAD的指向,将其指向上一个快照
- 将HEAD移动后指向的快照回滚到暂存区域
- 将暂存区域的文件还原到工作目录

有时候并不想保留特定提交引入的修改,不同于软重置,应该再也无需访问它们,Git 应该直接将整体状态直接重置到特定提交之前的状态:这甚至包括在工作目录中和暂存文件上的修改

![img](https://cdn.jsdelivr.net/gh/LuShan123888/Files@master/Pictures/2020-12-10-kzpT9Smq8v3QZRb.gif)

Git 丢弃了 9e78i 和 035cc 引入的修改,并将状态重置到了 ec5be 的状态

##  --mixed

```shell
git reset --mixed HEAD~[~...]
```

- 移动HEAD的指向,将其指向上一个快照
- 将HEAD移动后指向的快照回滚到暂存区域
- 可在HEAD~后加数字选择返回指定数目的快照

## 根据版本快照ID号reset

```shell
git reset 版本快照的ID号(前5位即可)
```

- 回滚指定快照
- 不仅可以往回滚,还可以往前滚

##  reset文件

```shell
git reset HEAD~[~...]/版本快照的ID号(前5位即可) 文件名/路径
```

- 回滚指定文件
- 只有mixed