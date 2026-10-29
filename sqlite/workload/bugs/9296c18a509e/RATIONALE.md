# Rationale

Current code already has `sqlite3DecOrHexToI64()` (from the fix), so the
bug is reintroduced by undoing the two behaviours the fix added.

1. `src/util.c` `sqlite3Atoi64()`: restored the `#ifndef SQLITE_OMIT_HEX_INTEGER`
   branch removed by the fix (util.c hunk "-#ifndef SQLITE_OMIT_HEX_INTEGER ... in sqlite3Atoi64").
   Text-to-integer coercion/CAST understands `0x...` again, so
   `CAST('0x1234' AS INTEGER)` gives 4660 and `'0x1234'` inserted into an
   INT column becomes an integer, instead of staying text / casting to 0.
   (The sqlite3AtoF hex branch was not restored; AtoF has been rewritten and
   Atoi64 alone reproduces the coercion bug.)

2. `src/expr.c` `codeInteger()`: removed the `sqlite3_strnicmp(z,"0x",2)`
   check that raises "hex literal too big" (expr.c hunk 2), so oversized hex
   literals fall through to `codeReal()` again and silently become floats.

## Oracle failures
hexlit-301 (CAST gives 4660 not 0) and hexlist-400/401/402/410 (no
"hex literal too big" error; returns a float / 0.0 instead).
