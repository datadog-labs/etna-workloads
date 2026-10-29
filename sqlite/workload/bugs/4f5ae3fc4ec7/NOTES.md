`repro.sql` is the select6-13.120 case: a query with a flattened subquery containing `t2 LEFT JOIN empty1`, an INNER JOIN ... ON, and a RIGHT JOIN, plus `WHERE t1.y`.
The clean shell returns one row (`1`). The buggy shell returns no rows, because flattenSubquery() picks the wrong `iNewParent` cursor when the subquery has more than one FROM term, so the ON-clause is attached to the wrong table.
Both exit with status 0.
