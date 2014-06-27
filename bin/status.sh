#!/bin/bash

CONTAINER_ID=$(docker ps | egrep "drewkerrigan/basho-bench" | cut -d" " -f1)
CONTAINER_PORT=$(docker port "${CONTAINER_ID}" 9999 | cut -d ":" -f2)

if curl -s "http://localhost:${CONTAINER_PORT}/reports/current/" | grep "Report" > /dev/null 2>&1;
then 
    echo; echo "   Basho Bench is currently serving a report at [http://localhost:${CONTAINER_PORT}/reports/current/]"; echo
else
    echo; echo "   Basho Bench is not running"; echo
fi