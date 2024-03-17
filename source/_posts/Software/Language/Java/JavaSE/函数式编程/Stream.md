---
title: Java Stream
categories:
  - Software
  - Language
  - Java
  - JavaSE
  - 函数式编程
---
# Java Stream

- Java 8 API添加了一个新的抽象称为流Stream，可以让你以一种声明的方式处理数据。
- Stream 使用一种类似用 SQL 语句从数据库查询数据的直观方式来提供一种对 Java 集合运算和表达的高阶抽象。
- Stream API可以极大提高Java程序员的生产力，让程序员写出高效率，干净，简洁的代码。
- 这种风格将要处理的元素集合看作一种流，流在管道中传输，并且可以在管道的节点上进行处理，比如筛选，排序，聚合等。
- 元素流在管道中经过中间操作（intermediate operation）的处理，最后由最终操作（terminal operation）得到前面处理的结果。

```
stream of elements ----> filter---->sorted----> map----> collect
```

- 以上的流程转换为 Java 代码为：

```java
List<Integer> transactionsIds =
    widgets.stream()
    .filter(b -> b.getColor() == RED)
    .sorted((x,y) -> x.getWeight() - y.getWeight())
    .mapToInt(Widget::getWeight)
    .sum();
```

## 什么是 Stream

Stream（流）是一个来自数据源的元素队列并支持聚合操作。

- 元素是特定类型的对象，形成一个队列，Java中的Stream并不会存储元素，而是按需计算。
- **数据源** 流的来源，可以是集合，数组，I/O channel，产生器generator 等。
- **聚合操作** 类似SQL语句一样的操作，比如filter, map, reduce, find, match, sorted等。

和以前的Collection操作不同，Stream操作还有两个基础的特征：

- **Pipelining**：中间操作都会返回流对象本身，这样多个操作可以串联成一个管道，如同流式风格（fluent style)，这样做可以对操作进行优化，比如延迟执行（laziness）和短路（ short-circuiting)
- **内部迭代**：以前对集合遍历都是通过Iterator或者For-Each的方式，显式的在集合外部进行迭代，这叫做外部迭代，Stream提供了内部迭代的方式，通过访问者模式（Visitor）实现。

## 流处理的特性

- 不存储数据。
- 不会改变数据源。
- 不可以重复使用。
- 通过连续执行多个操作倒便就组成了 Stream 中的执行管道（pipeline)
- 需要注意的是这些管道被添加后并不会真正执行，只有等到调用终值操作之后才会执行。

## 生成流

### 由集合对象创建流

- 支持流处理的对象包括 `Collection` 集合及其子类。

#### stream()

- 为集合创建串行流。

```java
List<String> strings = Arrays.asList("abc", "", "bc", "efg", "abcd","", "jkl");
List<String> filtered = strings.stream().filter(string -> !string.isEmpty()).collect(Collectors.toList());
```

#### parallelStream()

- parallelStream 是流并行处理程序的代替方法。
- 以下实例我们使用 parallelStream 来输出空字符串的数量。

```java
List<String> strings = Arrays.asList("abc", "", "bc", "efg", "abcd","", "jkl");
// 获取空字符串的数量。
long count = strings.parallelStream().filter(string -> string.isEmpty()).count();
```

- 我们可以很容易的在顺序运行和并行直接切换。

### 由数组创建流

- 通过静态方法 `Arrays.stream()` 将数组转化为流（Stream)

```java
IntStream stream = Arrays.stream(new int[]{3, 2, 1});
```

### 通过静态方法 Stream.of()

- 底层其实还是调用`Arrays.stream()`

```java
Stream<Integer> stream = Stream.of(1, 2, 3);
```

- **注意**：还有两种比较特殊的流。
    - 空流：`Stream.empty()`
    - 无限流`Stream.generate()` 和`Stream.iterate()`，可以配合`limit()`使用限制数量。

```java
// 接受一个 Supplier 作为参数。
Stream.generate(Math::random).limit(10).forEach(System.out::println);
// 初始值是 0，新值是前一个元素值 + 2
Stream.iterate(0, n -> n + 2).limit(10).forEach(System.out::println);
```

## 中间操作（intermediate)

调用中间操作方法返回的是一个新的流对象。

### peek()

