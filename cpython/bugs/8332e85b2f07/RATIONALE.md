# Rationale

Reintroduces gh-116626: `INSTRUMENTED_CALL_FUNCTION_EX` did not emit `CALL`
for Python functions and bound methods.

In v3.15.2 the code lives in `_DO_CALL_FUNCTION_EX` (Python/bytecodes.c); the
tier-1 copies in Python/generated_cases.c.h (CALL_FUNCTION_EX and
INSTRUMENTED_CALL_FUNCTION_EX) were regenerated with
`Tools/cases_generator/tier1_generator.py`.

- Fix hunk 1 (`if (opcode == INSTRUMENTED_CALL_FUNCTION_EX)` replacing the
  condition with `&& !PyFunction_Check(func) && !PyMethod_Check(func)`):
  restored the extra condition, so Python functions/methods skip the
  instrumented branch and no CALL event fires.
- Fix hunk 2 (wrapping the C_RAISE/C_RETURN emission in
  `if (!PyFunction_Check ...)`): removed that wrapper, as it was before the
  fix. It is redundant once hunk 1 is restored, as in the original code.

Failing oracle case: `test_monitoring.TestRegressions.test_call_function_ex`.
`f(*args)` records `(set_events, 0)` as the first CALL instead of `(f, 1)`.
