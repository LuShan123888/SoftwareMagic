---
title: Git pull
categories:
- Software
- VCS
- Git
- 基本命令
---
# Git pull

- git pull 实际上是两个命令合成了一个即git fetch 和 git merge
- 当我们从来源拉取修改时,先是像 git fetch 那样取回所有数据,然后最新的修改会自动合并到本地分支中

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-vS253GcLbUsfOzW.gif)

**取回远程仓库的变化,并与本地分支合并**

```shell
git pull <远程主机名> <远程分支名>:<本地分支名>
```

- 要取回`origin`主机的`next`分支,与本地的`master`分支合并,需要写成下面这样

```shell
git pull origin next:master
```

- 如果远程分支(`next`)要与当前分支合并,则冒号后面的部分可以省略,上面命令可以简写为

```shell
git pull origin next
```

- 上面命令表示,取回`origin/next`分支,再与当前分支合并,实质上,这等同于先做`git fetch`,再执行`git merge`

**允许不同仓库拉取**

- 如果合并了两个不同的开始提交的仓库,在新的 git 会发现这两个仓库可能不是同一个,为了防止开发者上传错误,于是就给下面的提示

```
fatal: refusing to merge unrelated histories
```

- 如我在Github新建一个仓库,写了License,然后把本地一个写了很久仓库上传,这时会发现 github 的仓库和本地的没有一个共同的 commit 所以 git 不让提交,认为是写错了 `origin` ,如果开发者确定是这个 `origin` 就可以使用 `--allow-unrelated-histories` 告诉 git 自己确定
- 遇到无法提交的问题,一般先pull 也就是使用 `git pull origin master` 这里的 `origin` 就是仓库,而 `master` 就是需要上传的分支,因为两个仓库不同,发现 git 输出 `refusing to merge unrelated histories` 无法 pull 内容
- 因为他们是两个不同的项目,要把两个不同的项目合并,git需要添加一句代码,在 `git pull` 之后,这句代码是在git 2.9.2版本发生的,最新的版本需要添加 `--allow-unrelated-histories` 告诉 git 允许不相关历史合并
- 假如我们的源是origin,分支是master,那么我们需要这样写`git pull origin master --allow-unrelated-histories` 如果有设置了默认上传分支就可以用下面代码

```shell
git pull --allow-unrelated-histories
```

