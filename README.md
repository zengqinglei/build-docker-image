# 我的 Docker 构建镜像 

项目存放一些第三方项目的发布包或源码进行构建的 Dockerfile ，由于官方未提供 Docker 镜像或者自己需要个性化的一些镜像。

## 常用镜像调试

以下存放一些简单镜像的调试方式

### 基于 alpine 的镜像调试方式

alpine 镜像非常简洁，内部几乎不带任何东西，仅4mb。

#### 1. 启动镜像

``` bash
docker run -d -i -t --name=alpine-docker alpine sh
```
常用命令：
* docker cp {local-dir} alpine-docker:{target-dir}
* docker stop alpine-docker
* docker rm alpine-docker

#### 2. 进入镜像

``` bash
docker exec -it alpine-docker sh
```
常用命令：
* ls：列出目录
* vi：修改文件内容

#### 3. 构建镜像

``` bash
docker build -t {image-name} --build-arg {arg-name}={arg-value} .
```

### 记录一些不常用的 Docker 命令

``` bash
# 删除异常停止的容器
docker rm `docker ps -a | grep Exited | awk '{print $1}'`
# 清理无用数据卷
docker volume prune
# 删除名称或标签为none的镜像
docker rmi -f  `docker images | grep '<none>' | awk '{print $3}'`
```