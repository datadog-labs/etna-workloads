repro.sql: a RIGHT JOIN whose ON clause references a table to its right (t6),
inside a subquery that gets flattened.
Clean: "Parse error near line 4: ON clause references tables to its right", exit 1.
Buggy: the check runs after flattening, so no error is raised; the query succeeds silently, exit 0.
