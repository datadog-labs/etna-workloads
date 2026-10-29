repro.sql runs a RIGHT JOIN whose ON clause references a later table (t3) inside a
scalar subquery (joinI-1.1.2). Clean shell: "Parse error near line 4: ON clause
references tables to its right" (exit 1). Buggy shell: the check misses the
column inside the subquery, so the query is accepted silently (exit 0).
