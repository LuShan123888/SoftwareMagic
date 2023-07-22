---
title: Docker Image
categories:
- Software
- DevOps
- Docker
---
# Docker Image

## 镜像加载原理

### UnionFS (联合文件系统)

- Union文件系统(UnionFS)是一种分层,轻量级并且高性能的文件系统,它支持对文件系统的修改作为一次提交来一层层的叠加,同时可以将不同目录挂载到同一个虚拟文件系统下(unite several directories into a single virtual filesystem), Union文件系统是Docker镜像的基础,镜像可以通过分层来进行继承,基于基础镜像(没有父镜像) ,可以制作各种具体的应用镜像
- **特性**:一次同时加载多个文件系统,但从外面看起来,只能看到一个文件系统,联合加载会把各层文件系统叠加起来,这样最终的文件系统会包含所有底层的文件和目录

### Docker镜像加载原理

- docker的镜像实际上由一层一层的文件系统组成,这种层级的文件系统UnionFS
- `bootfs`(boot file system)主要包含`bootloader`和`kernel`, `bootloader`主要是引导加载`kernel`, Linux刚启动时会加载`bootfs`文件系统,在Docker镜像的最底层是`bootfs`,这一层与我们典型的Linux/Unix系统是一样的,包含boot加载器和内核,当boot加载完成之后整个内核就都在内存中了,此时内存的使用权已由`bootfs`转交给内核,此时系统也会卸载`bootfs`
- `rootfs` (root file system) ,在`bootfs`之上,包含的就是典型Linux系统中的`/dev`,` /proc`,` /bin`,` /etc`等标准目录和文件,`rootfs`就是各种不同的操作系统发行版,比如Ubuntu , Centos等等
- 对于一个精简的OS , `rootfs`可以很小,只需要包含最基本的命令,工具和程序库就可以了,因为底层直接用Host的kernel,自己需要提供`rootfs`就可以了,由此可见对于不同的linux发行版, `bootis`基本是一致的, `rootfs`会有差别,因此不同的发行版可以共用`bootfs`

### 镜像分层

- 所有的Docker镜像都起始于一个基础镜像层,当进行修改或增加新的内容时,就会在当前镜像层之上,创建新的镜像层
- 举一个简单的例子,假如基于Ubuntu Linux 16.04创建一个新的镜像,这就是新镜像的第一层;如果在该镜像中添加Python包,就会在基础镜像层之上创建第二个镜像层;如果继续添加一个安全补丁,就会创建第三个镜像层
- 该镜像当前已经包含3个镜像层,如下图所示(这只是一个用于演示的很简单的例子)

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-image-20200927203109389.png" alt="image-20200927203109389" style="zoom:50%;" />

- 在添加额外的镜像层的同时,镜像始终保持是当前所有镜像的组合,理解这一点非常重要,下图中举了一个简单的例子,每个镜像层包含3个文件,而镜像包含了来自两个镜像层的6个文件

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-image-20200927203223166.png" alt="image-20200927203223166" style="zoom:50%;" />

- 上图中的镜像层跟之前图中的略有区别,主要目的是便于展示文件
- 下图中展示了一个稍微复杂的三层镜像,在外部看来整个镜像只有6个文件,这是因为最上层中的文件7是文件5的一个更新版本

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-image-20200927203345054.png" alt="image-20200927203345054" style="zoom:50%;" />

- 这种情况下,上层镜像层中的文件覆盖了底层镜像层中的文件,这样就使得文件的更新版本作为一个新镜像层添加到镜像当中
- Docker通过存储引擎(新版本采用快照机制)的方式来实现镜像层堆栈,并保证多镜像层对外展示为统一的文件系统
- Linux上可用的存储引擎有AUFS, Overlay2, Device Mapper, Btrfs以及ZFS,顾名思义,每种存储引擎都基于Linux中对应的文件系统或者块设备技术,并且每种存储引擎都有其独有的性能特点
- Docker在Windows上仅支持windowsfilter一种存储引擎,该引擎基于NTFS文件系统之上实现了分层和CoW
- 下图展示了与系统显示相同的三层镜像,所有镜像层堆叠并合并,对外提供统一的视图

<img src="https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-image-20200927203532052.png" alt="image-20200927203532052" style="zoom:50%;" />

- **注意**:Docker镜像都是只读的,当容器启动时,一个新的可写层被加载到镜像的顶部,这一层就是我们通常说的容器层,容器之下的都叫镜像层

## 本地管理

### images

```shell
$ docker images
```

