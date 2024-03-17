---
title: Go Method
categories:
- Software
- Language
- Go
- Function
---
# Go Method

### 方法和接收者

- Go 语言中的 `方法（Method)` 是一种作用于特定类型变量的函数，这种特定类型变量叫做 `接收者（Receiver)`，接收者的概念就类似于其他语言中的 `this` 或者 `self`
- 方法与函数的区别是，函数不属于任何类型，方法属于特定的类型。

```go
func (接收者变量接收者类型）方法名（参数列表） (返回参数） {
    函数体。
}
```

- 接收者变量：接收者中的参数变量名在命名时，官方建议使用接收者类型名称首字母的小写，而不是 `self`, `this` 之类的命名，例如， `Person` 类型的接收者变量应该命名为 `p`, `Connector` 类型的接收者变量应该命名为 `c` 等。
- 接收者类型：接收者类型和参数类似，可以是指针类型和非指针类型。
- 方法名，参数列表，返回参数：具体格式与函数定义相同。

```go
//Person 结构体。
type Person struct {
	name string
	age  int8
}

func NewPerson(name string, age int8) *Person {
	return &Person{
		name: name,
		age:  age,
	}
}

func (p Person) Fly() {
	fmt.Printf("%s is flying!\n", p.name)
}

func main() {
	p1 := NewPerson("Test", 25)
	p1.Dream()
}
```

#### 指针类型的接收者

- 指针类型的接收者由一个结构体的指针组成，由于指针的特性，调用方法时修改接收者指针的任意成员变量，在方法结束后，修改都是有效的，这种方式就十分接近于其他语言中面向对象中的 `this` 或者 `self`
- 例如我们为 `Person` 添加一个 `SetAge` 方法，来修改实例变量的年龄。

```go
// SetAge 设置p的年龄。
// 使用指针接收者。
func (p *Person) SetAge(newAge int8) {
	p.age = newAge
}
```

```go
func main() {
	p1 := NewPerson("Test", 25)
	fmt.Println(p1.age) // 25
	p1.SetAge(30)
	fmt.Println(p1.age) // 30
}
```

#### 值类型的接收者

- 当方法作用于值类型接收者时， Go 语言会在代码运行时将接收者的值复制一份，在值类型接收者的方法中可以获取接收者的成员值，但修改操作只是针对副本，无法修改接收者变量本身。

```go
// SetAge2 设置p的年龄。
// 使用值接收者。
func (p Person) SetAge2(newAge int8) {
	p.age = newAge
}

func main() {
	p1 := NewPerson("Test", 25)
	p1.Dream()
	fmt.Println(p1.age) // 25
	p1.SetAge2(30) // (*p1).SetAge2(30)
	fmt.Println(p1.age) // 25
}
```

>**什么时候应该使用指针类型接收者**
>
>1. 需要修改接收者中的值。
>2. 接收者是拷贝代价比较大的大对象。
>3. 保证一致性，如果有某个方法使用了指针接收者，那么其他的方法也应该使用指针接收者。

#### 任意类型添加方法

- 在 Go 语言中，接收者的类型可以是任何类型，不仅仅是结构体，任何类型都可以拥有方法。
- 例如基于内置的 `int` 类型使用 type 关键字可以定义新的自定义类型，然后为我们的自定义类型添加方法。

```go
//MyInt 将int定义为自定义MyInt类型。
type MyInt int

//SayHello 为MyInt添加一个SayHello的方法。
func (m MyInt) SayHello() {
	fmt.Println("Hello，我是一个int,")
}
func main() {
	var m1 MyInt
	m1.SayHello() //Hello，我是一个int
	m1 = 100
	fmt.Printf("%#v  %T\n", m1, m1) //100  main.MyInt
}
```

**注意**：非本地类型不能定义方法，即不能给别的包的类型定义方法。