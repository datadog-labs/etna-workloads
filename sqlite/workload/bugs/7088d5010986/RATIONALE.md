# Rationale

## Hunk changed: src/build.c, sqlite3CreateIndex()
The fix replaced `assert( pParse->nErr==0 )` plus a check without nErr by a
runtime check `|| pParse->nErr>0` that bails out. In 3.54.1 the runtime check is
`if( pParse->nErr ){ goto exit_create_index; }`. I reverted that to the
pre-fix incorrect `assert( pParse->nErr==0 )` (with the early-exit removed), so
CREATE INDEX called after a parse error (e.g. syntax error in the WHERE clause)
trips the assert.

## Oracle failure
index7-6.5 (`CREATE INDEX t5a ON t5(a) WHERE a=#1;`) aborts with
`Assertion 'pParse->nErr==0' failed` in sqlite3CreateIndex instead of
returning `1 {near "#1": syntax error}`.
