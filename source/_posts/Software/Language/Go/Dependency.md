---
title: Go Dependency
categories:
- Software
- Language
- Go
---
# Go Dependency

## 背景

Go 依赖管理的演进经历了以下 3 个阶段：

![在这里插入图片描述](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/a12ee0c35fc64188bdc2dd0a01db5d1d~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75-20240316163823300.awebp)

被广泛应用的是 Go Module，整个演进路线主要围绕实现两个目标来迭代发展：

- 不同环境（项目）依赖的版本不同。
- 控制依赖库的版本。

## Go 依赖管理的演进

### GOPATH

GOPATH 是 Go 语言支持的一个环境变量，是 Go 项目的工作区。其目录有以下 3 个结构（需要手动创建文件夹）：

| 文件夹 | 作用                 |
| ------ | -------------------- |
| bin    | 项目编译的二进制文件 |
| pkg    | 项目编译的中间产物   |
| src    | 项目源码             |

- 项目代码直接依赖 `src` 下的代码；
- `go get` 下载最新版本的包到 `src` 目录下。

**弊端**：下面的场景就体现了 GOPATH 的弊端：项目 A 和项 B 依赖于某一 package 的不同版本（分别为 `Pkg V1` 和 `Pkg V2` ) 。而 `src` 下只能允许一个版本存在，那项目 A 和项 B 就无法保证都能编译通过。

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/bb053e42b85b43908d67b1fc1f5a5d9e~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75-20240316163939004.awebp" alt="image-20220517141844767" style="zoom:50%;" />

在 GOPATH 管理模式下，如果多个项目依赖同一个库，则依赖该库是同一份代码，无法做到不同项目依赖同一个库的不同版本。这显然无法满足实际开发中的项目依赖需求，为了解决这个问题，Go Vendor 出现了。

### Go Vendor

- 与 GOPATH 不同之处在于项目目录下增加了 `vendor` 文件，所有依赖包以副本形式放在 `$ProjectRoot/vendor` 下。
- 在 Vendor 机制下，如果当前项目存在 Vendor 目录，会优先使用该目录下的依赖；如果依赖不存在，则会从 GOPATH 中寻找。这样，通过每个项目引入一份依赖的副本，解决了多个项目需要同一个 package 依赖的冲突问题。

**弊端**：但 Vendor 无法很好解决依赖包版本变动问题和一个项目依赖同一个包的不同版本的问题。

![image-20220517144202958](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/625c0e3703704db481ba00f438427b96~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75-20240316163932427.awebp)

如图项目 A 依赖 Package B 和 Package C，而 Package B 和 Package C 又依赖了 Package D 的不同版本。通过 Vendor 的管理模式不能很好地控制对于 Package D 的依赖版本。一旦更新项目，有可能出现依赖冲突，导致编译出错。归根到底： Vendor 不能很清晰地标识依赖的版本概念。

### Go Module

- Go Module 是 Go 语言官方推出的依赖管理系统，解决了之前依赖管理系统存在的诸如无法依赖同一个库的多个版本等问题。
- Go Module 自 Go 1.11 开始引入，Go 1.16 默认开启。可以在项目目录下看到 `go.mod` 文件：

| 名称                | 作用                 |
| ------------------- | -------------------- |
| go. mod              | 文件，管理依赖包版本 |
| `go get` / `go mod` | 指令，管理依赖包     |

## Go Module

| 要素               | 对于工具            |
| ------------------ | ------------------- |
| 配置文件，描述依赖 | go. mod              |
| 中心仓库管理依赖库 | Proxy               |
| 本地工具           | `go get` / `go mod` |

### go. mod

打开项目目录下的 go. mod 文件，其文件结构主要分为三部分：

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/56e6d92fe4f647778f93fdbc22d7e950~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp" alt="image-20220517150510319" style="zoom:50%;" />

- **module 路径（上图的“依赖管理基本单元”)**：用来标识一个 module，从 module 路径可以看出从哪里找到该 module 。例如，如果以 `github` 为前缀开头，表示可以从 Github 仓库找到该 module 。依赖包的源代码由 Github 托管，如果项目的子包想被单独引用，则需要通过单独的 `init go.mod` 文件进行管理。
- **原生库**：依赖的原生 Go SDK 版本。
- **单元依赖**：每个依赖单元用 `module路径 + 版本号` 来唯一标识。

#### version

- GOPATH 和 Go Vendor 都是源码副本方式依赖，没有版本规则概念。
- 而 go. mod 为了方便管理，定义了版本规则。分为语义化版本和基于 commit 伪版本两个版本。

**语义化版本**

```bash
${MAJOR}.${MINOR}.${PATCH}
```

如：V 1.18.1、V 1.8.0

| 名称  | 含义                                                                                          |
| ----- | --------------------------------------------------------------------------------------------- |
| MAJOR | 不同的 MAJOR 版本表示是不兼容的 API。因此即使是同一个库，MAJOR 版本不同也会被认为是不同的模块 |
| MINOR | 通常是新增函数或功能，向后兼容                                                                |
| PATCH | 一般是修复 bug                                                                                |

**基于 commit 伪版本**

每次提交 commit 后，Go 都会默认生成一个伪版本号：

```
v0.0.0-yyyymmddhhmmss-abcdefgh1234
```

如：v 1.0.0-20220517152630-c 38 fb 59326 b 7

