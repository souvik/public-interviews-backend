#!/bin/bash

rm -f ./tmp/pids/server.pid
./bin/rails s -p ${CONTAINER_PORT:-3000} -b 0.0.0.0 -e ${RAILS_ENV:-development}
