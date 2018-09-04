FROM alpine:3.5
LABEL MAINTAINER zengql <zengql@live.cn>

# Keepalived version
ARG KEEPALIVED_VERSION

# Add keepalived default script user to make sure their IDs get assigned consistently,
# regardless of whatever dependencies get added
RUN addgroup -S keepalived_script && adduser -D -S -G keepalived_script keepalived_script

# 1. install required libraries and tools
# 2. compile and install keepalived
# 3. remove keepalived sources and unnecessary libraries and tools
RUN apk --no-cache add \
       gcc \
       ipset \
       ipset-dev \
       iptables \
       iptables-dev \
       libnfnetlink \
       libnfnetlink-dev \
       libnl3 \
       libnl3-dev \
       make \
       musl-dev \
       openssl \
       openssl-dev \
       autoconf \
       curl \
    && curl -o keepalived.tar.gz -SL http://keepalived.org/software/keepalived-${KEEPALIVED_VERSION}.tar.gz \
    && mkdir -p /tmp/keepalived-sources \
    && tar -xzf keepalived.tar.gz --strip 1 -C /tmp/keepalived-sources \
    && rm -rf keepalived.tar.gz \
    && cd /tmp/keepalived-sources \
    && ./configure --disable-dynamic-linking \
    && make && make install \
    && cd - \
    && rm -rf /tmp/keepalived-sources \
    && apk --no-cache del \
        gcc \
        ipset-dev \
        iptables-dev \
        libnfnetlink-dev \
        libnl3-dev \
        make \
        musl-dev \
        openssl-dev \
        autoconf

ADD keepalived/ /etc/keepalived/
ADD ./entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

# set keepalived as image entrypoint with --dont-fork and --log-console (to make it docker friendly)
# define /usr/local/etc/keepalived/keepalived.conf as the configuration file to use
ENTRYPOINT ["/entrypoint.sh"]
CMD ["keepalived","--dont-fork","--log-console"]

# example command to customise keepalived daemon:
# CMD ["--log-detail","--dump-conf"]
