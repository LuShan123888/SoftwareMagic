---
title: Go Dependence
categories:
- Software
- Language
- Go
---
# Go Dependence

## 包 (package)

- Go 语言中支持模块化的开发理念，在 Go 语言中使用 `包(package)` 来支持代码模块化和代码复用，一个包是由一个或多个 Go 源码文件 (. go 结尾的文件) 组成，是一种高级的代码复用方案, Go 语言为我们提供了很多内置包，如 `fmt`, `os`, `io` 等

### 定义包

- 可以根据需要创建自定义包，一个包可以简单理解为一个存放 `.go` 文件的文件夹，该文件夹下面的所有 `.go` 文件都要在非注释的第一行添加如下声明，声明该文件归属的包

```go
package packagename
```

- `package`: 声明包的关键字
- `packagename`: 包名，可以不与文件夹的名称一致，不能包含 `-` 符号，最好与其实现的功能相对应

- **注意**: 一个文件夹下面直接包含的文件只能归属一个包，同一个包的文件不能在多个文件夹下，包名为 `main` 的包是应用程序的入口包，这种包编译后会得到一个可执行文件，而编译不包含 `main` 包的源代码则不会得到可执行文件

### 标识符可见性

- 在同一个包内部声明的标识符都位于同一个命名空间下，在不同的包内部声明的标识符就属于不同的命名空间，想要在包的外部使用包内部的标识符就需要添加包名前缀，例如 `fmt.Println("Hello world!")`, 就是指调用 `fmt` 包中的 `Println` 函数
- 如果想让一个包中的标识符（如变量，常量，类型，函数等) 能被外部的包使用，那么标识符必须是对外可见的 (public), 在 Go 语言中是通过标识符的首字母大/小写来控制标识符的对外可见 (public)/不可见 (private) 的，在一个包内部只有首字母大写的标识符才是对外可见的

```go
package demo

import "fmt"

// 包级别标识符的可见性

// num 定义一个全局整型变量
// 首字母小写，对外不可见（只能在当前包内使用)
var num = 100

// Mode 定义一个常量
// 首字母大写，对外可见（可在其它包中使用)
const Mode = 1

// person 定义一个代表人的结构体
// 首字母小写，对外不可见（只能在当前包内使用)
type person struct {
    name string
    Age  int
}

// Add 返回两个整数和的函数
// 首字母大写，对外可见（可在其它包中使用)
func Add(x, y int) int {
    return x + y
}

// sayHi 打招呼的函数
// 首字母小写，对外不可见（只能在当前包内使用)
func sayHi() {
    var myName = "Test" // 函数局部变量，只能在当前函数内使用
    fmt.Println(myName)
}
```

- 同样的规则也适用于结构体，结构体中可导出字段的字段名称必须首字母大写

```go
type Student struct {
	Name  string // 可在包外访问的方法
	class string // 仅限包内访问的字段
}
```

### 包的引入

- 要在当前包中使用另外一个包的内容就需要使用 `import` 关键字引入这个包，并且 import 语句通常放在文件的开头, `package` 声明语句的下方，完整的引入声明语句格式如下:

```go
import importname "path/to/package"
```

- `importname`: 引入的包名，通常都省略，默认值为引入包的包名
- `path/to/package`: 引入包的路径名称，必须使用双引号包裹起来
- **注意**: Go 语言中禁止循环导入包

#### 包的别名

- 当引入的多个包中存在相同的包名或者想自行为某个引入的包设置一个新包名时，都需要通过 `importname` 指定一个在当前文件中使用的新包名，例如，在引入 `fmt` 包时为其指定一个新包名 `f`

```go
import f "fmt"
```

- 这样在当前这个文件中就可以通过使用 `f` 来调用 `fmt` 包中的函数了

```go
f.Println("Hello world!")
```

- 如果引入一个包的时候为其设置了一个特殊 `_` 作为包名，那么这个包的引入方式就称为匿名引入，一个包被匿名引入的目的主要是为了加载这个包，从而使得这个包中的资源得以初始化，被匿名引入的包中的 `init` 函数将被执行并且仅执行一遍

```go
import _ "github.com/go-sql-driver/mysql"
```

- 匿名引入的包与其他方式导入的包一样都会被编译到可执行文件中
- **注意**: Go 语言中不允许引入包却不在代码中使用这个包的内容，如果引入了未使用的包则会触发编译错误

### init 初始化函数

- 在每一个 Go 源文件中，都可以定义任意个如下格式的特殊函数:

```go
func init(){
  // ...
}
```

- 这种特殊的函数不接收任何参数也没有任何返回值，也不能在代码中主动调用它，当程序启动的时候, init 函数会按照它们声明的顺序自动执行
- 一个包的初始化过程是按照代码中引入的顺序来进行的，所有在该包中声明的 `init` 函数都将被串行调用并且仅调用执行一次，每一个包初始化的时候都是先执行依赖的包中声明的 `init` 函数再执行当前包中声明的 `init` 函数，确保在程序的 `main` 函数开始执行时所有的依赖包都已初始化完成

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/package01.png" alt="包初始化函数执行顺序示意图" style="zoom:67%;" />

