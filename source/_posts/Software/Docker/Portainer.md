---
title: Docker Portainer
categories:
- Software
- Docker
---
# Docker Portainer

- Portainer是一个可视化的容器镜像的图形管理工具,利用Portainer可以轻松构建,管理和维护Docker环境

## 安装

```bash
$ docker run --name portainer -d \
-p 8000:8000 -p 9000:9000 \
--hostname portainer \
-v /var/run/docker.sock:/var/run/docker.sock \
-v portainer_data:/data \
--restart=always portainer/portainer-ce
```

- **-v**:映射数据卷,映射宿主机的docker.sock到容器内部的文件
- **--restart=always**:自动重启容器

## 使用

- 浏览器访问http://localhost:9000
- 出现这个页面说明已经部署成功

![img](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-02-10-5db23a202ea4e7dfda990abd321114f4b7541090.png@1320w_854h.png)

- 输入两个相同的密码注册,点击 `Create User`
- 即可进入主界面管理本地Docker

![img](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-02-10-3d0e0f7c9ccae95a952017f5256dc76af095cc9a.png@1320w_450h.png)