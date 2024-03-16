---
title: Go Dependency
categories:
- Software
- Language
- Go
---
# Go Dependency

## 2.1 背景

Go 依赖管理的演进经历了以下 3 个阶段：

![在这里插入图片描述](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/a12ee0c35fc64188bdc2dd0a01db5d1d~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp)

目前被广泛应用的是 Go Module，整个演进路线主要围绕实现两个目标来迭代发展：

-   不同环境 (项目) 依赖的版本不同；
-   控制依赖库的版本。

## 2.2 Go 依赖管理的演进

### 2.2.1 GOPATH

GOPATH 是 Go 语言支持的一个环境变量，是 Go 项目的工作区。其目录有以下 3 个结构 (需要手动创建文件夹)：

![image-20220517141135083](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/17c5d0e709e94daf8f2b742dae6b5a9b~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp)

| 文件夹 | 作用                 |
| ------ | -------------------- |
| bin    | 项目编译的二进制文件 |
| pkg    | 项目编译的中间产物   |
| src    | 项目源码             |

-   项目代码直接依赖 `src` 下的代码；
-   `go get` 下载最新版本的包到 `src` 目录下。

**2.弊端**

下面的场景就体现了 GOPATH 的弊端：项目A 和项B 依赖于某一 package 的不同版本 (分别为 `Pkg V1` 和 `Pkg V2` ) 。而 `src` 下只能允许一个版本存在，那项目A 和项B 就无法保证都能编译通过。

![image-20220517141844767](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/bb053e42b85b43908d67b1fc1f5a5d9e~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp)

在 GOPATH 管理模式下，如果多个项目依赖同一个库，则依赖该库是同一份代码，无法做到不同项目依赖同一个库的不同版本。这显然无法满足实际开发中的项目依赖需求，为了解决这个问题，Go Vendor 出现了。

### 2.2.2 Go Vendor

-   与 GOPATH 不同之处在于项目目录下增加了 `vendor` 文件，所有依赖包以副本形式放在 `$ProjectRoot/vendor` 下。
-   在 Vendor 机制下，如果当前项目存在 Vendor 目录，会优先使用该目录下的依赖；如果依赖不存在，则会从 GOPATH 中寻找。这样，通过每个项目引入一份依赖的副本，解决了多个项目需要同一个 package 依赖的冲突问题。

![image-20220517143602660](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/7aa828bd8f034696bd07ce0c91cf3127~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp)

**2.弊端**

但 Vendor 无法很好解决依赖包版本变动问题和一个项目依赖同一个包的不同版本的问题。

![image-20220517144202958](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/625c0e3703704db481ba00f438427b96~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp)

如图项目A 依赖 Package B 和 Package C，而 Package B 和 Package C 又依赖了 Package D 的不同版本。通过 Vendor 的管理模式不能很好地控制对于 Package D 的依赖版本。一旦更新项目，有可能出现依赖冲突，导致编译出错。归根到底： Vendor 不能很清晰地标识依赖的版本概念。

### 2.2.3 Go Module

-   Go Module 是 Go 语言官方推出的依赖管理系统，解决了之前依赖管理系统存在的诸如无法依赖同一个库的多个版本等问题。
-   Go Module 自 Go1.11 开始引入，Go 1.16 默认开启。可以在项目目录下看到 `go.mod` 文件： ![image-20220517144835944](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/c7888c3f35ae49d8bf6d827893486e1f~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp)

| 名称                | 作用                 |
| ------------------- | -------------------- |
| go.mod              | 文件，管理依赖包版本 |
| `go get` / `go mod` | 指令，管理依赖包     |

【终极目标】定义版本规则和管理项目依赖关系。和 Java 中的 Maven 作用是一样的。

## 2.3 Go Module实践

### 2.3.1 依赖管理三要素

| 要素               | 对于工具            |
| ------------------ | ------------------- |
| 配置文件，描述依赖 | go.mod              |
| 中心仓库管理依赖库 | Proxy               |
| 本地工具           | `go get` / `go mod` |

### 2.3.2 依赖配置-go.mod

打开项目目录下的 go.mod 文件，其文件结构主要分为三部分：

![image-20220517150510319](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/56e6d92fe4f647778f93fdbc22d7e950~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp)

【module 路径 (上图的“依赖管理基本单元”)】用来标识一个 module，从 module 路径可以看出从哪里找到该 module 。例如，如果以 `github` 为前缀开头，表示可以从 Github 仓库找到该 module 。依赖包的源代码由 Github 托管，如果项目的子包想被单独引用，则需要通过单独的 `init go.mod` 文件进行管理。

