# Rationale

Fix (2008-09-08): in `sqlite3InitCallback`, a NULL `rootpage` column made the
callback call `corruptSchema()` and then `return 1`, which aborts
`sqlite3_exec()` with SQLITE_ABORT instead of reporting SQLITE_CORRUPT. The
fix removed the `return 1` so the corrupt error is reported.

## Change (src/prepare.c, `sqlite3InitCallback`)
In the `if( argv[3]==0 )` branch (argv[3] is rootpage in the 5-column
schema query), restored `return 1;` after `corruptSchema(...)`. This reverses
the fix hunk that dropped `return 1` (the `}else if` chaining is already
present in 3.54.1).

## Oracle
`corrupt2-10.2` fails: expected SQLITE_CORRUPT, got SQLITE_ABORT.
`corrupt2-10.1` still passes because the "malformed database schema (t2)"
message is already set by corruptSchema.
