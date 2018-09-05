# skywalking-docker 

官方集群部署文档：https://github.com/apache/incubator-skywalking/blob/5.x/docs/cn/Deploy-backend-in-cluster-mode-CN.md

## 启动镜像

**以host网络模式启动**
``` bash
docker run -d -i -t --name=skywalking --restart=always --network=host \
    -e 'zookeeper_hostPort=192.168.0.110:2181' \
    -e 'remote_gRPC_host=0.0.0.0' \
    -e 'agent_gRPC_host=0.0.0.0' \
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
    -e 'remote_gRPC_host=0.0.0.0' \
    -e 'agent_gRPC_host=0.0.0.0' \
    -e 'storage_elasticsearch_clusterNodes=192.168.0.110:9300' \
    registry.cn-shenzhen.aliyuncs.com/zengql-release/skywalking:5.0.0-beta2
```

浏览器打开：http://localhost:8080 , 访问用户名/密码：admin/admin
