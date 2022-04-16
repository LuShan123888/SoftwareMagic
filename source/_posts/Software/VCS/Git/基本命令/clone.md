---
title: Git clone
categories:
- Software
- VCS
- Git
- 基本命令
---
# Git clone

**克隆远端仓库**

```shell
git clone <url> [local_path]
```

- `--depth <num>`:指定深度,为1即表示只克隆最近一次commit
- `-b <branch_name>`:指定分支
- `--bare`:只克隆仓库信息

**递归克隆(包含子模块)**

```shell
git clone --recurse-submodules -j8 git://github.com/foo/bar.git
```

- `-j8`：可选的性能优化,在2.8版中可用,一次最多可以并行提取8个子模块