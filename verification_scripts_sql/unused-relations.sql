SELECT "Error! Unused relation (not referenced in a View):", Type, ID
FROM relations r
WHERE NOT EXISTS (SELECT * FROM view_content vc WHERE vc.ObjectID=r.ID);
