# Rationale

## src/window.c, sqlite3WindowCodeStep(), `case TK_UNBOUNDED`
Reverses the fix hunk that guarded `s.eDelete = WINDOW_AGGSTEP` for
`UNBOUNDED PRECEDING AND <expr> PRECEDING` with
`eType!=TK_RANGE && windowExprGtZero(pEnd)`. In 3.54.1 the guard is
`eFrmType!=TK_RANGE && windowExprGtZero(pParse, pMWin->pEnd)`. I restored the
pre-fix unconditional `s.eDelete = WINDOW_AGGSTEP;`. `windowExprGtZero` is
left in place because the TK_FOLLOWING case still uses it (as in the fix).

Effect: rows are deleted from the ephemeral table right after AGGSTEP even
when the end offset is 0 PRECEDING (frame includes the current row) or when
the frame is RANGE, so the frame loses rows it still needs.

## Failing oracle cases
- window6-11.3.3 (ROWS ... AND 0 PRECEDING): returns NULLs for a, instead of the row values.
- window6-11.4.1 (RANGE ... AND 10 PRECEDING): returns NULLs for y instead of the values.
