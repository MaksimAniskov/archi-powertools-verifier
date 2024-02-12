CALL apoc.diff.graphs(
    'match (n)-[Archi_PresentedIn]->(:Archi_View{name:"System A"}) return n',
    'match (n{_archi_pwrt_verifier_model_n: 2})-[Archi_PresentedIn]->(:Archi_View{name:"Default View", _archi_pwrt_verifier_model_n: 2}) return n'
);

// It needs to call apoc.diff.graphs again switching those two match statements.
// This is because apoc.diff.graphs behaves asymmetrically in regard to its source and dest parameters.
// Check out the procedure's documentation https://neo4j.com/labs/apoc/4.4/comparing-graphs/graph-difference/
CALL apoc.diff.graphs(
    'match (n{_archi_pwrt_verifier_model_n: 2})-[Archi_PresentedIn]->(:Archi_View{name:"Default View", _archi_pwrt_verifier_model_n: 2}) return n',
    'match (n)-[Archi_PresentedIn]->(:Archi_View{name:"System A"}) return n'
);
