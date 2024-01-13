SELECT "Error! Generated View drifted. Relation not presented:", r.Type, r.ID
FROM relations r JOIN elements e ON e.ID=r.Source
WHERE e.Name='Application Service 1'
  AND NOT EXISTS (
      SELECT * FROM view_content vc JOIN views v ON vc.ViewID=v.ID
      WHERE v.Name='Generated View for Application Service 1' AND vc.ObjectID=r.ID
  );

SELECT "Error! Generated View drifted. Relation not presented:", r.Type, r.ID
FROM relations r JOIN elements e ON e.ID=r.Target
WHERE e.Name='Application Service 1'
  AND NOT EXISTS (
      SELECT * FROM view_content vc JOIN views v ON vc.ViewID=v.ID
      WHERE v.Name='Generated View for Application Service 1' AND vc.ObjectID=r.ID
  );

SELECT "Error! Generated View drifted. Related element not presented:", e2.Type, e2.Name, e2.ID
FROM elements e2 JOIN relations r ON e2.ID=r.Target JOIN elements e ON e.ID=r.Source
WHERE e.Name='Application Service 1'
  AND NOT EXISTS (
      SELECT * FROM view_content vc JOIN views v ON vc.ViewID=v.ID
      WHERE v.Name='Generated View for Application Service 1' AND vc.ObjectID=e2.ID
  );

SELECT "Error! Generated View drifted. Related element not presented:", e2.Type, e2.Name, e2.ID
FROM elements e2 JOIN relations r ON e2.ID=r.Source JOIN elements e ON e.ID=r.Target
WHERE e.Name='Application Service 1'
  AND NOT EXISTS (
      SELECT * FROM view_content vc JOIN views v ON vc.ViewID=v.ID
      WHERE v.Name='Generated View for Application Service 1' AND vc.ObjectID=e2.ID
  );