- 提供了一种对流中所有元素操作的方法，生成一个包含原Stream的所有元素的新Stream，同时会提供一个消费函数（Consumer实例）
- 新Stream每个元素被消费的时候都会执行给定的消费函数。
- 一般不推荐使用，文档提示：该方法主要用于调试，做一些消耗这个对象但不修改它的东西（发送通知，打印模型等）

```java
Stream.of("1", "2", "3", "4")
    .filter(e -> e.length() > 3)
    .peek(e -> System.out.println("Filtered value: " + e))
    .map(String::toUpperCase)
    .peek(e -> System.out.println("Mapped value: " + e))
    .collect(Collectors.toList());
```

- peek调试打印流中某操作后的每个元素。

### map()

- map 方法用于映射每个元素到对应的结果。
- 以下代码片段使用 map 输出了元素对应的平方数。

```java
List<Integer> numbers = Arrays.asList(3, 2, 2, 3, 7, 3, 5);
// 获取对应的平方数。
List<Integer> squaresList = numbers.stream().map( i -> i*i).distinct().collect(Collectors.toList());
```

### filter()

- filter 方法用于通过设置的条件过滤出元素。
- 以下代码片段使用 filter 方法过滤出空字符串。

```java
List<String>strings = Arrays.asList("abc", "", "bc", "efg", "abcd","", "jkl");
// 获取空字符串的数量。
long count = strings.stream().filter(string -> string.isEmpty()).count();
```

### distinct()

- distinct方法用于过滤相同元素。

```java
Collection<String> list = Arrays.asList("A", "B", "C", "D", "A", "B", "C");
List<String> Elements = list.stream().distinct().collect(Collectors.toList());
```

### max()

- max方法用于过滤出最大值。

```java
Collection<String> list = Arrays.asList(1,2,3,4,5);
List<String> Elements = list.stream().max().collect(Collectors.toList());
```

### min()

- min方法用于过滤出最小值。

```java
Collection<String> list = Arrays.asList(1,2,3,4,5);
List<String> Elements = list.stream().min().collect(Collectors.toList());
```

### limit()

- limit 方法用于获取指定数量的流。
- 以下代码片段使用 limit 方法打印出 10 条数据。

```java
Random random = new Random();
random.ints().limit(10).forEach(System.out::println);
```

### sorted()

- sorted 方法用于对流进行排序。
- 以下代码片段使用 sorted 方法对输出的 10 个随机数进行排序。

```java
Random random = new Random();
random.ints().limit(10).sorted().forEach(System.out::println);
```

## 终值操作（terminal)

在调用该方法后，将执行之前所有的中间操作，并返回结果。

### toArray()

- toArray方法将Stream流转换为数组。

```java
List<Integer> numbers = Arrays.asList(3, 2, 2, 3, 7, 3, 5);
List<Integer> list = numbers.stream().toArray();
```

- 若是对象数组，则要在 toArray 里面加上生产对象数组的方法引用。

```java
//Integer 数组。
toArray(Integer[] :: new)
//person 数组。
toArray(person[] ::  new)
```

### forEach()

- Stream 提供了新的方法`forEach()`来迭代流中的每个数据。
- 以下代码片段使用 forEach 输出了10个随机数。

```java
Random random = new Random();
random.ints().limit(10).forEach(System.out::println);
```

### collect与Collectors

- Stream 接口中 `collect()` 使用Collector做参数。

- Collectors类实现了很多归约操作，例如将流转换成集合和聚合元素。

- Collectors可用于返回列表或字符串。

- Collectors 被指定和四个函数一起工作，并实现累加 entries 到一个可变的结果容器，并可选择执行该结果的最终变换，这四个函数就是：

    | 接口函数      | 作用                           | 返回值         |
    | ------------- | ------------------------------ | -------------- |
    | supplier()    | 创建并返回一个新的可变结果容器 | Supplier       |
    | accumulator() | 把输入值加入到可变结果容器     | BiConsumer     |
    | combiner()    | 将两个结果容器组合成一个       | BinaryOperator |
    | finisher()    | 转换中间结果为终值结果         | Function       |

- 其中，`collect(Supplier<R> supplier, BiConsumer<R, ? super T> accumulator, BiConsumer<R, R> combiner)` 无非就是比Collector少一个 finisher，本质上是一样的。

```java
List<String>strings = Arrays.asList("abc", "", "bc", "efg", "abcd","", "jkl");
List<String> filtered = strings.stream().filter(string -> !string.isEmpty()).collect(Collectors.toList());

System.out.println("筛选列表： " + filtered);
String mergedString = strings.stream().filter(string -> !string.isEmpty()).collect(Collectors.joining(", "));
System.out.println("合并字符串： " + mergedString);
```

