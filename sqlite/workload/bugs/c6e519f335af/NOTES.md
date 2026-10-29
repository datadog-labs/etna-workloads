repro.sql: table with PRIMARY KEY(b,b) (duplicate column), then a row-value IN query
`(a,b) IN (VALUES(1,2))`. The clean shell prints `1|2`; the buggy shell hits the
assert() in removeUnindexableInClauseTerms (wherecode.c) and aborts.
