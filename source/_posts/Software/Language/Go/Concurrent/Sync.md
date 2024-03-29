---
title: Go Sync
categories:
- Software
- Language
- Go
- Concurrent
---
# Go Sync

## 并发安全和锁


- 有时候我们的代码中可能会存在多个 goroutine 同时操作一个资源（临界区）的情况，这种情况下就会发生 `竞态问题` （数据竞态）

```go
package main

import (
	"fmt"
	"sync"
)

var (
	x int64
	wg sync.WaitGroup // 等待组。
)

// add 对全局变量x执行5000次加1操作。
func add() {
	for i := 0; i < 5000; i++ {
		x = x + 1
	}
	wg.Done()
}

func main() {
	wg.Add(2)

	go add()
	go add()

	wg.Wait()
	fmt.Println(x)
}
```

- 我们将上面的代码编译后执行，不出意外每次执行都会输出诸如 9537,5865,6527 等不同的结果，这是为什么呢？
- 在上面的示例代码片中，我们开启了两个 goroutine 分别执行 add 函数，这两个 goroutine 在访问和修改全局的 `x` 变量时就会存在数据竞争，某个 goroutine 中对全局变量 `x` 的修改可能会覆盖掉另一个 goroutine 中的操作，所以导致最后的结果与预期不符。

### 互斥锁

- 互斥锁是一种常用的控制共享资源访问的方法，它能够保证同一时间只有一个 goroutine 可以访问共享资源， Go 语言中使用 `sync` 包中提供的 `Mutex` 类型来实现互斥锁。
- `sync.Mutex` 提供了两个方法供我们使用。

|          方法名          |    功能    |
| :----------------------: | :--------: |
|  func (m *Mutex) Lock ()  | 获取互斥锁 |
| func (m *Mutex) Unlock () | 释放互斥锁 |

- 我们在下面的示例代码中使用互斥锁限制每次只有一个 goroutine 才能修改全局变量 `x`，从而修复上面代码中的问题。

```go
package main

import (
	"fmt"
	"sync"
)

// sync.Mutex

var (
	x int64
	wg sync.WaitGroup // 等待组。
	m sync.Mutex // 互斥锁。
)

// add 对全局变量x执行5000次加1操作。
func add() {
	for i := 0; i < 5000; i++ {
		m.Lock() // 修改x前加锁。
		x = x + 1
		m.Unlock() // 改完解锁。
	}
	wg.Done()
}

func main() {
	wg.Add(2)

	go add()
	go add()

	wg.Wait()
	fmt.Println(x)
}
```

- 将上面的代码编译后多次执行，每一次都会得到预期中的结果——10000
- 使用互斥锁能够保证同一时间有且只有一个 goroutine 进入临界区，其他的 goroutine 则在等待锁，当互斥锁释放后，等待的 goroutine 才可以获取锁进入临界区，多个 goroutine 同时等待一个锁时，唤醒的策略是随机的。

### 读写互斥锁

- 互斥锁是完全互斥的，但是实际上有很多场景是读多写少的，当我们并发的去读取一个资源而不涉及资源修改的时候是没有必要加互斥锁的，这种场景下使用读写锁是更好的一种选择，读写锁在 Go 语言中使用 `sync` 包中的 `RWMutex` 类型。
- `sync.RWMutex` 提供了以下 5 个方法。

|                 方法名                 |         功能         |
| :---------------------------------: | :----------------: |
|      func (rw *RWMutex) Lock ()      |        获取写锁        |
|     func (rw *RWMutex) Unlock ()     |        释放写锁        |
|     func (rw *RWMutex) RLock ()      |        获取读锁        |
|    func (rw *RWMutex) RUnlock ()     |        释放读锁        |
| func (rw *RWMutex) RLocker () Locker | 返回一个实现 Locker 接口的读写锁 |

- 读写锁分为两种：读锁和写锁，当一个 goroutine 获取到读锁之后，其他的 goroutine 如果是获取读锁会继续获得锁，如果是获取写锁就会等待，而当一个 goroutine 获取写锁之后，其他的 goroutine 无论是获取读锁还是写锁都会等待。
- 下面我们使用代码构造一个读多写少的场景，然后分别使用互斥锁和读写锁查看它们的性能差异。

