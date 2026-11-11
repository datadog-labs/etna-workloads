# Rationale
File: src/src/math/dd/dd_pdd.cpp (pdd_manager::apply_rec, case pdd_reduce_op in the early-exit switch).

Hunk 1: FIX.diff hunk "@@ -184,7 +184,8 @@" replaced the early exit with
`degree(p) < degree(q)` plus `level(first_leading(q)) > level(p)`.
I removed the second condition (the level check on the leading monomial of q). Polynomials p whose
variables are all ordered below lm(q) are no longer returned unchanged, so reduce() descends into
cases where it expects level(first_leading(q)) <= level_p. The result is the original bug:
reduce() mishandles the changed variable order.

Hunk 2: FIX.diff hunk "@@ -310,18 +311,25 @@" (the recursive reduce case). I restored the old,
simpler recombination (plain make_node of reduced lo/hi, no re-normalisation via multiplication and
addition when the reduced children violate the order).
In the current tree the case condition and the reduce_on_match call already use first_leading(q), so only the recombination was reverted.

Final ./check.sh result:
BUILD OK
FAIL pdd (rc=110)
(pdd fails with an assertion violation in the reduce test: dd_pdd.cpp level(first_leading(q)) == level_p.)
