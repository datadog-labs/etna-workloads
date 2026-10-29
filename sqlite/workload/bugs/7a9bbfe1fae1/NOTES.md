repro.sh builds a db with a partial index `WHERE b IS 'abc' COLLATE nocase`, then (defensive off,
writable_schema) rewrites the index SQL to use the unknown collation `xyz`. A fresh connection then
runs `SELECT * FROM t1`, which forces a schema parse.

Clean: schema parses fine, prints `1|abc|3`, exit 0.
Buggy: `malformed database schema (ex1) - no such collation sequence: xyz`, exit 1
(the bug calls sqlite3WherePartIdxExpr at schema-parse time, which errors on the unknown collation).
