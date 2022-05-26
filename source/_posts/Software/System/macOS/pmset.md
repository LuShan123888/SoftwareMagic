---
title: macOS pmset
categories:
- Software
- System
- macOS
---
# macOS pmset

- 这个工具可以设置和列出电量管理的设置一部分功能在"节能偏好”面板中通过图形界面的形式提供出来然而,pmset 预留的一些更加灵活的选项并不适用于图形界面

- 它可以根据使用情况设置不同的电量管理设定当机器正在充电,使用电池,UPS 或者三者全都有的情况下,可以应用不同的设定下面是相关的标记:

    - -c 调节设定用于连接充电器的时候

    - -b 调节设定用于使用电池的时候

    - -u 调节设定用于使用 UPS 的时候

    - -a 调节设定用于全部情景


## 命令

- pmset,操纵电源管理设置( power managment settings )

```shell
pmset [-a | -b | -c | -u] [setting value] [...]

pmset -u [haltlevel percent] [haltafter minutes] [haltremain minutes]

pmset -g [option]

pmset schedule [cancel] type date+time [owner]

pmset repeat cancel

pmset repeat type weekdays time

pmset relative wake seconds

pmset [touch | sleepnow | displaysleepnow | lock | boot]

```

- pmset 管理电源设置,像空闲睡眠时间,当管理员访问时唤醒,断电自动重启等等
- 注意,这个过程可以通过使用 IO 电源断言动态的覆盖无论何时程序覆盖任何系统电源设置, pmset 将列出那些程序以及他们的电源断言

**使用情景**

- pmset 可以修改任意电源管理设置以下定义的值你可以在命令行中使用
- mset 指定至少一个情景-值对-a,-b,-c,-u 标记设置是否应用到电池(-b),充电(-c),UPS(-u) 或者全部(-a)
- 使用一个 0 的分钟参数来设置空闲时间,绝不睡眠,硬盘睡眠和显示器睡眠
- pmset 必须由 root 用户运行来修改任何的设置

### 设置信息

|         命令          |                             说明                             |
| :-------------------: | :----------------------------------------------------------: |
|     displaysleep      | 显示器睡眠计时器,替换 10.4 版本中的 dim 参数(值为分钟,或者设置 0 来禁用) |
|       disksleep       | 硬盘降速计时器,替换 10.4 版本中的 spindown 参数(值为分钟,或者设置 0 来禁用) |
|         sleep         |          系统睡眠计时器(值为分钟,或者设置 0 来禁用)          |
|         womp          |                通过以太网唤醒(值为 1 或者 0)                 |
|         ring          |              通过调制解调器环境(值为 1 或者 0)               |
|      autorestart      |             当电量损耗时自动重启(值为 1 或者 0)              |
|        lidwake        |        当笔记本打开盖子的时候唤醒机器(值为 1 或者 0)         |
|        acwake         |     当电源(AC 或者电池)改变的时候唤醒机器(值为 1 或者 0)     |
|      lessbright       |        当切换电源时,略微调低显示器亮度(值为 1 或者 0)        |
|        halfdim        | 显示器睡眠将使用在最大亮度和关闭显示器之间的中间亮度(值为 1 或者 0) |
|          sms          | 当重力突然改变时,使用瞬时运动传感器来停止磁盘头(值为 1 或者 0) |
|     hibernatemode     |               改变休眠模式请小心使用(值为整数)               |
|     hibernatefile     | 改变休眠镜像文件位置镜像应该只被定为到根卷中请小心使用(值为路径) |
|     ttyskeepawake     | 当任何 tty(如:远程登录会话) 在活动状态时,阻止系统空闲睡眠tty 只能是非活动 当它的空闲时间超过系统睡眠计时器(值为 1 或者 0) |
|   networkoversleep    | 这个设置影响 OS X 在系统睡眠时如何联网这个设置不被全平台使用,不支持修改这个值 |
| destroyfvkeyonstandby | 当变为待机模式时销毁文件库密钥默认地,当系统待机时密钥被保留如果关键文件被销毁,将导致当用户退出待机模式时输入密码(值为 1 – 销毁 ,0 – 保留) |
|     autopoweroff      | 系统将写入休眠镜像并且进入到低电量芯片组睡眠从这个状态唤醒所花的时间要比普通休眠唤醒的时间要长如果有外部设备连接,系统不会自动切断电源,如果系统使用电池供电,或者系统被绑定在网络并且通过网络访问被唤醒功能开启 |
|   autopoweroffdelay   |        进入自动切断电源模式的延迟(值为表示分钟的整数)        |

