#!/bin/bash

PTR="$1"
BASE_BACKUP=${2:-"pg_backup_2024_03_25_082011"}

KAMAL_PG="pg-16.1"

#
# Prepare the database
#
kamal accessory stop $KAMAL_PG

#
# Prepare base backup
#
kamal accessory exec -i $KAMAL_PG "/etc/recover.sh $BASE_BACKUP \"$PTR\""

#
# Run database
#
kamal accessory reboot $KAMAL_PG

#
# Show logs for db
#
kamal accessory logs $KAMAL_PG -f
