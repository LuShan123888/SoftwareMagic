---
title: Git tag
categories:
- Software
- VCS
- Git
- 基本命令
---
# Git tag

## 查看本地分支标签

```shell
git tag
git tag -l
git tag --list
```

## 查看远程所有标签

```shell
git ls-remote --tags
git ls-remote --tag
```

## 给当前分支打标签

```shell
git tag <标签名>
#例如
git tag v1.1.0
```

## 给特定的某个commit版本打标签

比如现在某次提交的id为 039bf8b

```shell
git tag v1.0.0 039bf8b
# OR者可以添加注释
git tag v1.0.0 -m "add tags information" 039bf8b
# OR
git tag v1.0.0 039bf8b -m "add tags information"
```

## 删除本地某个标签

```shell
git tag --delete v1.0.0
# OR
git tag -d v1.0.0
```

## 删除远程的某个标签

```shell
git push -d origin v1.0.0
# OR
git push --delete origin v1.0.0
# OR
git push origin :v1.0.0
```

## 将本地标签全部推送到远程

```shell
git push origin --tags
# OR
git push --tags
```

## 将本地某个特定标签推送到远程

```shell
git push origin <tag-id>
#例如
git push origin v1.0.0
```

## 查看某个标签的提交信息

```shell
git show <tag-id>
#例如
git show v1.0.0
```

## 查看某个标签的代码

```shell
git checkout <tag-id>
```

## 从某个标签处创建分支

```shell
git checkout -b <new-branch>  <tag-id>
```

