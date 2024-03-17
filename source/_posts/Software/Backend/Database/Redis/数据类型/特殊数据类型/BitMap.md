---
title: Redis BitMap
categories:
- Software
- BackEnd
- Database
- Redis
- 数据类型
- 特殊数据类型
---
# Redis BitMap

- BitMap通过一个bit位来表示某个元素对应的值或者状态,其中的key就是对应元素本身
- Bitmaps 本身不是一种数据结构,实际上它就是字符串,但是它可以对字符串的位进行操作
- Bitmaps 单独提供了一套命令,所以在 Redis 中使用 Bitmaps 和使用字符串的方法不太相同
- 可以把 Bitmaps 想象成一个以位为单位的数组,数组的每个单元只能存储0和1,数组的下标在Bitmaps中叫做偏移量

## SETBIT

```
SETBIT key offset value
```

**说明**:

- 对 `key` 所储存的字符串值,设置或清除指定偏移量上的位(bit)
- 位的设置或清除取决于 `value` 参数,可以是 `0` 也可以是 `1`
- 当 `key` 不存在时,自动生成一个新的字符串值
- 字符串会进行伸展(grown)以确保它可以将 `value` 保存在指定的偏移量上,当字符串值进行伸展时,空白位置以 `0`填充
- `offset` 参数必须大于或等于 `0` ,小于 2^32 (bit 映射被限制在 512 MB 之内)
- **对使用大的 `offset` 的 `SETBIT` 操作来说,内存分配可能造成 Redis 服务器被阻塞,**

**返回值**:

- 字符串值指定偏移量上原来储存的位(bit)

**示例**:

```
# SETBIT 会返回之前位的值（默认是 0)这里会生成 126 个位
coderknock> SETBIT testBit 125 1
(integer) 0
coderknock> SETBIT testBit 125 0
(integer) 1
coderknock> SETBIT testBit 125 1
(integer) 0
coderknock> GETBIT testBit 125
(integer) 1
coderknock> GETBIT testBit 100
(integer) 0
# SETBIT  value 只能是 0 或者 1  二进制只能是0或者1
coderknock> SETBIT testBit 618 2
(error) ERR bit is not an integer or out of range
```

## GETBIT

```
GETBIT key offset
```

**说明**:

- 对 `key` 所储存的字符串值,获取指定偏移量上的位(bit)
- 当 `offset` 比字符串值的长度大,或者 `key` 不存在时,返回 `0`

**返回值**:

- 字符串值指定偏移量上的位(bit)

**示例**

```
coderknock> EXISTS bit
(integer) 0
coderknock> SETBIT bit 125 1
(integer) 0
coderknock> GETBIT bit 125
(integer) 1
# 偏移量如果不存在则是0
coderknock> GETBIT bit 126
(integer) 0
# 可以看到 bit 本身也是个字符串
coderknock> GET bit
"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00 "
```

## BITCOUNT

- 获取Bitmaps 指定范围值为 1 的位个数

```
BITCOUNT key start end
```

**说明**:

- 计算给定字符串中,被设置为 `1` 的比特位的数量
- 一般情况下,给定的整个字符串都会被进行计数,通过指定额外的 `start` 或 `end` 参数,可以让计数只在特定的位上进行
- `start` 和 `end` 参数的设置和 `GETRANGE` 命令类似,都可以使用负数值: 比如 `-1` 表示最后一个字节, `-2`表示倒数第二个字节,以此类推
- 不存在的 `key` 被当成是空字符串来处理,因此对一个不存在的 `key` 进行 `BITCOUNT` 操作,结果为 `0`

**返回值**:

- 被设置为 `1` 的位的数量

**示例**

```
# 此处的 bit 基于 GETBIT 示例的命令中的
coderknock> BITCOUNT bit
(integer) 1
# 计算 bit 中所有值为 1 的位的个数
coderknock> BITCOUNT bit
(integer) 1
coderknock> SETBIT bit 0 1
(integer) 0
coderknock> BITCOUNT bit
(integer) 2
# 计算指定位置 bit 中所有值为 1 的位的个数
coderknock> BITCOUNT bit 10 126
(integer) 1
```

## BITOP

```
BITOP operation destkey key [key ...]
```

**说明**:

