#!/bin/bash

docker build -t 007ba7/git-metrics:$1 .
docker push 007ba7/git-metrics:$1
