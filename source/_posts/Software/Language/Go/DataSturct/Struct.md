---
title: Go Struct
categories:
- Software
- Language
- Go
- DataSturct
---
# Go Struct

- Go语言中没有"类”的概念,也不支持"类”的继承等面向对象的概念,Go语言中通过结构体的内嵌再配合接口比面向对象具有更高的扩展性和灵活性

## 类型别名和自定义类型

### 自定义类型

- 在Go语言中有一些基本的数据类型,如`string`,`整型`,`浮点型`,`布尔`等数据类型,Go语言中可以使用`type`关键字来定义自定义类型

```go
type CustomType Type
```

- 自定义类型是定义了一个全新的类型,我们可以基于内置的基本类型定义,也可以通过struct定义,例如:

```go
// 将MyInt定义为int类型
type MyInt int
```

- 通过`type`关键字的定义,`MyInt`就是一种新的类型,它具有`int`的特性

### 类型别名

- 类型别名规定:TypeAlias只是Type的别名,本质上TypeAlias与Type是同一个类型

```go
type TypeAlias = Type
```

- `rune`和`byte`就是类型别名,其定义如下:

```go
type byte = uint8
type rune = int32
```

### 类型定义和类型别名的区别

- 类型别名与类型定义表面上看只有一个等号的差异,通过下面的这段代码来理解它们之间的区别

```go
//类型定义
type NewInt int

//类型别名
type MyInt = int

func main() {
	var a NewInt
	var b MyInt
	
	fmt.Printf("type of a:%T\n", a) // type of a:main.NewInt
	fmt.Printf("type of b:%T\n", b) // type of b:int
}
```

- 结果显示a的类型是`main.NewInt`,表示main包下定义的`NewInt`类型,b的类型是`int`,`MyInt`类型只会在代码中存在,编译完成时并不会有`MyInt`类型

## 结构体

- Go语言提供了一种自定义数据类型,可以封装多个基本数据类型,这种数据类型叫结构体,英文名称`struct`,Go语言中通过`struct`来实现面向对象

### 结构体的定义

- 使用`type`和`struct`关键字来定义结构体,具体代码格式如下:

```go
type 类型名 struct {
    字段名 字段类型
    字段名 字段类型
…
}
```

- `类型名`:标识自定义结构体的名称,在同一个包内不能重复
- `字段名`:表示结构体字段名,结构体中的字段名必须唯一
- `字段类型`:表示结构体字段的具体类型

**实例**:定义一个`Person`(人)结构体,它有`name`,`city`,`age`三个字段,分别表示姓名,城市和年龄,代码如下:

```go
type person struct {
	name string
	city string
	age  int8
}
```

- 同样类型的字段也可以写在一行

```go
type person struct {
	name, city string
	age        int8
}
```

### 结构体实例化

- 结构体本身也是一种类型,可以像声明内置类型一样使用`var`关键字声明结构体类型,只有当结构体实例化时,才会真正地分配内存

```go
var 结构体实例 结构体类型
// 或
结构体实例 := 结构体类型{}
```

#### 基本实例化

- 结构体中字段大写开头表示可公开访问,小写表示私有(仅在定义当前结构体的包中可访问)
- 可以通过`.`来访问结构体的字段(成员变量),例如`p1.name`和`p1.age`等

```go
type person struct {
    name string
    city string
    age  int8
}

func main() {
    var p1 person
    p1.name = "Test"
    p1.city = "北京"
    p1.age = 18
    fmt.Printf("p1=%v\n", p1)  // p1={Test 北京 18}
    fmt.Printf("p1=%#v\n", p1) // p1=main.person{name:"Test", city:"北京", age:18}

    p3 := &person{}
    p3.name = "Test"
    p3.age = 30
    p3.city = "成都"
    fmt.Printf("p3=%#v\n", p3) // p3=&main.person{name:"Test", city:"成都", age:30}
}
```

#### 匿名结构体实例化

- 在定义一些临时数据结构等场景下还可以使用匿名结构体

```go
func main() {
    var user struct {
        Name string
        Age  int
    }
    user.Name = "Test"
    user.Age = 18
    fmt.Printf("%#v\n", user) // struct { Name string; Age int }{Name:"Test", Age:18}
}
```

#### 指针类型结构体实例化

- 通过使用`new`关键字对结构体进行实例化,得到的是结构体的地址,格式如下:

```go
var p2 = new(person)
// 或
var p2 = &person{}

fmt.Printf("%T\n", p2)     // *main.person
fmt.Printf("p2=%#v\n", p2) // p2=&main.person{name:"", city:"", age:0}
```

