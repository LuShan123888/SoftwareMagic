---
title: Go Map
categories:
- Software
- Language
- Go
- DataSturct
---
# Go Map

- map 是一种无序的基于 `key-value` 的数据结构， Go 语言中的 map 是引用类型，必须初始化才能使用。
- Go 语言中提供的映射关系容器为 `map`，其内部使用 `散列表（hash)` 实现。

## map 定义

- Go 语言中 `map` 的定义语法如下：

```go
map[KeyType]ValueType
```

- `KeyType`：表示键的类型。
- `ValueType`：表示键对应的值的类型。

## 定义 map

- map 类型的变量默认初始值为 nil，需要使用 make (）函数来分配内存，语法为：

```go
make(map[KeyType]ValueType, [cap])
```

- 其中 cap 表示 map 的容量，该参数虽然不是必须的，但是应该在初始化 map 的时候就为其指定一个合适的容量。

```go
func main() {
    scoreMap := make(map[string]int, 8)
    scoreMap["张三"] = 90
    scoreMap["小明"] = 100
    fmt.Println(scoreMap)
    fmt.Println(scoreMap["小明"])
    fmt.Printf("type of a:%T\n", scoreMap)
}
```

```bash
map[小明：100 张三：90]
100
type of a:map[string]int
```

- map 也支持在声明的时候填充元素，例如：

```go
func main() {
	userInfo := map[string]string{
		"username": "小明",
		"password": "123456",
	}
	fmt.Println(userInfo)
}
```

## 判断某个 Key 是否存在

- Go 语言中有个判断 map 中 Key 是否存在的特殊写法，格式如下：

```go
value, ok := map[key]
```

- 例如。

```go
func main() {
    scoreMap := make(map[string]int)
    scoreMap["张三"] = 90
    scoreMap["小明"] = 100
    // 如果key存在ok为true,v为对应的值，不存在ok为false,v为值类型的零值。
    v, ok := scoreMap["张三"]
    if ok {
        fmt.Println(v)
    } else {
        fmt.Println("查无此人")
    }
}
```

## 遍历 map

- Go 语言中使用 `for range` 遍历 map

```go
func main() {
    scoreMap := make(map[string]int)
    scoreMap["张三"] = 90
    scoreMap["小明"] = 100
    scoreMap["娜扎"] = 60
    for k, v := range scoreMap {
        fmt.Println(k, v)
    }
}
```

- 只遍历 key

```go
func main() {
	scoreMap := make(map[string]int)
	scoreMap["张三"] = 90
	scoreMap["小明"] = 100
	scoreMap["娜扎"] = 60
	for k := range scoreMap {
		fmt.Println(k)
	}
}
```

- **注意**：遍历 map 时的元素顺序与添加键值对的顺序无关。
- 按照指定顺序遍历 map

```go
func main() {
    rand.Seed(time.Now().UnixNano()) // 初始化随机数种子。
    var scoreMap = make(map[string]int, 200)
    for i := 0; i < 100; i++ {
        key := fmt.Sprintf("stu%02d", i) // 生成stu开头的字符串。
        value := rand.Intn(100)          // 生成0~99的随机整数。
        scoreMap[key] = value
    }
    // 取出map中的所有key存入切片keys
    var keys = make([]string, 0, 200)
    for key := range scoreMap {
        keys = append(keys, key)
    }
    // 对切片进行排序。
    sort.Strings(keys)
    // 按照排序后的key遍历map
    for _, key := range keys {
        fmt.Println(key, scoreMap[key])
    }
}
```

## 删除键值对

- 使用 `delete()` 内建函数从 map 中删除一组键值对， `delete()` 函数的格式如下：

```go
delete(map, key)
```

- `map`：表示要删除键值对的 map
- `key`：表示要删除的键值对的键。

```go
func main(){
    scoreMap := make(map[string]int)
    scoreMap["张三"] = 90
    scoreMap["小明"] = 100
    scoreMap["娜扎"] = 60
    delete(scoreMap, "小明")// 将小明：100从map中删除。
    for k,v := range scoreMap{
        fmt.Println(k, v)
    }
}
```

## 元素为 map 类型的切片

```go
func main() {
	var mapSlice = make([]map[string]string, 3)
	for index, value := range mapSlice {
		fmt.Printf("index:%d value:%v\n", index, value)
	}
	fmt.Println("after init")
	// 对切片中的map元素进行初始化。
	mapSlice[0] = make(map[string]string, 10)
	mapSlice[0]["name"] = "Test"
	mapSlice[0]["password"] = "123456"
	for index, value := range mapSlice {
		fmt.Printf("index:%d value:%v\n", index, value)
	}
}
```

```
index:0 value:map[]
index:1 value:map[]
index:2 value:map[]
after init
index:0 value:map[name:Test password:123456]
index:1 value:map[]
index:2 value:map[]
```

## 值为切片类型的 map

```go
func main() {
    var sliceMap = make(map[string][]string, 3)
    fmt.Println(sliceMap)
    fmt.Println("after init")
    key := "中国"
    value, ok := sliceMap[key]
    if !ok {
        value = make([]string, 0, 2)
    }
    value = append(value, "北京", "上海")
    sliceMap[key] = value
    fmt.Println(sliceMap)
}
```