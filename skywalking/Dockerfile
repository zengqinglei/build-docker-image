FROM openjdk:8u151-alpine
LABEL MAINTAINER zengql <zengql@live.cn>

# Skywalking version
ARG SKYWALKING_VERSION

RUN apk --no-cache add \
       curl \
    && curl -o skywalking.tar.gz -SL http://mirrors.hust.edu.cn/apache/incubator/skywalking/${SKYWALKING_VERSION}/apache-skywalking-apm-incubating-${SKYWALKING_VERSION}.tar.gz \
    && apk --no-cache del \
       curl \
    && mkdir -p /skywalking \
    && tar -zxvf skywalking.tar.gz  --strip 1 -C /skywalking \
    && rm -rf /skywalking.tar.gz \
    && rm -rf /skywalking/agent

# Skywalking environment configuration
ENV zookeeper_hostPort=localhost:2181 \
    naming_jetty_host=localhost  \
    naming_jetty_port=10800 \
    remote_gRPC_host=localhost  \
    remote_gRPC_port=11800  \
    agent_gRPC_host=localhost \
    agent_gRPC_port=11800 \
    agent_jetty_host=localhost \
    agent_jetty_port=12800 \
    ui_jetty_host=localhost \
    ui_jetty_port=12800 \
    storage_elasticsearch_clusterName=CollectorDBCluster \
    storage_elasticsearch_clusterNodes=localhost:9300

ADD skywalking/config/application.yml /skywalking/config/application.yml
ADD entrypoint.sh /entrypoint.sh

# 1. install required libraries and tools
# 2. compile and install skywalking
# 3. remove skywalking sources and unnecessary libraries and tools
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && chmod +x /entrypoint.sh \
    && chmod +x /skywalking/bin/startup.sh \
    && echo "tail -f /dev/null" >> /skywalking/bin/startup.sh

EXPOSE 8080 10800 11800 12800

ENTRYPOINT ["/entrypoint.sh"]