```go
var (
	x       int64
	wg      sync.WaitGroup
	mutex   sync.Mutex
	rwMutex sync.RWMutex
)

// writeWithLock 使用互斥锁的写操作。
func writeWithLock() {
	mutex.Lock() // 加互斥锁。
	x = x + 1
	time.Sleep(10 * time.Millisecond) // 假设写操作耗时10毫秒。
	mutex.Unlock()                    // 解互斥锁。
	wg.Done()
}

// readWithLock 使用互斥锁的读操作。
func readWithLock() {
	mutex.Lock()                 // 加互斥锁。
	time.Sleep(time.Millisecond) // 假设读操作耗时1毫秒。
	mutex.Unlock()               // 释放互斥锁。
	wg.Done()
}

// writeWithLock 使用读写互斥锁的写操作。
func writeWithRWLock() {
	rwMutex.Lock() // 加写锁。
	x = x + 1
	time.Sleep(10 * time.Millisecond) // 假设写操作耗时10毫秒。
	rwMutex.Unlock()                  // 释放写锁。
	wg.Done()
}

// readWithRWLock 使用读写互斥锁的读操作。
func readWithRWLock() {
	rwMutex.RLock()              // 加读锁。
	time.Sleep(time.Millisecond) // 假设读操作耗时1毫秒。
	rwMutex.RUnlock()            // 释放读锁。
	wg.Done()
}

func do(wf, rf func(), wc, rc int) {
	start := time.Now()
	// wc个并发写操作。
	for i := 0; i < wc; i++ {
		wg.Add(1)
		go wf()
	}

	//  rc个并发读操作。
	for i := 0; i < rc; i++ {
		wg.Add(1)
		go rf()
	}

	wg.Wait()
	cost := time.Since(start)
	fmt.Printf("x:%v cost:%v\n", x, cost)

}
```

- 我们假设每一次读操作都会耗时 1 ms，而每一次写操作会耗时 10 ms，我们分别测试使用互斥锁和读写互斥锁执行 10 次并发写和 1000 次并发读的耗时数据。

```go
// 使用互斥锁，10并发写，1000并发读。
do(writeWithLock, readWithLock, 10, 1000) // x:10 cost:1.466500951s

// 使用读写互斥锁，10并发写，1000并发读。
do(writeWithRWLock, readWithRWLock, 10, 1000) // x:10 cost:117.207592ms
```

- 从最终的执行结果可以看出，使用读写互斥锁在读多写少的场景下能够极大地提高程序的性能，不过需要注意的是如果一个程序中的读操作和写操作数量级差别不大，那么读写互斥锁的优势就发挥不出来。

### sync. WaitGroup

- 在代码中生硬的使用 `time.Sleep` 肯定是不合适的， Go 语言中可以使用 `sync.WaitGroup` 来实现并发任务的同步， `sync.WaitGroup` 有以下几个方法：

|                方法名                |        功能         |
| :----------------------------------: | :-----------------: |
| func (wg * WaitGroup) Add (delta int) |    计数器+delta     |
|        (wg *WaitGroup) Done ()        |      计数器-1       |
|        (wg *WaitGroup) Wait ()        | 阻塞直到计数器变为 0 |

- `sync.WaitGroup` 内部维护着一个计数器，计数器的值可以增加和减少，例如当我们启动了 N 个并发任务时，就将计数器值增加 N，每个任务完成时通过调用 Done 方法将计数器减 1，通过调用 Wait 来等待并发任务执行完，当计数器值为 0 时，表示所有并发任务已经完成。

```go
var wg sync.WaitGroup

func hello() {
	defer wg.Done()
	fmt.Println("Hello Goroutine!")
}
func main() {
	wg.Add(1)
	go hello() // 启动另外一个goroutine去执行hello函数。
	fmt.Println("main goroutine done!")
	wg.Wait()
}
```

- 需要注意 `sync.WaitGroup` 是一个结构体，进行参数传递的时候要传递指针。

### sync. Once

- 在某些场景下我们需要确保某些操作即使在高并发的场景下也只会被执行一次，例如只加载一次配置文件等。
- Go 语言中的 `sync` 包中提供了一个针对只执行一次场景的解决方案—— `sync.Once`, `sync.Once` 只有一个 `Do` 方法，其签名如下：

```go
func (o *Once) Do(f func())
```

