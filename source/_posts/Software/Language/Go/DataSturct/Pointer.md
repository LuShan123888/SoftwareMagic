---
title: Go Pointer
categories:
- Software
- Language
- Go
- DataSturct
---
# Go Pointer

- 任何程序数据载入内存后，在内存都有他们的地址，这就是指针，而为了保存一个数据在内存中的地址，就需要指针变量
- Go 语言中的指针不能进行偏移和运算，因此 Go 语言中的指针操作非常简单，只有两个符号: `&` (取地址）和 `*` (根据地址取值)

## 指针地址和指针类型

- 每个变量在运行时都拥有一个地址，这个地址代表变量在内存中的位置, Go 语言中使用 `&` 字符放在变量前面对变量进行"取地址”操作, Go 语言中的值类型 (int, float, bool, string, array, struct) 都有对应的指针类型，如: `*int`, `*int64`, `*string` 等
- 对变量进行取地址 (&) 操作，可以获得这个变量的指针变量
- 指针变量的值是指针地址

```go
v := 1 // v的类型为int
ptr := &v // ptr的类型为*T,称做T的指针类型
```

```go
func main() {
	a := 10
	b := &a
	fmt.Printf("a:%d ptr:%p\n", a, &a) // a:10 ptr:0xc00001a078
	fmt.Printf("b:%p type:%T\n", b, b) // b:0xc00001a078 type:*int
	fmt.Println(&b)                    // 0xc00000e018
}
```

## 指针取值

- 对指针变量进行取值 (*) 操作，可以获得指针变量指向的原变量的值，指针取值

```go
func main() {
	// 指针取值
	a := 10
	b := &a // 取变量a的地址，将指针保存到b中
	fmt.Printf("type of b:%T\n", b)
	c := *b // 指针取值（根据指针去内存取值)
	fmt.Printf("type of c:%T\n", c)
	fmt.Printf("value of c:%v\n", c)
}
```

```go
type of b:*int
type of c:int
value of c:10
```

## new 和 make

- Go 语言中对于引用类型的变量，我们在使用的时候不仅要声明它，还要为它分配内存空间，否则我们的值就没办法存储，而对于值类型的声明不需要分配内存空间，是因为它们在声明的时候已经默认分配好了内存空间
- Go 语言中 new 和 make 是内建的两个函数，主要用来分配内存

### new

- new 是一个内置的函数, new 函数可以得到一个类型的指针，并且该指针对应的值为该类型的零值

```go
func new(Type) *Type
```

- `Type`: 表示类型, new 函数只接受一个参数，这个参数是一个类型
- `*Type` 表示类型指针, new 函数返回一个指向该类型内存地址的指针

```go
func main() {
	a := new(int)
	b := new(bool)
	fmt.Printf("%T\n", a) // *int
	fmt.Printf("%T\n", b) // *bool
	fmt.Println(*a)       // 0
	fmt.Println(*b)       // false

	var a *int
	a = new(int) // 赋值前需要分配空间
	*a = 10
	fmt.Println(*a)
}
```

### make

- make 也是用于内存分配的，区别于 new, 它只用于 slice, map 以及 channel 的内存创建，而且返回的类型就是这三个类型本身，而不是指针类型

```go
func make(t Type, size ...IntegerType) Type
```

```go
func main() {
	var b map[string]int
	b = make(map[string]int, 10)
	b["Test"] = 100
	fmt.Println(b)
}
```
