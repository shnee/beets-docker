#!/bin/sh

BEETS_DOCKER_DATA="/home/gert/projects/beets-docker-data"

docker run \
    --name beets \
    --rm \
    -ti \
    --user $(id -u):$(id -g) \
    -v $BEETS_DOCKER_DATA:/config \
    beets:latest $@

