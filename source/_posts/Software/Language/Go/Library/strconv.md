---
title: Go strconv
categories:
- Software
- Language
- Go
- Library
---
# Go strconv

strconv 包实现了基本数据类型与其字符串表示的转换，主要有以下常用函数： `Atoi()`、`Itoa()`、parse 系列、format 系列、append 系列。

## string 与 int 类型转换

### Atoi ()

`Atoi()` 函数用于将字符串类型的整数转换为 int 类型，函数签名如下。

```go
func Atoi(s string) (i int, err error)
```

如果传入的字符串参数无法转换为 int 类型，就会返回错误。

```go
s1 := "100"
i1, err := strconv.Atoi(s1)
if err != nil {
    fmt.Println("can't convert to int")
} else {
    fmt.Printf("type:%T value:%#v\n", i1, i1) //type:int value:100
}
```

### Itoa ()

`Itoa()` 函数用于将 int 类型数据转换为对应的字符串表示，具体的函数签名如下。

```go
func Itoa(i int) string
```

示例代码如下：

```go
i2 := 200
s2 := strconv.Itoa(i2)
fmt.Printf("type:%T value:%#v\n", s2, s2) //type:string value:"200"
```

## Parse

Parse 类函数用于转换字符串为给定类型的值：ParseBool ()、ParseFloat ()、ParseInt ()、ParseUint ()。

### ParseBool ()

返回字符串表示的 bool 值。接受 1、0、t、f、T、F、true、false、True、False、TRUE、FALSE；否则返回错误。

```go
func ParseBool(str string) (value bool, err error)

b, err := strconv.ParseBool("true")
```

### ParseInt ()

返回字符串表示的整数值，接受正负号。

```go
func ParseInt(s string, base int, bitSize int) (i int64, err error)

i, err := strconv.ParseInt("-2", 10, 64)
```

- base 指定进制（2 到 36），如果 base 为 0，则会从字符串前置判断，”0 x”是 16 进制，”0”是 8 进制，否则是 10 进制；
- bitSize 指定结果必须能无溢出赋值的整数类型，0、8、16、32、64 分别代表 int、int 8、int 16、int 32、int 64；
- 返回的 err 是*NumErr 类型的，如果语法有误，err. Error = ErrSyntax；如果结果超出类型范围 err. Error = ErrRange。

### ParseUnit ()

```go
func ParseUint(s string, base int, bitSize int) (n uint64, err error)

u, err := strconv.ParseUint("2", 10, 64)
```

`ParseUint` 类似 `ParseInt` 但不接受正负号，用于无符号整型。

### ParseFloat ()

解析一个表示浮点数的字符串并返回其值。

```go
func ParseFloat(s string, bitSize int) (f float64, err error)

f, err := strconv.ParseFloat("3.1415", 64)
```

- 如果 s 合乎语法规则，函数会返回最为接近 s 表示值的一个浮点数（使用 IEEE 754 规范舍入）。
- bitSize 指定了期望的接收类型，32 是 float 32（返回值可以不改变精确值的赋值给 float 32），64 是 float 64；
- 返回值 err 是*NumErr 类型的，语法有误的，err. Error=ErrSyntax；结果超出表示范围的，返回值 f 为±Inf，err. Error= ErrRange。

## Format 系列函数

Format 系列函数实现了将给定类型数据格式化为 string 类型数据的功能。

### FormatBool ()

根据 b 的值返回 `true` 或 `false`。

```go
func FormatBool(b bool) string

s1 := strconv.FormatBool(true)
```

### FormatInt ()

返回 i 的 base 进制的字符串表示。base 必须在 2 到 36 之间，结果中会使用小写字母 `a` 到 `z` 表示大于 10 的数字。

```go
func FormatInt(i int64, base int) string

s3 := strconv.FormatInt(-2, 16)
```

### FormatUint ()

FormatInt 的无符号整数版本。

```go
func FormatUint(i uint64, base int) string

s4 := strconv.FormatUint(2, 16)
```

### FormatFloat ()

函数将浮点数表示为字符串并返回。

```go
func FormatFloat(f float64, fmt byte, prec, bitSize int) string

s2 := strconv.FormatFloat(3.1415, 'E', -1, 64)
```

- fmt 表示格式：`f`（-ddd. dddd）, `b`（-ddddp±ddd，指数为二进制）、`e`（-d.dddde±dd，十进制指数）、`E`（-d.ddddE±dd，十进制指数）、`g`（指数很大时用 `e` 格式，否则 `f` 格式）、`G`（指数很大时用 `E` 格式，否则 `f` 格式）。
- prec 控制精度（排除指数部分）：对 `f`、`e`、`E`，它表示小数点后的数字个数；对 `g`、`G`，它控制总的数字个数。如果 prec 为-1，则代表使用最少数量的、但又必需的数字来表示 f。
- bitSize 表示 f 的来源类型（32：float 32、64：float 64），会据此进行舍入。

## 其他

### isPrint ()

返回一个字符是否是可打印的。

```go
func IsPrint(r rune) bool
```

- `r` 必须是：字母（广义）、数字、标点、符号、ASCII 空格。

### CanBackquote ()

返回字符串 s 是否可以不被修改的表示为一个单行的、没有空格和 tab 之外控制字符的反引号字符串。

```go
func CanBackquote(s string) bool
```

