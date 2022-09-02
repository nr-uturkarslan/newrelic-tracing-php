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

# Set variables
export NEWRELIC_LICENSE_KEY=$NEWRELIC_LICENSE_KEY

# Install docker on host machine
sudo bash ./02_install_docker.sh
