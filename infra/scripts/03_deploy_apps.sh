#!/bin/bash

# Get commandline arguments
while (( "$#" )); do
  case "$1" in
    --license-key)
      NEWRELIC_LICENSE_KEY="$2"
      shift
      ;;
    *)
      shift
      ;;
  esac
done
##################
### Apps Setup ###
##################

### Set variables

# Docker
dockerNetwork="php-tracing"

# Proxy
declare -A proxy
proxy["name"]="proxy-php"
proxy["imageName"]="proxy-php"
proxy["port"]=8080

# Persistence
declare -A persistence
persistence["name"]="persistence-php"
persistence["imageName"]="persistence-php"
persistence["port"]=8081
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

# Persistence
docker build \
  --build-arg newRelicAppName=${persistence[name]} \
  --build-arg newRelicLicenseKey=$NEWRELIC_LICENSE_KEY \
  --tag ${persistence[imageName]} \
  "../../apps/persistence/."
######

### Run ###

# Proxy
docker run \
  -d \
  --rm \
  --network $dockerNetwork \
  --name "${proxy[name]}" \
  -p ${proxy[port]}:80 \
  ${proxy[imageName]}

# Persistence
docker run \
  -d \
  --rm \
  --network $dockerNetwork \
  --name "${persistence[name]}" \
  -p ${persistence[port]}:80 \
  ${persistence[imageName]}
######
