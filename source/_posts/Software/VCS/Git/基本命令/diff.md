---
title: Git diff
categories:
- Software
- VCS
- Git
- 基本命令
---
# Git diff

- diff命令用于比较不同版本的差异
- 默认使用工作区比较与其他版本进行比较
- 如果未指定其他版本,默认比较工作区与暂存区的差异

```
git diff [<path>...]
```

- `--cached`:使用暂存区与其他版本比较,如果未指定其他版本,比较暂存区和上一次提交(commit)的差异
- `--stat`:查看简单的diff结果
- `[<path>...]`:只比较单个文件的路径

## 比较HEAD指针

- 比较工作区与上次提交commit的差异

```
git diff HEAD [<path>...]
```

- 比较上次提交commit和上上次提交的差异

```
  git diff HEAD^ HEAD [<path>...]
```

## 比较分支

- 比较工作区与分支的差异

```
git diff <branch_name> [<path>...]
```

## 比较commit-id

- 比较工作区与指定commit-id的差异

```
git diff commit-id [<path>...]
```

- 比较两个commit-id之间的差异

```
git diff [<commit-id>] [<commit-id>] [<path>...]
```

## 使用git diff打补丁

- patch作用是当希望将本仓库工作区的修改拷贝一份到其他机器上使用,但是修改的文件比较多,拷贝量比较大,此时可以将修改的代码做成补丁

```
git diff [<path>...]> <patch_name>
```

- `--cached`:将暂存区与版本库的差异做成补丁
- `--HEAD`:将工作区与版本库的差异做成补丁
- `[<path>...]`:将单个文件做成一个单独的补丁

### 应用补丁

```
git apply patch
```

- `--check `:应用补丁之前我们可以先检验一下补丁能否应用,如果没有任何输出,那么表示可以顺利接受这个补丁
- `--reject`:将能打的补丁先打上,有冲突的会生成`.rej`文件,之后可以找到这些文件进行手动打补丁　