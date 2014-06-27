#! /bin/bash

echo
echo "Creating Snapshot of current container"
echo

CONTAINER_ID=$(docker ps -a | egrep "drewkerrigan/basho-bench" | cut -d" " -f1)

docker commit ${CONTAINER_ID} bench_snapshot

echo
echo "Running /bin/bash on the snapshot"
echo

docker run -P --link riak:riak -t -i bench_snapshot /bin/bash