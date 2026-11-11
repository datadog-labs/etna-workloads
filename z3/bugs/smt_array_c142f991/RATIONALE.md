# Rationale

Changed hunk: src/src/smt/theory_array_base.cpp, `theory_array_base::collect_shared_vars`.

Traces to the FIX.diff hunk in `collect_shared_vars` that added `|| has_array_ext(r)` to the
shared-var condition, so that arrays involved in nested-array extensionality terms are treated
as shared (issue #3532). In today's code that role is played by `is_select_arg(r)`
(`has_array_ext` no longer exists). I reverted the condition to `if (ctx.is_shared(r))`, which
drops those arrays from the shared set. No interface equalities are created for them, and Z3
produces an invalid model for 3532.smt2.

The `TRACE` hunks and the `has_array_ext` declaration in FIX.diff are not reproduced. They have no functional effect.

## Final ./check.sh output
BUILD OK
FAIL z3test:smt2/3532.smt2 (rc=1)
    1a2
    > (error "line 9 column 10: an invalid model was generated")
