#!/bin/bash

# Update
sudo apt-get update
echo Y | sudo apt-get upgrade

# Clone repo to app
mkdir app
cd app
git clone https://github.com/nr-uturkarslan/newrelic-tracing-php.git

# Run setup
cd newrelic-tracing-php/infra/helpers/vm
bash 01_run_setup.sh \
  --license-key <YOUR_NEWRELIC_LICENCE_KEY>
