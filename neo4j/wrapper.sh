#!/bin/bash

# turn on bash's job control
set -m

# Start neo4j process and put it in the background
tini -g -- /startup/docker-entrypoint.sh neo4j &

# wait for Neo4j
wget --tries=20 --waitretry=10 -O /dev/null http://localhost:7474

./archi-verifier.sh

if [ "${RUN_NEO4J_AS_DAEMON}" == "true" ]
then
    fg %1
fi
