---
title: Supervisor
categories:
- Software
- Tools
---
# Supervisor

## 介绍

Supervisor是用Python开发的一套通用的进程管理程序,能将一个普通的命令行进程变为后台daemon,并监控进程状态,异常退出时能自动重启,它是通过fork/exec的方式把这些被管理的进程当作supervisor的子进程来启动,这样只要在supervisor的配置文件中,把要管理的进程的可执行文件的路径写进去即可,也实现当子进程挂掉的时候,父进程可以准确获取子进程挂掉的信息的,可以选择是否自己启动和报警

## 安装

```text
yum install supervisor -y
```

## supervisor 配置说明

- 配置文件的目录
    - `/etc/supervisord.conf` (主配置文件)
    - `/etc/supervisor.d/` (默认子进程配置文件,也就是需要我们根据程序配置的地方)

### supervisord.conf基本配置项说明

- **提示** `;`符号是表示该行配置被注释

```text
[unix_http_server]
file=/home/supervisor/supervisor.sock   ; supervisorctl使用的 socket文件的路径
;chmod=0700                 ; 默认的socket文件权限0700
;chown=nobody:nogroup       ; socket文件的拥有者

[inet_http_server]         ; 提供web管理后台管理相关配置
port=0.0.0.0:9001          ; web管理后台运行的ip地址及端口,绑定外网需考虑安全性
;username=root             ; web管理后台登录用户名密码
;password=root

[supervisord]
logfile=/var/log/supervisord.log ; 日志文件,默认在$CWD/supervisord.log
logfile_maxbytes=50MB        ; 日志限制大小,超过会生成新文件,0表示不限制
logfile_backups=10           ; 日志备份数量默认10,0表示不备份
loglevel=info                ; 日志级别
pidfile=/home/supervisor/supervisord.pid ; supervisord pidfile; default supervisord.pid              ; pid文件
nodaemon=false               ; 是否在前台启动,默认后台启动false
minfds=1024                  ; 可以打开文件描述符最小值
minprocs=200                 ; 可以打开的进程最小值

[supervisorctl]
serverurl=unix:///home/supervisor/supervisor.sock ; 通过socket连接supervisord,路径与unix_http_server->file配置的一致

[include]
files = supervisor.d/*.conf ;指定了在当前目录supervisor.d文件夹下配置多个配置文件
```

### 定义supervisor管理进程配置文件

- 从上面的配置文件`[include]->files`配置项可以知道,supervisor会把`supervisor.d/`下以conf结尾的配置文件都加载进来,那么我们在这个目录下面新建一个自定义配置文件`test.conf`:

```text
[program:test] ;[program:xxx] 这里的xxx是指的项目名字
directory = /opt/project  ;程序所在目录
command =  java -jar springboot-hello-sample.jar ;程序启动命令
autostart=true ;是否跟随supervisord的启动而启动
autorestart=true;程序退出后自动重启,可选值:[unexpected,true,false],默认为unexpected,表示进程意外杀死后才重启
stopasgroup=true;进程被杀死时,是否向这个进程组发送stop信号,包括子进程
killasgroup=true;向进程组发送kill信号,包括子进程
stdout_logfile=/var/log/sboot/supervisor.log;该程序日志输出文件,目录需要手动创建
stdout_logfile_maxbytes = 50MB;日志大小
stdout_logfile_backups  = 100;备份数
```

- 重启supervisord,使配置文件生效

```text
service supervisord restart
```

### 管理服务

#### 命令行

- 显示当前已配置好的项目信息

```
supervisorctl
test                            RUNNING   pid 27517, uptime 0:18:04
supervisor>
```

- 查看项目的状态

```
supervisor> status
```

- 控制项目的启停

```
supervisor> start/stop/restart 项目名
```

- 管理全部进程

```
supervisorctl start/stop/restart all
```

- 重新加载配置

```
supervisor> reload
```

#### 浏览器

浏览器输入主配置文件中的地址与端口号

![img](https://cdn.jsdelivr.net/gh/LuShan123888/Files@master/Pictures/2020-12-10-2020-12-10-2020-11-27-v2-3032f202ef1566428701231235529c76_1440w.jpg)