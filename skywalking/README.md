# 构建 Skywalking Docker 镜像

详细配置文档请参考：[官方集群部署文档](https://github.com/apache/incubator-skywalking/blob/5.x/docs/cn/Deploy-backend-in-cluster-mode-CN.md)

## 构建镜像

由于官方并未提供最新版docker镜像，这里通过 Dockerfile 构建镜像,并通过环境变量应用于相关配置。

``` bash
# 下载仓库地址，切换到skywalking目录
git clone https://github.com/zengqinglei/build-docker-image.git
cd build-docker-image/skywalking
# 修改Makefile中skywalking版本以及镜像源地址等配置信息
# 开始构建镜像
make build
```

## 启动镜像

**以host网络模式启动**
``` bash
docker run -d -i -t --name=skywalking --restart=always --network=host \
    -e 'zookeeper_hostPort=192.168.0.110:2181' \
    -e 'storage_elasticsearch_clusterNodes=192.168.0.110:9300' \
    registry.cn-shenzhen.aliyuncs.com/zengql-release/skywalking:5.0.0-beta2
```
**非host网络模式启动**
``` bash
docker run -d -i -t --name=skywalking --restart=always \
    -p 18080:8080 \
    -p 10800:10800 \
    -p 11800:11800 \
    -p 12800:12800 \
    -e 'zookeeper_hostPort=192.168.0.110:2181' \
    -e 'naming_jetty_host=0.0.0.0' \
    -e 'remote_gRPC_host=0.0.0.0' \
    -e 'agent_gRPC_host=0.0.0.0' \
    -e 'agent_jetty_host=0.0.0.0' \
    -e 'ui_jetty_host=0.0.0.0' \
    -e 'storage_elasticsearch_clusterNodes=192.168.0.110:9300' \
    -v '/skywalking/logs/:/skywalking/logs/' \
    registry.cn-shenzhen.aliyuncs.com/zengql-release/skywalking:5.0.0-beta2
```

浏览器打开：http://localhost:8080 (或 18080 端口), 访问用户名/密码：admin/admin
