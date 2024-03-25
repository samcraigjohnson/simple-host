#!/bin/bash
#
# Example from docs:
#   archive_command = 'test ! -f /mnt/server/archivedir/%f && cp %p /mnt/server/archivedir/%f'
#
# For this script
#   archive_command = 'archive_command.sh "%f" "%p"'

set -e

FILE="$1"
PATH="$2"
BUCKET="$AWS_S3_BUCKET"
CLI_PATH="/usr/local/bin"

# HEAD to see if file exists
$CLI_PATH/aws s3api head-object --bucket "$BUCKET" --key "wal/$FILE" && \
   exit 0 || echo "Doesn't exist continuing..."

# IF NOT EXISTS, upload
$CLI_PATH/aws s3 cp "$PATH" s3://"$BUCKET"/wal/"$FILE"
