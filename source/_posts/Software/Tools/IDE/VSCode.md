---
title: VS Code
categories:
- Software
- Tools
- IDE
---
# VS Code

## 解决VScode在Mac上滚动掉帧的问题

1. 打开命令板。

```
Ctrl+Shift+P/ CMD+Shift+P / F1
```

2. 添加配置项。

```
Preferences: Configure Runtime Arguments
```

- 添加。

```
disable-hardware-acceleration": true
```

3. 重启。

    此时应用启动时默认关闭硬件加速，等同于`code --disable-gpu`

