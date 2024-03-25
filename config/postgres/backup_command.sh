#!/bin/sh

set -e

# Set variables
PG_BACKUP_DIR="/etc/backups"
BACKUP_NAME="pg_backup_$(date +%Y_%m_%d_%H%M%S)"
S3_BUCKET="s3://$AWS_S3_BUCKET/full_backups"
BACKUP_LOC="$PG_BACKUP_DIR/$BACKUP_NAME"


# Create and compress the backup using pg_basebackup
# -t Tar -z gzip -P progress -v verbose -D data destination
pg_basebackup -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -D \
              "$BACKUP_LOC" -F t -z -P -v

# Upload to S3
aws s3 cp "$BACKUP_LOC" "${S3_BUCKET}/${BACKUP_NAME}" --recursive

rm -rf "$BACKUP_LOC"