【原生库】依赖的原生 Go SDK 版本。

【单元依赖】每个依赖单元用 `module路径 + 版本号` 来唯一标识。

### 2.3.3 依赖配置-version

-   GOPATH 和 Go Vendor 都是源码副本方式依赖，没有版本规则概念。
-   而 go.mod 为了方便管理，定义了版本规则。分为语义化版本和基于 commit 伪版本两个版本。

**1.语义化版本**

```bash
bash
复制代码${MAJOR}.${MINOR}.${PATCH}
```

如：V1.18.1、V1.8.0

| 名称  | 含义                                                         |
| ----- | ------------------------------------------------------------ |
| MAJOR | 不同的MAJOR版本表示是不兼容的API。因此即使是同一个库，MAJOR版本不同也会被认为是不同的模块 |
| MINOR | 通常是新增函数或功能，向后兼容                               |
| PATCH | 一般是修复bug                                                |

**2.基于 commit 伪版本**

每次提交 commit 后，Go 都会默认生成一个伪版本号：

```
复制代码v0.0.0-yyyymmddhhmmss-abcdefgh1234
```

如：v1.0.0-20220517152630-c38fb59326b7

| 名称           | 含义                         |
| -------------- | ---------------------------- |
| v0.0.0         | 版本前缀和语义化版本是一样的 |
| yyyymmddhhmmss | 时间戳，提交Commit的时间     |
| abcdefgh1234   | 校验码，包含12位的哈希前缀   |

### 2.3.4 依赖配置-indirect

2.3.2 节的 go.mod 文件图中，细心观察可以发现有些单元依赖带有 `// indirect` 的后缀，这是一个特殊标识符，表示 go.mod 对应的当前 module 没有直接导入的包，也就是非直接依赖 (即间接依赖) 。

![image-20220517153440426](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/ee43ef2fca7c4c9494a2285985dd6bb3~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp)

例如，一个依赖关系链为：A->B->C 。其中，A->B 是直接依赖；而 A->C 是间接依赖。

### 2.3.5 依赖配置-incompatible

2.3.2 节的 go.mod 文件图中，细心观察可以发现有些单元依赖带有 `+incompatible` 的后缀，这也是一个特殊标识符。对于 MAJOR 主版本在 V2 及以上的模块，go.mod 会在模块路径增加 `/vN` 后缀 (如下图中 `example/lib5/v3 v3.0.2` )。这能让 Go Module 按照不同的模块来处理同一个项目不同 MAJOR 主版本的依赖。

-   由于 Go Module 是在 Go 1.11 才实验性地引入，所以在这个更新提出之前，已经有一些仓库打上了 V2 或者更高版本的 tag 了。
-   为了兼容这部分仓库，对于没有 go.mod 文件并且 MAJOR 主版本在 V2 及以上的依赖，会在版本号后加上 `+incompatible` 后缀。表示可能会存在不兼容的源代码。

![image-20220517154220581](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/6478f27156754549a6235cbe79bf694a~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp)

### 2.3.6 依赖配置-依赖图

如下图所示，Main 项目依赖项目A 和项目B ，且项目A 和项目B 分别依赖项目C 的 v1.3 和 v1.4 版本。最终编译时，Go 所使用的项目C 的版本为：v1.4 。

【总结】Go 选择最低的兼容版本。

![image-20220517160311299](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/439631ce77fe456bb314e9e9ce2ed831~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp)

### 2.3.7 依赖分发-回源

-   依赖分发，即依赖从何处下载、如何下载的问题。
-   Go 的依赖绝大部分托管在 GitHub 上。Go Module 系统中定义的依赖，最终都可以对应到 GitHub 中某一项目的特定提交 (commit) 或版本。
-   对于 go.mod 中定义的依赖，则直接可以从对应仓库中下载指定依赖，从而完成依赖分发。

![image-20220517161158838](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/a08866eef9694c8083831781f2e21ee1~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp)

**2.弊端**

直接使用 GitHub 仓库下载依赖存在一些问题：

-   首先，无法保证构建稳定性。代码作者可以直接在 GitHub 上增加/修改/删除软件版本。
-   无法保证依赖可用性。代码作者可以直接在 GitHub 上删除代码仓库，导致依赖不可用。
-   第三，如果所有人都直接从 GitHub 上获取依赖，会导致 GitHub 平台负载压力。

**3.解决方案-Proxy**

