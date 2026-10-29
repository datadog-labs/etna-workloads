repro.sql creates an fts4 table with content= pointing at a real table that has the
languageid column (`fts4(content=c, languageid=l)`), as in fts4langid-3.1.

Clean: the table is created, 'rebuild' works and the MATCH query returns docid 1.
Buggy: the language id column isn't removed from the content columns, so CREATE VIRTUAL
TABLE fails with "vtable constructor failed: t" and the later statements fail with "no such table: t" (exit status 1).
