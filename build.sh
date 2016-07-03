#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
docker build \
  -t mrebscher/payara-postgres:latest \
  -t mrebscher/payara-postgres:4.1.1.154 \
  -t mrebscher/payara-postgres:4.1.1 \
  .
