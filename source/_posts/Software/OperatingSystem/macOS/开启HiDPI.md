---
title: macOS HiDPI
categories:
  - Software
  - OperatingSystem
  - macOS
---
# macOS HiDPI

## 安装

```shell
bash -c "$(curl -fsSL https://raw.githubusercontent.com/xzhih/one-key-hidpi/master/hidpi.sh)"
```

## 恢复

### 命令恢复

- 如果还能进系统，就再次运行命令选择选项 3 关闭 HIDPI

### 恢复模式

- 如果使用此脚本后，开机无法进入系统，请到 macos 恢复模式中或使用 clover `-x` 安全模式进入系统，打开终端。
- 这里有两种方式进行关闭，建议选第一种。

**快捷恢复**

```shell
$ ls /Volumes/
$ cd /Volumes/你的系统盘/System/Library/Displays/Contents/Resources/Overrides/HIDPI

$ ./disable
```

**手动恢复**

- 使用终端删除 `/System/Library/Displays/Contents/Resources/Overrides` 下删除显示器 VendorID 对应的文件夹，并把 `HIDPI/backup` 文件夹中的备份复制出来。
- 请使用单个显示器执行以下命令，笔记本关闭外接显示器的 HIDPI 时请关闭内置显示器。
- 具体命令如下：

```shell
$ ls /Volumes/
$ cd /Volumes/你的系统盘/System/Library/Displays/Contents/Resources/Overrides
$ EDID=($(ioreg -lw0 | grep -i "IODisplayEDID" | sed -e "/[^<]*</s///" -e "s/\>//"))
$ Vid=($(echo $EDID | cut -c18-20))
$ rm -rf ./DisplayVendorID-$Vid
$ cp -r ./HIDPI/backup/* ./
```

