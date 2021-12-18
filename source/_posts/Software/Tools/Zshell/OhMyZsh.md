---
title: Zshell Oh My Zsh
categories:
- Software
- Tools
- Zshell
---
# Zshell Oh My Zsh

## 安装

### 手动安装

1. 直接用git从github上面下载包

```shell
$ git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
```

2. 备份已有的`.zshrc`, 替换`.zshrc`

```shell
$ cp ~/.zshrc ~/.zshrc.orig
$ cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
```

3. 使用脚本安装

```shell
$ cd .oh-my-zsh/tools
$ sh ./install.sh
```

### 命令安装

#### curl

```shell
$ sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

#### wget

```shell
$ sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
```

- 其本质就是下载并执行了github上的install.sh脚本, 该脚本位于`~/.oh-my-zsh/tools/install.sh`

## 卸载

```shell
$ sh oh-my-zsh/tools/uninstall.sh
```

## oh my zsh 目录结构

- 进入`~/.oh-my-zsh`目录后,看看该目录的结构
    - **lib**:提供了核心功能的脚本库
    - **tools**:提供安装,升级等功能的快捷工具
    - **plugins**:自带插件的存在放位置
    - **templates**:自带模板的存在放位置
    - **themes**:自带主题文件的存在放位置
    - **custom**:个性化配置目录,自安装的插件和主题可放这里