- **注意**：如果要执行的函数 `f` 需要传递参数就需要搭配闭包来使用。

#### 加载配置文件示例

- 延迟一个开销很大的初始化操作到真正用到它的时候再执行是一个很好的实践，因为预先初始化一个变量（比如在 init 函数中完成初始化）会增加程序的启动耗时，而且有可能实际执行过程中这个变量没有用上，那么这个初始化操作就不是必须要做的，我们来看一个例子：

```go
var icons map[string]image.Image

func loadIcons() {
	icons = map[string]image.Image{
		"left":  loadIcon("left.png"),
		"up":    loadIcon("up.png"),
		"right": loadIcon("right.png"),
		"down":  loadIcon("down.png"),
	}
}

// Icon 被多个goroutine调用时不是并发安全的。
func Icon(name string) image.Image {
	if icons == nil {
		loadIcons()
	}
	return icons[name]
}
```

- 多个 goroutine 并发调用 Icon 函数时不是并发安全的，现代的编译器和 CPU 可能会在保证每个 goroutine 都满足串行一致的基础上自由地重排访问内存的顺序， loadIcons 函数可能会被重排为以下结果：

```go
func loadIcons() {
	icons = make(map[string]image.Image)
	icons["left"] = loadIcon("left.png")
	icons["up"] = loadIcon("up.png")
	icons["right"] = loadIcon("right.png")
	icons["down"] = loadIcon("down.png")
}
```

- 在这种情况下就会出现即使判断了 `icons` 不是 nil 也不意味着变量初始化完成了，考虑到这种情况，我们能想到的办法就是添加互斥锁，保证初始化 `icons` 的时候不会被其他的 goroutine 操作，但是这样做又会引发性能问题。
- 使用 `sync.Once` 改造的示例代码如下：

```go
var icons map[string]image.Image

var loadIconsOnce sync.Once

func loadIcons() {
	icons = map[string]image.Image{
		"left":  loadIcon("left.png"),
		"up":    loadIcon("up.png"),
		"right": loadIcon("right.png"),
		"down":  loadIcon("down.png"),
	}
}

// Icon 是并发安全的。
func Icon(name string) image.Image {
	loadIconsOnce.Do(loadIcons)
	return icons[name]
}
```

#### 并发安全的单例模式

- 下面是借助 `sync.Once` 实现的并发安全的单例模式：

```go
package singleton

import (
    "sync"
)

type singleton struct {}

var instance *singleton
var once sync.Once

func GetInstance() *singleton {
    once.Do(func() {
        instance = &singleton{}
    })
    return instance
}
```

- `sync.Once` 其实内部包含一个互斥锁和一个布尔值，互斥锁保证布尔值和数据的安全，而布尔值用来记录初始化是否完成，这样设计就能保证初始化操作的时候是并发安全的并且初始化操作也不会被执行多次。

### sync. Map

- Go 语言中内置的 map 不是并发安全的，请看下面这段示例代码。

```go
package main

import (
    "fmt"
    "strconv"
    "sync"
)

var m = make(map[string]int)

func get(key string) int {
    return m[key]
}

func set(key string, value int) {
    m[key] = value
}

func main() {
    wg := sync.WaitGroup{}
    for i := 0; i < 10; i++ {
        wg.Add(1)
        go func(n int) {
            key := strconv.Itoa(n)
            set(key, n)
            fmt.Printf("k=:%v,v:=%v\n", key, get(key))
            wg.Done()
        }(i)
    }
    wg.Wait()
}
```

- 将上面的代码编译后执行，会报出 `fatal error: concurrent map writes` 错误，我们不能在多个 goroutine 中并发对内置的 map 进行读写操作，否则会存在数据竞争问题。
- 像这种场景下就需要为 map 加锁来保证并发的安全性了， Go 语言的 `sync` 包中提供了一个开箱即用的并发安全版 map—— `sync.Map`，开箱即用表示其不用像内置的 map 一样使用 make 函数初始化就能直接使用，同时 `sync.Map` 内置了诸如 `Store`, `Load`, `LoadOrStore`, `Delete`, `Range` 等操作方法。