### 显示信息

|       命令       |                             说明                             |
| :--------------: | :----------------------------------------------------------: |
|   -g(不带参数)   |                    显示当前正在使用的设置                    |
|     -g live      |                    显示当前正在使用的设置                    |
|    -g custom     |                  显示为所有电源的自定义设置                  |
|      -g cap      |                 显示机器支持哪些电力管理功能                 |
|     -g sched     |               显示计划启动,唤醒或关闭,睡眠事件               |
|   -g ps / batt   |                    显示电池和 UPS 的状态                     |
|     -g pslog     |             显示电源(电池或者 UPS)状态的连续日志             |
|    -g rawlog     |             显示直接读取电池的电池状态的连续日志             |
|     -g therm     |         显示影响 CPU 速度的热力条件不适用于全部平台          |
|   -g thermlog    |      显示影响 CPU 速度的热量的通知日志不适用于全部平台       |
|  -g assertions   | 显示电量断言的概要断言可以阻止系统睡眠或显示器睡眠适用于 10.6 及更新版本 |
| -g assertionslog |      显示电量断言的创建及释出日志适用于 10.6 及更新版本      |
|    -g sysload    |         显示"系统负载顾问”----适用于 10.6 及更新版本         |
|  -g ac/adapter   | 显示关于交流电源适配器的详情只有 MacBoook 和 MacBook Pro 支持 |
|      -g log      | 显示睡眠,唤醒及其他电源管理时间的历史这个日志只提供给管理员和调试目的 |
|     -g uuid      |                显示当前活跃的睡眠,唤醒的 UUID                |
|    -g uuidlog    | 显示当前活跃的睡眠,唤醒的 UUID,并且打印一个新的被系统设置的 UUID |
|    -g history    | 一个调试工具当使用启动参数 io=0x3000000 被启用时,打印系统睡眠唤醒的 UUID 的时间线 |
|  -g powerstate   | 打印当前为 IO Kit 驱动电源状态调用者应该至少提供一个 IO Kit 类名来作为参数如果没有类名被听过,它将打印全部驱动的电源状态 |
| -g powerstatelog |                                                              |
|     -g stats     |            打印自系统启动以来睡眠和唤醒系统的计数            |
|  -g systemstate  |               打印当前系统的电量状态和可用能力               |
|  -g everything   | 打印每个参数这是一个有用的快速收集所有 pmset 提供的输出适用于 10.8 |

### 安全睡眠参数

- hibernatemode 有一个位字段参数来定义安全睡眠能力通过 0 来禁用安全睡眠,强制计算进入普通睡眠
- 我们不推荐修改休眠设置你做的任何改变都不被支持如果你一定要这么做,我们推荐使用以下三种设置其中之一为了保证你的利益,请不要使用除了了 0,3,25 以外的设置

|        命令        |                             说明                             |
| :----------------: | :----------------------------------------------------------: |
| hibernatemode = 0  | 台式机默认支持系统将不会备份内存到持久化存储系统必须从内存内容中唤醒,当断电时系统将会失去上下文这是传统的普通睡眠方式 |
| hibernatemode = 3  | 便携式计算机默认支持系统将存储一份内存的备份到持久化存储(磁盘)中,并且在睡眠过程中持续给内存供电系统将从内存中被唤醒,除非断电才强制从磁盘镜像会恢复 |
| hibernatemode = 25 | 只能通过 pmset 才可以设置系统将存储一份内存的备份到持久化存储(磁盘)中,并且将会给内存断电系统将从磁盘镜像中恢复如果你希望"休眠”----慢一点但是有益电池寿命,你应该使用这个设置 |

### 待机参数

- standby使得机器在睡眠了一段指定的时间间隔后,核心电源管理会自动休眠机器通过睡眠来节电这个设置默认在被支持的硬件环境下是默认开启的如果这个功能被机器支持,standby 设置在 pmset -g 命令中是可见的
- standby 只有 hibernate 被设置为 3 或者 25 时才工作

