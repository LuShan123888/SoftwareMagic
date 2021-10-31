---
title: Git merge
categories:
- Software
- VCS
- Git
- 基本命令
---
# Git merge

```shell
git merge 分支名
```

## Fast-forward (—ff)

在当前分支相比于要合并的分支没有额外的提交(commit)时,可以执行 fast-forward 合并,Git 很懒,首先会尝试执行最简单的选项:fast-forward,这类合并不会创建新的提交,而是会将正在合并的分支上的提交直接合并到当前分支

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-0a0431c992211561f14ee66f1cf0ea89.gif)

## No-fast-foward (—no-ff)

如果当前分支相比于想要合并的分支没有任何提交,那当然很好,但很遗憾现实情况很少如此!如果在当前分支上提交想要合并的分支不具备的改变,那么 git 将会执行 no-fast-forward 合并

使用 no-fast-forward 合并时,Git 会在当前活动分支上创建新的 merging commit,这个提交的父提交(parent commit)即指向这个活动分支,也指向想要合并的分支

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-d5be0dfa20f8a7c57f99f2b48b521bda.gif)

## 合并冲突

- 尽管 Git 能够很好地决定如何合并分支以及如何向文件添加修改,但它并不总是能完全自己做决定,当想要合并的两个分支的同一文件中的同一行代码上有不同的修改,或者一个分支删除了一个文件而另一个分支修改了这个文件时,Git 就不知道如何取舍了
- 在这样的情况下,Git 会询问你想要保留哪种选择?假设在这两个分支中,都编辑了 README.md 的第一行

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-6f061d950a7b02084d40e06b1e4b74d5552cc8cc.jpeg)

- 如果想把 dev 合并到 master,就会出现一个合并冲突:想要标题是 Hello! 还是 Hey!?
- 当尝试合并这些分支时,Git 会向你展示冲突出现的位置,可以手动移除我们不想保留的修改,保存这些修改,再次添加这个已修改的文件,然后提交这些修改

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-2a8ce9f5e3f32b399cca693f38418e65.gif)

- 尽管合并冲突往往很让人厌烦,但这是合理的:Git 不应该瞎猜我们想要保留哪些修改