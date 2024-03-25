#!/bin/bash

set -e

# Build new docker image
cd config/postgres
./docker_build.sh
cd -

# Pull latest
ssh -J root@5.78.89.183 root@10.0.0.3 docker pull sjohnson540/simple-host-postgres:latest
