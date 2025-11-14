#!/bin/sh
set -e

KEY=/data/server_key

if [ ! -f "$KEY" ]; then
    echo "[upterm] Generating SSH host key"
    ssh-keygen -t ed25519 -N "" -f "$KEY"
fi

echo "[upterm] Starting uptermd on port 22"

/usr/local/bin/upterm \
  serve \
  --ssh-host-key $KEY \
  --bind-addr 0.0.0.0:22
