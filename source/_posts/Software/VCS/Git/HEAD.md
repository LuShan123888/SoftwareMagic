---
title: Git HEAD
categories:
- Software
- VCS
- Git
---
# Git HEAD

- Git 中的 HEAD 可以理解为一个指针，可以在命令行中输入 `cat .git/HEAD` 查看当前 HEAD 指向哪儿，一般它指向当前工作目录所在分支的最新提交
- 当使用`git checkout`切换分支的时候,HEAD 修订版本重新指向新的分支，有的时候HEAD会指向一个没有分支名字的修订版本，这种情况叫`detached HEAD`

## ~ 的作用

- 如果想要 `HEAD` 的第 10 个祖先提交，直接使用 `HEAD~10`
- `<rev>~<n>` 用来表示一个提交的第 n 个祖先提交，如果不指定 n,那么默认为 1, 另外,`HEAD~~~` 和 `HEAD~3` 是等价的

```
$ git rev-parse HEAD
a19bf31 (D)

$ git rev-parse HEAD~0
a19bf31 (D)

$ git rev-parse HEAD~
85ce81b (C)

$ git rev-parse HEAD~1
85ce81b (C)

$ git rev-parse HEAD~~
73d1f3b (B)

$ git rev-parse HEAD~3
078e0e6 (A)
```

## ^ 的作用

```
$ git log --graph --oneline

* f44239d D
*   7a3fb3d C
|\
| * 07b920c B
|/
* 71bd2cf A
...
```

- 很多情况下一个提交并不是只有一个父提交, 就如上图表示那样,`7a3fb3d (C)` 就有两个父提交:
    - `07b920c (B)`
    - `71bd2cf (A)`
- 这时候不能通过 `~` 去找到 `07b920c (B)` 这个提交的, 如果一个提交有多个父提交，那么 `~` 只会找第一个父提交,
- 这时候应该使用`HEAD~^2`找到 `07b920c (B)`
- `<rev>^<n>` 用来表示一个提交的第 n 个父提交，如果不指定 n,那么默认为1,和 `~` 不同的是,`HEAD^^^` 并不等价于 `HEAD^3`,而是等价与 `HEAD^1^1^1`

```
$ git rev-parse HEAD~
7a3fb3d (C)

$ git rev-parse HEAD~^
71bd2cf (A)

$ git rev-parse HEAD~^0
7a3fb3d (C)

$ git rev-parse HEAD~^2
07b920c (B)

$ git rev-parse HEAD~^3
fatal: ambiguous argument 'HEAD~^3': unknown revision or path not in the working tree

$ git rev-parse HEAD^2
fatal: ambiguous argument 'HEAD^2': unknown revision or path not in the working tree
```


## ~ 与 ^ 的关系

- `~` 获取第一个祖先提交,`^` 可以获取第一个父提交, 其实第一个祖先提交就是第一个父提交，反之亦然, 因此，当 n 为 1 时,`~` 和 `^` 其实是等价的, 譬如:`HEAD~~~` 和 `HEAD^^^` 是等价的

```
G   H   I   J
 \ /     \ /
  D   E   F
   \  |  / \
    \ | /   |
     \|/    |
      B     C
       \   /
        \ /
         A
A =      = A^0
B = A^   = A^1     = A~1
C = A^2  = A^2
D = A^^  = A^1^1   = A~2
E = B^2  = A^^2
F = B^3  = A^^3
G = A^^^ = A^1^1^1 = A~3
H = D^2  = B^^2    = A^^^2  = A~2^2
I = F^   = B^3^    = A^^3^
J = F^2  = B^3^2   = A^^3^2
```
