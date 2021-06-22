#!/usr/bin/env bash
set -veu

ROOT_DIR=$(dirname "$0")/../../..
OUT_ROOTFS_TAR=$ROOT_DIR/images/debian-9p-rootfs.tar
OUT_ROOTFS_FLAT=$ROOT_DIR/images/debian-9p-rootfs-flat
OUT_FSJSON=$ROOT_DIR/images/debian-base-fs.json
CONTAINER_NAME=debian-full
IMAGE_NAME=i386/debian-full

docker build . --rm --tag "$IMAGE_NAME"
docker rm "$CONTAINER_NAME" || true
docker create -t -i --name "$CONTAINER_NAME" "$IMAGE_NAME" bash

docker export "$CONTAINER_NAME" > "$OUT_ROOTFS_TAR"

$ROOT_DIR/tools/fs2json.py --out "$OUT_FSJSON" "$OUT_ROOTFS_TAR"

# Note: Not deleting old files here
mkdir -p "$OUT_ROOTFS_FLAT"
$ROOT_DIR/tools/copy-to-sha256.py "$OUT_ROOTFS_TAR" "$OUT_ROOTFS_FLAT"

echo "$OUT_ROOTFS_TAR", "$OUT_ROOTFS_FLAT" and "$OUT_FSJSON" created.
