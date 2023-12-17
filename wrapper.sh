#!/bin/bash

# turn on bash's job control
set -m

# Start the primary process and put it in the background
tini -g -- /startup/docker-entrypoint.sh neo4j &

# wait for Neo4j
wget --tries=20 --waitretry=10 -O /dev/null http://localhost:7474

# Start the secondary process
./archi-verifier.sh

# now we bring the primary process back into the foreground
# and leave it there
fg %1
