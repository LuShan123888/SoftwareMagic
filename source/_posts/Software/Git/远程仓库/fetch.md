---
title: Git Fetch
categories:
- Software
- Git
- 远程仓库
---
# Git Fetch

## 取回(Fetching)

```shell
git fetch <远程主机名>
```

如果有一个远程 Git 分支,比如在 GitHub 上的分支,当远程分支上包含当前分支没有的提交时,可以使用取回,比如当合并了另一个分支或你的同事推送了一个快速修复时

通过在这个远程分支上执行 git fetch,就可在本地获取这些修改,这不会以任何方式影响你的本地分支:fetch 只是单纯地下载新的数据而已

![img](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-hVziLcuZmjHIS5D.gif)

现在我们可以看到自上次推送以来的所有修改了,这些新数据也已经在本地了,可以决定用这些新数据做什么了

## 取回所有主机的所有分支

```shell
git fetch -all
```

## 只取回特定分支的更新

```shell
git fetch <远程主机名> <分支名>
```

- 例如,取回`origin`主机的`master`分支:

    ```shell
    git fetch origin master
    ```

## 强制覆盖本地目录

```shell
git fetch --all
```

- 选择master分支

    ```shell
    git reset --hard origin/master
    ```

- 或者如果其他分支上

    ```shell
    git reset --hard origin/<branch_name>
    ```

