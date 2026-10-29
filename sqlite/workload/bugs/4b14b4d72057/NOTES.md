repro.sql runs the tkt1444 setup (table, index, view with ORDER BY) and a compound
`SELECT ... UNION ALL SELECT ... FROM view ORDER BY 1`.
Clean shell returns the rows. Buggy shell aborts with assertion
`pParent->pOrderBy==0` in flattenSubquery (exit status -6), because the view's ORDER BY
is flattened into a compound query that has its own ORDER BY.
