#!/usr/bin/env bash

set -e

if [[ "${GITHUB_REF}" == refs/heads/master || "${GITHUB_REF}" == refs/tags/* ]]; then
    echo "${PA_TOKEN}" | docker login "${DOCKER_REGISTRY}" --username "${DOCKER_USERNAME}" --password-stdin

    IFS=',' read -ra tags <<< "${TAGS}"

    for tag in "${tags[@]}"; do
        make buildx-push TAG="${tag}";
    done
fi