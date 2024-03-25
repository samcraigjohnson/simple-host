#!/bin/bash
#
# 3 steps to setup a secondary.
#
# 1. Setup primary configuration
#
# 2. Setup secondary configuration
#
# 3. Bootstrap from a backup


set -e

DATADIR="/var/lib/postgresql/data"

SECONDARY_HOST="pg-16.1-secondary"
PRIMARY_HOST="pg-16.1"

SECONDARY_PASSWORD="mysecurepassword"
SECONDARY_IP="10.0.0.5"
PRIMARY_IP="10.0.0.3"
JUMP_IP="5.78.89.183"

DB="simple_host_production"

###########
# Helpers #
###########

primary() {
  kamal accessory exec --reuse $PRIMARY_HOST "$1"
}

primary_sql() {
  primary "psql -h localhost -U postgres $DB -c \"$1\""
}

secondary() {
  kamal accessory exec -i $SECONDARY_HOST "$1"
}

upload() {
  scp -o ProxyJump=root@$JUMP_IP -P 22 \
      "$1" root@$PRIMARY_IP:/etc/
}

##############################
### Primary server setup   ###
##############################

# Add necessary modifications to config
# max_wal_senders
# max_replication_slots
#
scp -o ProxyJump=root@$JUMP_IP -P 22 \
    ./config/postgresql.conf root@$PRIMARY_IP:/etc/

# Modify authentication to allow
# replication
#
scp -o ProxyJump=root@$JUMP_IP -P 22 \
    ./config/pg_hba.conf root@$PRIMARY_IP:/etc/

# Reload the config
#
kamal accessory reboot $PRIMARY_HOST

# Add replication user so standby can connect
#
create="CREATE ROLE secondary WITH REPLICATION PASSWORD '$SECONDARY_PASSWORD' LOGIN"
primary_sql "$create" || echo "Replication user already exists"

# Setup replication slots to make sure WAL entries are
# kept around in case of secondary going offline
#
replication_slot="SELECT * FROM pg_create_physical_replication_slot('secondary')"
primary_sql "$replication_slot" || echo "Replication slot already exists"


##############################
### Secondary server setup ###
##############################

# Add necessary modifications to config
# primary_conninfo
# primary_slot_name
# hot_standby
#
scp -o ProxyJump=root@$JUMP_IP -P 22 \
    ./config/secondary-postgresql.conf root@$SECONDARY_IP:/etc/

##############################
### Secondary bootstrap    ###
##############################

# Stop secondary so we can bootstrap the data
#
kamal accessory stop $SECONDARY_HOST

# Start the bootstrap backup
#
secondary "sh -c \"rm -rf $DATADIR/* && pg_basebackup -h $PRIMARY_IP -D $DATADIR -U secondary -P -v -S secondary\""

# Create signal file so secondary knows
# when it starts that it is a standby
#
secondary "touch $DATADIR/standby.signal"

# Start secondary
#
kamal accessory reboot $SECONDARY_HOST

echo "Complete"

# Run SELECT * FROM pg_stat_replication; # on the primary
# Run SELECT * FROM pg_stat_wal_receiver; # on the secondary

