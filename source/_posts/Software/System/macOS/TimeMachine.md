---
title: macOS 时间机器
categories:
- Software
- System
- macOS
---
# macOS 时间机器

## 删除本地缓存

- 打开"终端”输入如下代码。

```shell
$ sudo tmutil listlocalsnapshots /

Snapshots for disk /:
com.apple.TimeMachine.2021-12-09-175319.local
com.apple.TimeMachine.2021-12-09-194330.local
com.apple.TimeMachine.2021-12-09-204342.local
com.apple.TimeMachine.2021-12-09-214401.local
com.apple.TimeMachine.2021-12-09-224402.local
com.apple.TimeMachine.2021-12-09-235534.local
com.apple.TimeMachine.2021-12-10-005955.local
com.apple.TimeMachine.2021-12-10-015548.local
com.apple.TimeMachine.2021-12-10-025603.local
com.apple.TimeMachine.2021-12-10-035607.local
com.apple.TimeMachine.2021-12-10-051109.local
com.apple.TimeMachine.2021-12-10-071111.local
com.apple.TimeMachine.2021-12-10-081123.local
com.apple.TimeMachine.2021-12-10-091708.local
com.apple.TimeMachine.2021-12-10-103043.local
com.apple.TimeMachine.2021-12-10-121725.local
com.apple.TimeMachine.2021-12-10-131731.local
com.apple.TimeMachine.2021-12-10-141731.local
```

- 接下来只需逐个删除就行，终端输入。

```shell
$ tmutil deletelocalsnapshots 2017-12-18-093234(上面文件末尾显示的日期）
```

## 加速命令

```
$ sudo sysctl debug.lowpri_throttle_enabled=0
```

- 恢复。

```shell
$ sudo sysctl debug.lowpri_throttle_enabled=1
```
