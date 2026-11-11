Changes in src/src/math/grobner/grobner.cpp (the helper grobner::inc(monomial const&) is left defined but unused):
- merge_monomials: FIX.diff hunk @@435 -- restored the flat `m_manager.limit().inc(sz);` before the loop and removed the per-monomial coefficient-sized `inc(*m2)`.
- mul_append: hunk @@576 -- removed `inc(*m)`, so multiplication is not charged by coefficient size.
- simplify, simplify_to_process, unify, superpose: hunks @@638, @@797, @@826, @@899 -- removed the `inc(...)` calls, so reduction/superposition cost does not depend on coefficient size.
Result: rlimit charge is independent of coefficient size, the original bug (#10939); the grobner test's cost(large) > cost(1) check fails.

Final ./check.sh:
BUILD OK
FAIL grobner (rc=114)
    Failed to verify: reduction_cost(large) > reduction_cost(rational(1))
