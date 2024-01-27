#!/bin/bash

cp -r /usr/var/verification_scripts import/verification_scripts
cp -r /usr/var/additional_data import/additional_data

echo "Importing the Archimate model to Neo4j..."
cypher-shell -f import-archi-model.cypher
if [ -f /var/lib/neo4j/import/intermediate_files/model2/elements.csv ]
then
    echo "Importing the second Archimate model to Neo4j..."
    cypher-shell -f import-archi-model2.cypher
fi

echo "Executing verification scripts..."
find import/verification_scripts -type f | sort | xargs -I {} sh -c 'echo "{}"; cypher-shell -f "{}"'

echo "Verification completed"
