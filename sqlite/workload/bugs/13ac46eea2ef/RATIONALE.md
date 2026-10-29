# Rationale

## src/where.c, whereScanInit()
Reverses the fix hunk in `whereScanInit` that added
`pScan->zCollName = pIdx->azColl[j];` in the `iColumn==XN_EXPR` branch.
I removed that line (in 3.54.1 it sits in the `XN_EXPR` branch of `whereScanInit`).
For an index on an expression, `zCollName` is again left at 0, so `whereScanNext`
skips the collation check. A term like `substr(b,4)='ess' COLLATE nocase` can then
match an index on `substr(b,4)` that uses BINARY collation.

## src/expr.c, comparisonAffinity()
The fix's other hunk only changed `NEVER(aff==0)` to `aff==0`. In 3.54.1 the code is
already `aff==0`, and the change has no behavioural effect, so I left it alone.

## Oracle
`indexexpr1-1300.1` fails. The query returns only the row matching the
BINARY-collated index instead of `3 4`. The other 119 cases pass.
