# Zookeeper Docker 镜像的使用

使用zookeeper官方镜像

### 启动镜像
``` bash
docker run -d --name=zookeeper --restart=always --network=host
    -v '/zookeeper/data/:/opt/zookeeper/data/'
    -v '/zookeeper/logs/:/opt/zookeeper/logs/'
    -v '/zookeeper/conf/:/opt/zookeeper/conf/'
    -e 'ZOO_MY_ID=1'
    -e 'ZOO_SERVERS=server.1=192.168.0.102:2888:3888 server.2=192.168.0.103:2888:3888 server.3=192.168.0.104:2888:3888'
    zookeeper
```

### 验证zookeeper运行情况

``` bash
# 进入容器
docker exec -it zookeeper sh

# echo stat | nc 127.0.0.1 2181 ,查看哪个节点被选择作为follower或者leader
# echo ruok | nc 127.0.0.1 2181 ,测试是否启动了该Server，若回复imok表示已经启动。
# echo dump | nc 127.0.0.1 2181 ,列出未经处理的会话和临时节点。
# echo kill | nc 127.0.0.1 2181 ,关掉server
# echo conf | nc 127.0.0.1 2181 ,输出相关服务配置的详细信息。
# echo cons | nc 127.0.0.1 2181 ,列出所有连接到服务器的客户端的完全的连接 / 会话的详细信息。
# echo envi | nc 127.0.0.1 2181 ,输出关于服务环境的详细信息（区别于 conf 命令）。
# echo reqs | nc 127.0.0.1 2181 ,列出未经处理的请求。
# echo wchs | nc 127.0.0.1 2181 ,列出服务器 watch 的详细信息。
# echo wchc | nc 127.0.0.1 2181 ,通过 session 列出服务器 watch 的详细信息，它的输出是一个与 watch 相关的会话的列表。
# echo wchp | nc 127.0.0.1 2181 ,通过路径列出服务器 watch 的详细信息。它输出一个与 session 相关的路径。
```