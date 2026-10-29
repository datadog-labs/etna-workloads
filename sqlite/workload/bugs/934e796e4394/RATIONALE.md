# Rationale

In 3.54.1 the fix's code lives in `whereOmitNoopJoin()` (src/where.c), logged as "omit unused FROM-clause term".
There, the `m1 = MASKBIT(i)-1;` line, its `testcase()`, and the `pWInfo->revMask = (m1 & revMask) | ((revMask>>1) & ~m1);` shift were already present.
That matches the fix's added lines (`m1` declaration, `m1 = ...`, `revMask = ...`).

I removed the `m1` declaration, the `m1` assignment, the testcase and the revMask shift.
With these gone, revMask bits for loops to the right of an omitted LEFT JOIN term are no longer shifted down. This is the pre-fix behaviour.

Oracle failure: `join2-13.1` returns `33 1 33 2` instead of `33 2 33 1`.
The ORDER BY ... DESC on t2 is satisfied by a reverse scan, but the reverse bit now sits at the wrong loop index.