- standbydelay 指定一个以秒为单位的延迟,在写入休眠镜像到磁盘并且内存断电之前

### 调度事件参数

- pmset 允许你调度系统睡眠,关机,唤醒以及电源开启"schedule”是设置一次电源事件的,"repeats”用来设置每日或者每周的电源开启及关闭事件注意,你只能定义一对重复事件的调度----"power on” 事件或者"power off”事件对于睡眠周期的应用,pmset 可以调度一个

### 电源参数

- -g 后面跟随一个 batt 或者 ps 参数将显示全部电源的状态
- -g 后面跟随 pslog 或者 rawlog 参数通常被用来调试,比如隔离一个老旧电池的问题

### 其他参数

- boot 告诉内核系统启动完成对于 Darwin 用户来说可能很有用
- force 告诉 PM 立刻激活这些设置不要写入到磁盘,并且设置可以简单地被重写在 PM 配置插件没有运行的情况下很有用
- touch PM 从磁盘中重新读取已存在的设置

### 用例

- 这个命令设置了在使用电池电量的情景下,显示器睡眠倒计时为 5 分钟,保留电池上的其他设定并且其他电源不受影响:

```
pmset -b displaysleep 5
```

- 设置显示器睡眠倒计时为 10 分钟,磁盘睡眠倒计时为 10 分钟,系统睡眠倒计时为 30 分钟,并且为全部电源情景(交流电,电池和 UPS)启动 WakeOnMagicPacket:

```
pmset -a displaysleep 10 disksleep 10 sleep 30 womp 1
```

- 对于一个附带并支持 UPS 的系统来说,这指示系统在 UPS 电池电量低于 40% 的时候要紧急关闭

```
pmset -u haltlevel 40
```

- 对于一个附带并支持 UPS 的系统来说,下面这条指令指示了系统在 UPS 电池电量低于 25% 或者 UPS 预估可用时间少于 30 分钟时要紧急关闭这两个条件满足一个就会执行系统关闭:

```
pmset -u haltlevel 25 haltremain 30
```

- 对于一个附带并支持 UPS 的系统来说,这个指令指示当系统使用 UPS 电池时在两分钟后关闭系统:

```
pmset -u haltafter 2
```

- 系统计划于 2016 年 7 月 4 日 20:00 的时候自动从睡眠中唤醒:

```
pmset schedule wake "07/04/16 20:00:00"
```

- 系统计划在每周的周二到周六上午 11 点钟关闭:

```
pmset repeat shutdown TWRFS 11:00:00
```

- 计划在每周二的中午 12 点唤醒或供电,并且在每天晚上 8 点钟睡眠:

```
pmset repeat wakeorpoweron T 12:00 sleep MTWRFSU 20:00:00
```

- 打印系统在使用的电量管理设定:

```
pmset -g
```

- 打印此刻的电池或电源的状态快照:

```
pmset -g batt
```

- 如果你的系统在使用电池供电的使用还有 20-50% 剩余电量时突然睡眠,请在终端窗口中运行下面这个命令当你看到问题和,你将能够检测到老化电池的突然不连续电量(比如突然从 30% 降到 0%):

```
pmset -g pslog
```

**参考文章**:[pmset wiki 页面](https://en.wikipedia.org/wiki/Pmset)

## Setting

```shell
Battery Power:
 autopoweroff         0
 standbydelayhigh     86400
 autopoweroffdelay    28800
 proximitywake        0
 standby              0
 standbydelaylow      10800
 ttyskeepawake        0
 hibernatemode        0
 powernap             0
 gpuswitch            2
 hibernatefile        /var/vm/sleepimage
 highstandbythreshold 50
 displaysleep         60
 sleep                0
 tcpkeepalive         0
 halfdim              1
 lessbright           0
 disksleep            0
AC Power:
 autopoweroff         0
 standbydelayhigh     86400
 autopoweroffdelay    28800
 proximitywake        0
 standby              0
 standbydelaylow      10800
 ttyskeepawake        0
 hibernatemode        0
 powernap             0
 gpuswitch            2
 hibernatefile        /var/vm/sleepimage
 highstandbythreshold 50
 displaysleep         60
 sleep                0
 tcpkeepalive         0
 halfdim              1
 disksleep            0
```