- 每一个包的初始化是先从初始化包级别变量开始的，例如从下面的示例中我们就可以看出包级别变量的初始化会先于 `init` 初始化函数

```go
package main

import "fmt"

var x int8 = 10

const pi = 3.14

func init() {
    fmt.Println("x:", x)
    fmt.Println("pi:", pi)
    sayHi()
}

func sayHi() {
    fmt.Println("Hello World!")
}

func main() {
    fmt.Println("你好，世界!")
}
```

```bash
x: 10
pi: 3.14
Hello World!
你好，世界!
```

## go module

- 在 Go 语言的早期版本中，我写 Go 项目代码时所依赖的所有第三方包都需要保存在 GOPATH 这个目录下面，这样的依赖管理方式存在一个致命的缺陷，那就是不支持版本管理，同一个依赖包只能存在一个版本的代码，可是我们本地的多个项目完全可能分别依赖同一个第三方包的不同版本
- Go module 是 Go 1.11 版本发布的依赖管理方案，从 Go 1.14 版本开始推荐在生产环境使用，于 Go 1.16 版本默认开启
- 使用 go module 管理依赖后会在项目根目录下生成两个文件 `go.mod` 和 `go.sum`

### go mod

|      命令       |                   介绍                   |
| :-------------: | :--------------------------------------: |
|   go mod init   |      初始化项目依赖，生成 go. mod 文件      |
| go mod download |          根据 go. mod 文件下载依赖          |
|   go mod tidy   | 比对项目文件中引入的依赖与 go. mod 进行比对 |
|  go mod graph   |              输出依赖关系图              |
|   go mod edit   |              编辑 go. mod 文件              |
|  go mod vendor  |     将项目的所有依赖导出至 vendor 目录     |
|  go mod verify  |        检验一个依赖包是否被篡改过        |
|   go mod why    |          解释为什么需要某个依赖          |

### GOPROXY

- 这个环境变量主要是用于设置 Go 模块代理 (Go module proxy), 其作用是用于使 Go 在后续拉取模块版本时能够脱离传统的 VCS 方式，直接通过镜像站点来快速拉取
- GOPROXY 的默认值是: `https://proxy.golang.org,direct`, 由于某些原因国内无法正常访问该地址，所以我们通常需要配置一个可访问的地址，目前社区使用比较多的有两个 `https://goproxy.cn` 和 `https://goproxy.io`, 当然如果你的公司有提供 GOPROXY 地址那么就直接使用，设置 GOPAROXY 的命令如下:

```bash
go env -w GOPROXY=https://goproxy.cn,direct
```

- GOPROXY 允许设置多个代理地址，多个地址之间需使用英文逗号 ",” 分隔，最后的 "direct” 是一个特殊指示符，用于指示 Go 回源到源地址去抓取（比如 GitHub 等), 当配置有多个代理地址时，如果第一个代理地址返回 404 或 410 错误时, Go 会自动尝试下一个代理地址，当遇见 "direct” 时触发回源，也就是回到源地址去抓取

### GOPRIVATE

- 设置了 GOPROXY 之后, go 命令就会从配置的代理地址拉取和校验依赖包，当我们在项目中引入了非公开的包（公司内部 git 仓库或 github 私有仓库等), 此时便无法正常从代理拉取到这些非公开的依赖包，这个时候就需要配置 GOPRIVATE 环境变量, GOPRIVATE 用来告诉 go 命令哪些仓库属于私有仓库，不必通过代理服务器拉取和校验
- GOPRIVATE 的值也可以设置多个，多个地址之间使用英文逗号 ",” 分隔，我们通常会把自己公司内部的代码仓库设置到 GOPRIVATE 中，例如:

```bash
$ go env -w GOPRIVATE="git.mycompany.com"
```

- 这样在拉取以 `git.mycompany.com` 为路径前缀的依赖包时就能正常拉取了
- 此外，如果公司内部自建了 GOPROXY 服务，那么我们可以通过设置 `GONOPROXY=none`, 允许通内部代理拉取私有仓库的包

### 项目初始化

- 初始化项目依赖，生成 go. mod 文件

```bash
$ go mod init Test
go: creating new go.mod: module Test
```

- 该命令会自动在项目目录下创建一个 `go.mod` 文件，其内容如下

```go
module Test

go 1.16
```

- `module Test`: 定义当前项目的导入路径
- `go 1.16`: 标识当前项目使用的 Go 版本
- `go.mod` 文件会记录项目使用的第三方依赖包信息，包括包名和版本

### 下载依赖

#### go get

- 在项目中执行 `go get` 命令可以下载依赖包，查找并记录当前项目的依赖，同时生成一个 `go.sum` 记录每个依赖库的版本和哈希值

```go
go get packagename
```

