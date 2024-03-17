---
title: Go Interface
categories:
- Software
- Language
- Go
---
# Go Interface

- 在 Go 语言中接口 (interface) 是一种类型，一种抽象的类型，包含一组方法的集合，接口 (interface) 定义了一个对象的行为规范，只定义规范不实现，由具体的对象来实现规范的细节
- interface 是一组 method 的集合，是 duck-type prog ramming 的一种体现，接口做的事情就像是定义一个协议（规则), 只要一台机器有洗衣服和甩干的功能，我就称它为洗衣机，不关心属性（数据), 只关心行为（方法)

## 接口的定义

- 每个接口类型由任意个方法签名组成，接口的定义格式如下:

```go
type 接口类型名 interface{
    方法名1( 参数列表1 ) 返回值列表1
    方法名2( 参数列表2 ) 返回值列表2
…
}
```

- `接口类型名`: Go 语言的接口在命名时，一般会在单词后面添加 `er`, 如有写操作的接口叫 `Writer`, 有关闭操作的接口叫 `closer` 等，接口名最好要能突出该接口的类型含义
- `方法名`:当方法名首字母是大写且这个接口类型名首字母也是大写时，这个方法可以被接口所在的包 (package) 之外的代码访问
- `参数列表，返回值列表`: 参数列表和返回值列表中的参数变量名可以省略

```go
type Writer interface{
    Write([]byte) error
}
```

## 实现接口的条件

- 接口就是规定了一个**需要实现的方法列表**, 在 Go 语言中一个类型只要实现了接口中规定的所有方法，那么就称它实现了这个接口
- 例如定义的 `Singer` 接口类型，它包含一个 `Sing` 方法

```go
// Singer 接口
type Singer interface {
	Sing()
}
```

- 有一个 `Bird` 结构体类型如下

```go
type Bird struct {}
```

- 因为 `Singer` 接口只包含一个 `Sing` 方法，所以只需要给 `Bird` 结构体添加一个 `Sing` 方法就可以满足 `Singer` 接口的要求

```go
// Sing Bird类型的Sing方法
func (b Bird) Sing() {
	fmt.Println("汪汪汪")
}
```

- 这样就称为 `Bird` 实现了 `Singer` 接口

## 面向接口编程

- PHP, Java 等语言中也有接口的概念，不过在 PHP 和 Java 语言中需要显式声明一个类实现了哪些接口，在 Go 语言中使用隐式声明的方式实现接口，只要一个类型实现了接口中规定的所有方法，那么它就实现了这个接口
- Go 语言中的这种设计符合程序开发中抽象的一般规律，例如在下面的代码示例中，我们的电商系统最开始只设计了支付宝一种支付方式:

```go
type AliPay struct {
    // 支付宝
}

// Pay 支付宝的支付方法
func (a *AliPay) Pay(amount int64) {
    fmt.Printf("使用支付宝付款:%.2f元,\n", float64(amount/100))
}

// Checkout 结账
func Checkout(obj *AliPay) {
    // 支付100元
    obj.Pay(100)
}

func main() {
    Checkout(&AliPay{})
}
```

- 随着业务的发展，根据用户需求添加支持微信支付

```go
type WeChat struct {
	// 微信
}

// Pay 微信的支付方法
func (w *WeChat) Pay(amount int64) {
	fmt.Printf("使用微信付款:%.2f元,\n", float64(amount/100))
}
```

- 在实际的交易流程中，我们可以根据用户选择的支付方式来决定最终调用支付宝的 Pay 方法还是微信支付的 Pay 方法

```go
// Checkout 支付宝结账
func CheckoutWithZFB(obj *AliPay) {
    // 支付100元
    obj.Pay(100)
}

// Checkout 微信支付结账
func CheckoutWithWX(obj *WeChat) {
    // 支付100元
    obj.Pay(100)
}
```

- 实际上，从上面的代码示例中我们可以看出，我们其实并不怎么关心用户选择的是什么支付方式，我们只关心调用 Pay 方法时能否正常运行，这就是典型的"不关心它是什么，只关心它能做什么”的场景
- 在这种场景下我们可以将具体的支付方式抽象为一个名为 `Payer` 的接口类型，即任何实现了 `Pay` 方法的都可以称为 `Payer` 类型

