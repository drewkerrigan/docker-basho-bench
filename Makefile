.PHONY: all build start-test stop

all: stop build start

build:
	./bin/build.sh

start:
	./bin/start.sh $TESTS

debug:
	./bin/start.sh debug

stop:
	./bin/stop.sh

snapshot:
	./bin/snapshot.sh

status:
	./bin/status.sh