Domain= registry.cn-shenzhen.aliyuncs.com
NAME = $(Domain)/zengql-release/skywalking
VERSION = 6.1.0

.PHONY: build-oap build-ui release run remove

build-oap:
	cd oap; \
	docker build -t $(NAME)-oap:$(VERSION) --build-arg SKYWALKING_VERSION=$(VERSION) .

build-ui:
	cd ui; \
	docker build -t $(NAME)-ui:$(VERSION) --build-arg SKYWALKING_VERSION=$(VERSION) .

build: build-oap build-ui

release:
	docker login --username=413210209@qq.com $(Domain)
	docker push $(NAME)-oap:$(VERSION)
	docker tag $(NAME)-oap:$(VERSION) $(NAME)-oap:latest
	docker push $(NAME)-oap:latest
	docker push $(NAME)-ui:$(VERSION)
	docker tag $(NAME)-ui:$(VERSION) $(NAME)-ui:latest
	docker push $(NAME)-ui:latest

run:
	env     VERSION=$(VERSION) \
			docker-compose up -d --remove-orphans

remove:
	docker-compose down --remove-orphans
