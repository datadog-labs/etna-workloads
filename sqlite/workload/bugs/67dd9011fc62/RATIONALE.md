# Rationale

Fix (ticket #1912, CVS 3345) added to `getToken` in `src/tokenize.c` a loop after
numeric-literal scanning: `while( IdChar(z[i]) ){ *tokenType = TK_ILLEGAL; i++; }`,
so a number immediately followed by identifier characters is one illegal token.

## Change
`src/tokenize.c`, `case CC_DIGIT` in `sqlite3GetToken`: removed that same
`while( IdChar(z[i]) )` loop (it is still present verbatim in 3.54.1, just after
the hex/decimal/float scanning, before `return i`). The numeric token now ends at
the last digit, so the identifier part is tokenized separately again.
This is exactly the fix hunk reversed.

## Oracle failures
- misc5-10.1: `SELECT 123abc` returns `0 123` (abc parsed as an alias) instead of
  `unrecognized token: "123abc"`.
- misc5-10.2: `SELECT 1*123.4e5ghi;` returns `0 12340000.0` instead of
  `unrecognized token: "123.4e5ghi"`.

The autovacuum.test changes in the fix only fixed a test typo (missing space in the
generated SQL), so they are unaffected by this change.
