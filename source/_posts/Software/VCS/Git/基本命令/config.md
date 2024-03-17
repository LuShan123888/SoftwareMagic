---
title: Git config
categories:
- Software
- VCS
- Git
- 基本命令
---
# Git config

- Git的配置文件为`~/.gitconfig`,它可以在用户主目录下（全局配置),也可以在项目目录下（项目配置)

 ```bash
$ git config
 ```

- `--list`:显示当前的Git配置
- `--global`:编辑全局配置

**设置用户名和邮箱**

```shell
git config --global user.name "用户名"
git config --global user.email "邮箱"
```

**查看当前的用户名和邮箱**

```shell
git config --global user.name
git config --global user.email
```

**保存用户名和密码**

```shell
git config crendential.helper store
```

- cache模式：会将凭证存放在内存中一段时间, 密码永远不会被存储在磁盘中，并且在15分钟后从内存中清除
- store模式：会将凭证用明文的形式存放在磁盘中，并且永不过期, 这意味着除非你修改了你在 Git 服务器上的密码，否则你永远不需要再次输入你的凭证信息, 这种方式的缺点是你的密码是用明文的方式存放在你的 home 目录下
- 如果你使用的是 Mac,Git 还有一种 "osxkeychain” 模式，它会将凭证缓存到你系统用户的钥匙串中, 这种方式将凭证存放在磁盘中，并且永不过期，但是是被加密的，这种加密方式与存放 HTTPS 凭证以及 Safari 的自动填写是相同的
- store 模式可以接受一个 `--file <path>` 参数，可以自定义存放密码的文件路径（默认是 `~/.git-credentials` ), "cache” 模式有 `--timeout <seconds>` 参数，可以设置后台进程的存活时间（默认是 "900”,也就是 15 分钟), 下面是一个配置 "store” 模式自定义路径的例子:

```shell
git config --global credential.helper 'store --file ~/.my-credentials'
```

## 代理

### HTTP 代理

**走 HTTP 代理**

```
git config --global http.proxy "http://127.0.0.1:8080"
git config --global https.proxy "http://127.0.0.1:8080"
```

**走 socks5 代理（如 Shadowsocks)**

```
git config --global http.proxy "socks5://127.0.0.1:7890"
git config --global https.proxy "socks5://127.0.0.1:7890"
```

**取消代理**

```
git config --global --unset http.proxy
git config --global --unset https.proxy
```

### SSH 代理

- 修改 `~/.ssh/config` 文件

```
# 必须是 github.com
Host github.com
   HostName github.com
   User git
   # 走 HTTP 代理
   # ProxyCommand socat - PROXY:127.0.0.1:%h:%p,proxyport=8080
   # 走 socks5 代理（如 Shadowsocks)
   # ProxyCommand nc -v -x 127.0.0.1:7890 %h %p
```

