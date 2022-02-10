#!/usr/bin/env bash


GIT_REV="$(git rev-parse --short=7 HEAD)"
IMAGE="${REGISTRY:-quay.io/rgopinat/devfile-index}"
IMAGE_TAG="${IMAGE_TAG:-${GIT_REV}}"

podman build --no-cache -t devfile-index -f .

if [[ -n "$QUAY_USER" && -n "$QUAY_TOKEN" ]]; then
    podman tag devfile-index "${IMAGE}:${IMAGE_TAG}"
    podman tag devfile-index "${IMAGE}:next"
    podman login -u="$QUAY_USER" -p="$QUAY_TOKEN" quay.io
    podman push "${IMAGE}:${IMAGE_TAG}"
    podman push "${IMAGE}:next"
fi