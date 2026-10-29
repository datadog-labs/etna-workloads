# Rationale

## Hunk changed
`tree/src/build.c`, `sqlite3EndTable()`: the `sqlite3VdbeAddParseSchemaOp()` filter
was changed from `tbl_name='%q' AND type!='trigger'` back to `tbl_name='%q'`.
This reverses the fix's single implementation hunk (the fix added
`AND type!='trigger'`). The code is the same, apart from the extra
`, 0` argument that newer versions pass.

Without the filter, creating a TEMP table named like a main-db table that has a
temp trigger re-parses the temp trigger's schema row before the temp table
exists, so the trigger is re-loaded against the wrong table. This produces
"malformed database schema".

## Oracle failures
`temptrigger-4.1` fails (`CREATE TEMP TABLE t1(x)` with an existing temp trigger on
main.t1 gives a malformed schema error). The tests that currently pass
(auth2, other temptrigger cases) are unaffected.
