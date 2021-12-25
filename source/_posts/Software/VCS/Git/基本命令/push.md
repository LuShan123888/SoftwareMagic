---
title: Git push
categories:
- Software
- VCS
- Git
- 基本命令
---
# Git push

**推送分支**

```shell
$ git push <远程主机名> <本地分支名>:<远程分支名>
```

- `-u`:如果当前分支与多个主机存在追踪关系,则可以使用`-u`选项指定一个默认主机,这样后面就可以不加任何参数使用`git push`
- `--force`:强行推送当前分支到远程仓库,即使有冲突
- `--all`:所有本地分支都推送到远程主机
- `--tags`:提交所有tag

**实例**

```shell
$ git push origin master
```

- 上面命令表示,将本地的`master`分支推送到`origin`主机的`master`分支,如果`master`不存在,则会被新建

- 如果省略本地分支名,则表示删除指定的远程分支,因为这等同于推送一个空的本地分支到远程分支

**提交指定tag**

```shell
$ git push [remote] [tag]
```

**删除远程tag**

```shell
$ git push --delete [remote] [tag]
```

**删除远程分支**

```shell
$ git push origin --delete [branch-name]
```

**本地分支与远程分支关联**

- 在远程创建一个 `branch_name` 分支,然后本地分支会 track 该分支,后面再对该分支使用 push 和 pull 就自动同步

```shell
git push --set-upstream [remote] [branch-name]
```



