# Rationale

Changed `tree/ext/fts3/fts3.c`, `fts3PutDeltaVarint()`: `assert_fts3_nc( iVal-*piPrev > 0 || (*piPrev==0 && iVal==0) )` changed back to plain `assert(...)`.

This reverses the fix's only implementation hunk, which changed `assert` to `assert_fts3_nc`. Pre-fix, the assert fired on corrupt records even though a negative delta is reachable with corrupt data. The surrounding code already refuses to write a negative delta, so it is otherwise unchanged.

Oracle failure: fts3corrupt4-46.2 aborts with `Assertion 'iVal-*piPrev > 0 || (*piPrev==0 && iVal==0)' failed` instead of returning "database disk image is malformed". This is the case the fix added.
