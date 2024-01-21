SHELL=/bin/bash

export COMPOSE_DOCKER_CLI_BUILD=1
export DOCKER_BUILDKIT=1
export BUILDKIT_PROGRESS=plain

PHP_VERSION?=8.3

TAG?=latest
PLATFORM?=linux/arm64,linux/amd64

DOCKER_REGISTRY:=ghcr.io
DOCKER_IMAGE_NAME:=nulldark/php-fpm
DOCKER_IMAGE:=$(DOCKER_REGISTRY)/$(DOCKER_IMAGE_NAME):$(TAG)

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
