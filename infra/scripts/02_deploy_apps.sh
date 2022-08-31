#!/bin/bash

##################
### Apps Setup ###
##################

### Set variables

# Proxy
declare -A proxy
proxy["name"]="proxy"
proxy["imageName"]="proxy-php"
proxy["namespace"]="proxy"
proxy["port"]=80
#########

####################
### Build & Push ###
####################

# Proxy
docker build \
  --tag "${DOCKERHUB_NAME}/${proxy[imageName]}" \
  "../../apps/proxy/."

docker run \
  --rm \
  --name "${proxy[name]}" \
  -p ${proxy[port]}:${proxy[port]} \
  "${DOCKERHUB_NAME}/${proxy[imageName]}"
