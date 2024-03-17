---
title: Git BFG
categories:
- Software
- VCS
- Git
---
# Git BFG

## 删除不需要的文件

将下载好的 jar 放到下载好的 git 库的同级目录
删除大于 100 M 的文件

```shell
java -jar bfg.jar --strip-blobs-bigger-than 100M some-big-repo.git
```

删除大于 100 M 的文件


BFG 将更新您的提交以及所有分支和标记, 此时还没有物理删除,**使用 gc 去除 git 认为多余的数据 (上面调用命令删除的文件)**

```shell
cd some-big-repo.git
git reflog expire --expire=now --all && git gc --prune=now --aggressive
```

调用上面的命令后，文件将彻底删除 (everywhere)

## 将代码提交到远程仓库

确保文件没有任何问题之后, 将代码提交到远程仓库, 这将影响远程服务器上所有的 refs

```shell
git push
```

如果有必要, 让其他人删除原来的仓库, 因为原来的仓库中还是有脏数据, 有可能会再次提交到远程仓库

## 其他命令

```shell
1.删除所有的名为'id_dsa'或'id_rsa'的文件
java -jar bfg.jar --delete-files id_{dsa,rsa}  my-repo.git

2.删除所有大于50M的文件
java -jar bfg.jar --strip-blobs-bigger-than 50M  my-repo.git

3.删除文件夹下所有的文件
java -jar bfg.jar --delete-folders doc  my-repo.git
```

**注意**: 删除文件后别忘了 gc 命令, 工具不会清除最近一次提交的文件内容, 如果需要删除, 使用
`--no-blob-protection`, 官方不推荐, 在删除前最好确保最新的提交为干净的

## 详细命令

```shell
bfg 1.13.0
Usage: bfg [options] [<repo>]

  -b, --strip-blobs-bigger-than <size>
                           strip blobs bigger than X (eg '128K', '1M', etc)
  -B, --strip-biggest-blobs NUM
                           strip the top NUM biggest blobs
  -bi, --strip-blobs-with-ids <blob-ids-file>
                           strip blobs with the specified Git object ids
  -D, --delete-files <glob>
                           delete files with the specified names (eg '*.class', '*.{txt,log}' - matches on file name, not path within repo)
  --delete-folders <glob>  delete folders with the specified names (eg '.svn', '*-tmp' - matches on folder name, not path within repo)
  --convert-to-git-lfs <value>
                           extract files with the specified names (eg '*.zip' or '*.mp4') into Git LFS
  -rt, --replace-text <expressions-file>
                           filter content of files, replacing matched text. Match expressions should be listed in the file, one expression per line - by default, each expression is treated as a literal, but 'regex:' & 'glob:' prefixes are supported, with '==>' to specify a replacement string other than the default of '***REMOVED***'.
  -fi, --filter-content-including <glob>
                           do file-content filtering on files that match the specified expression (eg '*.{txt,properties}')
  -fe, --filter-content-excluding <glob>
                           don't do file-content filtering on files that match the specified expression (eg '*.{xml,pdf}')
  -fs, --filter-content-size-threshold <size>
                           only do file-content filtering on files smaller than <size> (default is 1048576 bytes)
  -p, --protect-blobs-from <refs>
                           protect blobs that appear in the most recent versions of the specified refs (default is 'HEAD')
  --no-blob-protection     allow the BFG to modify even your *latest* commit. Not recommended: you should have already ensured your latest commit is clean.
  --private                treat this repo-rewrite as removing private data (for example: omit old commit ids from commit messages)
  --massive-non-file-objects-sized-up-to <size>
                           increase memory usage to handle over-size Commits, Tags, and Trees that are up to X in size (eg '10M')
  <repo>                   file path for Git repository to clean
```