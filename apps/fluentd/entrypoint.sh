#!/bin/sh

#source vars if file exists
DEFAULT=/etc/default/fluentd

if [ -r $DEFAULT ]; then
    set -o allexport
    . $DEFAULT
    set +o allexport
fi

# If the user has supplied only arguments append them to `fluentd` command
if [ "${1#-}" != "$1" ]; then
    set -- fluentd "$@"
fi

# If user does not supply config file or plugins, use the default
if [ "$1" = "fluentd" ]; then

    # Set config file path
    set -- "$@" -c /fluentd/etc/${FLUENTD_CONF}

    # Set plugins path
    set -- "$@" -p /fluentd/plugins

    # In order to parse env vars in config file
    set -- "$@" --use-v1-config
fi

exec "$@"
