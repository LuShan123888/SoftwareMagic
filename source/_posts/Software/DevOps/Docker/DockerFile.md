---
title: Docker DockerFile
categories:
- Software
- DevOps
- Docker
---
# Docker DockerFile

- Dockerfile 是一个用来构建镜像的文本文件，文本内容包含了一条条构建镜像所需的指令和说明。

##  Dockerfile文件指令

### FROM

- 定制的镜像都是基于 FROM 的镜像，这里的 nginx 就是定制需要的基础镜像，后续的操作都是基于 nginx

```dockerfile
FROM nginx
RUN echo '这是一个本地构建的nginx镜像' > /usr/share/nginx/html/index.html
```

### COPY

- 复制指令，从上下文目录中复制文件或者目录到容器里指定路径。

```dockerfile
COPY [--chown=<user>:<group>] <源路径1>...  <目标路径>
COPY [--chown=<user>:<group>] ["<源路径1>",...  "<目标路径>"]
```

- **[--chown=<user>:<group>]**：可选参数，用户改变复制到容器内文件的拥有者和属组。
- **<源路径>**：源文件或者源目录，这里可以是通配符表达式，其通配符规则要满足 Go 的 filepath.Match 规则。

```dockerfile
COPY hom* /mydir/
COPY hom?.txt /mydir/
```

- **<目标路径>**：容器内的指定路径，该路径不用事先建好，路径不存在的话，会自动创建。
- 可以使用 COPY 命令把前一阶段构建的产物拷贝到另一个镜像中。

```dockerfile
COPY --from=0 /source/dubbo-admin-$version/docker/entrypoint.sh /usr/local/bin/entrypoint.sh
```

### ADD

- ADD 指令和 COPY 的使用格式一致（同样需求下，官方推荐使用 COPY)，功能也类似，不同之处如下：
- ADD 的优点：在执行 <源文件> 为 tar 压缩文件的话，压缩格式为 gzip, bzip2 以及 xz 的情况下，会自动复制并解压到 <目标路径>
- ADD 的缺点：在不解压的前提下，无法复制 tar 压缩文件，会令镜像构建缓存失效，从而可能会令镜像构建变得比较缓慢，具体是否使用，可以根据是否需要自动解压来决定。

### RUN

- RUN 执行命令并创建新的镜像层，RUN 只影响如何构建镜像，所以镜像中不保留 RUN 命令。

```shell
# shell 格式：
RUN <shell 命令>
# exec 格式：
RUN ["<可执行文件或命令>","<param1>","<param2>",...]
```

- **注意**:Dockerfile 的指令每执行一次都会在 docker 上新建一层，所以过多无意义的层，会造成镜像膨胀过大，例如：

```dockerfile
FROM centos
RUN yum install wget
RUN wget -O redis.tar.gz "http://download.redis.io/releases/redis-5.0.3.tar.gz"
RUN tar -xvf redis.tar.gz
```

- 以上执行会创建 3 层镜像，可简化为以下格式：

```dockerfile
FROM centos
RUN yum install wget \
  && wget -O redis.tar.gz "http://download.redis.io/releases/redis-5.0.3.tar.gz" \
  && tar -xvf redis.tar.gz
```

- 如上，以 **&&** 符号连接命令，这样执行后，只会创建 1 层镜像。

### ENTRYPOINT

- ENTRYPOINT 配置容器启动时运行的命令。
- 如果运行容器时使用了`--entrypoint`选项，此选项的参数可当作要运行的程序覆盖 ENTRYPOINT 指令指定的程序。
- **注意**：如果 Dockerfile 中如果存在多个 ENTRYPOINT 指令，仅最后一个生效。

```dockerfile
# shell 格式：
ENTRYPOINT <shell 命令>
# exec 格式：
ENTRYPOINT ["<可执行文件或命令>","<param1>","<param2>",...]
```

#### 附加参数

