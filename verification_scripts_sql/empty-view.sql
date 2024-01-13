SELECT "Error! This view has no elements:", v.Name, v.ID
FROM views v
WHERE NOT EXISTS (SELECT * FROM view_content vc WHERE vc.ViewID=v.ID);
