---
title: Git Workflow
categories:
- Software
- VCS
- Git
---
# Git Workflow

## 经典分支模型

| 分支    | 说明                                                         | 命名规范  | checkout from          | merge to        |
| ------- | ------------------------------------------------------------ | --------- | ---------------------- | --------------- |
| master  | 主干，最稳定的分支，随时可以当作 release 版本 ，只能从其他分支合入， 不能在上面做任何提交。 |           |                        |                 |
| develop | 开发主干，是稳定的、最新的分支。主要合并其他分支，比如 feature 分支 bugfix 分支。 |           |                        |                 |
| feature | 新功能分支                                                   | feature/* | develop                | develop         |
| release | 发布分支，对应一次新版本的发布，只接受 bugfix                | release/* | develop                | develop和master |
| hotfix  | 紧急修复分支，生产环境中发现的紧急 bug 的修复                | hotfix/*  | master（tag），release | develop和master |

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/image-20220609191847486.png" alt="image-20220609191847486" style="zoom:50%;" />