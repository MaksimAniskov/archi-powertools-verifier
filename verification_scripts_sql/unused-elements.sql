SELECT "Error! Unused element (not referenced in a View):", Name, Type, ID
FROM elements e
WHERE NOT EXISTS (SELECT * FROM view_content vc WHERE vc.ObjectID=e.ID);
