#!/bin/sh
#
# "normal" starts postgres normally
# "recovery"  recovery process is started with given variables
#

set -e

MODE=$1
DATA_DIR="/var/lib/postgresql/data"

# Setup AWS secrets
cat > /docker-entrypoint-initdb.d/aws_init.sh <<-EOF
  export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
  export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
  echo 'aws export complete'
EOF
chown postgres:postgres /docker-entrypoint-initdb.d/aws_init.sh
chmod +x /docker-entrypoint-initdb.d/aws_init.sh

# Setup HBA
cp /etc/pg_hba.conf "$DATA_DIR"

# Handle commands
if [ "$MODE" = "postgres" ]; then

  # If we are doing a PITR recovery we want
  # to read the time to recover in at runtime
  # this avoids having to updat env variables
  if [ -f "${DATA_DIR}/recovery_target" ]; then
    PTR=$(cat "${DATA_DIR}/recovery_target")
    sed -r -i \
    "s%^#?recovery_target_time =.*$%recovery_target_time = '${PTR}'%" \
    /etc/postgresql.conf
  fi

  docker-entrypoint.sh postgres -c config_file=/etc/postgresql.conf
else
  exec "${@}"
fi