```go
// Payer 包含支付方法的接口类型
type Payer interface {
	Pay(int64)
}
```

- 此时只需要修改下原始的 `Checkout` 函数，它接收一个 `Payer` 类型的参数，这样就能够在不修改既有函数调用的基础上，支持新的支付方式

```go
// Checkout 结账
func Checkout(obj Payer) {
	// 支付100元
	obj.Pay(100)
}

func main() {
	Checkout(&AliPay{}) // 之前调用支付宝支付
	Checkout(&WeChat{}) // 现在支持使用微信支付
}
```

## 接口类型变量

- 接口类型的变量能够存储所有实现了该接口的类型变量
- 例如在上面的示例中, `支付宝` 和 `微信` 类型均实现了 `Payer` 接口，此时一个 `Payer` 类型的变量就能够接收 `AliPay` 和 `WeChat` 类型的变量

```go
var x Sayer
a := AliPay{}
b := WeChat{}
x = a // 可以把AliPay类型变量直接赋值给x
x.Pay()
x = b // 可以把WeChat类型变量直接赋值给x
x.Pay()
```

## 值接收者和指针接收者

- 结构体方法时既可以使用值接收者也可以使用指针接收者，那么对于实现接口来说使用值接收者和使用指针接收者有什么区别呢？接下来我们通过一个例子看一下其中的区别

### 值接收者实现接口

- 使用值接收者实现接口之后，不管是结构体类型还是对应的结构体指针类型的变量都可以赋值给该接口变量

```go
// Mover 定义一个接口类型
type Mover interface {
    Move()
}
// Dog 狗结构体类型
type Dog struct{}

// Move 使用值接收者定义Move方法实现Mover接口
func (d Dog) Move() {
    fmt.Println("Dog is Moving")
}
func main(){
    var x Mover    // 声明一个Mover类型的变量x

    var d1 = Dog{} // d1是Dog类型
    x = d1         // 可以将d1赋值给变量x
    x.Move()

    var d2 = &Dog{} // d2是Dog指针类型
    x = d2          // 也可以将d2赋值给变量x
    x.Move()
}
```

### 指针接收者实现接口

- 使用指针接收者实现接口之后，只有结构体指针类型的变量都可以赋值给该接口变量

```go
// Mover 定义一个接口类型
type Mover interface {
    Move()
}

// Cat 猫结构体类型
type Cat struct{}

// Move 使用指针接收者定义Move方法实现Mover接口
func (c *Cat) Move() {
    fmt.Println("Cat is Moving")
}

func main(){
    var x Mover    // 声明一个Mover类型的变量x

    var c1 = &Cat{} // c1是*Cat类型
    x = c1          // 可以将c1当成Mover类型
    x.Move()

    // 下面的代码无法通过编译
    var c2 = Cat{} // c2是Cat类型
    x = c2         // 不能将c2当成Mover类型
}
```

## 接口多实现

- 一个类型可以同时实现多个接口，而接口间彼此独立，不知道对方的实现，例如狗不仅可以叫，还可以动，我们完全可以分别定义 `Sayer` 接口和 `Mover` 接口，具体代码示例如下

```go
// Sayer 接口
type Sayer interface {
	Say()
}

// Mover 接口
type Mover interface {
	Move()
}
```

- `Dog` 既可以实现 `Sayer` 接口，也可以实现 `Mover` 接口

```go
type Dog struct {
	Name string
}

// 实现Sayer接口
func (d Dog) Say() {
	fmt.Printf("%s is Saying\n", d.Name)
}

// 实现Mover接口
func (d Dog) Move() {
	fmt.Printf("%s is Moving\n", d.Name)
}
```

- 同一个类型实现不同的接口互相不影响使用

```go
var d = Dog{Name: "Test"}

var s Sayer = d
var m Mover = d

s.Say()  // 对Sayer类型调用Say方法
m.Move() // 对Mover类型调用Move方法
```

## 方法嵌套实现

- 一个接口的所有方法，不一定需要由一个类型完全实现，接口的方法可以通过在类型中嵌入其他类型或者结构体来实现

```go
type Machine interface {
	wash()
	dry()
}

// 甩干器
type dryer struct{}

// 实现Machine接口的dry()方法
func (d dryer) dry() {
	fmt.Println("dry")
}

// 洗衣机
type WashingMachine struct {
	dryer // 嵌入甩干器
}

// 实现WashingMachine接口的wash()方法
func (w WashingMachine) wash() {
	fmt.Println("wash")
}
```