- 对一个或多个保存二进制位的字符串 `key` 进行位元操作,并将结果保存到 `destkey` 上
- `operation` 可以是 `AND` , `OR` , `NOT` , `XOR` 这四种操作中的任意一种:
    - `BITOP AND destkey key [key ...]` ,对一个或多个 `key` 求逻辑并,并将结果保存到 `destkey`
    - `BITOP OR destkey key [key ...]` ,对一个或多个 `key` 求逻辑或,并将结果保存到 `destkey`
    - `BITOP XOR destkey key [key ...]` ,对一个或多个 `key` 求逻辑异或,并将结果保存到 `destkey`
    - `BITOP NOT destkey key` ,对给定 `key` 求逻辑非,并将结果保存到 `destkey`
- 除了 `NOT` 操作之外,其他操作都可以接受一个或多个 `key` 作为输入
- **处理不同长度的字符串**
    - 当 `BITOP` 处理不同长度的字符串时,较短的那个字符串所缺少的部分会被看作 `0`
    - 空的 `key` 也被看作是包含 `0` 的字符串序列

**返回值**:

保存到 `destkey` 的字符串的长度,和输入 `key` 中最长的字符串长度相等

**示例**

```
coderknock> SETBIT bits-1 0 1
(integer) 0
coderknock> SETBIT bits-1 3 1
(integer) 0
# bits-1 为 1001

coderknock> SETBIT bits-2 0 1
(integer) 0
coderknock> SETBIT bits-2 1 1
(integer) 0
coderknock> SETBIT bits-2 3 1
(integer) 0
# bits-2 为 1011

#bits-1 bits-2 做并 操作
coderknock> BITOP AND and-result bits-1 bits-2
(integer) 1
coderknock> GETBIT and-result 0
(integer) 1
coderknock> GETBIT and-result 1
(integer) 0
coderknock> GETBIT and-result 2
(integer) 0
coderknock> GETBIT and-result 3
(integer) 1
#and-result 1001

#bits-1 bits-2 做或 操作
coderknock> BITOP OR or-result bits-1 bits-2
(integer) 1
coderknock> GETBIT and-result 0
(integer) 1
coderknock> GETBIT and-result 1
(integer) 0
coderknock> GETBIT and-result 2
(integer) 0
coderknock> GETBIT and-result 3
(integer) 1
#or-result 1011

# 非操作只能针对一个 key
coderknock> BITOP NOT not-result bits-1 bits-2
(error) ERR BITOP NOT must be called with a single source key.
coderknock> BITOP NOT not-result bits-1
(integer) 1
coderknock> GETBIT not-result 0
(integer) 0
coderknock> GETBIT not-result 1
(integer) 1
coderknock> GETBIT not-result 2
(integer) 1
coderknock> GETBIT not-result 3
(integer) 0
# not-result 0110

# 异或操作
coderknock> BITOP XOR xor-result bits-1 bits-2
(integer) 1
coderknock> GETBIT xor-result 0
(integer) 0
coderknock> GETBIT xor-result 1
(integer) 1
coderknock> GETBIT xor-result 2
(integer) 0
coderknock> GETBIT xor-result 3
(integer) 0
# xor-result 0010
```

**注意**:`BITOP` 的复杂度为 O(N) ,当处理大型矩阵(matrix)或者进行大数据量的统计时,最好将任务指派到附属节点(slave)进行,避免阻塞主节点

## BITPOS

```
BITPOS key bit [start][end]
```

**说明**:

- 返回字符串里面第一个被设置为 1 或者 0 的bit位
- 返回一个位置,把字符串当做一个从左到右的字节数组,第一个符合条件的在位置 0,其次在位置 8,等等
- `GETBIT` 和 `SETBIT` 相似的也是操作字节位的命令
- 默认情况下整个字符串都会被检索一次,只有在指定 start 和 end 参数（指定start和end位是可行的),该范围被解释为一个字节的范围,而不是一系列的位,所以`start=0` 并且 `end=2`是指前三个字节范围内查找
- 注意,返回的位的位置始终是从 0 开始的,即使使用了 start 来指定了一个开始字节也是这样
- 和 `GETRANGE` 命令一样,start 和 end 也可以包含负值,负值将从字符串的末尾开始计算,-1是字符串的最后一个字节,-2是倒数第二个,等等
- 不存在的key将会被当做空字符串来处理

**返回值**:

- 命令返回字符串里面第一个被设置为 1 或者 0 的 bit 位
- 如果我们在空字符串或者 0 字节的字符串里面查找 bit 为1的内容,那么结果将返回-1
- 如果我们在字符串里面查找 bit 为 0 而且字符串只包含1的值时,将返回字符串最右边的第一个空位,如果有一个字符串是三个字节的值为 `0xff` 的字符串,那么命令 `BITPOS key 0` 将会返回 24,因为 0-23 位都是1
- 基本上,我们可以把字符串看成右边有无数个 0
- 然而,如果你用指定 start 和 end 范围进行查找指定值时,如果该范围内没有对应值,结果将返回 -1