| 名称           | 含义                         |
| -------------- | ---------------------------- |
| v 0.0.0         | 版本前缀和语义化版本是一样的 |
| yyyymmddhhmmss | 时间戳，提交 Commit 的时间   |
| abcdefgh 1234   | 校验码，包含 12 位的哈希前缀 |

#### indirect

在 go. mod 文件图中，细心观察可以发现有些单元依赖带有 `// indirect` 的后缀，这是一个特殊标识符，表示 go. mod 对应的当前 module 没有直接导入的包，也就是非直接依赖（即间接依赖） 。

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/ee43ef2fca7c4c9494a2285985dd6bb3~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp" alt="image-20220517153440426" style="zoom:50%;" />

例如，一个依赖关系链为：A->B->C 。其中，A->B 是直接依赖；而 A->C 是间接依赖。

#### incompatible

在 go. mod 文件图中，细心观察可以发现有些单元依赖带有 `+incompatible` 的后缀，这也是一个特殊标识符。对于 MAJOR 主版本在 V 2 及以上的模块，go. mod 会在模块路径增加 `/vN` 后缀（如下图中 `example/lib5/v3 v3.0.2` )。这能让 Go Module 按照不同的模块来处理同一个项目不同 MAJOR 主版本的依赖。

- 由于 Go Module 是在 Go 1.11 才实验性地引入，所以在这个更新提出之前，已经有一些仓库打上了 V 2 或者更高版本的 tag 了。
- 为了兼容这部分仓库，对于没有 go. mod 文件并且 MAJOR 主版本在 V 2 及以上的依赖，会在版本号后加上 `+incompatible` 后缀。表示可能会存在不兼容的源代码。

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/6478f27156754549a6235cbe79bf694a~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp" alt="image-20220517154220581" style="zoom:50%;" />

### 依赖选择

如下图所示，Main 项目依赖项目 A 和项目 B ，且项目 A 和项目 B 分别依赖项目 C 的 v 1.3 和 v 1.4 版本。最终编译时，Go 所使用的项目 C 的版本为：v 1.4 。

**总结**：Go 选择最低的兼容版本。

![image-20220517160311299](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/439631ce77fe456bb314e9e9ce2ed831~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp)

### 依赖分发

#### 回源

- 依赖分发，即依赖从何处下载、如何下载的问题。
- Go 的依赖绝大部分托管在 GitHub 上。Go Module 系统中定义的依赖，最终都可以对应到 GitHub 中某一项目的特定提交（commit) 或版本。
- 对于 go. mod 中定义的依赖，则直接可以从对应仓库中下载指定依赖，从而完成依赖分发。

![image-20220517161158838](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/a08866eef9694c8083831781f2e21ee1~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp)

**2. 弊端**

直接使用 GitHub 仓库下载依赖存在一些问题：

- 首先，无法保证构建稳定性。代码作者可以直接在 GitHub 上增加/修改/删除软件版本。
- 无法保证依赖可用性。代码作者可以直接在 GitHub 上删除代码仓库，导致依赖不可用。
- 第三，如果所有人都直接从 GitHub 上获取依赖，会导致 GitHub 平台负载压力。

**3. 解决方案-Proxy**

- Go Proxy 就是解决上述问题的方案。Go Proxy 是一个服务站点，它会缓存 GitHub 中的代码内容，缓存的代码版本不会改变，并且在 GitHub 作者删除了代码之后也依然可用，从而实现了 "immutability" (不变性）和 "available" (可用的）的依赖分发。
- 使用 Go Proxy 后，构建时会直接从 Go Proxy 站点拉取依赖。如下图所示。

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/3765a36f40a846a69a45ea68347defb5~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp" alt="image-20220517183641065" style="zoom:50%;" />

#### GOPROXY

- Go Module 通过 GOPROXY 环境变量控制如何使用 Go Proxy 。

- GOPROXY 是一个 Go Proxy 站点 URL 列表。

```
GOPROXY = "https://proxy1.cn, https://proxy2.cn, direct"
```

- 上述代码中，`direct` 表示源站（如 GitHub) ，`proxy 1` `proxy 2` 是两个 URL 站点。依赖寻址路径为：优先从 `proxy 1` 下载依赖，如果 `proxy 1` 不存在，再从 `proxy 2` 寻找，如果 `proxy 2` 不存在，则会回源到源站直接下载依赖，并缓存到 Go Proxy 站点中（这种设计思路和 Redis 缓存与 MySQL 数据库一模一样）。

![image-20220517184332536](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/02fb6e8a00c84508b02ab2109b5d6c14~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp)

### 命令

#### go get

```shell
go get example. org/pkg +...
```

- `go get -u` ：更新到最新的次要版本或者修订版本（x.y.z)
- `go get -u=patch` ：更新到最新的修订版本。
- `go get package@version ` ：更新到指定的版本号 version
- 运行 `go get` 如果有版本的更改，那么 go. mod 文件也会作出相应的更改。

| 指令       | 功能               |
| -------- | ---------------- |
| @update  | 默认               |
| @none    | 删除依赖             |
| @v 1.1.2  | 下载指定 tag 版本，语义版本 |
| @23 dfdd 5 | 下载特定的 commit 版本  |
| @master  | 下载分支的最新 commit   |

#### go mod

| 指令     | 功能                             |
| -------- | -------------------------------- |
| init     | 初始化，创建 go. mod 文件         |
| download | 下载模块到本地缓存               |
| tidy     | 增加需要的依赖，删除不需要的依赖 |

在实际开发中，尽量提交之前执行下 `go tidy` ，减少构建时无效依赖包的拉取。
