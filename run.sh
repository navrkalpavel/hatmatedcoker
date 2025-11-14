#!/bin/sh
set -e

export XDG_CONFIG_HOME="/data/upterm"
mkdir -p /data/upterm

echo "[upterm] Starting uptermd on port 22"

/usr/local/bin/uptermd \
  --ssh-addr 0.0.0.0:22
