# Rationale

Changed hunk (src/src/math/realclosure/realclosure.cpp, `imp::interval(value*)`):
traces to the FIX.diff hunk that adds `initialize_rational_value_interval` and the lazy
`interval(value * a)` accessor ("For rational values, we only compute the binary intervals
if needed"; `set(...)` now resets the interval via `update_mpq_value`). Before the fix,
rational values had no binary-interval approximation computed on demand, so the interval of
a rational such as 1/3 stayed the default empty/zero-containing interval. I removed the
lazy initialization from today's `interval()`, which is the same bug: rational values
expose an uninitialized interval that contains zero. Arithmetic on such values (e.g. the
division in rcf tst1) then violates `!contains_zero(num_i)`.

Other hunks of FIX.diff (typo fixes, comments, rename of m_eps_prec, display changes,
open/closed interval flags, header helpers) were either already equivalent in today's
code or had no observable effect on the oracle tests, so they were not touched.

## ./check.sh output
```
BUILD OK
PASS algebraic
FAIL rcf (rc=110)
    ASSERTION VIOLATION
    Line: 4610  !contains_zero(num_i)
```
