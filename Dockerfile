FROM neo4j:5.15.0

ENV NEO4J_AUTH=none
ENV NEO4J_PLUGINS=[\"apoc\"]

COPY archi-verifier.sh archi-verifier.sh
COPY wrapper.sh wrapper.sh
COPY import-archi-model.cyp import-archi-model.cyp

ENTRYPOINT ["./wrapper.sh"]
