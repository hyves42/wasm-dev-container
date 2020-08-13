#!/bin/sh
#Build the container the first time
docker build --build-arg uid=`id -u` --rm -f Dockerfile -t ubuntu:dev .
