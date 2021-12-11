---
title: macOS SIP
categories:
- Software
- System
- macOS
---
# macOS SIP

## 查看SIP状态

```bash
csrutil status
```

- 未关闭 `enabled`:

```
System Integrity Protection status: enabled.
```

- 已关闭 `disabled`:

```
System Integrity Protection status: disabled
```

## 关闭SIP

1. 关机,然后重新启动你的Mac电脑,在开机时一直按住Command+R迸入Recovery模式
2. 进入Recovery模式后打开终端,如图:

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-02-13-recovery-utilities-terminal.jpg" style="zoom:50%;" />

3. 在终端上输入命令

```shell
$ csrutil disable
Successfully disabled System Integrity Protection . Please restart the machine for the changes to take effect .
```

4. 点击左上角苹果图标,再点击重新启动