|                                         方法名                                         |           功能           |
| :---------------------------------------------------------------------------------: | :--------------------: |
|                     func (m *Map) Store (key, value interface{})                     |     存储 key-value 数据      |
|          func (m *Map) Load (key interface{}) (value interface{}, ok bool)           |     查询 key 对应的 value      |
| func (m *Map) LoadOrStore (key, value interface{}) (actual interface{}, loaded bool) |    查询或存储 key 对应的 value    |
|    func (m *Map) LoadAndDelete (key interface{}) (value interface{}, loaded bool)    |        查询并删除 key        |
|                        func (m *Map) Delete (key interface{})                        |         删除 key          |
|              func (m *Map) Range (f func (key, value interface{}) bool)               | 对 map 中的每个 key-value 依次调用 f |

- 下面的代码示例演示了并发读写 `sync.Map`

```go
package main

import (
	"fmt"
	"strconv"
	"sync"
)

// 并发安全的map
var m = sync.Map{}

func main() {
	wg := sync.WaitGroup{}
	// 对m执行20个并发的读写操作。
	for i := 0; i < 20; i++ {
		wg.Add(1)
		go func(n int) {
			key := strconv.Itoa(n)
			m.Store(key, n)         // 存储key-value
			value, _ := m.Load(key) // 根据key取值。
			fmt.Printf("k=:%v,v:=%v\n", key, value)
			wg.Done()
		}(i)
	}
	wg.Wait()
}
```

## 原子操作

- 针对整数数据类型（int 32, uint 32, int 64, uint 64）我们还可以使用原子操作来保证并发安全，通常直接使用原子操作比使用锁操作效率更高， Go 语言中原子操作由内置的标准库 `sync/atomic` 提供。

### atomic 包

|                             方法                             |      解释      |
| :----------------------------------------------------------: | :------------: |
| func LoadInt 32 (addr *int 32) (val int 32) func LoadInt 64 (addr *int 64) (val int 64) func LoadUint 32 (addr *uint 32) (val uint 32) func LoadUint 64 (addr *uint 64) (val uint 64) func LoadUintptr (addr *uintptr) (val uintptr) func LoadPointer (addr *unsafe. Pointer) (val unsafe. Pointer) |    读取操作    |
| func StoreInt 32 (addr *int 32, val int 32) func StoreInt 64 (addr *int 64, val int 64) func StoreUint 32 (addr *uint 32, val uint 32) func StoreUint 64 (addr *uint 64, val uint 64) func StoreUintptr (addr *uintptr, val uintptr) func StorePointer (addr *unsafe. Pointer, val unsafe. Pointer) |    写入操作    |
| func AddInt 32 (addr *int 32, delta int 32) (new int 32) func AddInt 64 (addr *int 64, delta int 64) (new int 64) func AddUint 32 (addr *uint 32, delta uint 32) (new uint 32) func AddUint 64 (addr *uint 64, delta uint 64) (new uint 64) func AddUintptr (addr *uintptr, delta uintptr) (new uintptr) |    修改操作    |
| func SwapInt 32 (addr *int 32, new int 32) (old int 32) func SwapInt 64 (addr *int 64, new int 64) (old int 64) func SwapUint 32 (addr *uint 32, new uint 32) (old uint 32) func SwapUint 64 (addr *uint 64, new uint 64) (old uint 64) func SwapUintptr (addr *uintptr, new uintptr) (old uintptr) func SwapPointer (addr *unsafe. Pointer, new unsafe. Pointer) (old unsafe. Pointer) |    交换操作    |
| func CompareAndSwapInt 32 (addr *int 32, old, new int 32) (swapped bool) func CompareAndSwapInt 64 (addr *int 64, old, new int 64) (swapped bool) func CompareAndSwapUint 32 (addr *uint 32, old, new uint 32) (swapped bool) func CompareAndSwapUint 64 (addr *uint 64, old, new uint 64) (swapped bool) func CompareAndSwapUintptr (addr *uintptr, old, new uintptr) (swapped bool) func CompareAndSwapPointer (addr *unsafe. Pointer, old, new unsafe. Pointer) (swapped bool) | 比较并交换操作 |

### 示例

- 我们填写一个示例来比较下互斥锁和原子操作的性能。

