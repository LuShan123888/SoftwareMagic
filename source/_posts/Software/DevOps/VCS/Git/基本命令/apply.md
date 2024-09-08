---
title: Git apply
categories:
  - Software
  - DevOps
  - VCS
  - Git
  - 基本命令
---
# Git apply

**应用补丁**

```
git apply <patch-name>
```

- `--check `：应用补丁之前我们可以先检验一下补丁能否应用，如果没有任何输出，那么表示可以顺利接受这个补丁。
- `--reject`：将能打的补丁先打上，有冲突的会生成 `.rej` 文件，之后可以找到这些文件进行手动打补丁　