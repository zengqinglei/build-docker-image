Domain= registry.cn-shenzhen.aliyuncs.com
NAME = $(Domain)/zengql-release/keepalived
VERSION = 2.0.8

.PHONY: build release run remove

build:
	docker build -t $(NAME):$(VERSION) --build-arg KEEPALIVED_VERSION=$(VERSION) .


release:
	docker login --username=413210209@qq.com $(Domain)
	docker push $(NAME):$(VERSION)
	docker tag $(NAME):$(VERSION) $(NAME):latest
	docker push $(NAME):latest

run:
	docker run -d --name=keepalived --privileged --restart=always --network=host \
		-v /keepalived/:/etc/keepalived/ \
		$(NAME):$(VERSION)

remove:
	docker stop keepalived
	docker rm keepalived
