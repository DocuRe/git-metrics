#!/bin/bash

docker build -t ghcr.io/jtfogarty/git-metrics:$1 .
#docker push 007ba7/git-metrics:$1


docker push ghcr.io/jtfogarty/git-metrics:$1

# k create secret docker-registry ghcr-config --from-file=.dockerconfigjson -n git-metrix

