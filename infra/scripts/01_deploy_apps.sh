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
proxy["port"]=8080
######

### Docker setup ###
docker network create \
  --driver bridge \
  $dockerNetwork
######

### Build ###

# Proxy
docker build \
  --build-arg newRelicAppName=${proxy[name]} \
  --build-arg newRelicLicenseKey=$NEWRELIC_LICENSE_KEY \
  --tag ${proxy[imageName]} \
  "../../apps/proxy/."
######

### Run ###
docker run \
  -d \
  --rm \
  --network $dockerNetwork \
  --name "${proxy[name]}" \
  -p ${proxy[port]}:80 \
  ${proxy[imageName]}
######
