repro.sql is the whereF-7.1 query (ticket ec32177c99ccac2b1): a correlated subquery whose WHERE is an OR of ANDs that share the term `me.genreid IS NOT NULL`.

The injected bug makes sqlite3WhereBegin scan virtual terms when it codes constant-for-this-loop terms. The factored-out OR term then gets applied wrongly.

Clean shell prints `4` and `5`. Buggy shell prints `1`, `4` and `5`, so it returns an extra wrong row. Exit status is 0 in both.