**示例**

```
redis> SET mykey "\xff\xf0\x00"
OK
redis> BITPOS mykey 0 # 查找字符串里面bit值为0的位置
(integer) 12
redis> SET mykey "\x00\xff\xf0"
OK
redis> BITPOS mykey 1 0 # 查找字符串里面bit值为1从第0个字节开始的位置
(integer) 8
redis> BITPOS mykey 1 2 # 查找字符串里面bit值为1从第2个字节(12)开始的位置
(integer) 16
redis> set mykey "\x00\x00\x00"
OK
redis> BITPOS mykey 1 # 查找字符串里面bit值为1的位置
                    (integer) -1
```

## BITFIELD

```
BITFIELD key [GET type offset][SET type offset value][INCRBY type offset increment][OVERFLOW WRAP|SAT|FAIL]
```

- `BITFIELD` 命令可以将一个 Redis 字符串看作是一个由二进制位组成的数组, 并对这个数组中储存的长度不同的整数进行访问（被储存的整数无需进行对齐), 换句话说, 通过这个命令, 用户可以执行诸如 "对偏移量 1234 上的 5 位长有符号整数进行设置”, "获取偏移量 4567 上的 31 位长无符号整数”等操作, 此外, `BITFIELD` 命令还可以对指定的整数执行加法操作和减法操作, 并且这些操作可以通过设置妥善地处理计算时出现的溢出情况
- `BITFIELD` 命令可以在一次调用中同时对多个位范围进行操作: 它接受一系列待执行的操作作为参数, 并返回一个数组作为回复, 数组中的每个元素就是对应操作的执行结果
- 比如以下命令就展示了如何对位于偏移量 100 的 8 位长有符号整数执行加法操作, 并获取位于偏移量 0 上的 4 位长无符号整数:

```
coderknock> BITFIELD mykey INCRBY i8 100 1 GET u4 0
1) (integer) 1
2) (integer) 0
```

**注意**:

- 使用 `GET` 子命令对超出字符串当前范围的二进制位进行访问（包括键不存在的情况), 超出部分的二进制位的值将被当做是 0
- 使用 `SET` 子命令或者 `INCRBY` 子命令对超出字符串当前范围的二进制位进行访问将导致字符串被扩大, 被扩大的部分会使用值为 0 的二进制位进行填充, 在对字符串进行扩展时, 命令会根据字符串目前已有的最远端二进制位, 计算出执行操作所需的最小长度

### 支持的子命令以及数字类型:

- `GET <type> <offset>`——返回指定的二进制位范围
- `SET <type> <offset> <value>`——对指定的二进制位范围进行设置,并返回它的旧值
- `INCRBY <type> <offset> <increment>`——对指定的二进制位范围执行加法操作,并返回它的旧值,用户可以通过向 `increment` 参数传入负值来实现相应的减法操作

- 除了以上三个子命令之外, 还有一个子命令, 它可以改变之后执行的 `INCRBY` 子命令在发生溢出情况时的行为:
    - `OVERFLOW [WRAP|SAT|FAIL]`
- 当被设置的二进制位范围值为整数时, 用户可以在类型参数的前面添加 `i` 来表示有符号整数, 或者使用 `u` 来表示无符号整数, 比如说, 我们可以使用 `u8` 来表示 8 位长的无符号整数, 也可以使用 `i16` 来表示 16 位长的有符号整数
- `BITFIELD` 命令最大支持 64 位长的有符号整数以及 63 位长的无符号整数, 其中无符号整数的 63 位长度限制是由于 Redis 协议目前还无法返回 64 位长的无符号整数而导致的

### 二进制位和位置偏移量

- 在二进制位范围命令中, 用户有两种方法来设置偏移量:
- 如果用户给定的是一个没有任何前缀的数字, 那么这个数字指示的就是字符串以零为开始(zero-base)的偏移量
- 另一方面, 如果用户给定的是一个带有 `#` 前缀的偏移量, 那么命令将使用这个偏移量与被设置的数字类型的位长度相乘, 从而计算出真正的偏移量
- 比如说, 对于以下这个命令来说:

```
BITFIELD mystring SET i8 #0 100 i8 #1 200
```

