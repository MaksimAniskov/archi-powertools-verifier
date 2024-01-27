LOAD CSV WITH HEADERS FROM "file:///intermediate_files/model2/elements.csv" AS line
MERGE (:Element{_archi_pwrt_verifier_model_n: 2, archi_id:line.ID, type:line.Type, name:line.Name, documentation:line.Documentation, specialization:line.Specialization})
RETURN count(*) AS `Imported elements:`;

LOAD CSV WITH HEADERS FROM "file:///intermediate_files/model2/relations.csv" AS line
MATCH (s:Element{_archi_pwrt_verifier_model_n: 2, archi_id:line.Source})
MATCH (t:Element{_archi_pwrt_verifier_model_n: 2, archi_id:line.Target})
MERGE (s)-[:Relation{_archi_pwrt_verifier_model_n: 2, archi_id:line.ID, type:replace(line.Type,"Relationship",""), name:line.Name, specialization:line.Specialization}]->(t)
RETURN count(*) AS `Imported relationships:`;

LOAD CSV WITH HEADERS FROM "file:///intermediate_files/model2/views.csv" AS line
MERGE (:Archi_View{_archi_pwrt_verifier_model_n: 2, archi_id:line.ID, name:line.Name, documentation:line.Documentation})
RETURN count(*) AS `Imported views:`;

LOAD CSV WITH HEADERS FROM "file:///intermediate_files/model2/view-content.csv" AS line
MATCH (c:Element{_archi_pwrt_verifier_model_n: 2, archi_id:line.ObjectID})
MATCH (v:Archi_View{_archi_pwrt_verifier_model_n: 2, archi_id:line.ViewID})
MERGE (c)-[:Archi_PresentedIn]->(v)
RETURN count(*) AS `Imported elements and relationships in views:`;

LOAD CSV WITH HEADERS FROM "file:///intermediate_files/model2/folders.csv" AS line
MERGE (:Archi_Folder{_archi_pwrt_verifier_model_n: 2, archi_id:line.ID, type:line.Type, name:line.Name,documentation:line.Documentation})
RETURN count(*)  AS `Imported folders:`;

LOAD CSV WITH HEADERS FROM "file:///intermediate_files/model2/folders.csv" AS line
MATCH (f:Archi_Folder{_archi_pwrt_verifier_model_n: 2, archi_id:line.ID})
MATCH (p:Archi_Folder{_archi_pwrt_verifier_model_n: 2, archi_id:line.Parent})
MERGE (f)-[:Archi_SubfolderOf]->(p);

// Problem: The following does not create relationship between a folder and Archi relation in the folder
LOAD CSV WITH HEADERS FROM "file:///intermediate_files/model2/folder-content.csv" AS line
MATCH (c:Element{_archi_pwrt_verifier_model_n: 2, archi_id:line.ObjectID})
MATCH (f:Archi_Folder{_archi_pwrt_verifier_model_n: 2, archi_id:line.FolderID})
MERGE (c)-[:Archi_LivesIn]->(f)
RETURN count(*)  AS `Imported elements and relationships in folders:`;

LOAD CSV WITH HEADERS FROM "file:///intermediate_files/model2/properties.csv" AS line
MATCH (n:Element{_archi_pwrt_verifier_model_n: 2, archi_id:line.ID})
CALL apoc.create.setProperty(n, line.Key, line.Value)
YIELD node
RETURN count(*) AS `Imported elements' properties:`;

LOAD CSV WITH HEADERS FROM "file:///intermediate_files/model2/properties.csv" AS line
MATCH ()-[r:Relation{_archi_pwrt_verifier_model_n: 2, archi_id:line.ID}]->()
CALL apoc.create.setRelProperty(r, line.Key, line.Value)
YIELD rel
RETURN count(*) AS `Imported relationships' properties:`;

MATCH (:Element{_archi_pwrt_verifier_model_n: 2})-[rel:Relation{_archi_pwrt_verifier_model_n: 2}]->(:Element{_archi_pwrt_verifier_model_n: 2})
CALL apoc.refactor.setType(rel,rel.type)
YIELD input, output
REMOVE output.type;

MATCH (n:Element{_archi_pwrt_verifier_model_n: 2})
CALL apoc.create.addLabels( id(n), [ n.type ] )
YIELD node
REMOVE node.type;
