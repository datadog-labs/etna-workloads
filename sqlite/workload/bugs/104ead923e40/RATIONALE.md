# Rationale

## src/where.c, whereLoopAddVirtual() (line ~4777)
Reverses the single implementation hunk of fix.patch. The fix changed the
`whereLoopAddVirtualOne()` call in the loop over candidate prerequisite masks
from passing `mNext` to `mNext|mExtra` as the mPrereq argument. In 3.54.1
`mExtra` is named `mPrereq`, so the call is restored to pass `mNext` alone,
dropping the `|mPrereq`. With a LEFT/CROSS JOIN to the left, mPrereq is nonzero,
and the omitted bits make the mask passed to xBestIndex inconsistent.

## Oracle failures
- bestindex2-1.7.2 (CROSS JOIN x1 with three virtual tables t1,t2,t3): fails
  with an assertion, `(mUsable & mPrereq)==mPrereq` in whereLoopAddVirtualOne,
  which aborts the run. Earlier cases (1.0-1.7.1) pass.
