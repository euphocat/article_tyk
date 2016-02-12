#!/bin/bash

PWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Stop compose"
docker-compose -f $PWD/../src/compose/docker-compose.yml stop

echo "Remove containers"
docker-compose -f $PWD/../src/compose/docker-compose.yml rm -f

echo "Start containers"
docker-compose -f $PWD/../src/compose/docker-compose.yml up -d

echo "Pause for 1s"
sleep 1

echo "Init Gateway"
$PWD/setup_tyk.sh

echo -e "\n"

echo "You can look at:"

echo "- Bouchon: http://bouchon.local:9090/horaires/MANG"
echo "- Bouchon behind GW: http://api.local/open/horaires/MANG"
echo "- Bouchon as seen by clients: http://open.local:9092/horaires/MANG"
