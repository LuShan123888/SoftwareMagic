---
title: Go 编译与运行
categories:
- Software
- Language
- Go
---
# Go 编译与运行

## go build

- `go build` 命令表示将源代码编译成可执行文件
- 在项目目录下执行:

```bash
go build
```

- 或者在其他目录执行:

```bash
go build test
```

- go 编译器会去 `GOPATH` 的 src 目录下查找要编译的 `test` 项目，编译得到的可执行文件会保存在执行编译命令的当前目录下
- 还可以使用 `-o` 参数来指定编译后得到的可执行文件的名字

```bash
go build -o hello
```

## go run

- `go run main.go` 也可以执行程序，该命令本质上也是先编译再执行

## go install

- `go install` 表示安装的意思，它先编译源代码得到可执行文件，然后将可执行文件移动到 `GOPATH` 的 bin 目录下

## 跨平台编译

- 默认我们 `go build` 的可执行文件都是当前操作系统可执行的文件, Go 语言支持跨平台编译——在当前平台（例如 Windows) 下编译其他平台（例如 Linux) 的可执行文件
- 在编译时指定目标操作系统的平台和处理器架构可以进行跨平台编译

### Windows 编译 Linux 可执行文件

- Windows 编译 Linux 可执行文件

    cmd 终端执行

```bash
SET CGO_ENABLED=0  // 禁用CGO
SET GOOS=linux  // 目标平台是linux
SET GOARCH=amd64  // 目标处理器架构是amd64
go build
```

- PowerShell 终端执行

```bash
$ENV:CGO_ENABLED=0
$ENV:GOOS="linux"
$ENV:GOARCH="amd64"
go build
```

### Windows 编译 Mac 可执行文件

- Windows 编译 Mac 64 位可执行程序
- cmd 终端执行

```bash
SET CGO_ENABLED=0
SET GOOS=darwin
SET GOARCH=amd64
go build
```

- PowerShell 终端执行

```bash
$ENV:CGO_ENABLED=0
$ENV:GOOS="darwin"
$ENV:GOARCH="amd64"
go build
```

### Mac 编译 Linux 可执行文件

- Mac 编译 Linux 64 位可执行程序

```bash
CGO_ENABLED=0
GOOS=linux
GOARCH=amd64
go build
```

### Mac 编译 Windows 可执行文件

- Mac 编译得到 Windows 64 位可执行程序

```bash
CGO_ENABLED=0
GOOS=windows
GOARCH=amd64
go build
```

### Linux 编译 Mac 可执行文件

- Linux 编译 Mac 64 位可执行程序

```bash
CGO_ENABLED=0
GOOS=darwin
GOARCH=amd64
go build
```

### Linux 编译 Windows 可执行文件

- Linux 编译 Windows 64 位可执行程序

```bash
CGO_ENABLED=0
GOOS=windows
GOARCH=amd64
go build
```