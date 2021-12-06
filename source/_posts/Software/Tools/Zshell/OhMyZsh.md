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
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
```

2. 备份已有的zshrc, 替换zshrc

```shell
cp ~/.zshrc ~/.zshrc.orig
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
```

3. 使用脚本安装

```shell
cd .oh-my-zsh/tools
./install.sh
```

### 命令安装

#### curl

```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

#### wget

```shell
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
```

其本质就是下载并执行了github上的install.sh脚本, 该脚本位于`oh-my-zsh/tools/install.sh`

- 卸载oh my zsh

```
uninstall_oh_my_zsh
```

## oh my zsh 目录结构

- 进入`~/.oh-my-zsh`目录后,看看该目录的结构
    - lib 提供了核心功能的脚本库
    - tools 提供安装,升级等功能的快捷工具
    - plugins 自带插件的存在放位置
    - templates 自带模板的存在放位置
    - themes  自带主题文件的存在放位置
    - custom 个性化配置目录,自安装的插件和主题可放这里

## 配置

- `zsh` 的配置主要集中在`~/.zshrc`里,用 `vim` 或你喜欢的其他编辑器打开`.zshrc`
- 可以在此处定义自己的环境变量和别名,当然,`oh my zsh` 在安装时已经自动读取当前的环境变量并进行了设置,你可以继续追加其他环境变量

## 别名设置

- `zsh`不仅可以设置通用别名,还能针对文件类型设置对应的打开程序,比如
    - `alias -s html=vi`,意思就是你在命令行输入 `hello.html`,`zsh`会为你自动打开`vim`并读取`hello.html`
    - `alias -s gz='tar -xzvf'`,表示自动解压后缀为`gz`的压缩包

```bash
alias cls='clear'
alias ll='ls -l'
alias la='ls -a'
alias vi='vim'
alias javac="javac -J-Dfile.encoding=utf8"
alias grep="grep --color=auto"
alias -s html=vi   # 在命令行直接输入后缀为 html 的文件名,会在 vim 中打开
alias -s rb=vi     # 在命令行直接输入 ruby 文件,会在 vim 中打开
alias -s py=vi       # 在命令行直接输入 python 文件,会用 vim 中打开,以下类似
alias -s js=vi
alias -s c=vi
alias -s java=vi
alias -s txt=vi
alias -s gz='tar -xzvf'
alias -s tgz='tar -xzvf'
alias -s zip='unzip'
alias -s bz2='tar -xjvf'
```

## 主题设置

- oh my zsh 提供了数十种主题,相关文件在`~/.oh-my-zsh/themes`目录下
- `ZSH_THEME="random"`主题设置为随机,这样我们每打开一个窗口,都会随机在默认主题中选择一个
- 安装powerlevel10k主题

```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
# 或
brew install powerlevel10k
```

- `~/.zshrc`

```bash
ZSH_THEME="powerlevel10k/powerlevel10k"
```

- 配置主题

```
$ p10k configure
```

- 安装字体

```
https://aur.archlinux.org/packages/ttf-meslo-nerd-font-powerlevel10k/
```

## 插件设置

- `oh my zsh`项目提供了完善的插件体系,相关的文件在`~/.oh-my-zsh/plugins`目录下,默认提供了100多种
- 想了解每个插件的功能,只要打开相关目录下的 `zsh` 文件
- 插件也是在`~/.zshrc`里配置,找到`plugins`关键字,就可以加载自己的插件了,系统默认加载`git`,你可以在后面追加内容,如下:

```undefined
plugins=(git
docker
docker-compose
mvn
node
npm
yarn
sudo
zsh-syntax-highlighting
zsh-autosuggestions
zsh-completions
autojump)
```

- 安装 `zsh-autosuggestions`

```bash
git clone git://github.com/zsh-users/zsh-autosuggestions  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

- 安装 `zsh-syntax-highlighting`

```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

- 安装`autojump`

```sh
https://github.com/wting/autojump
```

- 安装`zsh-completions`

```
git clone https://github.com/zsh-users/zsh-completions  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions
```
