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

# Fluentd
declare -A fluentd
fluentd["name"]="fluentd"
fluentd["imageName"]="fluentd"
fluentd["newrelicEndpoint"]="https://log-api.eu.newrelic.com/log/v1"
fluentd["logLevel"]="info"
fluentd["port"]=24224

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

# Fluentd
sudo docker build \
  --build-arg licenseKey=$NEWRELIC_LICENSE_KEY \
  --build-arg baseUri=${fluentd[newrelicEndpoint]} \
  --build-arg logLevel=${fluentd[logLevel]} \
  --tag ${fluentd[imageName]} \
  "../../apps/fluentd/."

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

# Fluentd
sudo docker run \
  -d \
  --rm \
  --network $dockerNetwork \
  --name ${fluentd[name]} \
  -p ${fluentd[port]}:${fluentd[port]} \
  ${fluentd[imageName]}

# Proxy
docker run \
  -d \
  --rm \
  --network $dockerNetwork \
  --log-driver="fluentd" \
  --log-opt "fluentd-address=${fluentd[name]}:${fluentd[port]}" \
  --name "${proxy[name]}" \
  -p ${proxy[port]}:80 \
  ${proxy[imageName]}

# Persistence
docker run \
  -d \
  --rm \
  --network $dockerNetwork \
  --log-driver="fluentd" \
  --log-opt "fluentd-address=${fluentd[name]}:${fluentd[port]}" \
  --name "${persistence[name]}" \
  -p ${persistence[port]}:80 \
  ${persistence[imageName]}
######
