#!/bin/sh

set -e

BASE_BACKUP="$1"
PTR="$2"

DATA_DIR="/var/lib/postgresql/data"
BACKUP_DIR="/etc/backups"

# Delete existing data to prepare
rm -rf "$DATA_DIR" || echo "rm tried my best"

# Download the base backup from s3
mkdir -p "$BACKUP_DIR"
aws s3 cp "s3://$AWS_S3_BUCKET/full_backups/$BASE_BACKUP/base.tar.gz" \
    "$BACKUP_DIR"

aws s3 cp "s3://$AWS_S3_BUCKET/full_backups/$BASE_BACKUP/pg_wal.tar.gz" \
    "$BACKUP_DIR"

# Unzip base backup into data directory
tar -xzvf "$BACKUP_DIR"/base.tar.gz -C "$DATA_DIR"
tar -xzvf "$BACKUP_DIR"/pg_wal.tar.gz -C "$DATA_DIR"/pg_wal

# Store recovery target for use later
# 2004-10-19 10:23:54+02 (timestamp with timezone)
echo "$PTR" > "$DATA_DIR"/recovery_target
echo "Saved as $PTR"

# Set the db to be ready for recovery
touch "$DATA_DIR"/recovery.signal

echo "Ready to start recovery!"
