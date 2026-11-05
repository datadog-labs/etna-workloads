# Rationale

All changes are in src/interfaces/ecpg/preproc/pgc.l (the lexer; the grammar files already
use `$1` in a different, `@1`-based form, so the lexer hunks are where the bug lives).

- `<SQL>{xbstart}` / `<SQL>{xhstart}` actions: trace to the pgc.l hunks that dropped
  `addlitchar('b'/'x')`. Re-added, so the literal buffer again begins with the b/x prefix.
- `<xqs>` stop handling, `case xb`: trace to the hunk changing the strspn check and
  `psprintf("b'%s'")`. Restored `strspn(...) + 1` (skips the prefix) and returns the raw
  buffer via mm_strdup, so the token lacks the quotes (`b1010` rather than `b'1010'`).
- `case xh`: restored the old form without the hex validity check and with the raw buffer
  (no `x'...'` quoting).

Result: ecpg emits B'..'/X'..' literals without quotes / without validation.

Failing oracle case: src/interfaces/ecpg||preproc/strings