```go
package main

import (
    "fmt"
    "sync"
    "sync/atomic"
    "time"
)

type Counter interface {
    Inc()
    Load() int64
}

// 普通版。
type CommonCounter struct {
    counter int64
}

func (c CommonCounter) Inc() {
    c.counter++
}

func (c CommonCounter) Load() int64 {
    return c.counter
}

// 互斥锁版。
type MutexCounter struct {
    counter int64
    lock    sync.Mutex
}

func (m *MutexCounter) Inc() {
    m.lock.Lock()
    defer m.lock.Unlock()
    m.counter++
}

func (m *MutexCounter) Load() int64 {
    m.lock.Lock()
    defer m.lock.Unlock()
    return m.counter
}

// 原子操作版。
type AtomicCounter struct {
    counter int64
}

func (a *AtomicCounter) Inc() {
    atomic.AddInt64(&a.counter, 1)
}

func (a *AtomicCounter) Load() int64 {
    return atomic.LoadInt64(&a.counter)
}

func test(c Counter) {
    var wg sync.WaitGroup
    start := time.Now()
    for i := 0; i < 1000; i++ {
        wg.Add(1)
        go func() {
            c.Inc()
            wg.Done()
        }()
    }
    wg.Wait()
    end := time.Now()
    fmt.Println(c.Load(), end.Sub(start))
}

func main() {
    c1 := CommonCounter{} // 非并发安全。
    test(c1)
    c2 := MutexCounter{} // 使用互斥锁实现并发安全。
    test(&c2)
    c3 := AtomicCounter{} // 并发安全且比互斥锁效率更高。
    test(&c3)
}
```

- `atomic` 包提供了底层的原子级内存操作，对于同步算法的实现很有用，这些函数必须谨慎地保证正确使用，除了某些特殊的底层应用，使用通道或者 sync 包的函数/类型实现同步更好。

## 处理并发错误

### recover goroutine 中的 panic

- 我们知道可以在代码中使用 recover 来会恢复程序中意想不到的 panic，而 panic 只会触发当前 goroutine 中的 defer 操作。
- 例如在下面的示例代码中，无法在 main 函数中 recover 另一个 goroutine 中引发的 panic

```go
func f1() {
	defer func() {
		if e := recover(); e != nil {
			fmt.Printf("recover panic:%v\n", e)
		}
	}()
	// 开启一个goroutine执行任务。
	go func() {
		fmt.Println("in goroutine....")
		// 只能触发当前goroutine中的defer
		panic("panic in goroutine")
	}()

	time.Sleep(time.Second)
	fmt.Println("exit")
}
```

- 执行上面的 f 1 函数会得到如下结果：

```bash
in goroutine....
panic: panic in goroutine

goroutine 6 [running]:
main.f1.func2()
        /Users/liwenzhou/workspace/github/the-road-to-learn-golang/ch12/goroutine_recover.go:20 +0x65
created by main.f1
        /Users/liwenzhou/workspace/github/the-road-to-learn-golang/ch12/goroutine_recover.go:17 +0x48

Process finished with exit code 2
```

- 从输出结果可以看到程序并没有正常退出，而是由于 panic 异常退出了（exit code 2)
- 正如上面示例演示的那样，在启用 goroutine 去执行任务的场景下，如果想要 recover goroutine 中可能出现的 panic 就需要在 goroutine 中使用 recover，就像下面的 f 2 函数那样。

```go
func f2() {
	defer func() {
		if r := recover(); r != nil {
			fmt.Printf("recover outer panic:%v\n", r)
		}
	}()
	// 开启一个goroutine执行任务。
	go func() {
		defer func() {
			if r := recover(); r != nil {
				fmt.Printf("recover inner panic:%v\n", r)
			}
		}()
		fmt.Println("in goroutine....")
		// 只能触发当前goroutine中的defer
		panic("panic in goroutine")
	}()

	time.Sleep(time.Second)
	fmt.Println("exit")
}
```

- 执行 f 2 函数会得到如下输出结果。

```go
in goroutine....
recover inner panic:panic in goroutine
exit
```

- 程序中的 panic 被 recover 成功捕获，程序最终正常退出。

### errgroup

- 在以往演示的并发示例中，我们通常像下面的示例代码那样在 go 关键字后，调用一个函数或匿名函数。

```go
go func(){
  // ...
}

go foo()
```

- 在之前讲解并发的代码示例中我们默认被并发的那些函数都不会返回错误，但真实的情况往往是事与愿违。
- 当我们想要将一个任务拆分成多个子任务交给多个 goroutine 去运行，这时我们该如何获取到子任务可能返回的错误呢？
- 假设我们有多个网址需要并发去获取它们的内容，这时候我们会写出类似下面的代码。

