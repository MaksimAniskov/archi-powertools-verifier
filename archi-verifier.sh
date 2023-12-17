#!/bin/bash

cypher-shell -f import-archi-model.cyp
cypher-shell -f import/verify.cyp
