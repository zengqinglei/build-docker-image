# skywalking-docker 

**运行镜像**
``` bash
docker run -d --name=skywalking --restart=always \
-p 18080:8080 \
-p 10800:10800 \
-p 11800:11800 \
-p 12800:12800 \
-e 'zookeeper_hostPort=192.168.0.110:2181' \
-e 'naming_jetty_host=192.168.0.110' \
-e 'remote_gRPC_host=192.168.0.110' \
-e 'agent_gRPC_host=192.168.0.110' \
-e 'agent_jetty_host=192.168.0.110' \
-e 'ui_jetty_host=192.168.0.110' \
-e 'storage_elasticsearch_clusterNodes=192.168.0.110:9300' \
registry.cn-shenzhen.aliyuncs.com/zengql-release/skywalking:5.0.0-beta2
```

**_待补充......_**