- exec格式的 ENTRYPOINT 能接收 CMD 或 `dock run <image>` 后的参数作为附加参数，相当于是往这个数组中附加元素。

**实例**

- 假设已通过 Dockerfile 构建了 nginx:test 镜像：

```dockerfile
FROM nginx
ENTRYPOINT ["nginx", "-c"] # 定参。
CMD ["/etc/nginx/nginx.conf"] # 变参。
```

1. ENTRYPOINT 接收 CMD 的参数。

```dockerfile
$ docker run nginx:test
$ nginx -c /etc/nginx/nginx.conf
```

2. ENTRYPOINT 接收  `dock run <image>` 后的参数。

```dockerfile
$ docker run  nginx:test /etc/nginx/new.conf
$ nginx -c /etc/nginx/new.conf
```

-  CMD 在运行容器时被 `docker run <image>` 后的命令覆盖。

#### 环境变量替换

- exec格式无法通过环境变量进行替换，原因是变量替换操作实际是由 "/bin/sh" 能完成的，shell 格式总是由 "/bin/sh -c" 启动的，如果 exec 格式的 ENTRYPOINT 也希望能解析变量，就得依样写成。

```
ENTRYPOINT ["/bin/sh", "-c", "<param1>","<param2>",...]
```

##### 增强型 shell 格式

- 这里补充一种 ENTRYPOINT 的声明格式，它实质是 shell 格式，为而把它单独列出来关键就在于 shell 的 `exec` 命令，此 `exec` 非前面 exec 格式中的 exec，而是一个结结实实的 shell 命令。

```shell
ENTRYPOINT exec command param1 param2 ...
```

- 它仍然是 shell 格式，所以 inspect 镜像后看到的 ENTRYPOINT 是。

```shell
ENTRYPOINT ["/bin/sh", "-c" "exec java $JAVA_OPTS -jar /app.jar"]
```

- 然而加了 `exec` 的绝妙之处在于shell 的内建命令 exec 将并不启动新的shell，而是用要被执行命令替换当前的 shell 进程，并且将老进程的环境清理掉，exec 后的命令不再是 shell 的子进程序，而且 exec 命令后的其它命令将不再执行，从执行效果上可以看到 exec 会把当前的 shell 关闭掉，直接启动它后面的命令。
- 虽然它与之后的命令（如上 `exec java $JAVA_OPTS -jar /app.jar`)还是作为 "/bin/sh" 的第二个参数，但 `exec` 来了个金蝉脱壳，让这里的 `java` 进程得已作为一个 PID 1 的超级进程，进行使得这个 java 进程可以收到 SIGTERM 信号，或者理解 `exec` 为 "/bin/sh" 的子进程，但是借助于 `exec` 让它后面的进程启动在最顶端。
- 另外，由于通过 "/bin/sh" 的搭桥，命令中的变量（如 $JAVA_OPTS) 也会被正确解析，因此 `ENTRYPOINT exec command param1 param2 ...` 是被推荐的格式。
- **注意**:exec 只会启动后面的第一个命令，`exec ls; top` 或 `exec ls && top` 只会执行 `ls` 命令。



### CMD

- CMD 设置容器启动后默认执行的命令及其参数，但 CMD 能够在启动容器时被覆盖。
- **注意**：如果 Dockerfile 中如果存在多个 CMD 指令，仅最后一个生效。

```dockerfile
CMD <shell 命令>
CMD ["<可执行文件或命令>","<param1>","<param2>",...]
CMD ["<param1>","<param2>",...]  # 该写法是为 ENTRYPOINT 指令指定的程序提供默认参数。
```

### ENV

- 设置环境变量，定义了环境变量，那么在后续的指令中，就可以使用这个环境变量。

```dockerfile
ENV <key> <value>
ENV <key1>=<value1> <key2>=<value2>...
```

- 以下示例设置 `NODE_VERSION = 7.2.0` ，在后续的指令中可以通过 `$NODE_VERSION` 引用：

