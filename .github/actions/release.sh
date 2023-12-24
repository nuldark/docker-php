#!/usr/bin/env bash

set -e

if [[ "${GITHUB_REF}" == refs/heads/master || "${GITHUB_REF}" == refs/tags/* ]]; then
    docker login "${DOCKER_REGISTRY}" -u "${DOCKER_USERNAME}" -p "${DOCKER_PASSWORD}"

    IFS=',' read -ra tags <<< "${TAGS}"

    for tag in "${tags[@]}"; do
        make buildx-push TAG="${tag}";
    done
fi