- 使用`&`对结构体进行取地址操作相当于对该结构体类型进行了一次`new`实例化操作

```go
p3 := &person{}
fmt.Printf("%T\n", p3)     //*main.person
fmt.Printf("p3=%#v\n", p3) //p3=&main.person{name:"", city:"", age:0}
p3.name = "Test"
p3.age = 30
p3.city = "成都"
fmt.Printf("p3=%#v\n", p3) //p3=&main.person{name:"Test", city:"成都", age:30}
```

- 在Go语言中支持对结构体指针直接使用`.`来访问结构体的成员

```go
var p2 = new(person)
p2.name = "Test"
p2.age = 28
p2.city = "上海"
fmt.Printf("p2=%#v\n", p2) //p2=&main.person{name:"Test", city:"上海", age:28}
```

- `p3.name = "Test"`其实在底层是`(*p3).name = "Test"`,这是Go语言帮我们实现的语法糖

### 结构体初始化

- 没有初始化的结构体,其成员变量都是对应其类型的零值

```go
type person struct {
	name string
	city string
	age  int8
}

func main() {
	var p4 person
	fmt.Printf("p4=%#v\n", p4) // p4=main.person{name:"", city:"", age:0}
}
```

#### 使用键值对初始化

- 使用键值对对结构体进行初始化时,键对应结构体的字段,值对应该字段的初始值

```go
p5 := person{
	name: "Test",
	city: "北京",
	age:  18,
}
fmt.Printf("p5=%#v\n", p5) // p5=main.person{name:"Test", city:"北京", age:18}
```

- 也可以对结构体指针进行键值对初始化,例如:

```go
p6 := &person{
	name: "Test",
	city: "北京",
	age:  18,
}
fmt.Printf("p6=%#v\n", p6) // p6=&main.person{name:"Test", city:"北京", age:18}
```

- 当某些字段没有初始值的时候,该字段可以不写,此时,没有指定初始值的字段的值就是该字段类型的零值

```go
p7 := &person{
	city: "北京",
}
fmt.Printf("p7=%#v\n", p7) //p7=&main.person{name:"", city:"北京", age:0}
```

#### 使用值的列表初始化

- 初始化结构体的时候可以简写,也就是初始化的时候不写键,直接写值:

```go
p8 := &person{
    "Test",
    "北京",
    28,
}
fmt.Printf("p8=%#v\n", p8) //p8=&main.person{name:"Test", city:"北京", age:28}
```

**注意**

1. 必须初始化结构体的所有字段
2. 初始值的填充顺序必须与字段在结构体中的声明顺序一致
3. 该方式不能和键值初始化方式混用

### 结构体内存布局

- 结构体占用一块连续的内存

```go
type test struct {
    a int8
    b int8
    c int8
    d int8
}
n := test{
    1, 2, 3, 4,
}
fmt.Printf("n.a %p\n", &n.a)
fmt.Printf("n.b %p\n", &n.b)
fmt.Printf("n.c %p\n", &n.c)
fmt.Printf("n.d %p\n", &n.d)
```

```bash
n.a 0xc0000a0060
n.b 0xc0000a0061
n.c 0xc0000a0062
n.d 0xc0000a0063
```

- 空结构体是不占用空间的

```go
var v struct{}
fmt.Println(unsafe.Sizeof(v))  // 0
```

### 结构体的匿名字段

- 结构体允许其成员字段在声明时没有字段名而只有类型,这种没有名字的字段就称为匿名字段
- 匿名字段默认会采用类型名作为字段名,结构体要求字段名称必须唯一,因此一个结构体中同种类型的匿名字段只能有一个

```go
//Person 结构体Person类型
type Person struct {
    string
    int
}

func main() {
    p1 := Person{
        "Test",
        18,
    }
    fmt.Printf("%#v\n", p1)        //main.Person{string:"北京", int:18}
    fmt.Println(p1.string, p1.int) //北京 18
}
```

### 嵌套结构体

- 一个结构体中可以嵌套包含另一个结构体或结构体指针

```go
//Address 地址结构体
type Address struct {
    Province string
    City     string
}

//User 用户结构体
type User struct {
    Name    string
    Gender  string
    Address Address
}

func main() {
    user1 := User{
        Name:   "Test",
        Gender: "男",
        Address: Address{
            Province: "山东",
            City:     "威海",
        },
    }
    fmt.Printf("user1=%#v\n", user1)//user1=main.User{Name:"Test", Gender:"男", Address:main.Address{Province:"山东", City:"威海"}}
}
```

#### 嵌套匿名结构体字段

