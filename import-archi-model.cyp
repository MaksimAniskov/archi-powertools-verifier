MATCH (n) DETACH DELETE n;


LOAD CSV WITH HEADERS FROM "file:///elements.csv" AS line
MERGE (:Element{archi_id:line.ID, type:line.Type, name:line.Name, documentation:line.Documentation, specialization:line.Specialization});


LOAD CSV WITH HEADERS FROM "file:///relations.csv" AS line
MATCH (s:Element{archi_id:line.Source})
MATCH (t:Element{archi_id:line.Target})
MERGE (s)-[:Relation{archi_id:line.ID, type:replace(line.Type,"Relationship",""), name:line.Name, specialization:line.Specialization}]->(t);


MATCH (n:Element)
CALL apoc.create.addLabels( id(n), [ n.type ] )
YIELD node
REMOVE node.type
RETURN node;


MATCH ()-[rel:Relation]->()
CALL apoc.refactor.setType(rel,rel.type)
YIELD input, output
REMOVE output.type
RETURN input, output;


LOAD CSV WITH HEADERS FROM "file:///properties.csv" AS line
MATCH (n{archi_id:line.ID})
CALL apoc.create.setProperty(n, line.Key, line.Value)
YIELD node
RETURN null;


LOAD CSV WITH HEADERS FROM "file:///properties.csv" AS line
MATCH ()-[r{archi_id:line.ID}]->()
CALL apoc.create.setRelProperty(r, line.Key, line.Value)
YIELD rel
RETURN null;