MATCH (e:Element)
WHERE NOT (e)-[:Archi_PresentedIn]->(:Archi_View)
RETURN
    e.name AS `Error! Unused elements (not referenced in a View)`,
    [l IN labels(e) WHERE l<>"Element"][0] AS `Type`