## 接口组合

- 接口与接口之间可以通过互相嵌套形成新的接口类型，例如 Go 标准库 `io` 源码中就有很多接口之间互相组合的示例

```go
// src/io/io.go

type Reader interface {
	Read(p []byte) (n int, err error)
}

type Writer interface {
	Write(p []byte) (n int, err error)
}

type Closer interface {
	Close() error
}

// ReadWriter 是组合Reader接口和Writer接口形成的新接口类型
type ReadWriter interface {
	Reader
	Writer
}

// ReadCloser 是组合Reader接口和Closer接口形成的新接口类型
type ReadCloser interface {
	Reader
	Closer
}

// WriteCloser 是组合Writer接口和Closer接口形成的新接口类型
type WriteCloser interface {
	Writer
	Closer
}
```

- 对于这种由多个接口类型组合形成的新接口类型，同样只需要实现新接口类型中规定的所有方法就算实现了该接口类型
- 接口也可以作为结构体的一个字段，我们来看一段 Go 标准库 `sort` 源码中的示例

```go
// src/sort/sort.go

// Interface 定义通过索引对元素排序的接口类型
type Interface interface {
    Len() int
    Less(i, j int) bool
    Swap(i, j int)
}

// reverse 结构体中嵌入了Interface接口
type reverse struct {
    Interface
}
```

- 通过在结构体中嵌入一个接口类型，从而让该结构体类型实现了该接口类型，并且还可以重写该接口的方法

```go
// Less 为reverse类型添加Less方法，重写原Interface接口类型的Less方法
func (r reverse) Less(i, j int) bool {
	return r.Interface.Less(j, i)
}
```

- `Interface` 类型原本的 `Less` 方法签名为 `Less(i, j int) bool`, 此处重写为 `r.Interface.Less(j, i)`, 即通过将索引参数交换位置实现反转
- 在这个示例中还有一个需要注意的地方是 `reverse` 结构体本身是不可导出的（结构体类型名称首字母小写), `sort.go` 中通过定义一个可导出的 `Reverse` 函数来让使用者创建 `reverse` 结构体实例

```go
func Reverse(data Interface) Interface {
	return &reverse{data}
}
```

- 这样做的目的是保证得到的 `reverse` 结构体中的 `Interface` 属性一定不为 `nil`, 否者 `r.Interface.Less(j, i)` 就会出现空指针panic

## 空接口

### 空接口的定义

- 空接口是指没有定义任何方法的接口类型，因此任何类型都可以视为实现了空接口，也正是因为空接口类型的这个特性，空接口类型的变量可以存储任意类型的值

```go
package main

import "fmt"

// 空接口

// Any 不包含任何方法的空接口类型
type Any interface{}

// Dog 狗结构体
type Dog struct{}

func main () {
	var x Any

	x = "你好" // 字符串型
	fmt.Printf ("type:%T value:%v\n", x, x)
	x = 100 // int 型
	fmt.Printf ("type:%T value:%v\n", x, x)
	x = true // 布尔型
	fmt.Printf ("type:%T value:%v\n", x, x)
	x = Dog{} // 结构体类型
	fmt.Printf ("type:%T value:%v\n", x, x)
}
```

- 通常我们在使用空接口类型时不必使用`type`关键字声明，可以像下面的代码一样直接使用`interface{}`

```go
var x interface{}  // 声明一个空接口类型变量 x
```

### 空接口的应用

#### 空接口作为函数的参数

- 使用空接口实现可以接收任意类型的函数参数

```go
// 空接口作为函数参数
func show (a interface{}) {
	fmt.Printf ("type:%T value:%v\n", a, a)
}
```

#### 空接口作为 map 的值

- 使用空接口实现可以保存任意值的 Map

```go
// 空接口作为 map 值
var studentInfo = make (map[string]interface{})
studentInfo["name"] = "Test"
studentInfo["age"] = 18
studentInfo["married"] = false
fmt.Println (studentInfo)
```

## 接口值

