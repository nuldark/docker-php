REPO = ghcr.io/nulldark/php-fpm
PHP_VERSION?=8.3
TARGET_PLATFORM?=linux/amd64

ifeq ($(TAG),)
	TAG ?= $(PHP_VERSION)
endif

build:
	docker build --tag $(REPO):$(TAG) \
		$(PHP_VERSION)/
		