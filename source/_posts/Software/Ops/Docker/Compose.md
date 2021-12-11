---
title: Docker Compose
categories:
- Software
- Ops
- Docker
---
# Docker Compose

- Compose 是用于定义和运行多容器 Docker 应用程序的工具,通过 Compose,您可以使用 YML 文件来配置应用程序需要的所有服务,然后,使用一个命令,就可以从 YML 文件配置中创建并启动所有服务
- Compose 使用的三个步骤:
  1. 使用`Dockerfile`定义应用程序的环境
  2. 使用`docker-compose.yml`定义构成应用程序的服务,这样它们可以在隔离环境中一起运行
  3. 执行`docker-compose up`命令来启动并运行整个应用程序

## 安装

- 运行以下命令以下载 Docker Compose 的当前稳定版本

```shell
$ sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```

- 将可执行权限应用于二进制文件

```shell
$ sudo chmod +x /usr/local/bin/docker-compose
```

- 创建软链

```shell
$ sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
```

- 测试是否安装成功

```shell
$ docker-compose --version
cker-compose version 1.24.1, build 4667896b
```

## 编写**docker-compose.yml**

### version

- 指定本 yml 依从的 compose 哪个版本制定的

### service

- 指定本应用程序下的所有服务容器

#### build

- 指定为构建镜像上下文路径:
- 例如 webapp 服务,指定为从上下文路径`./dir/Dockerfile`所构建的镜像

```yaml
version: "3.7"
services:
  webapp:
    build: ./dir
```

- 或者,作为具有在上下文指定的路径的对象,以及可选的 Dockerfile 和 args

```yaml
version: "3.7"
services:
  webapp:
    build:
      context: ./dir
      dockerfile: Dockerfile-alternate
      args:
        buildno: 1
      labels:
        - "com.example.description=Accounting webapp"
        - "com.example.department=Finance"
        - "com.example.label-with-empty-value"
      target: prod
```

- context:上下文路径
- dockerfile:指定构建镜像的 Dockerfile 文件名
- args:添加构建参数,这是只能在构建过程中访问的环境变量
- labels:设置构建镜像的标签
- target:多层构建,可以指定构建哪一层

#### cap_add,cap_drop

- 添加或删除容器拥有的宿主机的内核功能

```yaml
cap_add:
  - ALL # 开启全部权限

cap_drop:
  - SYS_PTRACE # 关闭 ptrace权限
```

#### cgroup_parent

- 为容器指定父 cgroup 组,意味着将继承该组的资源限制

```yaml
cgroup_parent: m-executor-abcd
```

#### command

- 覆盖容器启动的默认命令

```yaml
command: ["bundle", "exec", "thin", "-p", "3000"]
```

#### config

- Grant access to configs on a per-service basis using the per-service `configs` configuration.Two different syntax variants are supported.

**SHORT SYNTAX**

- **file**:通过文件创建configs
- **external**:已经创建的`docker config`

```yml
version: "3.9"
services:
  redis:
    image: redis:latest
    deploy:
      replicas: 1
    configs:
      - my_config
      - my_other_config
configs:
  my_config:
    file: ./my_config.txt
  my_other_config:
    external: true
```

**LONG SYNTAX**