```dockerfile
ENV NODE_VERSION 7.2.0

RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" \
  && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc"
```

### ARG

- 构建参数，与 ENV 作用相同，不过作用域不一样，ARG 设置的环境变量仅对 Dockerfile 内有效，也就是说只有 docker build 的过程中有效，构建好的镜像内不存在此环境变量。
- 构建命令 docker build 中可以用 `--build-arg <参数名>=<值>` 来覆盖。

```dockerfile
ARG <参数名>[=<默认值>]
```

### VOLUME

- 定义匿名数据卷，在启动容器时忘记挂载数据卷，会自动挂载到匿名卷。
- **作用**:
    - 避免重要的数据，因容器重启而丢失，这是非常致命的。
    - 避免容器不断变大。

```dockerfile
VOLUME ["<路径1>", "<路径2>"...]
VOLUME <路径>
```

- 在启动容器 docker run 的时候，我们可以通过 -v 参数修改挂载点。

### EXPOSE

- 仅仅只是声明端口。
- **作用**:
    - 帮助镜像使用者理解这个镜像服务的守护端口，以方便配置映射。
    - 在运行时使用随机端口映射时，也就是 docker run -P 时，会自动随机映射 EXPOSE 的端口。

```dockerfile
EXPOSE <端口1> [<端口2>...]
```

### WORKDIR

- 指定工作目录，用 WORKDIR 指定的工作目录，会在构建镜像的每一层中都存在，(WORKDIR 指定的工作目录，必须是提前创建好的)
- docker build 构建镜像过程中的，每一个 RUN 命令都是新建的一层，只有通过 WORKDIR 创建的目录才会一直存在。

```dockerfile
WORKDIR <工作目录路径>
```

### USER

- 用于指定执行后续命令的用户和用户组，这边只是切换后续命令执行的用户（用户和用户组必须提前已经存在)

```dockerfile
USER <用户名>[:<用户组>]
```

### HEALTHCHECK

- 用于指定某个程序或者指令来监控 docker 容器服务的运行状态。

```dockerfile
HEALTHCHECK [选项] CMD <命令>：设置检查容器健康状况的命令。
HEALTHCHECK NONE：如果基础镜像有健康检查指令，使用这行可以屏蔽掉其健康检查指令。

HEALTHCHECK [选项] CMD <命令> ：这边 CMD 后面跟随的命令使用，可以参考 CMD 的用法。
```

### ONBUILD

- 用于延迟构建命令的执行，简单的说，就是 Dockerfile 里用 ONBUILD 指定的命令，在本次构建镜像的过程中不会执行（假设镜像为 test-build)，当有新的 Dockerfile 使用了之前构建的镜像 FROM test-build ，这是执行新镜像的 Dockerfile 构建时候，会执行 test-build 的 Dockerfile 里的 ONBUILD 指定的命令。

```dockerfile
ONBUILD <其它指令>
```

## build

- 通过Dockerfile构建镜像。

```shell
$ docker build [OPTIONS] PATH | URL | -
```

- **--build-arg=[]**：设置镜像创建时的变量;
- **--cpu-shares**：设置 cpu 使用权重;
- **--cpu-period**：限制 CPU CFS周期;
- **--cpu-quota**：限制 CPU CFS配额;
- **--cpuset-cpus**：指定使用的CPU id;
- **--cpuset-mems**：指定使用的内存 id;
- **--disable-content-trust**：忽略校验，默认开启;
- **-f**：指定要使用的Dockerfile路径;
- **--force-rm**：设置镜像过程中删除中间容器;
- **--isolation**：使用容器隔离技术;
- **--label=[]**：设置镜像使用的元数据;
- **-m**：设置内存最大值;
- **--memory-swap**：设置Swap的最大值为内存+swap,"-1"表示不限swap;
- **--no-cache**：创建镜像的过程不使用缓存;
- **--pull**：尝试去更新镜像的新版本;
- **--quiet, -q**：安静模式，成功后只输出镜像 ID;
- **--rm**：设置镜像成功后删除中间容器;
- **--shm-size**：设置/dev/shm的大小，默认值是64M;
- **--ulimit**:Ulimit配置。
- **--tag, -t**：镜像的名字及标签，通常 name:tag 或者 name 格式;可以在一次构建中为一个镜像设置多个标签。
- **--network**：默认 default，在构建期间设置RUN指令的网络模式。

