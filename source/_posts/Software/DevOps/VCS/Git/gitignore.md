---
title: Git gitignore
categories:
  - Software
  - DevOps
  - VCS
  - Git
---
# Git gitignore

## 匹配规则

- 以斜杠 `/` 开头表示目录。
- 以星号 `*` 通配多个字符。
- 以问号 `?` 通配单个字符。
- 以方括号 `[]` 包含单个字符的匹配列表。
- 以叹号 `!` 表示不忽略（跟踪）匹配到的文件或目录。

此外，git 对于 .ignore 配置文件是按行从上到下进行规则匹配的，意味着如果前面的规则匹配的范围更大，则后面的规则将不会生效。

```shell
.a       # 忽略所有 .a 结尾的文件。
!lib.a    # 但 lib.a 除外。
/TODO     # 仅仅忽略项目根目录下的 TODO 文件，不包括 subdir/TODO
build/    # 忽略 build/ 目录下的所有文件。
doc/.txt # 会忽略 doc/notes.txt 但不包括 doc/server/arch.txt
/fd1/* #忽略根目录下的 /fd1/ 目录的全部内容。
```

## 强制添加到 Git

```shell
$ git add -f App.class
```

## 移除已经跟踪的 Git 文件

当该文件已经被 `git add` 过，那么即使添加到 `.gitignore` 文件中也仍然会被提交，你可以使用 `git rm --cache` 命令将该文件从暂存区移除后再 `commit` 即可。

## .gitignore 忽略规则查看

```shell
$ git check-ignore -v App.class
.gitignore:3:*.class	App.class
```

Git 会告诉我们，`.gitignore` 的第 3 行规则忽略了该文件，于是我们就可以知道应该修订哪个规则。

## 使用配置文件

- 使用如下命令指定配置文件位置。

```
$ git config --global core.excludesfile "~/.gitignore"
```

- 或者修改 `~/.gitconfig`

```toml
[core]
	excludesfile = /Users/cian/.gitignore_global
```

- `~/.gitignore_global`

```
.DS_Store
node_modules/
dist/
target/
out/
!**/src/main/**/target/
!**/src/test/**/target/
!.mvn/wrapper/maven-wrapper.jar


# Editor directories and files
.idea
.mvn
.vscode
*.suo
*.ntvs*
*.njsproj
*.sln
*.iml

```

