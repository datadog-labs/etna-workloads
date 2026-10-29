# Rationale

## Changed hunk
`tree/src/func.c`, `sumInverse()`, floating-point branch (line ~2011):
`kahanBabuskaNeumaierStep(p, -sqlite3_value_double(argv[0]))` became
`kahanBabuskaNeumaierStep(p, sqlite3_value_double(argv[0]))`.

This reverses the fix's only implementation hunk (`p->rSum -= ...` back to
`p->rSum += ...`). In 3.54.1 the running sum uses Kahan-Babuska-Neumaier
summation, so the "subtract" is expressed as stepping with the negated value.
Dropping the negation makes xInverse add the departing row's value instead of
removing it, which is the original defect. The integer paths are untouched,
as they were in the original bug.

## Oracle failures
`window6-8.2` and `window6-8.3` (the cases the fix added) fail. SUM over
REAL values with a sliding frame (`ROWS 2 PRECEDING`) gives wrong totals once
rows leave the frame. The other 73 cases pass.
