Reproducer: create a table, add a TEMP trigger, then run `ALTER TABLE ... ADD COLUMN b CHECK (...)`.
The ALTER re-parses the schema in a nested parser, which exercises the db->pParse
parent/outer restore logic that injection.patch breaks.
Clean shell: prints the updated CREATE TABLE sql, exit 0.
Buggy shell: assertion failure `db->pParse==pParse` in sqlite3ParseObjectReset, abort (exit 134).
The upstream test only exercises this under simulated OOM, but the broken nesting bookkeeping
shows up without it in this build (the TEMP trigger from the test's 1.0 setup is what triggers it).
