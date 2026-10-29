# Rationale

Fix hunk (src/resolve.c): `else if( no_such_func )` became
`else if( no_such_func && pParse->db->init.busy==0 )`, so that "no such function"
is not raised while parsing the schema of an existing database.

In 3.54.1 the condition is `no_such_func && (init.busy==0 || (no_such_func==2 && init.busy==2))`
(the second clause handles ALTER TABLE ADD COLUMN internal functions). I removed that whole
init.busy clause in `resolveExprStep` (src/resolve.c), restoring the pre-fix unconditional
error. The `SQLITE_ENABLE_UNKNOWN_SQL_FUNCTION` clause is untouched.

Oracle failures (test/check.test): check-7.4, check-7.5, check-7.6. A second connection
opening a database whose CHECK constraint uses an unregistered UDF now sees a malformed
schema ("no such function: myfunc") instead of reading the table.