-   Go Proxy 就是解决上述问题的方案。Go Proxy 是一个服务站点，它会缓存 GitHub 中的代码内容，缓存的代码版本不会改变，并且在 GitHub 作者删除了代码之后也依然可用，从而实现了 "immutability" (不变性) 和 "available" (可用的) 的依赖分发。
-   使用 Go Proxy 后，构建时会直接从 Go Proxy 站点拉取依赖。如下图所示。

![image-20220517183641065](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/3765a36f40a846a69a45ea68347defb5~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp)

### 2.3.8 GOPROXY的使用

-   Go Module 通过 GOPROXY 环境变量控制如何使用 Go Proxy 。

-   GOPROXY 是一个 Go Proxy 站点 URL 列表。

    ```ini
    ini
    复制代码GOPROXY = "https://proxy1.cn, https://proxy2.cn, direct"
    ```

-   上述代码中，`direct` 表示源站 (如 GitHub) ，`proxy1` `proxy2` 是两个URL 站点。依赖寻址路径为：优先从 `proxy1` 下载依赖，如果 `proxy1` 不存在，再从 `proxy2` 寻找，如果 `proxy2` 不存在，则会回源到源站直接下载依赖，并缓存到 Go Proxy 站点中 (这种设计思路和 Redis 缓存与 MySQL 数据库一模一样)。

![image-20220517184332536](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/02fb6e8a00c84508b02ab2109b5d6c14~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp)

### 2.3.9 工具-go get

```arduino
arduino
复制代码go get example.org/pkg +...
```

后面跟不同的指令能实现不同的功能：

| 指令     | 功能                      |
| -------- | ------------------------- |
| @update  | 默认                      |
| @none    | 删除依赖                  |
| @v1.1.2  | 下载指定tag版本，语义版本 |
| @23dfdd5 | 下载特定的commit版本      |
| @master  | 下载分支的最新commit      |

### 2.3.10 工具-go mod

| 指令     | 功能                             |
| -------- | -------------------------------- |
| init     | 初始化，创建go.mod文件           |
| download | 下载模块到本地缓存               |
| tidy     | 增加需要的依赖，删除不需要的依赖 |

在实际开发中，尽量提交之前执行下 `go tidy` ，减少构建时无效依赖包的拉取。

## 2.4 go mod使用

### 2.4.1 设置GO111MODULE

Win + R 输入 cmd 打开命令行，输入：

```sh
sh
复制代码go env
```

即可看到 GO111MODULE (默认情况是空的)：

![image-20220518162705957](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/8f6b96a92e5349fda7dc4ef741e46db6~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp)

GO111MODULE 有三个值：off、on 和 auto (默认值)

-   `GO111MODULE=off` ：go命令行将不会支持module功能，寻找依赖包的方式将会沿用旧版本那种通过vendor目录或者GOPATH模式来查找。

-   `GO111MODULE=on` ：go命令行会使用modules，而一点也不会去GOPATH目录下查找。

-   ```
    GO111MODULE=auto
    ```

     

    ：默认值，go命令行将会根据当前目录来决定是否启用module功能。这种情况下可以分为两种情形：

    -   当前目录在GOPATH/src之外且该目录包含go.mod文件
    -   当前文件在包含go.mod文件的目录下面。

【注】

-   在使用go module时，GOPATH是无意义的。不过它仍然会把下载的依赖存储在 `$GOPATH/pkg/mod` 中，也会把 `go install` 的结果放在 `$GOPATH/bin` 中。
-   当module功能启用时，依赖包的存放位置变更为 `$GOPATH/pkg` 。允许同一个package多个版本并存，且多个项目可以共享缓存的module。

设置的命令如下：

```sh
sh
复制代码go env -w GO111MODULE=on
go env -w GOPROXY=https://goproxy.cn,direct
```

可在命令行中输入：`go env` 查看 `GO111MODULE=on` 。

### 2.4.2 清空所有GOPATH

开启 go mod 之后，并不能与 GOPATH 共存。必须把项目从 GOPATH 中移除，否则会报 `$GOPATH/go.mod exists but should not` 的错误。

在 Goland 中，移除项目所有 GOPATH 的操作如下：

![image-20220518160417108](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/593579446a37485ea125f589ae584f08~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp)

清空 GOPATH 之后，在单元测试模式下，同一个包下不同文件函数调用报错为 `undefined` 的问题也会解决。

### 2.4.3 在新项目中创建go mod

注意：如果你的项目根目录下已经有 `go.mod` 文件，可以不需要创建 `go.mod` 文件。 为了演示如何管理依赖，我创建了 `hello.go` 文件和 `hello_test.go` 单元测试代码：

单元测试的目录结构如下图所示：

![image-20220518132408063](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/667d11225a024cf18cbe23fa7ec3f8d8~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp)

