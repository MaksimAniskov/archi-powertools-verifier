SELECT "Error! Duplicate element names:", Name, Type FROM elements GROUP BY Name, Type HAVING COUNT(*)>1
