#!/bin/bash

cp -r /usr/var/verification_scripts import/verification_scripts

cypher-shell -f import-archi-model.cypher

find import/verification_scripts -type f | sort | xargs -L1 -I {} cypher-shell -f "{}"
