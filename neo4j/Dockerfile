FROM neo4j:5.15.0

ENV NEO4J_AUTH=none
ENV NEO4J_PLUGINS=[\"apoc\"]

COPY archi-verifier.sh archi-verifier.sh
COPY wrapper.sh wrapper.sh
COPY import-archi-model.cypher import-archi-model.cypher
COPY import-archi-model2.cypher import-archi-model2.cypher

ENTRYPOINT ["./wrapper.sh"]
