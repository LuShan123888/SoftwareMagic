---
title: Git Push命令
categories:
- Software
- Git
- 基本命令
---
# Git Push命令

## 推送分支

```shell
git push <远程主机名> <本地分支名>:<远程分支名>
```

```
git push origin master
```

- 上面命令表示,将本地的`master`分支推送到`origin`主机的`master`分支,如果`master`不存在,则会被新建

- 如果省略本地分支名,则表示删除指定的远程分支,因为这等同于推送一个空的本地分支到远程分支

## 设置默认主机

```shell
git push -u origin master
```

如果当前分支与多个主机存在追踪关系,则可以使用`-u`选项指定一个默认主机,这样后面就可以不加任何参数使用`git push`

## 强制覆盖远程主机

```shell
git push --force origin
```

## 所有本地分支都推送到远程主机

```shell
git push --all origin
```