- `source`: The name of the config as it exists in Docker.
- `target`: The path and name of the file to be mounted in the service’s task containers. Defaults to `/<source>` if not specified.
- `uid` and `gid`: The numeric UID or GID that owns the mounted config file within in the service’s task containers. Both default to `0` on Linux if not specified. Not supported on Windows.
- `mode`: The permissions for the file that is mounted within the service’s task containers, in octal notation. For instance, `0444`represents world-readable. The default is `0444`. Configs cannot be writable because they are mounted in a temporary filesystem, so if you set the writable bit, it is ignored. The executable bit can be set. If you aren’t familiar with UNIX file permission modes, you may find this [permissions calculator](http://permissions-calculator.org/) useful.

```yml
version: "3.9"
services:
  redis:
    image: redis:latest
    deploy:
      replicas: 1
    configs:
      - source: my_config
        target: /redis_config
        uid: '103'
        gid: '103'
        mode: 0440
configs:
  my_config:
    file: ./my_config.txt
  my_other_config:
    external: true
```

#### container_name

- 指定自定义容器名称,而不是生成的默认名称

```yaml
container_name: my-web-container
```

#### depends_on

- 设置依赖关系
- `docker-compose up`:以依赖性顺序启动服务,在以下示例中,先启动db和redis,才会启动 web
- `docker-compose up SERVICE`:自动包含 SERVICE 的依赖项,在以下示例中,docker-compose up web 还将创建并启动 db 和 redis
- `docker-compose stop`:按依赖关系顺序停止服务,在以下示例中,web 在 db 和 redis 之前停止

```yaml
version: "3.7"
services:
  web:
    build: .
    depends_on:
      - db
      - redis
  redis:
    image: redis
  db:
    image: postgres
```

- **注意**:web服务不会等待redis,db完全启动之后才启动

#### deploy

- 指定与服务的部署和运行有关的配置,只在 swarm 模式下才会有用

```yaml
version: "3.7"
services:
  redis:
    image: redis:alpine
    deploy:
      mode:replicated
      replicas: 6
      endpoint_mode: dnsrr
      labels:
        description: "This redis service label"
      resources:
        limits:
          cpus: '0.50'
          memory: 50M
        reservations:
          cpus: '0.25'
          memory: 20M
      restart_policy:
        condition: on-failure
        delay: 5s
        max_attempts: 3
        window: 120s
```

- **endpoint_mode**:访问集群服务的方式
    - **vip**:Docker 集群服务一个对外的虚拟 ip,所有的请求都会通过这个虚拟 ip 到达集群服务内部的机器
    - **dnsrr**:DNS 轮询(DNSRR),所有的请求会自动轮询获取到集群 ip 列表中的一个 ip 地址
- **labels**:在服务上设置标签,可以用容器上的 labels(跟 deploy 同级的配置)覆盖 deploy 下的 labels
- **mode**:指定服务提供的模式
    - **replicated**:复制服务,复制指定服务到集群的机器上
    - **global**:全局服务,服务将部署至集群的每个节点
- **replicas:mode** 为 replicated 时,需要使用此参数配置具体运行的节点数量
- **resources**:配置服务器资源使用的限制,例如上例子,配置 redis 集群运行需要的 cpu 的百分比 和 内存的占用,避免占用资源过高出现异常
- **restart_policy**:配置如何在退出容器时重新启动容器
    - condition:可选 none,on-failure 或者 any(默认值:any)
    - delay:设置多久之后重启(默认值:0)
    - max_attempts:尝试重新启动容器的次数,超出次数,则不再尝试(默认值:一直重试)
    - window:设置容器重启超时时间(默认值:0)
- **rollback_config**:配置在更新失败的情况下应如何回滚服务
    - parallelism:一次要回滚的容器数,如果设置为0,则所有容器将同时回滚
    - delay:每个容器组回滚之间等待的时间(默认为0s)
    - failure_action:如果回滚失败,该怎么办,其中一个 continue 或者 pause(默认pause)
    - monitor:每个容器更新后,持续观察是否失败了的时间 (ns|us|ms|s|m|h)(默认为0s)
    - max_failure_ratio:在回滚期间可以容忍的故障率(默认为0)
    - order:回滚期间的操作顺序,其中一个 stop-first(串行回滚),或者 start-first(并行回滚)(默认 stop-first)
- **update_config**:配置应如何更新服务,对于配置滚动更新很有用
    - parallelism:一次更新的容器数
    - delay:在更新一组容器之间等待的时间
    - failure_action:如果更新失败,该怎么办,其中一个 continue,rollback 或者pause(默认:pause)
    - monitor:每个容器更新后,持续观察是否失败了的时间 (ns|us|ms|s|m|h)(默认为0s)
    - max_failure_ratio:在更新过程中可以容忍的故障率
    - order:回滚期间的操作顺序,其中一个 stop-first(串行回滚),或者 start-first(并行回滚)(默认stop-first)
- **注意**:仅支持 V3.4 及更高版本

#### devices

- 指定设备映射列表

```yaml
devices:
  - "/dev/ttyUSB0:/dev/ttyUSB0"
```

#### dns

- 自定义 DNS 服务器,可以是单个值或列表的多个值

```yaml
dns: 8.8.8.8

dns:
  - 8.8.8.8
  - 9.9.9.9
```

#### dns_search

- 自定义 DNS 搜索域,可以是单个值或列表

```yaml
dns_search: example.com

dns_search:
  - dc1.example.com
  - dc2.example.com
```

#### entrypoint

- 覆盖容器默认的 entrypoint

```yaml
entrypoint: /code/entrypoint.sh
```

- 也可以是以下格式:

```yaml
entrypoint:
    - php
    - -d
    - zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20100525/xdebug.so
    - -d
    - memory_limit=-1
    - vendor/bin/phpunit
```

#### env_file

- 从文件添加环境变量,可以是单个值或列表的多个值

```yaml
env_file: .env
```

- 也可以是列表格式:

```yaml
env_file:
  - ./common.env
  - ./apps/web.env
  - /opt/secrets.env
```

#### environment

- 添加环境变量,您可以使用数组或字典,任何布尔值,布尔值需要用引号引起来,以确保 YML 解析器不会将其转换为 True 或 False

```yaml
environment:
  RACK_ENV: development
  SHOW: 'true'
```

#### expose

- 暴露端口,但不映射到宿主机,只被连接的服务访问
- 仅可以指定内部端口为参数:

```yaml
expose:
 - "3000"
 - "8000"
```

#### extra_hosts

- 添加主机名映射,类似`docker client --add-host`

```yaml
extra_hosts:
 - "somehost:162.242.195.82"
 - "otherhost:50.31.209.229"
```

- 以上会在此服务的内部容器中 /etc/hosts 创建一个具有 ip 地址和主机名的映射关系:

```
162.242.195.82  somehost
50.31.209.229   otherhost
```

#### healthcheck

- 用于检测 docker 服务是否健康运行

```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost"] # 设置检测程序
  interval: 1m30s # 设置检测间隔
  timeout: 10s # 设置检测超时时间
  retries: 3 # 设置重试次数
  start_period: 40s # 启动后,多少秒开始启动检测程序
```

#### image

- 指定容器运行的镜像,以下格式都可以

```yaml
image: redis
image: ubuntu:14.04
image: tutum/influxdb
image: example-registry.com:4000/postgresql
image: a4bc65fd # 镜像id
```

#### logging

- 服务的日志记录配置
- driver:指定服务容器的日志记录驱动程序,默认值为json-file,有以下三个选项

```yaml
driver: "json-file"
driver: "syslog"
driver: "none"
```

- 仅在 json-file 驱动程序下,可以使用以下参数,限制日志得数量和大小

```yaml
logging:
  driver: json-file
  options:
    max-size: "200k" # 单个文件大小为200k
    max-file: "10" # 最多10个文件
```

- 当达到文件限制上限,会自动删除旧文件
- syslog 驱动程序下,可以使用 syslog-address 指定日志接收地址

```yaml
logging:
  driver: syslog
  options:
    syslog-address: "tcp://192.168.0.42:123"
```

#### network_mode

- 设置网络模式

```yaml
network_mode: "bridge"
network_mode: "host"
network_mode: "none"
network_mode: "service:[service name]"
network_mode: "container:[container name/id]"
```

#### networks

- 配置容器连接的网络,引用顶级 networks 下的条目

```yaml
services:
  some-service:
    networks:
      - some-network
      - outside

networks:
  some-network:
    ipv4_address: 172.16.238.10
    ipv6_address: 2001:3984:3989::10
    driver: overlay
    aliases:
      - alias1
      - alias3
  outside:
    external: true
```

- **aliases**:同一网络上的其他容器可以使用服务名称或此别名来连接到对应容器的服务
- **app_net**:指定IP地址
- **external**:已经创建的`docker network`
- **driver**:配置网络驱动
    - bridge
    - overlay
    - host
    - none

#### port

- 配置容器的端口映射

**SHORT SYNTAX**

```yml
ports:
  - "3000"
  - "3000-3005"
  - "8000:8000"
  - "9090-9091:8080-8081"
  - "49100:22"
  - "127.0.0.1:8001:8001"
  - "127.0.0.1:5000-5010:5000-5010"
  - "6060:6060/udp"
  - "12400-12500:1240"
```

**LONG SYNTAX**

- `target`: the port inside the container
- `published`: the publicly exposed port
- `protocol`: the port protocol (`tcp` or `udp`)
- `mode`: `host` for publishing a host port on each node, or `ingress` for a swarm mode port to be load balanced.

```yml
ports:
  - target: 80
    published: 8080
    protocol: tcp
    mode: host
```

#### restart

- no:是默认的重启策略,在任何情况下都不会重启容器
- always:容器总是重新启动
- on-failure:在容器非正常退出时(退出状态非0),才会重启容器
- unless-stopped:在容器退出时总是重启容器,但是不考虑在Docker守护进程启动时就已经停止了的容器

```yaml
restart: "no"
restart: always
restart: on-failure
restart: unless-stopped
```

- **注意**:swarm 集群模式,请改用 restart_policy

#### secrets

- 存储敏感数据,例如密码

**SHORT SYNTAX**

- **file**:通过文件创建secret
- **external**:已经创建的`docker secret`

```yaml
version: "3.1"
services:

mysql:
  image: mysql
  environment:
    MYSQL_ROOT_PASSWORD_FILE: /run/secrets/my_secret
  secrets:
    - my_secret

secrets:
  my_secret:
    file: ./my_secret.txt
  my_other_secret:
    external: true
```

**LONG SYNTAX**

- `source`: The name of the secret as it exists in Docker.
- `target`: The name of the file to be mounted in `/run/secrets/` in the service’s task containers. Defaults to `source` if not specified.
- `uid` and `gid`: The numeric UID or GID that owns the file within `/run/secrets/` in the service’s task containers. Both default to `0` if not specified.
- `mode`: The permissions for the file to be mounted in `/run/secrets/` in the service’s task containers, in octal notation. For instance, `0444` represents world-readable. The default in Docker 1.13.1 is `0000`, but is be `0444` in newer versions. Secrets cannot be writable because they are mounted in a temporary filesystem, so if you set the writable bit, it is ignored. The executable bit can be set. If you aren’t familiar with UNIX file permission modes, you may find this [permissions calculator](http://permissions-calculator.org/) useful.

```yml
version: "3.9"
services:
  redis:
    image: redis:latest
    deploy:
      replicas: 1
    secrets:
      - source: my_secret
        target: redis_secret
        uid: '103'
        gid: '103'
        mode: 0440
secrets:
  my_secret:
    file: ./my_secret.txt
  my_other_secret:
    external: true
```

#### security_opt

- 修改容器默认的 schema 标签

```yaml
security-opt:
  - label:user:USER   # 设置容器的用户标签
  - label:role:ROLE   # 设置容器的角色标签
  - label:type:TYPE   # 设置容器的安全策略标签
  - label:level:LEVEL  # 设置容器的安全等级标签
```

#### stop_grace_period

- 指定在容器无法处理 SIGTERM (或者任何 stop_signal 的信号),等待多久后发送 SIGKILL 信号关闭容器

```yaml
stop_grace_period: 1s # 等待 1 秒
stop_grace_period: 1m30s # 等待 1 分 30 秒
```

- 默认的等待时间是 10 秒

#### stop_signal

- 设置停止容器的替代信号,默认情况下使用 SIGTERM
- 以下示例,使用 SIGUSR1 替代信号 SIGTERM 来停止容器

```yaml
stop_signal: SIGUSR1
```

#### sysctls

- 设置容器中的内核参数,可以使用数组或字典格式

```yaml
sysctls:
  net.core.somaxconn: 1024
  net.ipv4.tcp_syncookies: 0

sysctls:
  - net.core.somaxconn=1024
  - net.ipv4.tcp_syncookies=0
```

#### tmpfs

- 在容器内安装一个临时文件系统,可以是单个值或列表的多个值

```yaml
tmpfs: /run

tmpfs:
  - /run
  - /tmp
```

#### ulimits

- 覆盖容器默认的 ulimit

```yaml
ulimits:
  nproc: 65535
  nofile:
    soft: 20000
    hard: 40000
```

#### volumes

- 配置服务的容器数据卷

```yaml
version: "3.7"
services:
  db:
    image: postgres:latest
    volumes:
      - "/localhost/postgres.sock:/var/run/postgres/postgres.sock"
      - "/localhost/data:/var/lib/postgresql/data"
      - data-volume:/var/lib/backup/data

volumes:
  data-volume:
  data:
    external: true
```

## docker-compose命令

- `-p "my-app"`:通过该参数指定应用名

### config

验证 Compose 文件格式是否正确,若正确则显示配置,若格式错误显示错误原因

```
$ docker-compose conifg
```

### ps

- 列出项目中目前的所有容器

```
$ docker-compose ps
```

- `-a`:打印所有的容器信息(包括停止的容器)
- `-q` :只打印容器的 ID 信息

### top

- 查看各个服务容器内运行的进程

```
$ docker-compose top
```

### images

- 列出 Compose 文件中包含的镜像

```
$ docker-compose images
```

### up

- 该命令十分强大,它将尝试自动完成包括构建镜像,(重新)创建服务,启动服务,并关联服务相关容器的一系列操作

```
$ docker-compose up
```

- `-d` 在后台运行服务容器
- `--no-color` 不使用颜色来区分不同的服务的控制台输出
- `--no-deps` 不启动服务所链接的容器
- `--force-recreate` 强制重新创建容器,不能与 `--no-recreate` 同时使用
- `--no-recreate` 如果容器已经存在了,则不重新创建,不能与 `--force-recreate` 同时使用
- `--no-build` 不自动构建缺失的服务镜像
- `-t, --timeout TIMEOUT` 停止容器时候的超时(默认为 10 秒)

### port

- 打印某个容器端口所映射的公共端口

```
$ docker-compose port [options] SERVICE PRIVATE_PORT
```

- `--protocol=proto` 指定端口协议,tcp(默认值)或者 udp
- `--index=index` 如果同一服务存在多个容器,指定命令对象容器的序号(默认为 1)

### down

- 此命令将会停止 `up` 命令所启动的容器,并移除网络

```
$ docker-compose down
```

### start

- 停止已经处于运行状态的容器,但不删除它,通过 `docker-compose start` 可以再次启动这些容器

```
$ docker-compose start [SERVICE...]
```

### stop

- Stops running containers without removing them

```
$ docker-compose stop [SERVICE...]
```

- `-t, --timeout TIMEOUT` 停止容器时候的超时(默认为 10 秒)

### restart

- 重启项目中的服务

```
$ docker-compose restart [SERVICE...]
```

- `-t, --timeout TIMEOUT` 指定重启前停止容器的超时(默认为 10 秒)

### rm

- 删除所有(停止状态的)服务容器

```
$ docker-compose rm  [SERVICE...]
```

- `-f, --force` 强制直接删除,包括非停止状态的容器,一般尽量不要使用该选项
- `-v` 删除容器所挂载的数据卷

### logs

- 查看服务容器的输出
- 默认情况下,docker-compose 将对不同的服务输出使用不同的颜色来区分

```
$ docker-compose logs [SERVICE...]
```

- `--no-color` :关闭颜色

### build

- 构建(重新构建)项目中的服务容器
- 服务容器一旦构建后,将会带上一个标记名,例如对于 web 项目中的一个 db 容器,可能是 web_db
- 可以随时在项目目录下运行该命令来重新构建服务

```
$ docker-compose build [options] [SERVICE...]
```

- `--force-rm` 删除构建过程中的临时容器
- `--no-cache` 构建镜像过程中不使用 cache(这将加长构建过程)
- `--pull` 始终尝试通过 pull 来获取更新版本的镜像

### run

- 在指定服务上执行一个命令

```
$ docker-compose run [options] [-p PORT...] [-e KEY=VAL...] SERVICE [COMMAND] [ARGS...]
```

- `-d` 后台运行容器
- `--name NAME` 为容器指定一个名字
- `--entrypoint CMD` 覆盖默认的容器启动指令
- `-e KEY=VAL` 设置环境变量值,可多次使用选项来设置多个环境变量
- `-u, --user=""` 指定运行容器的用户名或者 uid
- `--no-deps` 不自动启动关联的服务容器
- `--rm` 运行命令后自动删除容器,`d` 模式下将忽略
- `-p, --publish=[]` 映射容器端口到本地主机
- `--service-ports` 配置服务端口并映射到本地主机
- `-T` 不分配伪 tty,意味着依赖 tty 的指令将无法运行
-  `--no-deps` 如果不希望自动启动关联的容器

**实例**

```
$ docker-compose run ubuntu ping docker.com
```

- 将会启动一个 ubuntu 服务容器,并执行 `ping docker.com` 命令
- 默认情况下,如果存在关联,则所有关联的服务将会自动被启动,除非这些服务已经在运行中
- 该命令类似启动容器后运行指定的命令,而相关卷,链接等等都将会按照配置自动创建,但是给定命令将会覆盖原有的自动运行命令,也不会自动创建端口,以避免冲突
-

```
$ docker-compose run --no-deps web python manage.py shel
```

### scale

- 设置指定服务运行的容器个数

```
$ docker-compose scale [options] [SERVICE=NUM...]
```

- `service=num` 设置数量,一般的,当指定数目多于该服务当前实际运行容器,将新创建并启动容器,反之,将停止容器
- `-t, --timeout TIMEOUT` 停止容器时候的超时(默认为 10 秒)

**实例**

```
$ docker-compose scale web=3 db=2
```

- 将启动 3 个容器运行 web 服务,2 个容器运行 db 服务



