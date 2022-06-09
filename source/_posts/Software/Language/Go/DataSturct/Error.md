---
title: Go Error
categories:
- Software
- Language
- Go
- DataSturct
---
# Go Error

- Go 语言中把错误当成一种特殊的值来处理,不支持其他语言中使用`try/catch`捕获异常的方式

## Error 接口

- Go 语言中使用一个名为 `error` 接口来表示错误类型
- `error` 接口只包含一个方法——`Error`,这个函数需要返回一个描述错误信息的字符串

```go
type error interface {
    Error() string
}
```

- 当一个函数或方法需要返回错误时,通常是把错误作为最后一个返回值,例如下面标准库 os 中打开文件的函数

```go
func Open(name string) (*File, error) {
	return OpenFile(name, O_RDONLY, 0)
}
```

- 由于 error 是一个接口类型,默认零值为`nil`,所以我们通常将调用函数返回的错误与`nil`进行比较,以此来判断函数是否返回错误

```go
file, err := os.Open("./xx.go")
if err != nil {
	fmt.Println("打开文件失败,err:", err)
	return
}
```

## 创建错误

- 可以根据需求自定义 error,最简单的方式是使用`errors` 包提供的`New`函数创建一个错误

### errors.New

```go
func New(text string) error
```

- 它接收一个字符串参数返回包含该字符串的错误,可以在函数返回时快速创建一个错误

```go
func queryById(id int64) (*Info, error) {
	if id <= 0 {
		return nil, errors.New("无效的id")
	}

	// ...
}
```

- 或者用来定义一个错误变量,例如标准库`io.EOF`错误定义如下

```go
var EOF = errors.New("EOF")
```

## fmt.Errorf

- 当需要传入格式化的错误描述信息时,使用`fmt.Errorf`是个更好的选择

```go
fmt.Errorf("查询数据库失败,err:%v", err)
```

- 但是上面的方式会丢失原有的错误类型,只拿到错误描述的文本信息
- 为了不丢失函数调用的错误链,使用`fmt.Errorf`时搭配使用特殊的格式化动词`%w`,可以实现基于已有的错误再包装得到一个新的错误

```go
fmt.Errorf("查询数据库失败,err:%w", err)
```

- 对于这种二次包装的错误,`errors`包中提供了以下三个方法

```go
func Unwrap(err error) error                 // 获得err包含下一层错误
func Is(err, target error) bool              // 判断err是否包含target
func As(err error, target interface{}) bool  // 判断err是否为target类型
```

## 错误结构体类型

- 此外还可以自己定义结构体类型,实现``error`接口

```go
// OpError 自定义结构体类型
type OpError struct {
	Op string
}

// Error OpError 类型实现error接口
func (e *OpError) Error() string {
	return fmt.Sprintf("无权执行%s操作", e.Op)
}
```