# Rationale

## Change
`tree/ext/fts5/fts5parse.y`, `%stack_overflow` block: replaced the call
`sqlite3Fts5ParseError(pParse, "fts5: parser stack overflow");` with `assert( 0 );`.

This reverses the fix hunk in `fts5parse.y`, which replaced `assert( 0 )` with
the error report. The other hunks of the fix (unused-parameter warnings and the
removal of unused parameters) are cleanups unrelated to the bug and were not reverted.
The `UNUSED_PARAM(yypMinor)` line added by the fix is only a warning silencer,
so it is not restored.

## Oracle failures
`fts5simple-19.2` (deeply nested `AND` query) crashes the testfixture:
`fts5yyStackOverflow: Assertion '0' failed`. It should return
`{1 {fts5: parser stack overflow}}`.
