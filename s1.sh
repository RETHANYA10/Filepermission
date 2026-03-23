#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="/home/administrator/newfolder"

echo "Creating & fixing permissions with sudo"
sudo mkdir -p "$TARGET_DIR"
sudo chown -R administrator:administrator "$TARGET_DIR"
sudo chmod -R 755 "$TARGET_DIR"

echo "Verify:"
sudo ls -ld "$TARGET_DIR"
