MATCH (e:Element)
WHERE EXISTS{
    MATCH (e2:Element{name: e.name})
    WHERE labels(e2)=labels(e)
      AND NOT e2=e
}
RETURN
    e.archi_id AS `Error! Duplicate element names`,
    [l IN labels(e) WHERE l<>"Element"][0] AS `Type`,
    e.name AS `Name`
ORDER BY Type, Name
