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

# Install docker
sudo bash 02_install_docker.sh

# Deploy apps
sudo bash 03_deploy_apps.sh \
  --license-key $NEWRELIC_LICENSE_KEY
