#!/bin/bash


docker build --platform linux/amd64 --push \
       -t sjohnson540/simple-host-postgres:latest .
