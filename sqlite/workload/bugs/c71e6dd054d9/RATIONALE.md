# Rationale

Fix: `sqlite3AlterDropConstraint()` in src/alter.c added `sqlite3DequoteToken(pCons)`
before building the argument as `%.*Q` from the raw token, so a quoted constraint
name (`DROP CONSTRAINT "name"`) was dequoted before being compared.

In 3.54.1 the code uses `sqlite3NameFromToken()` (which dequotes). I reverted that
hunk to the pre-fix behaviour: `zArg = sqlite3MPrintf(db, "%.*Q", pCons->n, pCons->z);`
passes the raw, still-quoted token text to `sqlite_drop_constraint()`, which compares
it against the dequoted name in the schema and so fails to match.

Failing oracle cases: altercons2-12.4 ("no such constraint: "BooleanZeroOrOne""),
altercons2-12.5 (schema unchanged as a result), and altercons2-12.7 (quoted name
`"a""b"` not found).
