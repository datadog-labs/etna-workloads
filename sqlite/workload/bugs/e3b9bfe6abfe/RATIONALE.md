# Rationale (ticket #3838)

Fix hunk (src/vdbemem.c, sqlite3ValueFromExpr): apply affinity with SQLITE_UTF8, then call
sqlite3VdbeChangeEncoding() if enc!=UTF8. Pre-fix applied affinity with `enc` and never
converted the encoding.

In 3.54.1 this logic lives in static valueFromExpr() in src/vdbemem.c. Changes:
- Both sqlite3ValueApplyAffinity(pVal, ..., SQLITE_UTF8) calls in the TK_STRING/FLOAT/INTEGER
  branch now pass `enc` (the old behaviour).
- Removed the trailing `if( enc!=SQLITE_UTF8 ) rc = sqlite3VdbeChangeEncoding(pVal, enc);`.

Result: a text default (e.g. DEFAULT 'xyzzy') in a UTF16 database stays tagged with a UTF16
encoding but holds UTF8 bytes.

Oracle: tkt3838-1.1 fails (expected `2 999 9e+99 xyzzy`, got `2 999 9e+99 祸空`, mojibake).
tkt3838-1.2 still passes.
