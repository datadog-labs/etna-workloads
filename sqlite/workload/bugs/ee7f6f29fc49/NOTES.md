repro.sql runs the update-22.0 case from test/update.test: an UPDATE whose WHERE contains
`1 BETWEEN 0 AND x<=(SELECT ...)`. The bug drops the EP_Subquery flag on the BETWEEN node, so
the subquery in the WHERE clause is not treated as a subquery.
Clean shell prints rows 4 and 5. Buggy shell prints nothing, because the UPDATE touches every row.
