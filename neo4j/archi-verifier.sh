#!/bin/bash

cp -r /usr/var/verification_scripts import/verification_scripts

cypher-shell -f import-archi-model.cyp

find import/verification_scripts -type f -exec cypher-shell -f {} \;
