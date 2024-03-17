---
title: Git rebase
categories:
- Software
- VCS
- Git
- 基本命令
---
# Git rebase

## 变基 (Rebasing)

- 将当前分支的提交复制到指定的分支之上
- **变基与合并有一个重大的区别**: Git 不会尝试确定要保留或不保留哪些文件，在执行 rebase 的分支总是含有想要保留的最新近的修改，这样不会遇到任何合并冲突，而且可以保留一个漂亮的，线性的 Git 历史记录

```shell
git rebase  <branch_name>
```

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-6b8427b4baf6cdfb08b852ab1cdb4941.gif)

- 上面这个例子展示了在 master 分支上的变基，但是，在更大型的项目中，通常不需要这样的操作，因为 rebase 在为复制的提交创建新的 hash 时会修改项目的历史记录
- 如果在开发一个 feature 分支并且 master 分支已经更新过，那么变基就很好用，可以在你的分支上获取所有更新，这能防止未来出现合并冲突

## 交互式变基 (Interactive Rebase)

- 在为提交执行变基之前，可以修改它们，可以使用交互式变基来完成这一任务
- 交互式变基在你当前开发的分支上以及想要修改某些提交时会很有用

```shell
  git rebase -i  [startpoint]  [endpoint]
```

- `-i --interactive`: 即弹出交互式的界面让用户编辑完成合并操作
- `[startpoint],[endpoint]`: 指定了一个编辑区间，可以用 commit-id 或 HEAD 指针指定
- 如果不指定 `[endpoint]`, 则该区间的终点默认是当前分支 `HEAD` 所指向的 `commit` (注：该区间指定的是一个前开后闭的区间)

在 rebase 的提交上，可以执行以下 6 个动作:

- reword: 修改提交信息

- edit: 修改此提交

- squash: 将提交融合到前一个提交中

- fixup: 将提交融合到前一个提交中，不保留该提交的日志消息

- exec: 在每个提交上运行我们想要 rebase 的命令

- drop: 移除该提交

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-7189da3226d1fdedeb6a297fbc2b1177.gif)

如果你想把多个提交融合到一起以便得到清晰的提交历史，那也没有问题!

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-758ead2cd3914cadc4d822053ad1089a.gif)

交互式变基能为你在 rebase 时提供大量控制，甚至可以控制当前的活动分支

**如果保存的时候，碰到了这个错误**:

```shell
error: cannot 'squash' without a previous commit
```

注意不要合并先前提交的东西，也就是已经提交远程分支的纪录

**如果异常退出了 `vi` 窗口，不要紧张**:

```
git rebase --edit-todo
```

这时候会一直处在这个编辑的模式里，我们可以回去继续编辑，修改完保存一下:

```
git rebase --continue
```

## 将某一段 commit 粘贴到另一个分支上

当项目中存在多个分支，有时候我们需要将某一个分支中的一段提交同时应用到其他分支中，就像下图:

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-808-20201210114029897.png)


希望将 develop 分支中的 C~E 部分复制到 master 分支中，这时就可以通过 rebase 命令来实现（如果只是复制某一两个提交到其他分支，建议使用更简单的命令: `git cherry-pick`)
在实际模拟中，创建了 master 和 develop 两个分支:
**master 分支**:

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-443.png)

**develop 分支**:

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-455.png)

使用命令的形式为:

```shell
git rebase   [startpoint]   [endpoint]  --onto  [branchName]
```

其中, `[startpoint]` `[endpoint]` 仍然和上一个命令一样指定了一个编辑区间（前开后闭), `--onto` 的意思是要将该指定的提交复制到哪个分支上
所以，在找到 C (90 bc 0045 b) 和 E (5 de 0 da 9 f 2) 的提交 id 后，运行以下命令:

```shell
git  rebase   90bc0045b^   5de0da9f2   --onto master
```

因为 `[startpoint]` `[endpoint]` 指定的是一个前开后闭的区间，为了让这个区间包含 C 提交，将区间起始点向后退了一步
运行完成后查看当前分支的日志:

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-488.png)

可以看到, C~E 部分的提交内容已经复制到了 G 的后面了，看一下当前分支的状态:

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-439.png)

当前 HEAD 处于游离状态，实际上，此时所有分支的状态应该是这样:

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-755.png)



所以，虽然此时 HEAD 所指向的内容正是所需要的，但是 master 分支是没有任何变化的, `git` 只是将 C~E 部分的提交内容复制一份粘贴到了 master 所指向的提交后面，需要做的就是将 master 所指向的提交 id 设置为当前 HEAD 所指向的提交 id 就可以了，即:

```shell
git checkout master
git reset --hard  0c72e64
```

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-689.png)