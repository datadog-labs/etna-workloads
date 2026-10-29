Reproducer (repro.sql) is join-14.3: a LEFT JOIN against a nested, flattened subquery
whose result column is an expression (`cc+222`) over the flattened column.

Clean shell prints `111|555|333`. The buggy shell aborts with
`sqlite3VdbeExec: Assertion 'pC!=0' failed` (exit -6). The injected change stops
substExpr() from recursing into the children of a TK_IF_NULL_ROW node, so the
inner `cc` is never rewritten to the new cursor.
