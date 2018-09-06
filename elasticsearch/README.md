# Elasticsearch Docker 镜像的使用

官方镜像相对好用，请勿使用阿里云等拉取镜像，请从：docker.elastic.co/elasticsearch/elasticsearch 拉取指定版本的镜像。

## 启动镜像教程

* 官方5.6教程：https://www.elastic.co/guide/en/elasticsearch/reference/5.6/docker.html
* 官方6.x教程：https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html

### 1. 设置系统内核vm.max_map_count需要至少设置为262144用于生产

``` bash
# 一键脚本
if [ -z `grep -E vm.max_map_count /etc/sysctl.conf` ]; then
    echo "vm.max_map_count=262144" >> /etc/sysctl.conf;
fi;
grep vm.max_map_count /etc/sysctl.conf;
```

### 2. 启动镜像,官方文档已经写的比较清楚，下面示例仅供参考

``` bash
docker run -d --name=elasticsearch --restart=always --network=host
    --ulimit memlock=-1
    -e "cluster.name=CollectorDBCluster" 
    -e "bootstrap.memory_lock=true"
    -e "ES_JAVA_OPTS=-Xms512m -Xmx512m"
    -e "node.master=true"
    -e "network.publish_host=192.168.0.102"
    -e "discovery.zen.ping.unicast.hosts=192.168.0.102,192.168.0.103,192.168.0.104"
    -e "discovery.zen.minimum_master_nodes=2"
    -e "xpack.security.enabled=false"
    docker.elastic.co/elasticsearch/elasticsearch:5.6.11
```

由于官方内置了x-pack插件，默认开启了安全认证，上面启动docker禁用了安全认证。
修改密码：
``` bash
curl -XPUT -u elastic '192.168.0.102:9200/_xpack/security/user/elastic/_password' 
    -H "Content-Type: application/json" 
    -d '{ "password" : "123456"}'
``` 

如果镜像下载慢，可以从我的阿里云镜像下载，仅上传了以下两个版本：
* registry.cn-shenzhen.aliyuncs.com/zengql-release/elasticsearch:5.6.11
* registry.cn-shenzhen.aliyuncs.com/zengql-release/elasticsearch:6.4.0

### 3. 导入x-pack授权文件

>官方镜像都默认集成了 x-pack，x-pack 是 elastic 官方的商业版插件，支持监控、鉴权以及机器学习等功能,我们可以免费使用 x-pack 的基础版本(1 年授权，可更换)，支持集群可视化监控，导入授权后 x-pack 会自动关闭 monitoring 以外的功能，比如登陆鉴权等。  
>官方教程：https://www.elastic.co/guide/en/x-pack/current/license-management.html
* 注册并下载授权码：https://register.elastic.co/xpack_register
* 导入授权信息：
    ``` bash
    curl -XPUT http://192.168.0.102:9200/_license?acknowledge=true 
        -d @zeng-qinglei-92d00a35-2bb3-414b-a426-43af5c8aa2ee-v5.json 
        -uelastic:changeme
    ```
### 4. 验证命令

``` bash
# 查看当前节点状态
curl http://localhost:9200
# 查看各节点状态
curl http://localhost:9200/_cat/nodes
# 查看集群健康状态
curl http://localhost:9200/_cat/health
```
