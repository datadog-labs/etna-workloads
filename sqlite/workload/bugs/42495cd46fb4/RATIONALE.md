# Rationale

Hunk reversed: `ext/fts3/fts3.c`, `fts3EvalSelectDeferred()` (fix hunk @@ -3966). The fix
guarded the per-iteration update `nLoad4 = nLoad4*4` with `if( ii<12 )` so the
int cannot overflow. In 3.54.1 the same code is still present (only the
neighbouring condition changed), so I restored the unguarded
`nLoad4 = nLoad4*4;` and removed the explanatory comment.

With many tokens (>16), nLoad4 overflows to 0, and `nLoad4/4` is then a
divisor of 0 in the `(nMinEst+(nLoad4/4)-1)/(nLoad4/4)` expression, causing
a SIGFPE (integer divide by zero).

Oracle: test/fts3defer.test case fts3defer-4.2 (the 19-token MATCH query) crashes
the testfixture with a floating-point exception; the run is incomplete, so
4.2 and later cases (5.x, 6.x) are reported as failing.
