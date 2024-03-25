#!/bin/bash

set -e

primary() {
  kamal accessory exec --reuse pg-16.1 "$1"
}

# Set variables
PG_BACKUP_DIR="/etc/backups"
BACKUP_NAME="pg_backup_$(date +%Y-%m-%d_%H:%M:%S%z)"
S3_BUCKET="s3://simple-host-backups/full_backups"
BACKUP_LOC="$PG_BACKUP_DIR/$BACKUP_NAME"

# Create and compress the backup using pg_basebackup
primary "pg_basebackup -h localhost -U postgres -D $BACKUP_LOC -F t -z -P -v"

# Upload to S3
primary "aws s3 cp $BACKUP_LOC ${S3_BUCKET}/${BACKUP_NAME} --recursive"

rm -rf "$BACKUP_LOC"