**实例**

- 使用当前目录的 Dockerfile 创建镜像，标签为 `test/ubuntu:v1`

```shell
$ docker build -t test/ubuntu:v1 .
```

- 注：最后的 `.` 代表本次执行的上下文路径。
- 使用URL **github.com/creack/docker-firefox** 的`Dockerfile`创建镜像。

```shell
$ docker build github.com/creack/docker-firefox
```

- 也可以通过 `-f Dockerfile 文件的位置`

```shell
$ docker build -f /path/to/a/Dockerfile
```

- 在 Docker 守护进程执行 Dockerfile 中的指令前，首先会对`Dockerfile`进行语法检查，有语法错误时会返回：

```shell
$ docker build -t test/myapp
Sending build context to Docker daemon 2.048 kB
Error response from daemon: Unknown instruction: RUNCMD
```

### 上下文路径

- 下面指令最后一个 `.` 是上下文路径。

```shell
$ docker build -t nginx:test .
```

- **上下文路径**:Docker 客户端会将构建命令后面指定的路径(`.`)下的所有文件打包成一个 tar 包，发送给 Docker 服务端，Docker 服务端收到客户端发送的 tar 包，然后解压，根据 Dockerfile 里面的指令进行镜像的分层构建，这个指定的路径就成为上下文路径。
- **解析**：由于 docker 的运行模式是 C/S，我们本机是 C,docker 引擎是 S，实际的构建过程是在docker引擎下完成的，所以这个时候无法用到我们本机的文件，这就需要把我们本机的指定目录下的文件一起打包提供给docker引擎使用。
- 如果构建镜像时没有明确指定 Dockerfile，那么 Docker 客户端默认在构建镜像时指定的上下文路径下找名字为 Dockerfile 的构建文件。
- **注意**：上下文路径下不要放无用的文件，因为会一起打包发送给 docker 引擎，如果文件过多会造成过程缓慢。

## history

- 查看指定镜像的创建历史。

```
$ docker history [OPTIONS] IMAGE
```

- **-H**：以可读的格式打印镜像大小和日期，默认为true;
- **--no-trunc**：显示完整的提交记录;
- **-q**：仅列出提交记录ID

**实例**

- 查看本地镜像test/ubuntu:v3的创建历史。

```shell
$ docker history test/ubuntu:v3
IMAGE             CREATED           CREATED BY                                      SIZE      COMMENT
4e3b13c8a266      3 months ago      /bin/sh -c #(nop) CMD ["/bin/bash"]             0 B
<missing>         3 months ago      /bin/sh -c sed -i 's/^#\s*\(deb.*universe\)$/   1.863 kB
<missing>         3 months ago      /bin/sh -c set -xe   && echo '#!/bin/sh' > /u   701 B
<missing>         3 months ago      /bin/sh -c #(nop) ADD file:43cb048516c6b80f22   136.3 MB
```

## Dockerfile实例

### Spring Boot 项目

```dockerfile
FROM openjdk:8
MAINTAINER Cian LuShan123888@Gmail.com
WORKDIR /
COPY *.jar app.jar
ENV JAVA_OPTS ""
ENTRYPOINT exec java $JAVA_OPTS -jar /app.jar"
```

### SSM 项目

```dockerfile
FROM tomcat:8.0.41-jre8
MAINTAINER Cian LuShan123888@Gmail.com
WORKDIR /usr/local/tomcat/webapps
COPY *.war app.war
ENTRYPOINT ["catalina.sh", "run"]
```

