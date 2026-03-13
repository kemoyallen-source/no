#!/bin/bash

# healthcheck.sh

# This script checks the health status of a container.

CONTAINER_NAME="my_container"

# Check if the container is running
if [ "
$(docker inspect -f '{{.State.Running}}' $CONTAINER_NAME)" == "true" ]; then
    echo "Container '$CONTAINER_NAME' is running."
    exit 0
else
    echo "Container '$CONTAINER_NAME' is NOT running."
    exit 1
fi