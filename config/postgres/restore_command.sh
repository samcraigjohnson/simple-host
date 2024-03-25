#!/bin/bash
#
# For this script
#   restore_command = 'restore_command.sh "%f" "%p"'

set -e

FILE="$1"
PATH="$2"
BUCKET="$AWS_S3_BUCKET"
CLI_PATH="/usr/local/bin"

# HEAD to see if file exists
$CLI_PATH/aws s3api head-object --bucket "$BUCKET" --key "wal/$FILE" && \
  # Exit with error if doesn't exist
  echo "Found it, continuing" || exit 1


# IF exists, download
$CLI_PATH/aws s3 cp s3://"$BUCKET"/wal/"$FILE" "$PATH"
