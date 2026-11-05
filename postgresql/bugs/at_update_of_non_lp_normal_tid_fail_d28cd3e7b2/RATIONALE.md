# Rationale

Changed hunk: src/backend/access/heap/heapam.c, heap_update().
Traces to the heapam.c hunk in fix_impl.patch that replaces `Assert(ItemIdIsNormal(lp))` with a
`!ItemIdIsNormal(lp)` branch returning TM_Deleted. I restored the bare Assert and removed the
branch. A syscache-originated TID that has been pruned (LP_DEAD/LP_UNUSED/LP_REDIRECT) is no
longer rejected. heap_update goes on to read the non-normal line pointer as a tuple, which
corrupts the page header (and trips the assertion in assert-enabled builds).

The injection-point and comment hunks of the fix are left in place. They only support the test and don't change behavior.

Failing oracle case: src/test/modules/injection_points||syscache-update-pruned