#### 求和

- Collectors.summingInt()
- Collectors.summingLong()
- Collectors.summingDouble()

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-2020-11-29-1730512-20200716220911037-2007965978.jpg)

```java
applestore.stream().collect(summingInt(Apple::getWeight()))
```

- 通过引用 `import static java.util.stream.Collectors.summingInt;` 就可以直接调用`summingInt()`
- `Apple::getWeight()`可以写为`apple -> apple.getWeight()`，求和函数的参数是结果转换函数 **Function**

#### 求平均值

- Collectors.averagingInt()
- Collectors.averagingKLong()
- Collectors.averagingDouble()

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-2020-11-29-1730512-20200716220927770-127840192.jpg)

```java
applestore.stream().collect(aceragingInt(Apple::getWeight())
```

#### 归约

- Collectors.reducing()
- 归约就是为了遍历数据容器，将每个元素对象转换为特定的值，通过累积函数，得到一个最终值。
- 转换函数，函数输入参数的对象类型是跟`Stream<T>`中的 T 一样的对象类型，输出的对象类型的是和初始值一样的对象类型。
- 累积函数，就是把转换函数的结果与上一次累积的结果进行一次合并，如果是第一次累积，那么取初始值来计算。
    - 累积函数还可以作用于两个`Stream<T> `合并时的累积，这个可以结合 groupingBy 来理解。
- 初始值的对象类型，和每一次累积函数输出值的对象类型是相同的，这样才能一直进行累积函数的运算。
- 归约不仅仅可以支持加法，还可以支持比如乘法以及其他更高级的累积公式。

```java
@Test
public void reduce() {
    Integer sum = appleStore.stream().collect(reducing(0, Apple::getWeight, (a, b) -> a + b));
    System.out.println(sum);
}
```

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-2020-11-29-1730512-20200717080958680-295486211.jpg)

#### 计数

- Collectors.counting()
- 计数只是归约的一种特殊形式：等同于初始值为 **0**，转换函数 **f(x)=1**(x 就是`Stream<T>`的 T 类型），累积函数就是做加法的reducing()

#### 分组

- Collectors.groupingBy()
- 分组与SQL 中的 **GROUP BY** 十分类似，所以`groupingBy()`的所有参数中有一个参数是 Collector接口，这样就能够和求和/求平均值/归约一起使用。
    ![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-2020-11-29-1730512-20200717183701535-768759500.jpg)
- 传入参数的接口是 Function 接口，实现这个接口可以是实现从 A 类型到 B 类型的转换。
- 其中有一个方法可以传入参数 `Supplier mapFactory`，这个可以通过自定义 Map工厂，来创建自定义的分组 Map

#### 分区

- Collectors.partitioningBy()
- 传入参数的是 Predicate 接口。
- 分区只是分组的一种特殊形式。
- 分区相当于把流中的数据，分组分成了"正反两个阵营”

### summaryStatistics()

产生统计结果的收集器也非常有用，它们主要用于int,double,long等基本类型上，它们可以用来产生类似如下的统计结果。

```java
List<Integer> numbers = Arrays.asList(3, 2, 2, 3, 7, 3, 5);

IntSummaryStatistics stats = numbers.stream().mapToInt((x) -> x).summaryStatistics();

System.out.println("列表中最大的数： " + stats.getMax());
System.out.println("列表中最小的数： " + stats.getMin());
System.out.println("所有数之和： " + stats.getSum());
System.out.println("平均数： " + stats.getAverage());
```

## 数值流

Java8引入了三个原始类型特化流接口：IntStream,LongStream,DoubleStream，分别将流中的元素特化为 int,long,double
普通对象流和原始类型特化流之间可以相互转化。

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-2020-11-30-1730512-20200717202104577-1160921711.jpg)

- 其中 IntStream 和 LongStream 可以调用 asDoubleStream 变为 DoubleStream，但是这是单向的转化方法。
- `IntStream.boxed()`可以得到`Stream<Integer>`，这个也是一个单向方法，支持数值流转换回对象流，LongStream 和 DoubleStream 也有类似的方法。

### 生成一个数值流

