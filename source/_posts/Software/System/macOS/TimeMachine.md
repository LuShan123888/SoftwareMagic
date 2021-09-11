---
title: macOS 时间机器
categories:
- Software
- System
- macOS
---
# macOS 时间机器

## 删除本地缓存

打开"终端”输入如下代码

```
sudo tmutil listlocalsnapshots /
```


键入密码(不会显示,直接输完回车即可)出现以下画面

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-5fTU9iE73qzWZmx.png)

接下来只需逐个删除就行,终端输入

```
tmutil deletelocalsnapshots 2017-12-18-093234(上面文件末尾显示的日期)
```


即可删除相关备份

## 加速命令

```
sudo sysctl debug.lowpri_throttle_enabled=0
```

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-02-17-2020-12-10-ebsxJ7nzgQjalKL-20200820130753630.jpg)

- 恢复

```
sudo sysctl debug.lowpri_throttle_enabled=1
```

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-02-17-2020-12-10-RGYU9oXjCDvpu4b-20200820130755381.jpg)