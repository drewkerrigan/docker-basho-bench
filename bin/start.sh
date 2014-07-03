#! /bin/bash

timestamp=$(date +%s)

if docker ps -a | grep "drewkerrigan/basho-bench" >/dev/null; then
  echo ""
  echo "It looks like you already have a basho_bench test running."
  echo "Please take them down before attempting to bring up another"
  echo "cluster with the following command:"
  echo ""
  echo "  make stop"
  echo "    or"
  echo "  make stop-bench"
  echo ""

  exit 1
fi

echo
echo "Starting basho_bench test:"
echo

if [ ! -z $1 ] 
then 
    docker run -P --link riak:riak -i drewkerrigan/basho-bench /opt/basho_bench/bin/run_test.sh \
      $timestamp \
      $TESTS #debug
else
    docker run -P --link riak:riak -d drewkerrigan/basho-bench /opt/basho_bench/bin/run_test.sh \
      $timestamp \
      $TESTS \
      > /dev/null 2>&1
fi

CONTAINER_ID=$(docker ps | egrep "drewkerrigan/basho-bench" | cut -d" " -f1)
CONTAINER_PORT=$(docker port "${CONTAINER_ID}" 9999 | cut -d ":" -f2)

echo "Attepmting to contact http://localhost:${CONTAINER_PORT}/reports/current/"

until curl -s "http://localhost:${CONTAINER_PORT}/reports/current/" | grep "Report" > /dev/null 2>&1;
do
  echo "Waiting for test to complete..."
  sleep 3
done

mkdir -p reports/

docker cp ${CONTAINER_ID}:/opt/basho_bench/reports/$timestamp reports/
rm reports/current
ln -fs reports/$timestamp reports/current

wd=$(pwd)

echo 
echo "  Test Complete, view summary at (http://localhost:${CONTAINER_PORT}/reports/current/)"
echo "  Results were also copied to $wd/reports/$timestamp, $wd/reports/current"
echo 