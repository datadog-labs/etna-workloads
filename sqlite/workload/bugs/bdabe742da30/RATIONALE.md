# Rationale

Fix hunk reversed: src/vdbe.c, OP_Eq/Ne/Lt/Le/Gt/Ge, the SQLITE_NULLEQ branch.
The fix changed `res = 1` to `res = ((flags3 & MEM_Null) ? -1 : +1)` so that,
when comparing a NULL with a non-NULL under NULLEQ (as RANGE window frame
tests do), NULL orders as smaller. I restored `res = 1`, so NULL vs non-NULL
always compares as "greater" regardless of which operand is NULL.

The other fix hunks are not reversed. The window.c RANGE/NULL handling has
been rewritten since (BIGNULL block), and the NULLEQ P5 is still set in
windowCodeRangeTest. The assert removal in vdbe.c is not a behavioural change.

Failing oracle cases (21 in test/window8.test): window8-4.1.1, 4.2.1, 4.2.2,
4.3.1, 6.1, 7.x.4/5/8/9. RANGE frames over NULL ORDER BY values return wrong
sums, e.g. 7.4.9 expected `4 4 4 {} {} {}`, got `6 6 6 {} {} {}`.
