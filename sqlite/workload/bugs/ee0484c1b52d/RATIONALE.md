# Rationale

## Change
`tree/ext/fts3/fts3_expr.c`, `getNextNode()`: the column-name prefix match
(`column:token`) now uses `memcmp(zStr, zInput, nStr)==0` instead of
`sqlite3_strnicmp(zStr, zInput, nStr)==0`.

This reverses the only behavioural hunk of fix.patch (the fts3_expr.c hunk).
The remaining hunks (exporting `sqlite3_strnicmp`, header/manifest edits) only
supply the API and are not needed to reintroduce the bug; the API is left in place.
Column names are again matched case-sensitively, so `B:two` no longer selects column `b`.

## Oracle failure
`fts3expr-1.15.2` (`test_fts3expr {one B:two}`) fails: `B:two` is parsed as a
plain phrase rather than column-restricted. 1 failure out of 660; the rest pass.