- IntStream.range(int startInclusive, int endExclusive)
- IntStream.rangeClosed(int startInclusive, int endInclusive)
- range 和 rangeClosed 的区别在于数值流是否包含 end 这个值，range 代表的区间是 [start, end) , rangeClosed 代表的区间是 [start, end]
- LongStream 也有 range 和 rangeClosed 方法，但是 DoubleStream 没有。

### flatMap

- Stream.flatMap 就是流中的每个对象，转换产生一个对象流。
- Stream.flatMapToInt 指定流中的每个对象，转换产生一个 IntStream 数值流，类似的，还有 flatMapToLong,flatMapToDouble
- IntStream.flatMap 数值流中的每个对象，转换产生一个数值流。
- flatMap 可以代替一些嵌套循环来开展业务。

**实例**

比如要求勾股数（即 a\*a+b\*b=c\*c 的一组数中的 a,b,c)，且我们要求 a 和 b 的范围是 [1,100]，我们在 Java8之前会这样写：

```java
@Test
public void testJava() {
  List<int[]> resultList = new ArrayList<>();
  for (int a = 1; a <= 100; a++) {
    for (int b = a; b <= 100; b++) {
      double c = Math.sqrt(a * a + b * b);
      if (c % 1 == 0) {
        resultList.add(new int[]{a, b, (int) c});
      }
    }
  }

  int size = resultList.size();
  for (int i = 0; i < size && i < 5; i++) {
    int[] a = resultList.get(i);
    System.out.println(a[0] + " " + a[1] + " " + a[2]);
  }
}
```

Java8之后，我们可以用上 flatMap:

```java
@Test
public void flatMap() {
  Stream<int[]> stream = IntStream.rangeClosed(1, 100)
    .boxed()
    .flatMap(a -> IntStream.rangeClosed(a, 100)
             .filter(b -> Math.sqrt(a * a + b * b) % 1 == 0)
             .mapToObj(b -> new int[]{a, b, (int) Math.sqrt(a * a + b * b)})
            );
  stream.limit(5).forEach(a -> System.out.println(a[0] + " " + a[1] + " " + a[2]));
}
```

- 创建一个从 1 到 100 的数值范围来创建 a 的值，对每个给定的 a 值，创建一个三元数流。
- flatMap 方法在做映射的同时，还会把所有生成的三元数流扁平化成一个流。

## Stream 完整实例

```java
public class Java8Tester {
  public static void main(String args[]){
    System.out.println("列表： " +strings);

    count = strings.stream().filter(string->string.isEmpty()).count();
    System.out.println("空字符串数量为： " + count);

    count = strings.stream().filter(string -> string.length() == 3).count();
    System.out.println("字符串长度为 3 的数量为： " + count);

    filtered = strings.stream().filter(string ->!string.isEmpty()).collect(Collectors.toList());
    System.out.println("筛选后的列表： " + filtered);

    mergedString = strings.stream().filter(string ->!string.isEmpty()).collect(Collectors.joining(", "));
    System.out.println("合并字符串： " + mergedString);

    squaresList = numbers.stream().map( i ->i*i).distinct().collect(Collectors.toList());
    System.out.println("Squares List: " + squaresList);
    System.out.println("列表： " +integers);

    IntSummaryStatistics stats = integers.stream().mapToInt((x) ->x).summaryStatistics();

    System.out.println("列表中最大的数： " + stats.getMax());
    System.out.println("列表中最小的数： " + stats.getMin());
    System.out.println("所有数之和： " + stats.getSum());
    System.out.println("平均数： " + stats.getAverage());
    System.out.println("随机数： ");

    random.ints().limit(10).sorted().forEach(System.out::println);

    // 并行处理。
    count = strings.parallelStream().filter(string -> string.isEmpty()).count();
    System.out.println("空字符串的数量为： " + count);
  }

}
```

执行以上程序，输出结果为：

```
列表： [abc, , bc, efg, abcd, , jkl]
空字符串数量为： 2
字符串长度为 3 的数量为： 3
筛选后的列表： [abc, bc, efg, abcd, jkl]
合并字符串： abc, bc, efg, abcd, jkl
Squares List: [9, 4, 49, 25]
列表： [1, 2, 13, 4, 15, 6, 17, 8, 19]
列表中最大的数： 19
列表中最小的数： 1
所有数之和： 85
平均数： 9.444444444444445
随机数：
-1743813696
-1301974944
-1299484995
-779981186
136544902
555792023
1243315896
1264920849
1472077135
1706423674
空字符串的数量为： 2
```