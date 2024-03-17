---
title: Sublime
categories:
- Software
- Tools
- IDE
---
# Sublime

## 配置命令行启动

```bash
sudo ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl
```

- 然后就可以直接命令行启动Sublime

```bash
$ subl .bash_profile
$ subl .../error.log
```

## 关闭自动更新

1.  Preferences -> Settings-User
2. 键入禁止检查更新命令后（如下），保存：

```json
{ "update_check":false }
```

3. 重启Submine Text

