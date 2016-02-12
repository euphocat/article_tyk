#!/bin/bash

PWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Stop compose"
docker-compose -f $PWD/../src/compose/docker-compose.yml stop

echo "Remove containers"
docker-compose -f $PWD/../src/compose/docker-compose.yml rm -f
