#!/bin/bash

set -a
source ./.env
set +a
mkdir -p backup

docker run \
    --rm \
    --network shvirtd-example-python_backend \
    -v "$(pwd)"/backup:/backup \
    --entrypoint mysqldump \
    mysql:8 \
    --no-tablespaces \
    -h mysql \
    -P 3306 \
    -u"${MYSQL_USER}" \
    -p"${MYSQL_PASSWORD}" \
    "${MYSQL_DATABASE}" \
    > "backup/dump_$(date +%Y%m%d_%H%M%S).sql"