- `-u`: 将会升级到最新的次要版本或者修订版本 (x.y.z, z 是修订版本号, y 是次要版本号)
- `-u=patch`: 将会升级到最新的修订版本

- 在项目目录下执行 `go get` 命令手动下载依赖的包:

```bash
$ go get -u github.com/test/hello
go get: added github.com/test/hello v0.1.1
```

- 这样默认会下载最新的发布版本，你也可以指定想要下载指定的版本号的

```bash
$ go get -u github.com/test/hello@v0.1.0
go: downloading github.com/test/hello v0.1.0
go get: downgraded github.com/test/hello v0.1.1 => v0.1.0
```

- 如果想指定下载某个 commit 对应的代码，可以直接指定 commit hash, 不过没有必要写出完整的 commit hash, 一般前 7 位即可，例如:

```bash
$ go get github.com/q1mi/hello@2ccfadd
go: downloading github.com/q1mi/hello v0.1.2-0.20210219092711-2ccfaddad6a3
go get: added github.com/q1mi/hello v0.1.2-0.20210219092711-2ccfaddad6a3
```

- 此时, `go.mod` 文件会记录下载的依赖包及版本信息

```
module Test

go 1.16

require github. com/test/hello v 0.1.0 // indirect
```

- 行尾的`indirect`表示该依赖包为间接依赖，说明在当前程序中的所有 import 语句中没有发现引入这个包

#### go mod download

- 直接编辑`go. mod`文件，将依赖包和版本信息写入该文件

```
module Test

go 1.16

require github. com/test/hello latest // 最新版本
require github. com/test/hello v 0.1.0 // 指定版本号
require github. com/test/hello 2 ccfadda // 指定 commit hash
```

- 然后在项目目录下执行`go mod download`下载依赖包

```bash
$ go mod download
```

- 如果不输出其它提示信息就说明依赖已经下载成功

#### 依赖地址替换

- 通过 replace 可以替换 module 的地址

```go
replace (
	golang. org/x/crypto v 0.0.0-20180820150726-614 d 502 a 4 dac => github. com/golang/crypto v 0.0.0-20180820150726-614 d 502 a 4 dac
	golang. org/x/net v 0.0.0-20180821023952-922 f 4815 f 713 => github. com/golang/net v 0.0.0-20180826012351-8 a 410 e 7 b 638 d
	golang. org/x/text v 0.3.0 => github. com/golang/text v 0.3.0
)
```

#### 依赖保存位置

- Go module 会把下载到本地的依赖包会以类似下面的形式保存在 `$GOPATH/pkg/mod`目录下，每个依赖包都会带有版本号进行区分，这样就允许在本地存在同一个包的多个不同版本

```bash
mod
├── cache
├── cloud. google. com
├── github. com
    	└──Test
          ├── hello@v0.0.0-20210218074646-139b0bcd549d
          ├── hello@v0.1.1
          └── hello@v0.1.0
...
```

- 如果想清除所有本地已缓存的依赖包数据，可以执行 `go clean -modcache` 命令

### go. mod 文件

- `go. mod`文件中记录了当前项目中所有依赖包的相关信息，声明依赖的格式如下:

```bash
require module/path v 1.2.3
```

- `require`: 声明依赖的关键字
- `module/path`: 依赖包的引入路径
- `v 1.2.3`: 依赖包的版本号，支持以下几种格式:
    - `latest`: 最新版本
    - `v 1.0.0`: 详细版本号
    - `commit hash`: 指定某次 commit hash
- 引入某些没有发布过`tag`版本标识的依赖包时,`go. mod`中记录的依赖版本信息就会出现类似`v 0.0.0-20210218074646-139 b 0 bcd 549 d`的格式，由版本号, commit 时间和 commit 的 hash 值组成

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/module_version_info.png" alt="go module生成的版本信息组成示意图" style="zoom:67%;" />

### go. sum 文件

- 不同于其他语言提供的基于中心的包管理机制，例如 npm 和 pypi 等, Go 并没有提供一个中央仓库来管理所有依赖包，而是采用分布式的方式来管理包，为了防止依赖包被非法篡改, Go module 引入了`go. sum`机制来对依赖包进行校验
- 使用 go module 下载了依赖后，项目目录下还会生成一个`go. sum`文件，这个文件中详细记录了当前项目中引入的依赖包的信息及其 hash 值,`go. sum`文件内容通常是以类似下面的格式出现

```go
<module> <version>/go. mod <hash>
// 或者
<module> <version> <hash>
<module> <version>/go. mod <hash>
```

### 废弃已发布依赖的版本

- 如果某个发布的版本存在致命缺陷不再想让用户使用时，我们可以使用`retract`声明废弃的版本，例如我们在`hello/go. mod`文件中按如下方式声明即可对外废弃`v 0.1.2`版本

```go
module github. com/test/hello

go 1.16

retract v 0.1.2
```

- 用户使用 go get 下载`v 0.1.2`版本时就会收到提示，催促其升级到其他版本