- 上面`user`结构体中嵌套的`Address`结构体也可以采用匿名字段的方式,例如:

```go
//Address 地址结构体
type Address struct {
    Province string
    City     string
}

//User 用户结构体
type User struct {
    Name    string
    Gender  string
    Address //匿名字段
}

func main() {
    var user2 User
    user2.Name = "Test"
    user2.Gender = "男"
    user2.Address.Province = "山东"    // 匿名字段默认使用类型名作为字段名
    user2.City = "威海"                // 匿名字段可以省略
    fmt.Printf("user2=%#v\n", user2) //user2=main.User{Name:"Test", Gender:"男", Address:main.Address{Province:"山东", City:"威海"}}
}
```

#### 访问嵌套结构体的字段

- 当访问结构体成员时会先在结构体中查找该字段,找不到再去嵌套的匿名字段中查找
- 嵌套结构体内部可能存在相同的字段名,在这种情况下为了避免歧义需要通过指定具体的内嵌结构体字段名

```go
//Address 地址结构体
type Address struct {
	Province   string
	City       string
	CreateTime string
}

//Email 邮箱结构体
type Email struct {
	Account    string
	CreateTime string
}

//User 用户结构体
type User struct {
	Name   string
	Gender string
	Address
	Email
}

func main() {
	var user User
	user.Name = "Test"
	user.Gender = "男"
	// user.CreateTime = "2019" //ambiguous selector user3.CreateTime
	user.Address.CreateTime = "2000" //指定Address结构体中的CreateTime
	user.Email.CreateTime = "2000"   //指定Email结构体中的CreateTime
}
```

### 结构体的"继承”

- Go语言中使用结构体也可以实现其他编程语言中面向对象的继承

```go
//Animal 动物
type Animal struct {
    name string
}

func (a *Animal) move() {
    fmt.Printf("%s is moving\n", a.name)
}

//Dog 狗
type Dog struct {
    Feet    int8
    *Animal //通过嵌套匿名结构体实现继承
}

func (d *Dog) bark() {
    fmt.Printf("%s is Barking\n", d.name)
}

func main() {
    d1 := &Dog{
        Feet: 4,
        Animal: &Animal{ //注意嵌套的是结构体指针
            name: "Dog",
        },
    }
    d1.bark() // Dog is Barking
    d1.move() // Dog is moving
}
```

### 结构体标签(Tag)

- `Tag`是结构体的元信息,可以在运行的时候通过反射的机制读取出来,`Tag`在结构体字段的后方定义,由一对**反引号**包裹起来,具体的格式如下:

```bash
`key1:"value1" key2:"value2"`
```

- 结构体tag由一个或多个键值对组成,键与值使用冒号分隔,值用双引号括起来,同一个结构体字段可以设置多个键值对tag,不同的键值对之间使用空格分隔
- **注意**: 为结构体编写`Tag`时,必须严格遵守键值对的规则,结构体标签的解析代码的容错能力很差,一旦格式写错,编译和运行时都不会提示任何错误,通过反射也无法正确取值,例如不要在key和value之间添加空格
- 例如为`Student`结构体的每个字段定义json序列化时使用的Tag:

```go
//Student 学生
type Student struct {
	ID     int    `json:"id"` //通过指定tag实现json序列化该字段时的key
	Gender string //json序列化是默认使用字段名作为key
	name   string //私有不能被json包访问
}

func main() {
	s1 := Student{
		ID:     1,
		Gender: "男",
		name:   "Test",
	}
	data, err := json.Marshal(s1)
	if err != nil {
		fmt.Println("json marshal failed!")
		return
	}
	fmt.Printf("json str:%s\n", data) //json str:{"id":1,"Gender":"男"}
}
```

### 结构体的拷贝

- 因为slice和map这两种数据类型都包含了指向底层数据的指针,因此在需要复制时要特别注意是否需要引用拷贝

```go
type Person struct {
    name   string
    age    int8
    dreams []string
}

func (p *Person) SetDreams(dreams []string) {
    p.dreams = dreams
}

func main() {
    p1 := Person{name: "Test", age: 18}
    data := []string{"吃饭", "睡觉", "运动"}
    p1.SetDreams(data)

    // 由于p1保存的是data的引用,所以后续修改data也会影响到p1
    data[1] = "不睡觉"
    fmt.Println(p1.dreams)  // [吃饭 不睡觉 运动]
}
```

- 如果需要值拷贝需要使用make方法申请新的空间,并通过copy方法复制

```go
func (p *Person) SetDreams(dreams []string) {
    p.dreams = make([]string, len(dreams))
    copy(p.dreams, dreams)
}
```