- 命令会把 `mystring` 键里面, 第一个 `i8` 长度的二进制位的值设置为 `100` , 并把第二个 `i8` 长度的二进制位的值设置为 `200` , 当我们把一个字符串键当成数组来使用, 并且数组中储存的都是同等长度的整数时, 使用 `#` 前缀可以让我们免去手动计算被设置二进制位所在位置的麻烦

### 溢出控制

- 用户可以通过 `OVERFLOW` 命令以及以下展示的三个参数, 指定 `BITFIELD` 命令在执行自增或者自减操作时, 碰上向上溢出(overflow)或者向下溢出(underflow)情况时的行为:
    - `WRAP` : 使用回绕(wrap around)方法处理有符号整数和无符号整数的溢出情况, 对于无符号整数来说, 回绕就像使用数值本身与能够被储存的最大无符号整数执行取模计算, 这也是 C 语言的标准行为, 对于有符号整数来说, 上溢将导致数字重新从最小的负数开始计算, 而下溢将导致数字重新从最大的正数开始计算, 比如说, 如果我们对一个值为 `127` 的 `i8` 整数执行加一操作, 那么将得到结果 `-128`
    - `SAT` : 使用饱和计算(saturation arithmetic)方法处理溢出, 也即是说, 下溢计算的结果为最小的整数值, 而上溢计算的结果为最大的整数值, 举个例子, 如果我们对一个值为 `120` 的 `i8` 整数执行加 `10`计算, 那么命令的结果将为 `i8` 类型所能储存的最大整数值 `127` , 与此相反, 如果一个针对 `i8` 值的计算造成了下溢, 那么这个 `i8` 值将被设置为 `-127`
    - `FAIL` : 在这一模式下, 命令将拒绝执行那些会导致上溢或者下溢情况出现的计算, 并向用户返回空值表示计算未被执行
- 需要注意的是, `OVERFLOW` 子命令只会对紧随着它之后被执行的 `INCRBY` 命令产生效果, 这一效果将一直持续到与它一同被执行的下一个 `OVERFLOW` 命令为止, 在默认情况下, `INCRBY` 命令使用 `WRAP` 方式来处理溢出计算
- 以下是一个使用 `OVERFLOW` 子命令来控制溢出行为的例子:

```
coderknock> BITFIELD mykey incrby u2 100 1 OVERFLOW SAT incrby u2 102 1
1) (integer) 1
2) (integer) 1

coderknock> BITFIELD mykey incrby u2 100 1 OVERFLOW SAT incrby u2 102 1
1) (integer) 2
2) (integer) 2

coderknock> BITFIELD mykey incrby u2 100 1 OVERFLOW SAT incrby u2 102 1
1) (integer) 3
2) (integer) 3

coderknock> BITFIELD mykey incrby u2 100 1 OVERFLOW SAT incrby u2 102 1
1) (integer) 0  -- 使用默认的 WRAP 方式处理溢出
2) (integer) 3  -- 使用 SAT 方式处理溢出
```

- 而以下则是一个因为 `OVERFLOW FAIL` 行为而导致子命令返回空值的例子:

```
coderknock> BITFIELD mykey OVERFLOW FAIL incrby u2 102 1
1) (nil)
```

### 作用

- `BITFIELD` 命令的作用在于它能够将很多小的整数储存到一个长度较大的位图中, 又或者将一个非常庞大的键分割为多个较小的键来进行储存, 从而非常高效地使用内存, 使得 Redis 能够得到更多不同的应用——特别是在实时分析领域: `BITFIELD` 能够以指定的方式对计算溢出进行控制的能力, 使得它可以被应用于这一领域

### 性能注意事项

- `BITFIELD` 在一般情况下都是一个快速的命令, 需要注意的是, 访问一个长度较短的字符串的远端二进制位将引发一次内存分配操作, 这一操作花费的时间可能会比命令访问已有的字符串花费的时间要长

### 二进制位的排列

- `BITFIELD` 把位图第一个字节偏移量 0 上的二进制位看作是 most significant 位, 以此类推, 举个例子, 如果我们对一个已经预先被全部设置为 0 的位图进行设置, 将它在偏移量 7 的值设置为 5 位无符号整数值 23 (二进制位为 `10111` ), 那么命令将生产出以下这个位图表示:

```
+--------+--------+
|00000001|01110000|
+--------+--------+
```

- 当偏移量和整数长度与字节边界进行对齐时, `BITFIELD` 表示二进制位的方式跟大端表示法(big endian)一致, 但是在没有对齐的情况下, 理解这些二进制位是如何进行排列也是非常重要的