- **-a**:列出本地所有的镜像(含中间映像层,默认情况下,过滤掉中间映像层);
- **--digests**:显示镜像的摘要信息;
- **-f**:显示满足条件的镜像;
- **--format**:指定返回值的模板文件;
- **--no-trunc**:显示完整的镜像信息;
- **-q**:只显示镜像ID

**实例**

```
docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
mysql                   latest              e1d7dc9731da        2 weeks ago         544MB
hello-world         latest              bf756fb1ae65        8 months ago        13.3kB
```

- `REPOSITORY`:镜像的仓库源
- `TAG`:镜像的标签
- `IMAGE ID`:镜像的id
- `SIZE`:镜像的大小

### rmi

```shell
$ docker rmi -f 镜像ID/镜像名
```

- **-f**:强制删除;
- **--no-prune**:不移除该镜像的过程镜像,默认移除;

**实例**

```shell
$ docker rmi -f $(docker images -aq) #删除全部镜像
$ docker rmi ID1 ID2 ID3 #同时删除多个镜像
```

### tag

- 标记本地镜像,将其归入某一仓库

```
$ docker tag [OPTIONS] IMAGE[:TAG] [REGISTRYHOST/][USERNAME/]NAME[:TAG]
```

**实例**

- 将镜像ubuntu:15.10标记为 test/ubuntu:v3 镜像

```
root@test:~# docker tag ubuntu:15.10 test/ubuntu:v3
root@test:~# docker images   test/ubuntu:v3
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
test/ubuntu       v3                  4e3b13c8a266        3 months ago        136.3 MB
```

## 镜像仓库

### search

```
$ docker search 镜像名
```

- **--filter**:搜索筛选
- **--automated**:只列出 automated build类型的镜像;
- **--no-trunc**:显示完整的镜像描述;
- **-s**:列出收藏数不小于指定值的镜像

**实例**

```
$ docker search mysql
NAME                          		     DESCRIPTION                                     				STARS               OFFICIAL            AUTOMATED
mysql                         		      MySQL is a widely used, open-source relation...              9990                 [OK]
mariadb                           		MariaDB is a community-developed fork of MyS...          3659                 [OK]
mysql/mysql-server                   Optimized MySQL Server Docker images. Create...            730                                                      [OK]
percona                           		Percona Server is a fork of the MySQL relati...                     512                 [OK]
centos/mysql-57-centos7        MySQL 5.7 SQL database server                                              83
mysql/mysql-cluster                  Experimental MySQL Cluster Docker images. Cr...               75
centurylink/mysql                       Image containing mysql. Optimized to be link...                   61                                                        [OK]
```

- **--filter=STARS=3000**:搜索出来的镜像是STARS数大于3000的

### pull

```
$ docker pull 镜像名[:tag]
```

- `tag`:版本号,如果不写tag默认为最新版
- `-a`:拉取所有 tagged 镜像
- `--disable-content-trust`:忽略镜像的校验,默认开启
- `--platform linux/x86_64`:指定版本

**实例**

```shell
$ docker pull mysql

Using default tag: latest
latest: Pulling from library/mysql # 分层下载,联合文件系统
d121f8d1c412: Pull complete
f3cebc0b4691: Pull complete
1862755a0b37: Pull complete
489b44f3dbb4: Pull complete
690874f836db: Pull complete
baa8be383ffb: Pull complete
55356608b4ac: Pull complete
dd35ceccb6eb: Pull complete
429b35712b19: Pull complete
162d8291095c: Pull complete
5e500ef7181b: Pull complete
af7528e958b6: Pull complete
Digest: sha256:e1bfe11693ed2052cb3b4e5fa356c65381129e87e38551c6cd6ec532ebe0e808 # 签名
Status: Downloaded newer image for mysql:latest # 真实地址
docker.io/library/mysql:latest
```

### push

```
$ docker push [OPTIONS] username/NAME[:TAG]
```

- push前需要tag本地镜像
- 将本地的镜像上传到镜像仓库,要先登陆到镜像仓库
- 以下命令中的 username 为你的 Docker 账号用户名
- **--disable-content-trust**:忽略镜像的校验,默认开启

### login/logout

- 登陆到一个Docker镜像仓库,如果未指定镜像仓库地址,默认为官方仓库 Docker Hub

```
$ docker login [OPTIONS] [SERVER]
```

- **-u**:登陆的用户名
- **-p**:登陆的密码
- 登出一个Docker镜像仓库,如果未指定镜像仓库地址,默认为官方仓库 Docker Hub

```
$ docker logout [OPTIONS] [SERVER]
```