# Rationale

## Change
`tree/src/build.c`, `sqlite3ViewGetColumnNames()` (viewGetColumnNames): the
"view %s is circularly defined" check on `pTable->nCol<0` is wrapped in `#if 0`.

This reverses the only implementation hunk of fix.patch (src/build.c, which
removed the `#if 0` / `#endif` around that same check). The code is identical
to the pre-fix form: the check is compiled out, leaving only
`assert( pTable->nCol>=0 )`.

## Oracle failure
view-14.1 (`CREATE TEMP VIEW t1 AS SELECT a,b FROM t1; SELECT * FROM temp.t1;`)
expects `1 {view t1 is circularly defined}`. With the check disabled,
testfixture aborts with `Assertion 'pTable->nCol>=0' failed` (in a non-assert
build it would proceed with a negative nCol instead of reporting the error).
