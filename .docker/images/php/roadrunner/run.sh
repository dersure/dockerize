#!/bin/sh

# Exit imediately if any command or pipeline returns a non-zero exit status.
set -e

conf_file=${CONF_FILE:-.rr.yaml}

init() {
    echo "Running init scripts"

    for a in /opt/run/*
    do
        sh $a
    done
}

init

echo "Launching container"
/usr/local/bin/rr serve -c $conf_file
