---
title: macOS Finder
categories:
  - Software
  - OperatingSystem
  - macOS
---
# macOS Finder

## 显示全路径

- 打开"终端”，输入以下两条命令：

```shell
defaults write com.apple.finder _FXShowPosixPathInTitle -bool TRUE;killall Finder
```

**恢复**

- 打开"终端”，输入以下两条命令：

```shell
defaults delete com.apple.finder _FXShowPosixPathInTitle
killall Finder
```

## Mac 隐藏文件

### 新建一个隐藏文件夹

- 在终端中输入。

```shell
 mkdir .folderName
```

- 比如说你想在文稿目录下新建一个隐藏文件夹，只需要打开终端，输入` mkdir Documents/.abc` 即可在文稿目录下创建一个 .abc 的隐藏文件夹。

### 将一个文件或文件夹变为隐藏文件夹

- 在终端中输入。

```shell
mv file .file
// 或者。
mv folder .folder
```

- 这就是 Mac 下用在名称前加小数点的方式来隐藏文件，但在 Mac 下你无法直接在 Finder 中对一个文件直接加小数点，必须在终端中实现。

### 修改文件的隐藏属性

- 在终端中输入。

```shell
chflags hidden 文件路径。
```

- chflags 是一个更改文件隐藏属性的命令，意思就是 change flags
- 也就是修改文件的标志，hidden 就是隐藏，所以 chflags hidden 就是隐藏文件。

- 如果要取消隐藏文件，在终端中输入。

```shell
chflags nohidden 文件路径。
```