```go
// fetchUrlDemo 并发获取url内容。
func fetchUrlDemo() {
	wg := sync.WaitGroup{}
	var urls = []string{
		"http://pkg.go.dev",
		"http://www.liwenzhou.com",
		"http://www.yixieqitawangzhi.com",
	}

	for _, url := range urls {
		wg.Add(1)
		go func(url string) {
			defer wg.Done()
			resp, err := http.Get(url)
			if err == nil {
				fmt.Printf("获取%s成功\n", url)
				resp.Body.Close()
			}
			return // 如何将错误返回呢？
		}(url)
	}
	wg.Wait()
	// 如何获取goroutine中可能出现的错误呢？
}
```

- 执行上述 `fetchUrlDemo` 函数得到如下输出结果，由于 http://www.yixieqitawangzhi.com并不真实存在，所以对它的 HTTP 请求会返回错误。

```bash
获取http://pkg.go.dev成功。
获取http://www.liwenzhou.com成功。
```

- 在上面的示例代码中，我们开启了 3 个 goroutine 分别去获取 3 个 url 的内容，类似这种将任务分为若干个子任务的场景会有很多，那么我们如何获取子任务中可能出现的错误呢？
- errgroup 包就是为了解决这类问题而开发的，它能为处理公共任务的子任务而开启的一组 goroutine 提供同步， error 传播和基于 context 的取消功能。
- errgroup 包中定义了一个 Group 类型，它包含了若干个不可导出的字段。

```go
type Group struct {
	cancel func()

	wg sync.WaitGroup

	errOnce sync.Once
	err     error
}
```

- errgroup. Group 提供了`Go`和`Wait`两个方法。

```go
func (g *Group) Go (f func () error)
```

- Go 函数会在新的 goroutine 中调用传入的函数 f
- 第一个返回非零错误的调用将取消该 Group，下面的 Wait 方法会返回该错误。

```go
func (g *Group) Wait () error
```

- Wait 会阻塞直至由上述 Go 方法调用的所有函数都返回，然后从它们返回第一个非 nil 的错误（如果有）
- 下面的示例代码演示了如何使用 errgroup 包来处理多个子任务 goroutine 中可能返回的 error

```go
// fetchUrlDemo 2 使用 errgroup 并发获取 url 内容。
func fetchUrlDemo 2 () error {
	g := new (errgroup. Group) // 创建等待组（类似 sync. WaitGroup)
	var urls = []string{
		"http://pkg.go.dev",
		"http://www.liwenzhou.com",
		"http://www.yixieqitawangzhi.com",
	}
	for _, url := range urls {
		url := url // 注意此处声明新的变量。
		// 启动一个 goroutine 去获取 url 内容。
		g.Go (func () error {
			resp, err := http.Get (url)
			if err == nil {
				fmt.Printf ("获取%s 成功\n", url)
				resp.Body.Close ()
			}
			return err // 返回错误。
		})
	}
	if err := g.Wait (); err != nil {
		// 处理可能出现的错误。
		fmt.Println (err)
		return err
	}
	fmt.Println ("所有 goroutine 均成功")
	return nil
}
```

- 执行上面的`fetchUrlDemo 2`函数会得到如下输出结果。

```bash
获取http://pkg.go.dev成功。
获取http://www.liwenzhou.com成功。
Get "http://www.yixieqitawangzhi.com": dial tcp: lookup www.yixieqitawangzhi.com: no such host
```

- 当子任务的 goroutine 中对`http://www.yixieqitawangzhi.com` 发起 HTTP 请求时会返回一个错误，这个错误会由 errgroup. Group 的 Wait 方法返回。
- 通过阅读下方 errgroup. Group 的 Go 方法源码，我们可以看到当任意一个函数 f 返回错误时，会通过`g.errOnce. Do`只将第一个返回的错误记录，并且如果存在 cancel 方法则会调用 cancel

```go
func (g *Group) Go (f func () error) {
	g.wg.Add (1)

	go func () {
		defer g.wg.Done ()

		if err := f (); err != nil {
			g.errOnce.Do (func () {
				g.err = err
				if g.cancel != nil {
					g.cancel ()
				}
			})
		}
	}()
}
```

