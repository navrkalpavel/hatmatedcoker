#!/bin/bash
set -e

# Persistent keys directory (HA add-ons persist /data)
KEYS_DIR="/data/keys"

if [ ! -d "$KEYS_DIR" ] || [ -z "$(ls -A "$KEYS_DIR" 2>/dev/null || true)" ]; then
  echo "[tmate-addon] Generating new SSH keys for tmate server in $KEYS_DIR"
  mkdir -p "$KEYS_DIR"
  cd /data

  # Download and run official tmate key generator script
  # See: https://github.com/tmate-io/tmate-ssh-server
  curl -s -q https://raw.githubusercontent.com/tmate-io/tmate-ssh-server/master/create_keys.sh | bash

  # Move generated keys into KEYS_DIR if they are not already there
  if [ -d "/data/keys" ] && [ "$KEYS_DIR" != "/data/keys" ]; then
    mv /data/keys/* "$KEYS_DIR"/
  fi
else
  echo "[tmate-addon] Using existing SSH keys in $KEYS_DIR"
fi

export SSH_KEYS_PATH="$KEYS_DIR"

# Defaults; can be overridden by environment if needed
: "${SSH_PORT_LISTEN:=22}"
: "${SSH_PORT_ADVERTISE:=$SSH_PORT_LISTEN}"
: "${SSH_HOSTNAME:=navrkalovi.cz}"

echo "[tmate-addon] Starting tmate-ssh-server"
echo "  SSH_HOSTNAME      = $SSH_HOSTNAME"
echo "  SSH_PORT_LISTEN   = $SSH_PORT_LISTEN"
echo "  SSH_PORT_ADVERTISE= $SSH_PORT_ADVERTISE"
echo "  SSH_KEYS_PATH     = $SSH_KEYS_PATH"

exec tmate-ssh-server
