---
title: Git subtree
categories:
  - Software
  - DevOps
  - VCS
  - Git
  - 基本命令
---
# Git subtree

- git subtree 可以实现一个仓库作为其他仓库的子仓库。
- git subtree 与 git submodule 不同，它不增加任何像 `.gitmodule` 这样的新的元数据文件。
- git subtree 对于项目中的其他成员透明，意味着可以不知道 git subtree 的存在。

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-2020-12-04-1460000012002154.png)

## 在父仓库中新增子仓库

```bash
git subtree add   --prefix=<prefix> <commit>
git subtree add   --prefix=<prefix> <repository> <ref>
```

**实例**

- 执行以下命令把 plugin 添加到 main 中。

```bash
git subtree add --prefix=sub/plugin https://github.com/test/plugin.git master --squash
```

- `--squash` 参数表示不拉取历史信息，而只生成一条 commit 信息。
- 执行 `git push` 把修改推送到远端 main 仓库，现在本地仓库与远端仓库的目录结构为。

```
main
    |
    |-- sub/
    |   |
    |   \--plugin/
    |       |
    |       |-- plugin.c
    |       |-- plugin.h
    |       \-- README.md
    |
    |-- main.c
    |-- main.h
    |-- main.c
    \-- README.md
```

**注意**

- 现在的 main 仓库对于其他项目人员来说，可以不需要知道 plugin 是一个子仓库。
- 当 `git clone` 或者 `git pull` 的时候，拉取到的是整个 main （包括 plugin 在内， plugin 就相当于 main 里的一个普通目录）
- 当修改了 sub 里的内容后执行 `git push`，你将会把修改 push 到 main 上，也就是说 main 仓库下的 plugin 与其他文件无异。

## 从子仓库拉取更新

```bash
git subtree pull  --prefix=<prefix> <repository> <ref>
```

**实例**

- 将子仓库的修改拉取到主仓库。

```bash
git subtree pull --prefix=sub/plugin https://github.com/test/plugin.git master --squash
```

## 推送修改到子仓库

```bash
git subtree push  --prefix=<prefix> <repository> <ref>
```

**实例**

- 在主仓库中修改后，推动修改到子仓库。

```bash
git subtree push --prefix=sub/plugin https://github.com/test/plugin.git master
```

## 简化 git subtree 命令

- 把子仓库的地址作为一个 remote

```bash
git remote add -f plugin https://github.com/test/plugin.git
```

- 然后可以这样来使用 git subtree 命令。

```bash
git subtree add --prefix=sub/plugin plugin master --squash
git subtree push --prefix=sub/plugin plugin master
git subtree pull --prefix=sub/plugin plugin master --squash
```