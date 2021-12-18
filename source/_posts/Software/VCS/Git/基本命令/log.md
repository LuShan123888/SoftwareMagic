---
title: Git log
categories:
- Software
- VCS
- Git
- 基本命令
---
# Git log

**显示当前分支的版本历史**

 ```shell
 git log
 ```

- ` --decorate`:显示所有的引用,包括分支和标签
- ` --oneline`:简短的显示快照
- `--graph`:以图形化的方式显示
- `--all`:显示所有的分支
- `--stat`:显示commit历史,以及每次commit发生变更的文件
- `--pretty=format:%s`:设置log格式，每个commit占据一行
- `--grep`: 显示某个commit之后的所有变动,其"提交说明"必须符合搜索条件
- `-[num]`:显示过去n次提交
- `[commit`]:显示某个commit之后的所有变动

**搜索提交历史,根据关键词**

```shell
$ git log -S [keyword]
```

**显示某个文件的版本历史,包括文件改名**

```shell
$ git log --follow [file]
```

**显示指定文件相关的每一次diff**

 ```bash
$ git log -p [file]
 ```

