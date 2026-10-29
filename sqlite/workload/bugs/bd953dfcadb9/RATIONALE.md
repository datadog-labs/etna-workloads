# Rationale

## src/func.c, sumFinalize()
Reverses the only implementation hunk of the fix. The fix added a guard so that
the Kahan-Babushka-Neumaier error term `rErr` is added to `rSum` only when it is
not NaN. In 3.54.1 the guard is spelled `!sqlite3IsOverflow(p->rErr)`, with an
`else` branch returning `rSum`. I removed the guard and the else branch, so the
result is always `rSum+rErr` (the pre-fix code).

With an infinite input, `rErr` becomes NaN (inf - inf), so `sum()` returns NULL
instead of Inf or -Inf. avg() and total() have their own guards; they were not
part of the fix and are unchanged.

## Oracle failures
func-38.100 (the fix's test: sum of 9e+999 and -9e+999 gives NULL instead of
Inf/-Inf) and func-39.120 to func-39.190, which check the same infinity
handling in sum(). 9 failures in total.
