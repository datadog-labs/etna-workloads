repro.sql runs the whereL-920 query: `SELECT * FROM (SELECT 1.0 AS abc) WHERE abc=1 AND abc LIKE '1.0';`.
Clean shell returns the row `1.0`. The buggy shell returns no rows, because the propagate-constants optimization wrongly substitutes the NONE-affinity subquery column (abc=1 becomes 1 LIKE '1.0').
