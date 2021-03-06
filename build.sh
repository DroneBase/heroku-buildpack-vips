#!/bin/bash

# set -x
set -e

docker build --no-cache --build-arg VIPS_VERSION=${VIPS_VERSION} -t libvips-heroku16 container

mkdir -p build

docker run --rm -t -v $PWD/build:/data libvips-heroku16 sh -c 'cp -f /usr/src/vips/build/*.tar.gz /data/'