**返回值**:

- 如果 `member` 元素是集合的成员,返回 `1`
- 如果 `member` 元素不是集合的成员,或 `key` 不存在,返回 `0`

**示例**:

```
coderknock> SISMEMBER saddTest add1
(integer) 1
#  add7  元素不存在
coderknock> SISMEMBER saddTest add7
(integer) 0
# key 不存在
coderknock> SISMEMBER nonSet a
(integer) 0
# key 类型不是集合
coderknock> SISMEMBER embstrKey a
(error) WRONGTYPE Operation against a key holding the wrong kind of value
```

### 案例

#### 使用场景一：用户签到

```
Jedis redis = new Jedis("192.168.31.89",6379,100000);
//用户uid
String uid = "1";
String cacheKey = "sign_"+Integer.valueOf(uid);
//记录有uid的key
// $cacheKey = sprintf("sign_%d", $uid);

//开始有签到功能的日期
String startDate = "2017-01-01";

//今天的日期
String todayDate = "2017-01-21";

//计算offset(时间搓)
long startTime = dateParase(startDate,"yyyy-MM-dd").getTime();
long todayTime = dateParase(todayDate,"yyyy-MM-dd").getTime();
long offset = (long) Math.floor((todayTime - startTime) / 86400);

System.out.println("今天是第"+offset+"天");

//签到
//一年一个用户会占用多少空间呢？大约365/8=45.625个字节,好小,有木有被惊呆？
redis.setbit(cacheKey,offset,"1");

//查询签到情况
boolean bitStatus = redis.getbit(cacheKey, offset);
//判断是否已经签到
//计算总签到次数
long qdCount = redis.bitcount(cacheKey);复制代码
```

#### 使用场景二：统计活跃用户

- 使用时间作为cacheKey,然后用户ID为offset,如果当日活跃过就设置为1 那么我该如果计算某几天/月/年的活跃用户呢（暂且约定,统计时间内只有有一天在线就称为活跃),有请下一个Redis的命令命令 BITOP operation destkey key [key ...] 说明：对一个或多个保存二进制位的字符串 key 进行位元操作,并将结果保存到 destkey 上, 说明:BITOP 命令支持 AND , OR , NOT , XOR 这四种操作中的任意一种参数

```
Map<String,List<Integer>>dateActiveuser = new HashMap<>();
Jedis redis = new Jedis("192.168.31.89",6379,100000);
Integer[] temp01 = {1,2,3,4,5,6,7,8,9,10};
List<Integer>temp01List = new ArrayList<>();
Collections.addAll(temp01List,temp01);
dateActiveuser.put("2017-01-10",temp01List);


Integer[] temp02 = {1,2,3,4,5,6,7,8};
List<Integer>temp02List = new ArrayList<>();
Collections.addAll(temp02List,temp02);
dateActiveuser.put("2017-01-11",temp02List);

Integer[] temp03 = {1,2,3,4,5,6};
List<Integer>temp03List = new ArrayList<>();
Collections.addAll(temp03List,temp03);
dateActiveuser.put("2017-01-12",temp03List);

Integer[] temp04 = {1,4,5,6};
List<Integer>temp04List = new ArrayList<>();
Collections.addAll(temp04List,temp04);
dateActiveuser.put("2017-01-13",temp04List);

Integer[] temp05 = {1,4,5,6};
List<Integer>temp05List = new ArrayList<>();
Collections.addAll(temp05List,temp05);
dateActiveuser.put("2017-01-14",temp05List);

String date[] = {"2017-01-10","2017-01-11","2017-01-12","2017-01-13","2017-01-14"};

//测试数据放入Redis中
for (int i=0;i<date.length;i++){
    for (int j=0;j<dateActiveuser.get(date[i]).size();j++){
        redis.setbit(date[i], dateActiveuser.get(date[i]).get(j), "1");
    }
}

//bitOp
redis.bitop(BitOP.AND, "stat", "stat_2017-01-10", "stat_2017-01-11","stat_2017-01-12");

System.out.println("总活跃用户:"+redis.bitcount("stat"));

redis.bitop(BitOP.AND, "stat1", "stat_2017-01-10", "stat_2017-01-11","stat_2017-01-14");
System.out.println("总活跃用户:"+redis.bitcount("stat1"));

redis.bitop(BitOP.AND, "stat2", "stat_2017-01-10", "stat_2017-01-11");
System.out.println("总活跃用户:"+redis.bitcount("stat2"));复制代码
```