① `hello.go` 代码：

```go
go
复制代码package hello

import "rsc.io/quote"//引入第三方依赖模块

func Hello() string {
   return quote.Hello()
}
```

第 3 行代码：需要导入第三方依赖模块 `rsc.io/quote` 。

② `hello_test.go` 代码：

```go
go
复制代码package hello

import "testing"

func TestHello(t *testing.T) {
   want := "Hello, world."
   if got := Hello(); got != want {
      t.Errorf("Hello() = %q, want %q", got, want)
   }
}
```

1.打开Windows终端命令行，`cd` 到新项目的文件夹目录。输入命令：

```sh
sh
复制代码go mod init XXX(你的文件夹名称)
```

![image-20220518171656640](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/2c1558c6fa2d4d9a8527527bed0cbefc~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp)

成功创建了 `go.mod` 文件，如下图所示：

![image-20220518165322088](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/35d660c299c54cacb16bf8cd78fcef2e~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp)

2.【重点！】从 Go 1.16 开始，创建完 `go.mod` 文件还必须执行指令：

```sh
sh
复制代码$ go mod tidy
```

来增加项目需要的最小依赖。否则，运行 `go test` 指令时会报 `no Go files in G:\hello` 和 `no required module provides package rsc.io/quote; to add it: go get rsc.io/quote` 的错误。 运行结果如下图所示，go mod 会自动拉取项目所需的最小依赖。

![image-20220518204236617](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/a794f6303a814e53968b0f43989d6363~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp)

此时我们可以打开看看 `go.mod` 文件中的内容：

```sh
sh
复制代码$ cat go.mod
```

输出：

```javascript
javascript
复制代码module hello

go 1.18

require rsc.io/quote v1.5.2

require (
        golang.org/x/text v0.0.0-20170915032832-14c0d48ead0c // indirect
        rsc.io/sampler v1.3.0 // indirect
)
```

在 Goland 中可以双击直接打开：

![image-20220518204405803](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/e5b1fe5f9bb04be691e0761539918396~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp)

这样，就成功编写并测试了第一个模块了。

### 2.4.4 go.mod文件结构

-   `module` ：指定模块的名称 (路径)
-   `go` ：依赖的原生 Go SDK 版本
-   `require` ：项目所依赖的模块
-   `replace` ：可以替换依赖的模块
-   `exclude` ：可以忽略依赖的模块

### 2.4.5 添加依赖

在完成上述所有操作后，发现 `hello.go` 文件还是编译不通过，如下图所示：

![image-20220518204513345](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/3935c68018fa4fdbb9a5d44fb12aca6c~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp)

这时候我们再次执行 `go test` 指令，如下图所示：

![image-20220518204907404](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/3ac07ffe07094842b3f84d5d06a990ce~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp)

发现 go mod 会自动查找依赖并自动下载。单元测试通过。

【注意】此时我们已经开启go mod模式了，但Goland可能仍出现 `hello.go` 文件的 import 报红的情况。

【解决方法】如下图设置，`Environment` 处填写的 GOPROXY 网址要与cmd命令行输入 `go env` 中的 GOPROXY 保持一致。设置好后重启Goland即可。

![image-20220519092159634](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/b8c0a6434fe94da29c2cc879beb913ec~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp)

![image-20220519092439474](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/9c36a3d9b5564dd28522dfd4b01f07fc~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp)

go module 安装 package 的原則是先拉最新的 release tag，若无tag则拉最新的commit，详见 [Modules官方介绍](https://link.juejin.cn/?target=https%3A%2F%2Fgithub.com%2Fgolang%2Fgo%2Fwiki%2FModules)。 go 会自动生成一个 go.sum 文件来记录 dependency tree：

![image-20220518205257609](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/dd8b65b7c78a4197babbdf9557757d06~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp)

-   在代码没有改变的情况下，再次执行代码会发现跳过了检查并安装依赖的步骤。
-   可以使用命令 `go list -m -u all` 来检查可以升级的 package ，使用 `go get -u need-upgrade-package` 升级后会将新的依赖版本更新到 go.mod 中。也可以使用 `go get -u` 升级所有依赖。

### 2.4.6 go get更新依赖

-   `go get -u` ：更新到最新的次要版本或者修订版本(x.y.z)
-   `go get -u=patch` ：更新到最新的修订版本
-   `go get package@version` ：更新到指定的版本号version
-   运行 `go get` 如果有版本的更改，那么 go.mod 文件也会作出相应的更改。



作者：自牧君
链接：https://juejin.cn/post/7099070146329149477
来源：稀土掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。