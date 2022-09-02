#!/bin/bash

##################
### Apps Setup ###
##################

### Set variables

# Docker
dockerNetwork="php-tracing"

# Proxy
declare -A proxy
proxy["name"]="proxy"
proxy["imageName"]="proxy-php"
proxy["namespace"]="proxy"
proxy["port"]=80
######

### Docker setup ###
docker network create \
  --driver bridge \
  $dockerNetwork
######

### Build ###

# Proxy
docker build \
  --tag "${DOCKERHUB_NAME}/${proxy[imageName]}" \
  "../../apps/proxy/."
######

### Run ###
docker run \
  --rm \
  --network $dockerNetwork \
  --name "${proxy[name]}" \
  -p ${proxy[port]}:${proxy[port]} \
  "${DOCKERHUB_NAME}/${proxy[imageName]}"
######