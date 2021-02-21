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

![recovery-utilities-terminal](https://cdn.jsdelivr.net/gh/LuShan123888/Files@master/Pictures/2021-02-13-recovery-utilities-terminal.jpg)

3. 在终端上输入命令 csrutil disable然后回车

![csrutil-disable](https://cdn.jsdelivr.net/gh/LuShan123888/Files@master/Pictures/2021-02-13-csrutil-disable.jpg)

4. 点击左上角苹果图标,再点击重新启动