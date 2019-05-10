# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM openjdk:8-jre-alpine
LABEL MAINTAINER zengql <zengql@live.cn>

# Skywalking version
ARG SKYWALKING_VERSION

ENV JAVA_OPTS=" -Xms256M -Xmx1024M"

Add http://mirrors.tuna.tsinghua.edu.cn/apache/skywalking/${SKYWALKING_VERSION}/apache-skywalking-apm-${SKYWALKING_VERSION}.tar.gz skywalking.tar.gz

RUN set -ex; \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime; \
    echo "Asia/Shanghai" > /etc/timezone; \
	mkdir -p /skywalking; \
	tar -xzf skywalking.tar.gz  --strip 1 -C /skywalking; \
	rm -rf /skywalking.tar.gz; \
	rm -rf "skywalking/config"; \
    rm -rf "skywalking/bin"; \
	rm -rf "skywalking/oap-libs"; \
	rm -rf "skywalking/agent";

WORKDIR skywalking

COPY docker-entrypoint.sh .
COPY logback.xml webapp/

EXPOSE 8080

ENTRYPOINT ["sh", "docker-entrypoint.sh"]