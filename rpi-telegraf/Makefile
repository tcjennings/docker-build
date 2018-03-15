IMAGE = telegraf
DATE := $(shell date +'%Y-%m-%d')
VERSION?=1.5.2
ARCH?=rpi
build: $(FILES)
	docker build -t $(ARCH)-$(IMAGE)\:$(VERSION) --build-arg build_date=$(DATE) --build-arg architecture=armhf --build-arg telegraf_version=$(VERSION) .