- 由于接口类型的值可以是任意一个实现了该接口的类型值，所以接口值除了需要记录具体**值**之外，还需要记录这个值属于的**类型**, 也就是说接口值由"类型”和"值”组成，鉴于这两部分会根据存入值的不同而发生变化，我们称之为接口的`动态类型`和`动态值`

![接口值示例](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/interface01.png)

- 我们接下来通过一个示例来加深对接口值的理解，下面的示例代码中，定义了一个`Mover`接口类型和两个实现了该接口的`Dog`和`Car`结构体类型

```go
type Mover interface {
    Move ()
}

type Dog struct {
    Name string
}

func (d *Dog) Move () {
    fmt.Println ("Dog is Moving")
}

type Car struct {
    Brand string
}

func (c *Car) Move () {
    fmt.Println ("Car is Moving")
}
```

- 首先创建一个`Mover`接口类型的变量`m`

```go
var m Mover
fmt.Println (m == nil)  // true
```

- 此时，接口变量`m`是接口类型的零值，也就是它的类型和值部分都是`nil`, 如下图所示

![接口值示例](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/interface02.png)

- 接下来，我们将一个`*Dog`结构体指针赋值给变量`m`

```go
m = &Dog{Name: "Test"}
```

- 此时，接口值`m`的动态类型会被设置为`*Dog`, 动态值为结构体变量的拷贝

![接口值示例](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/interface03.png)

- 然后，我们给接口变量`m`赋值为一个`*Car`类型的值

```go
m = new (Car)
```

- 这一次，接口值的动态类型为`*Car`, 动态值为`nil`

![接口值示例](https://www.liwenzhou.com/images/Go/interface/interface04.png)

- **注意**: 此时接口变量`m`与`nil`并不相等，因为它只是动态值的部分为`nil`, 而动态类型部分保存着对应值的类型

```go
fmt.Println (m == nil) // false
```

- 接口值是支持相互比较的，当且仅当接口值的动态类型和动态值都相等时才相等

```go
var (
	x Mover = new (Dog)
	y Mover = new (Car)
)
fmt.Println (x == y) // false
```

- 但是有一种特殊情况需要特别注意，如果接口值的保存的动态类型相同，但是这个动态类型不支持互相比较（比如切片), 那么对它们相互比较时就会引发 panic

```go
var z interface{} = []int{1, 2, 3}
fmt.Println (z == z) // panic: runtime error: comparing uncomparable type []int
```

## 类型断言

- 接口值可能赋值为任意类型的值，但是可以借助标准库`fmt`包的格式化打印获取到接口值的动态类型

```go
type Mover interface {
    Move ()
}
type Dog struct {
    Name string
}

func (d *Dog) Move () {
    fmt.Println ("Dog is Moving")
}

type Car struct {
    Brand string
}

func (c *Car) Move () {
    fmt.Println ("Car is Moving")
}
func main (){
    var m Mover
    m = &Dog{Name: "旺财"}
    fmt.Printf ("%T\n", m) // *main. Dog
    m = new (Car)
    fmt.Printf ("%T\n", m) // *main. Car
}
```

- `fmt`包内部其实是使用反射的机制在程序运行时获取到动态类型的名称
- 想要从接口值中获取到对应的实际值需要使用类型断言，其语法格式如下

```go
var. (Type)
```

- `var`: 表示接口类型的变量
- `Type`: 表示断言`x`可能是的类型
- 该语法返回两个参数，第一个参数是`x`转化为`T`类型后的变量，第二个值是一个布尔值，若为`true`则表示断言成功，为`false`则表示断言失败

```go
var n Mover = &Dog{Name: "DogName"}
v, ok := n.(*Dog)
if ok {
	fmt.Println ("类型断言成功")
	v.Name = "Test" // 变量 v 是*Dog 类型
} else {
	fmt.Println ("类型断言失败")
}
```

- 如果对一个接口值有多个实际类型需要判断，推荐使用`switch`语句来实现

```go
// justifyType 对传入的空接口类型变量 x 进行类型断言
func justifyType (x interface{}) {
	switch v := x.(type) {
	case string:
		fmt.Printf ("x is a string, value is %v\n", v)
	case int:
		fmt.Printf ("x is a int is %v\n", v)
	case bool:
		fmt.Printf ("x is a bool is %v\n", v)
	default:
		fmt.Println ("unsupport type!")
	}
}
```
