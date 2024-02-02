SHELL=/bin/bash

export COMPOSE_DOCKER_CLI_BUILD=1
export DOCKER_BUILDKIT=1
export BUILDKIT_PROGRESS=plain

PHP_VERSION ?= 8.3

TAG ?= latest
PLATFORM ?= linux/amd64

DOCKER_IMAGE_NAME:=nuldark/php-fpm
DOCKER_IMAGE:=$(DOCKER_IMAGE_NAME):$(TAG)

build:
	docker buildx build \
	   --load \
       --platform $(PLATFORM) \
       --tag $(DOCKER_IMAGE) \
       --file $(PHP_VERSION)/Dockerfile $(PHP_VERSION)/

push:
	docker buildx build \
	   --push \
       --platform $(PLATFORM) \
       --tag $(DOCKER_IMAGE) \
       --file $(PHP_VERSION)/Dockerfile $(PHP_VERSION)/

release: build push