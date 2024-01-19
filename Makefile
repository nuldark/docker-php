REPO = ghcr.io/nulldark/php-fpm
PHP_VERSION?=8.3.2
CHECKSUM=
TARGET_PLATFORM?=linux/amd64

ifeq ($(TAG),)
	TAG ?= $(PHP_VERSION)
endif

build:
	docker build --tag $(REPO):$(TAG) .

buildx-build-amd64:
	docker buildx build --load \
		--platform linux/amd64 \
		--tag $(REPO):$(PHP_VERSION) .
		
buildx-build:
	docker buildx build --platform $(TARGET_PLATFORM) \
		--tag $(REPO):$(PHP_VERSION) .

buildx-push:
	docker buildx build --platform=$(TARGET_PLATFORM) --push \
		--tag $(REPO):$(TAG) .