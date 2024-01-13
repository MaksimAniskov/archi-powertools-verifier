MATCH (v:Archi_View)
WHERE NOT ()-[:Archi_PresentedIn]->(v)
RETURN v.archi_id AS `Error! This view has no elements:`, v.name AS ``