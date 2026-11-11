# Rationale

The fix's behaviour is already in this tree, so the diff can't be reversed. I undid one hunk by hand.

Changed hunk: `optsmt::update_upper` in `src/src/opt/optsmt.cpp`. It traces to the FIX.diff hunk in `optsmt.cpp` that adds the `if (v.is_finite()) update_rational_bound(v); else m_upper[idx] = v;` guard.

The bug is that `update_upper` always calls `m_upper[idx].update_rational_bound(v)`.

- When a model callback resets the upper bound to infinity, the stale exact finite part is kept.
- That violates the `SASSERT(!m_exact || bound.is_finite())` in `objective_value::update_rational_bound`. The fix description records the same assertion failure.

Result: `opt_bounds` fails with that assertion violation (`opt_value.cpp:33`). `algebraic`, `opt_value` and `rational` still pass.

Final ./check.sh output:
```
BUILD OK
PASS algebraic
FAIL opt_bounds (rc=110)   (ASSERTION VIOLATION opt_value.cpp:33 !m_exact || bound.is_finite())
PASS opt_value
PASS rational
```
