---
title: Git gitignore
categories:
- Software
- Git
---
# Git gitignore

## 匹配规则

- 以斜杠`/`开头表示目录
- 以星号`*`通配多个字符
- 以问号`?`通配单个字符
- 以方括号`[]`包含单个字符的匹配列表
- 以叹号`!`表示不忽略(跟踪)匹配到的文件或目录

此外,git 对于 .ignore 配置文件是按行从上到下进行规则匹配的,意味着如果前面的规则匹配的范围更大,则后面的规则将不会生效

```shell
.a       # 忽略所有 .a 结尾的文件
!lib.a    # 但 lib.a 除外
/TODO     # 仅仅忽略项目根目录下的 TODO 文件,不包括 subdir/TODO
build/    # 忽略 build/ 目录下的所有文件
doc/.txt # 会忽略 doc/notes.txt 但不包括 doc/server/arch.txt
/fd1/* #忽略根目录下的 /fd1/ 目录的全部内容
```

## 强制添加到Git

```shell
git add -f App.class
```

## .gitignore忽略规则查看

```shell
git check-ignore -v App.class
.gitignore:3:*.class	App.class
```

Git会告诉我们,`.gitignore`的第3行规则忽略了该文件,于是我们就可以知道应该修订哪个规则

## 使用配置文件

- `~/,gitconfig`

```toml
[core]
	excludesfile = /Users/cian/.gitignore_global
```

- `~/.gitignore_global`

```
.DS_Store
node_modules/
dist/
npm-debug.log*
yarn-debug.log*
yarn-error.log*
package-lock.json
tests/**/coverage/

# Editor directories and files
.idea
.vscode
*.suo
*.ntvs*
*.njsproj
*.sln

#java
target/
out/
```

