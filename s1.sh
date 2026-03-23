#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="/home/administrator/newfolder"
TARGET_FILE="$TARGET_DIR/info.txt"

echo "Creating & fixing permissions with sudo"
sudo mkdir -p "$TARGET_DIR"
sudo chown -R administrator:administrator "$TARGET_DIR"
sudo chmod -R 755 "$TARGET_DIR"

echo "Creating empty file: $TARGET_FILE"
# Use sudo to ensure you can create the file under /home/administrator
sudo touch "$TARGET_FILE"

echo "Set ownership/permissions for the file"
sudo chown administrator:administrator "$TARGET_FILE"
sudo chmod 644 "$TARGET_FILE"

echo "Verify:"
sudo ls -ld "$TARGET_DIR"
sudo ls -l "$TARGET_DIR"
