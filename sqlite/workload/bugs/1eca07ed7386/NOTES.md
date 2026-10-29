repro.sql: a table is joined to a parenthesized `(t1 INDEXED BY idx)`.
Buggy shell drops the INDEXED BY clause: the query plan shows a plain `SCAN t1`
instead of `SCAN t1 USING INDEX t1a`, and a nonexistent index (t1x) gives no
"no such index" error. The clean shell reports both correctly.
