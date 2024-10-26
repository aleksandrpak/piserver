#!/bin/sh
set -x

docker images --digests
docker ps --format '{{.Image}}' | xargs -n 1 docker pull
docker rm -f $(docker ps -q)
./run.sh
docker image prune --all --force
