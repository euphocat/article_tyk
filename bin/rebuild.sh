#! /bin/bash

PWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Stop"
$PWD/stop.sh

echo "Build container"
docker-compose -f $PWD/../src/compose/docker-compose.yml build

echo "Start"
$PWD/start.sh