- 那么如何创建带有 cancel 方法的 errgroup. Group 呢？答案是通过 errorgroup 包提供的 WithContext 函数。

```go
func WithContext (ctx context. Context) (*Group, context. Context)
```

- WithContext 函数接收一个父 context，返回一个新的 Group 对象和一个关联的子 context 对象，下面的代码片段是一个官方文档给出的示例。

```go
package main

import (
	"context"
	"crypto/md 5"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"

	"golang. org/x/sync/errgroup"
)

// Pipeline demonstrates the use of a Group to implement a multi-stage
// pipeline: a version of the MD 5 All function with bounded parallelism from
// https://blog.golang.org/pipelines.
func main () {
	m, err := MD 5 All (context.Background (), ".")
	if err != nil {
		log.Fatal (err)
	}

	for k, sum := range m {
		fmt.Printf ("%s:\t%x\n", k, sum)
	}
}

type result struct {
	path string
	sum  [md 5. Size]byte
}

// MD 5 All reads all the files in the file tree rooted at root and returns a map
// from file path to the MD 5 sum of the file's contents. If the directory walk
// fails or any read operation fails, MD 5 All returns an error.
func MD 5 All (ctx context. Context, root string) (map[string][md 5. Size]byte, error) {
	// ctx is canceled when g.Wait () returns. When this version of MD 5 All returns
	// - even in case of error! - we know that all of the goroutines have finished
	// and the memory they were using can be garbage-collected.
	g, ctx := errgroup.WithContext (ctx)
	paths := make (chan string)

	g.Go (func () error {

		return filepath.Walk (root, func (path string, info os. FileInfo, err error) error {
			if err != nil {
				return err
			}
			if !info.Mode (). IsRegular () {
				return nil
			}
			select {
			case paths <- path:
			case <-ctx.Done ():
				return ctx.Err ()
			}
			return nil
		})
	})

	// Start a fixed number of goroutines to read and digest files.
	c := make (chan result)
	const numDigesters = 20
	for i := 0; i < numDigesters; i++ {
		g.Go (func () error {
			for path := range paths {
				data, err := ioutil.ReadFile (path)
				if err != nil {
					return err
				}
				select {
				case c <- result{path, md 5.Sum (data)}:
				case <-ctx.Done ():
					return ctx.Err ()
				}
			}
			return nil
		})
	}
	go func () {
		g.Wait ()
		close (c)
	}()

	m := make (map[string][md 5. Size]byte)
	for r := range c {
		m[r.path] = r.sum
	}
	// Check whether any of the goroutines failed. Since g is accumulating the
	// errors, we don't need to send them (or check for them) in the individual
	// results sent on the channel.
	if err := g.Wait (); err != nil {
		return nil, err
	}
	return m, nil
}
```

- 或者这里有另外一个示例。

```go
func GetFriends (ctx context. Context, user int 64) (map[string]*User, error) {
  g, ctx := errgroup.WithContext (ctx)
  friendIds := make (chan int 64)

  // Produce
  g.Go (func () error {
     defer close (friendIds)
     for it := GetFriendIds (user); ; {
        if id, err := it.Next (ctx); err != nil {
           if err == io. EOF {
              return nil
           }
           return fmt.Errorf ("GetFriendIds %d: %s", user, err)
        } else {
           select {
           case <-ctx.Done ():
              return ctx.Err ()
           case friendIds <- id:
           }
        }
     }
  })

  friends := make (chan *User)

  // Map
  workers := int 32 (nWorkers)
  for i := 0; i < nWorkers; i++ {
     g.Go (func () error {
        defer func () {
           // Last one out closes shop
           if atomic. AddInt 32 (&workers, -1) == 0 {
              close (friends)
           }
        }()

        for id := range friendIds {
           if friend, err := GetUserProfile (ctx, id); err != nil {
              return fmt.Errorf ("GetUserProfile %d: %s", user, err)
           } else {
              select {
              case <-ctx.Done ():
                 return ctx.Err ()
              case friends <- friend:
              }
           }
        }
        return nil
     })
  }

  // Reduce
  ret := map[string]*User{}
  g.Go (func () error {
     for friend := range friends {
        ret[friend. Name] = friend
     }
     return nil
  })

  return ret, g.Wait ()
}
```