# Rationale

## src/insert.c, xferOptimization()
Reverses the fix's insert.c hunk, which added
`if( (db->flags & SQLITE_CountRows)!=0 ) return 0;`. In 3.54.1 the same check
exists (with a comment) just before the authorization block; I removed it. With
`PRAGMA count_changes=1`, `INSERT INTO t2 SELECT * FROM t1` now takes the xfer
path, which emits no row-count result, so the statement returns nothing.

## src/vacuum.c, execSql() (not changed)
The fix relaxed `assert(rc!=SQLITE_ROW)`. 3.54.1 also clears SQLITE_CountRows
inside sqlite3RunVacuum() (line ~202), so VACUUM no longer sees the flag.
Reverting that would be a different change, so I left it alone.

## Oracle failures
- tkt-c48d99d690-1.1: expected `4`, got an empty result.
- vacuum.test cases stay passing, because VACUUM clears CountRows itself.
