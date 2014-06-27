#! /bin/bash

docker ps -a | egrep "drewkerrigan/basho-bench" | cut -d" " -f1 | xargs -I{} bash -c 'docker rm -f "$@"' _ {} > /dev/null 2>&1

echo "Stopped and cleared the container."
